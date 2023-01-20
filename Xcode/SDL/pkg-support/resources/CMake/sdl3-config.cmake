# SDL CMake configuration file:
# This file is meant to be placed in Resources/CMake of a SDL3 framework

# INTERFACE_LINK_OPTIONS needs CMake 3.12
cmake_minimum_required(VERSION 3.12)

include(FeatureSummary)
set_package_properties(SDL3 PROPERTIES
    URL "https://www.libsdl.org/"
    DESCRIPTION "low level access to audio, keyboard, mouse, joystick, and graphics hardware"
)

# Copied from `configure_package_config_file`
macro(set_and_check _var _file)
    set(${_var} "${_file}")
    if(NOT EXISTS "${_file}")
        message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
    endif()
endmacro()

# Copied from `configure_package_config_file`
macro(check_required_components _NAME)
    foreach(comp ${${_NAME}_FIND_COMPONENTS})
        if(NOT ${_NAME}_${comp}_FOUND)
            if(${_NAME}_FIND_REQUIRED_${comp})
                set(${_NAME}_FOUND FALSE)
            endif()
        endif()
    endforeach()
endmacro()

set(SDL3_FOUND TRUE)

# Compute the installation prefix relative to this file.
get_filename_component(_sdl3_framework_path "${CMAKE_CURRENT_LIST_FILE}" PATH)      # /SDL3.framework/Resources/CMake/
get_filename_component(_sdl3_framework_path "${_IMPORT_PREFIX}" PATH)               # /SDL3.framework/Resources/
get_filename_component(_sdl3_framework_path "${_IMPORT_PREFIX}" PATH)               # /SDL3.framework/
get_filename_component(_sdl3_framework_parent_path "${_sdl3_framework_path}" PATH)  # /

set_and_check(_sdl3_include_dirs "${_sdl3_framework_path}/Headers")

set(SDL3_LIBRARIES "SDL3::SDL3")

# All targets are created, even when some might not be requested though COMPONENTS.
# This is done for compatibility with CMake generated SDL3-target.cmake files.

if(NOT TARGET SDL3::headers)
    add_library(SDL3::headers INTERFACE IMPORTED)
    set_target_properties(SDL3::headers
        PROPERTIES
            INTERFACE_COMPILE_OPTIONS "SHELL:-F \"${_sdl3_framework_parent_path}\""
            INTERFACE_INCLUDE_DIRECTORIES "${_sdl3_include_dirs}"
    )
endif()
set(SDL3_headers_FOUND TRUE)
unset(_sdl3_include_dirs)

if(NOT TARGET SDL3::SDL3)
    add_library(SDL3::SDL3 SHARED IMPORTED)
    set_target_properties(SDL3::SDL3
        PROPERTIES
            FRAMEWORK "TRUE"
            INTERFACE_LINK_LIBRARIES "SDL3::headers"
            IMPORTED_LOCATION "${_sdl3_framework_path}/SDL3"
            IMPORTED_SONAME "${_sdl3_framework_path}/SDL3"
            COMPATIBLE_INTERFACE_BOOL "SDL3_SHARED"
            INTERFACE_SDL3_SHARED "ON"
    )
endif()
set(SDL3_SDL3_FOUND TRUE)

unset(_sdl3_framework_parent_path)
unset(_sdl3_framework_path)

check_required_components(SDL3)
