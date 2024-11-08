cmake_minimum_required(VERSION 3.19)

#Attempt to fetch the ARM GNU Toolchain as part of the build process
#  Calling FetchContent_MakeAvailable will download the toolchain into the /_deps/arm_gnu_toolchains-src/ folder
#  This folder is then used to get the path to the ARM GCC compiler to create the binary.
#  This process runs on configuration of CMake and will take a small amount of time, subsequent runs will not fetch the ARM toolchain.
include(FetchContent)
if( WIN32 )
    FetchContent_Declare(
    ARM_GNU_toolchains
    URL  https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-mingw-w64-i686-arm-none-eabi.zip
    URL_HASH   MD5=39d9882ca0eb475e81170ae826c1435d
    )
    FetchContent_MakeAvailable(ARM_GNU_toolchains)
else()
    FetchContent_Declare(
    ARM_GNU_toolchains
    URL  https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz
    URL_HASH   MD5=0601a9588bc5b9c99ad2b56133b7f118
    )
    FetchContent_MakeAvailable(ARM_GNU_toolchains)
endif()

#Print out extra messages to see exactly what CMAKE is up to 
set(CMAKE_VERBOSE_MAKEFILE ON)
#Path to toolchain file - this is placed before call to project(###)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/_toolchain/arm-none-eabi-gcc.cmake)

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
#Set up project, output and linker file
project(GBA_template)
#set the name of the executable to build
set(EXECUTABLE ${PROJECT_NAME}.elf)

set(LINKER_FILE ${CMAKE_SOURCE_DIR}/_linker_script/gba.ld)

enable_language(C ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

#Optional message to make sure that toolchain has been located
message(STATUS "CMAKE_TOOLCHAIN_FILE is: ${CMAKE_TOOLCHAIN_FILE}")

#cpu parameters
set(CPU_PARAMETERS
    -mcpu=arm7tdmi 
    -mthumb 
    -mthumb-interwork)

#compiler options
add_compile_options(
    ${CPU_PARAMETERS}
    -Wall)

#linker options
add_link_options( 
    -T${LINKER_FILE}
    ${CPU_PARAMETERS}
    -mtune=arm7tdmi
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map
    -W 
    -nostartfiles
    -lc 
    -lm
    -Wl,--print-memory-usage) 

#list of source files
set(SRC_FILES
    ../_crt/crt0.s
    src/main.c)

#build executables based on source files
add_executable(${EXECUTABLE} ${SRC_FILES})

#list of include directories
target_include_directories(${EXECUTABLE} PRIVATE
    include)

add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${EXECUTABLE}>
        ${PROJECT_NAME}.gba)
    
add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
        COMMAND "python" "${CMAKE_SOURCE_DIR}/_build_tools/rom_fixer.py" "${CMAKE_SOURCE_DIR}/build/GBA_template.gba" )





