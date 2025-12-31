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

# Collect source files
file(GLOB_RECURSE SRC_FILES "*.cpp" "*.c" "*.cc")
file(GLOB_RECURSE HDR_FILES "*.hpp" "*.h")

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

# Set C++ standard
target_compile_features(MotorTownMods PRIVATE cxx_std_20)

# Define macros
target_compile_definitions(MotorTownMods PRIVATE _CRT_SECURE_NO_WARNINGS)

# Debug-specific settings
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(MotorTownMods PRIVATE _DEBUG)
endif()
