import sys
import os
import shutil

def main():
    if len(sys.argv) != 3:
        print("Invalid arguments! Expected: proxy_generator.py <input_dll_name_or_exports_file> <output_path>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_path = sys.argv[2]

    if not os.path.exists(input_file):
        print("Input file doesn't exist!")
        sys.exit(1)

    input_filename = os.path.basename(input_file)
    input_stem = os.path.splitext(input_filename)[0]
    
    exports = []
    dll_path_out = ""

    # Parse .exports file (only mode supported for cross-compile)
    with open(input_file, 'r') as f:
        lines = f.readlines()
    
    if len(lines) > 0 and "Path: " in lines[0]:
        dll_path_out = lines[0].strip()[6:] # Remove "Path: "

    if not dll_path_out:
        print("Failed to read export file (missing file path info)")
        sys.exit(1)

    # Handle Windows path (which may have backslashes) on non-Windows system
    # Replace backslashes with forward slashes for cross-platform basename extraction
    dll_path_normalized = dll_path_out.replace("\\", "/")
    input_dll_name = os.path.basename(dll_path_normalized)
    input_dll_stem = os.path.splitext(input_dll_name)[0]

    for line in lines[1:]: # Skip Path line
        line = line.strip()
        if not line:
            continue
        
        parts = line.split()
        if len(parts) < 1:
            continue
            
        ordinal = int(parts[0])
        if ordinal == 0:
            continue
            
        name = ""
        is_named = False
        if len(parts) > 1:
            name = parts[1]
            is_named = True
        else:
            name = f"ordinal{ordinal}"
            is_named = False
            
        exports.append({
            "ordinal": ordinal,
            "is_named": is_named,
            "name": name
        })

    print(f"Generating a proxy using {input_filename}, output path: {output_path}")
    print(f"Export count: {len(exports)}")

    # Generate .exports file (redundant if reading from one, but C++ does it only for DLL input)
    # We skip generating .exports file since we are reading FROM one.

    # Generate .def
    def_path = os.path.join(output_path, f"{input_dll_stem}.def")
    with open(def_path, 'w') as f:
        f.write(f"LIBRARY {input_dll_stem}\n")
        f.write("EXPORTS\n")
        for i, exp in enumerate(exports):
            f.write(f"  {exp['name']}=f{i} @{exp['ordinal']}\n")

    # Generate .asm
    asm_path = os.path.join(output_path, f"{input_dll_stem}.asm")
    with open(asm_path, 'w') as f:
        f.write(".code\n")
        f.write("extern mProcs:QWORD\n")
        for i, exp in enumerate(exports):
            f.write(f"f{i} proc\n")
            f.write(f"  jmp mProcs[8*{i}]\n")
            f.write(f"f{i} endp\n")
        f.write("end\n")

    # Generate dllmain.cpp
    cpp_path = os.path.join(output_path, "dllmain.cpp")
    with open(cpp_path, 'w') as f:
        f.write("#include <File/Macros.hpp>\n\n")
        f.write("#include <cstdint>\n")
        f.write("#include <fstream>\n")
        f.write("#include <string>\n\n")
        f.write("#define WIN32_LEAN_AND_MEAN\n")
        f.write("#include <Windows.h>\n")
        f.write("#include <filesystem>\n\n")
        f.write("#pragma comment(lib, \"user32.lib\")\n\n")
        
        f.write("using namespace RC;\n")
        f.write("namespace fs = std::filesystem;\n\n")
        
        f.write("HMODULE SOriginalDll = nullptr;\n")
        f.write(f"extern \"C\" uintptr_t mProcs[{len(exports)}] = {{0}};\n\n")
        
        f.write("void setup_functions()\n{\n")
        for i, exp in enumerate(exports):
            getter = f"\"{exp['name']}\"" if exp['is_named'] else f"MAKEINTRESOURCEA({exp['ordinal']})"
            f.write(f"    mProcs[{i}] = (uintptr_t)GetProcAddress(SOriginalDll, {getter});\n")
        f.write("}\n\n")

        # load_original_dll
        f.write("void load_original_dll()\n{\n")
        f.write("    wchar_t path[MAX_PATH];\n")
        f.write("    GetSystemDirectory(path, MAX_PATH);\n\n")
        f.write(f"    std::wstring dll_path = std::wstring(path) + L\"\\\\{input_dll_name}\";\n\n")
        f.write("    SOriginalDll = LoadLibrary(dll_path.c_str());\n")
        f.write("    if (!SOriginalDll)\n    {\n")
        f.write("        MessageBox(nullptr, L\"Failed to load proxy DLL\", L\"UE4SS Error\", MB_OK | MB_ICONERROR);\n")
        f.write("        ExitProcess(0);\n    }\n}\n\n")
        
        # is_absolute_path
        f.write("bool is_absolute_path(const std::string& path)\n{\n")
        f.write("    return fs::path(path).is_absolute();\n}\n\n")

        # load_ue4ss_dll (copy verbatim from main.cpp)
        f.write("HMODULE load_ue4ss_dll(HMODULE moduleHandle)\n{\n")
        f.write("    HMODULE hModule = nullptr;\n")
        f.write("    wchar_t moduleFilenameBuffer[1024]{'\\0'};\n")
        f.write("    GetModuleFileNameW(moduleHandle, moduleFilenameBuffer, sizeof(moduleFilenameBuffer) / sizeof(wchar_t));\n")
        f.write("    const auto currentPath = std::filesystem::path(moduleFilenameBuffer).parent_path();\n")
        f.write("    const fs::path ue4ssPath = currentPath / \"ue4ss\" / \"UE4SS.dll\";\n\n")
        
        f.write("    // Check for override.txt\n")
        f.write("    const fs::path overrideFilePath = currentPath / \"override.txt\";\n")
        f.write("    if (fs::exists(overrideFilePath))\n    {\n")
        f.write("        std::ifstream overrideFile(overrideFilePath);\n")
        f.write("        std::string overridePath;\n")
        f.write("        if (std::getline(overrideFile, overridePath))\n        {\n")
        f.write("            fs::path ue4ssOverridePath = overridePath;\n")
        f.write("            if (!is_absolute_path(overridePath))\n            {\n")
        f.write("                ue4ssOverridePath = currentPath / overridePath;\n            }\n\n")
        f.write("            ue4ssOverridePath = ue4ssOverridePath / \"UE4SS.dll\";\n\n")

        f.write("            // Attempt to load UE4SS.dll from the override path\n")
        f.write("            hModule = LoadLibrary(ue4ssOverridePath.c_str());\n")
        f.write("            if (hModule)\n            {\n")
        f.write("                return hModule;\n            }\n")
        f.write("        }\n    }\n\n")
        
        f.write("    // Attempt to load UE4SS.dll from ue4ss directory\n")
        f.write("    hModule = LoadLibrary(ue4ssPath.c_str());\n")
        f.write("    if (!hModule)\n    {\n")
        f.write("        // If loading from ue4ss directory fails, load from the current directory\n")
        f.write("        hModule = LoadLibrary(L\"UE4SS.dll\");\n")
        f.write("    }\n\n")

        f.write("    return hModule;\n}\n\n")

        # DllMain
        f.write("BOOL WINAPI DllMain(HMODULE hInstDll, DWORD fdwReason, LPVOID lpvReserved)\n{\n")
        f.write("    if (fdwReason == DLL_PROCESS_ATTACH)\n    {\n")
        f.write("        load_original_dll();\n")
        f.write("        HMODULE hUE4SSDll = load_ue4ss_dll(hInstDll);\n")
        f.write("        if (hUE4SSDll)\n        {\n")
        f.write("            setup_functions();\n        }\n")
        f.write("        else\n        {\n")
        f.write("            MessageBox(nullptr, L\"Failed to load UE4SS.dll. Please see the docs on correct installation: \"\n")
        f.write("                \"https://docs.ue4ss.com/installation-guide\", L\"UE4SS Error\", MB_OK | MB_ICONERROR);\n")
        f.write("            ExitProcess(0);\n        }\n    }\n")
        f.write("    else if (fdwReason == DLL_PROCESS_DETACH)\n    {\n")
        f.write("        FreeLibrary(SOriginalDll);\n    }\n")
        f.write("    return TRUE;\n}\n")

    print("Finished generating!")

if __name__ == "__main__":
    main()
