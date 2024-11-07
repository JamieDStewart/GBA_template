cmake_minimum_required(VERSION 3.19)

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





