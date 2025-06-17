cmake_minimum_required(VERSION 3.15)
project(ABNT2_Fix VERSION 1.0.0)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Compiler-specific options
if(MSVC)
    add_compile_options(/W4)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
endif()

# Create the shared library
add_library(${PROJECT_NAME} SHARED src/ABNT2_Fix.cpp)

# Set target properties
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "ABNT2_Fix"
    SUFFIX ".dll"
)

# Include directories
target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/external/RED4ext.SDK/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Link libraries
target_link_libraries(${PROJECT_NAME}
    PRIVATE
        user32
        kernel32
)

# Install rules (optional)
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Print build information
message(STATUS "Building ${PROJECT_NAME} v${PROJECT_VERSION}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ standard: ${CMAKE_CXX_STANDARD}")

# Check for RED4ext SDK and provide helpful guidance
set(RED4EXT_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external/RED4ext.SDK/include")
if(NOT EXISTS "${RED4EXT_SDK_PATH}")
    message("")
    message("════════════════════════════════════════════════════════════════")
    message("⚠️  RED4ext.SDK NOT FOUND")
    message("════════════════════════════════════════════════════════════════")
    message("")
    message("The RED4ext.SDK is required to build this plugin but was not found at:")
    message("  ${RED4EXT_SDK_PATH}")
    message("")
    message("📥 DOWNLOAD OPTIONS:")
    message("")
    message("Option 1 - Git Submodule (Recommended):")
    message("  git submodule add https://github.com/WopsS/RED4ext.SDK.git source/dll/external/RED4ext.SDK")
    message("")
    message("Option 2 - Manual Download:")
    message("  1. Visit: https://github.com/WopsS/RED4ext.SDK")
    message("  2. Download/clone the repository")
    message("  3. Extract to: source/dll/external/RED4ext.SDK/")
    message("")
    message("After downloading, re-run CMake configuration.")
    message("════════════════════════════════════════════════════════════════")
    message("")
    message(FATAL_ERROR "RED4ext.SDK is required for compilation")
else()
    message(STATUS "✅ RED4ext.SDK found at: ${RED4EXT_SDK_PATH}")
endif()
