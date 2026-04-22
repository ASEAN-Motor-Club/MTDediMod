set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Use absolute path to unwrapped compiler from Nix
set(CMAKE_C_COMPILER "/nix/store/rr64nnycczvx7s1b110qmvqrlfcb6lsm-clang-21.1.8/bin/clang-cl")
set(CMAKE_CXX_COMPILER "/nix/store/rr64nnycczvx7s1b110qmvqrlfcb6lsm-clang-21.1.8/bin/clang-cl")
set(CMAKE_RC_COMPILER llvm-rc)
set(CMAKE_MT llvm-mt)
set(CMAKE_LINKER lld-link)

# Fix for target architecture
set(TRIPLE_FLAGS "--target=x86_64-pc-windows-msvc")

# Disable PIC flag which causes errors on Windows target
set(CMAKE_C_COMPILE_OPTIONS_PIC "")
set(CMAKE_CXX_COMPILE_OPTIONS_PIC "")

# Configure ASM_MASM to use llvm-ml
set(CMAKE_ASM_MASM_COMPILER llvm-ml)
set(CMAKE_ASM_MASM_FLAGS "-m64")

# Point to xwin cache
set(XWIN_CACHE "${CMAKE_CURRENT_LIST_DIR}/.xwin-cache")

set(XWIN_INCLUDE_FLAGS
    "/imsvc${XWIN_CACHE}/crt/include"
    "/imsvc${XWIN_CACHE}/sdk/include/ucrt"
    "/imsvc${XWIN_CACHE}/sdk/include/shared"
    "/imsvc${XWIN_CACHE}/sdk/include/um"
    "/imsvc${XWIN_CACHE}/sdk/include/winrt"
)

set(XWIN_LIB_FLAGS
    "/libpath:${XWIN_CACHE}/crt/lib/x86_64"
    "/libpath:${XWIN_CACHE}/sdk/lib/ucrt/x86_64"
    "/libpath:${XWIN_CACHE}/sdk/lib/um/x86_64"
)

# Apply flags
string(REPLACE ";" " " XWIN_INCLUDE_FLAGS_STR "${XWIN_INCLUDE_FLAGS}")
string(REPLACE ";" " " XWIN_LIB_FLAGS_STR "${XWIN_LIB_FLAGS}")

# Force Release Runtime (DLL) globally to bypass missing Debug CRT
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
set(CMAKE_C_FLAGS_DEBUG_INIT "/MD /Zi /Ob0 /Od /RTC1")
set(CMAKE_CXX_FLAGS_DEBUG_INIT "/MD /Zi /Ob0 /Od /RTC1")
set(CMAKE_C_FLAGS_RELEASE_INIT "/MD /O2 /Ob2 /DNDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE_INIT "/MD /O2 /Ob2 /DNDEBUG")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${XWIN_INCLUDE_FLAGS_STR} ${TRIPLE_FLAGS} -Wno-unused-command-line-argument -fuse-ld=lld /EHsc /DPLATFORM_WINDOWS /DPLATFORM_MICROSOFT /DUBT_COMPILED_PLATFORM=Win64 /DOVERRIDE_PLATFORM_HEADER_NAME=Windows /DUE_BUILD_SHIPPING=1")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${XWIN_INCLUDE_FLAGS_STR} ${TRIPLE_FLAGS} -Wno-unused-command-line-argument -fuse-ld=lld /EHsc /DPLATFORM_WINDOWS /DPLATFORM_MICROSOFT /DUBT_COMPILED_PLATFORM=Win64 /DOVERRIDE_PLATFORM_HEADER_NAME=Windows /DUE_BUILD_SHIPPING=1")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${XWIN_LIB_FLAGS_STR}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${XWIN_LIB_FLAGS_STR}")
set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${XWIN_LIB_FLAGS_STR}")

# RC Flags
set(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} ${XWIN_INCLUDE_FLAGS_STR} ${TRIPLE_FLAGS} -Wno-unused-command-line-argument")

# Fix for checking compiler
set(CMAKE_TRY_COMPILE_TARGET_TYPE_STATIC_LIBRARY ON)

