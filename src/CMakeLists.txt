cmake_minimum_required(VERSION 3.22)
project(MotorTownMods)

# Build type option (default: Release)
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()
option(MOTORTOWNMODS_DEBUG "Enable debug build" OFF)
if(MOTORTOWNMODS_DEBUG)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# Boost via FetchContent (cross-compile compatible)
include(FetchContent)
set(BOOST_INCLUDE_LIBRARIES json thread url beast asio)
set(BOOST_ENABLE_CMAKE ON)
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)

# Disable Boost tests/tools for faster builds
set(BOOST_DISABLE_TESTS ON CACHE BOOL "" FORCE)
set(BOOST_DISABLE_TOOLS ON CACHE BOOL "" FORCE)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
    Boost
    URL https://github.com/boostorg/boost/releases/download/boost-1.87.0/boost-1.87.0-cmake.tar.xz
    URL_HASH SHA256=7da75f171837577a52bbf217e17f8ea576c7c246e4594d617bfde7fafd408be5
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(Boost)

# Source files - listed explicitly for proper compile_commands.json export
# (file(GLOB) doesn't work reliably with external add_subdirectory)
set(SRC_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/AdminHide.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/dllmain.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/EventManager.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/EventsRoute.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/LocationBroadcaster.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/LocationSampler.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/LocationsRoute.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/LuaHttpServer.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/statics.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/TickProfiler.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/webroute.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/webserver.cpp"
)

set(HDR_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/AdminHide.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/dllmain.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/EventManager.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/EventsRoute.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/HookManager.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/LocationBroadcaster.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/LocationSampler.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/LocationsRoute.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/LuaHttpServer.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/statics.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/TickProfiler.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/webroute.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/webserver.h"
)

# Create shared library
add_library(MotorTownMods SHARED ${SRC_FILES} ${HDR_FILES})

# Link against UE4SS and Boost
target_link_libraries(MotorTownMods PRIVATE 
    UE4SS
    Boost::json
    Boost::thread
    Boost::url
    Boost::beast
)

# Include directories - UE4SS headers are provided by the Nix environment
if(NOT DEFINED UE4SS_SOURCE_DIR AND DEFINED ENV{UE4SS_SOURCE_DIR})
    set(UE4SS_SOURCE_DIR $ENV{UE4SS_SOURCE_DIR})
endif()

target_include_directories(MotorTownMods PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${UE4SS_SOURCE_DIR}/UE4SS/include
    ${UE4SS_SOURCE_DIR}/deps/first/Unreal/include
    ${UE4SS_SOURCE_DIR}/deps/first/LuaMadeSimple/include
    ${UE4SS_SOURCE_DIR}/deps/first/LuaRaw/include
    ${UE4SS_SOURCE_DIR}/deps/first/DynamicOutput/include
    ${UE4SS_SOURCE_DIR}/deps/first/JSON/include
)

# ── Native bridge (client only) ───────────────────────────────────────────
# mt_bridge.dll owns the thread-safe command queue/state snapshot shared by
# the Rust overlay and the C++ host mod. MTBridgeHost.dll is a tiny UE4SS
# client mod that drains that queue on the game thread and invokes the Lua
# handler. The server build does not include either target.
option(MT_BUILD_BRIDGE "Build the native client overlay bridge" OFF)
if(MT_BUILD_BRIDGE)
    add_library(mt_bridge SHARED "${CMAKE_CURRENT_SOURCE_DIR}/bridge/mt_bridge.cpp")
    target_compile_features(mt_bridge PRIVATE cxx_std_20)
    target_compile_definitions(mt_bridge PRIVATE MT_BRIDGE_BUILD _CRT_SECURE_NO_WARNINGS)
    if(MT_BRIDGE_ADMIN)
        target_compile_definitions(mt_bridge PRIVATE MT_BRIDGE_ADMIN)
    endif()
    set_target_properties(mt_bridge PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bridge-out")

    add_library(MTBridgeHost SHARED "${CMAKE_CURRENT_SOURCE_DIR}/bridge/BridgeHost.cpp")
    target_compile_features(MTBridgeHost PRIVATE cxx_std_20)
    target_compile_definitions(MTBridgeHost PRIVATE _CRT_SECURE_NO_WARNINGS)
    if(MT_BRIDGE_ADMIN)
        target_compile_definitions(MTBridgeHost PRIVATE MT_BRIDGE_ADMIN)
    endif()
    target_link_libraries(MTBridgeHost PRIVATE UE4SS mt_bridge)
    file(GLOB UE4SS_DEP_INCLUDE_DIRS LIST_DIRECTORIES true
        "${UE4SS_SOURCE_DIR}/deps/first/*/include")
    target_include_directories(MTBridgeHost PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/bridge
        ${UE4SS_SOURCE_DIR}/UE4SS/include
        ${UE4SS_DEP_INCLUDE_DIRS}
    )
    set_target_properties(MTBridgeHost PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bridge-out")
endif()

# Set C++ standard
target_compile_features(MotorTownMods PRIVATE cxx_std_20)

# Define macros
target_compile_definitions(MotorTownMods PRIVATE _CRT_SECURE_NO_WARNINGS)

# Debug-specific settings
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(MotorTownMods PRIVATE _DEBUG)
endif()
