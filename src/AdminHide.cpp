#include "AdminHide.h"

#include <windows.h>
#include <cstdint>
#include <cstring>

#include <DynamicOutput/DynamicOutput.hpp>

using namespace RC;

namespace
{
    // AMotorTownPlayerState.bIsAdmin lives at this+0x385 and is property index
    // 0x17 in the game's replication table. The game's setter is a tiny leaf
    // function:
    //
    //   mov  [rcx+0x385], dl        ; store the new value
    //   mov  r8d, 0x17              ; property id
    //   mov  rdx, [rcx+0x28]        ; replication slot
    //   jmp  <mark-dirty helper>
    //
    // We redirect the setter to a trampoline that zeroes edx first, then runs
    // the original prologue and jumps back into the function. The game still
    // performs its own dirty-marking, so clients are told bIsAdmin == false at
    // join and on every update: no " (Admin)" suffix and no star on any client,
    // with no client-side install.
    //
    // Trade-off: the server's own copy is false too, so the vanilla admin panel
    // and admin RPC authority go with it. Admins can restore the panel UI
    // client-side.
    //
    // Hot-path cost: one unconditional jump, one 2-byte xor, no C function
    // call, no counter, no logging, no locks. The setter only runs when admin
    // status actually changes (login, promote, demote) - it is not a per-tick
    // path - but the hook adds nothing measurable even if it were.
    constexpr size_t kStolenBytes = 16;
    constexpr size_t kTrampolineSize = 64;

    const unsigned char kSetAdminPattern[] = {
        0x88, 0x91, 0x85, 0x03, 0x00, 0x00, // mov byte [rcx+0x385], dl
        0x41, 0xB8, 0x17, 0x00, 0x00, 0x00, // mov r8d, 0x17
        0x48, 0x8B, 0x51, 0x28,             // mov rdx, [rcx+0x28]
        0xE9                                // jmp rel32
    };

    void* g_setter = nullptr;

    const unsigned char* FindTextSection(void* module, size_t& size_out)
    {
        auto* base = static_cast<unsigned char*>(module);
        auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
        if (dos->e_magic != IMAGE_DOS_SIGNATURE) return nullptr;
        auto* nt = reinterpret_cast<IMAGE_NT_HEADERS64*>(base + dos->e_lfanew);
        if (nt->Signature != IMAGE_NT_SIGNATURE) return nullptr;
        auto* sec = IMAGE_FIRST_SECTION(nt);
        for (WORD i = 0; i < nt->FileHeader.NumberOfSections; ++i, ++sec)
        {
            if (std::memcmp(sec->Name, ".text", 5) == 0)
            {
                size_out = sec->Misc.VirtualSize;
                return base + sec->VirtualAddress;
            }
        }
        return nullptr;
    }

    void* PatternScan(const unsigned char* haystack, size_t haystack_len,
                      const unsigned char* needle, size_t needle_len)
    {
        if (needle_len == 0 || haystack_len < needle_len) return nullptr;
        const unsigned char* end = haystack + (haystack_len - needle_len);
        for (const unsigned char* p = haystack; p <= end; ++p)
        {
            if (*p != needle[0]) continue;
            if (std::memcmp(p, needle, needle_len) == 0)
            {
                return const_cast<unsigned char*>(p);
            }
        }
        return nullptr;
    }

    // mov rax, imm64 ; jmp rax  (12 bytes, NOP-padded to `available`)
    void WriteAbsoluteJump(unsigned char* at, void* target, size_t available)
    {
        std::memset(at, 0x90, available);
        at[0] = 0x48;
        at[1] = 0xB8;
        std::memcpy(at + 2, &target, sizeof(target));
        at[10] = 0xFF;
        at[11] = 0xE0;
    }

    // jmp qword ptr [rip+0] ; dq target  (14 bytes)
    void WriteIndirectJump(unsigned char* at, void* target)
    {
        at[0] = 0xFF;
        at[1] = 0x25;
        const int32_t zero = 0;
        std::memcpy(at + 2, &zero, sizeof(zero));
        std::memcpy(at + 6, &target, sizeof(target));
    }
}

namespace AdminHide
{
    bool Install()
    {
        if (g_setter) return true;

        void* module = GetModuleHandleW(nullptr);
        if (!module)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] no main module\n"));
            return false;
        }

        size_t text_size = 0;
        const unsigned char* text = FindTextSection(module, text_size);
        if (!text)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] .text not found\n"));
            return false;
        }

        void* setter = PatternScan(text, text_size, kSetAdminPattern, sizeof(kSetAdminPattern));
        if (!setter)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] setter pattern not found (game build changed?)\n"));
            return false;
        }

        auto* tramp = static_cast<unsigned char*>(
            VirtualAlloc(nullptr, kTrampolineSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
        if (!tramp)
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] trampoline alloc failed\n"));
            return false;
        }

        // The whole detour lives in the trampoline so the hooked path never
        // enters C++ code: zero the value, replay the stolen prologue, resume.
        size_t pos = 0;
        tramp[pos++] = 0x31; // xor edx, edx
        tramp[pos++] = 0xD2;

        std::memcpy(tramp + pos, setter, kStolenBytes);
        pos += kStolenBytes;

        WriteIndirectJump(tramp + pos, static_cast<unsigned char*>(setter) + kStolenBytes);

        DWORD old = 0;
        if (!VirtualProtect(setter, kStolenBytes, PAGE_EXECUTE_READWRITE, &old))
        {
            Output::send<LogLevel::Error>(STR("[AdminHide] VirtualProtect failed\n"));
            return false;
        }
        WriteAbsoluteJump(static_cast<unsigned char*>(setter), tramp, kStolenBytes);
        VirtualProtect(setter, kStolenBytes, old, &old);
        FlushInstructionCache(GetCurrentProcess(), setter, kStolenBytes);

        g_setter = setter;
        Output::send<LogLevel::Warning>(
            STR("[AdminHide] hooked bIsAdmin setter at {} (clients always receive false)\n"),
            static_cast<void*>(setter));
        return true;
    }
}
