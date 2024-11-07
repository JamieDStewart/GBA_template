set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(ARM_TOOLCHAIN_DIR $ENV{ARM_NONE_EABI_GCC_PATH})
set(BINUTILS_PATH ${ARM_TOOLCHAIN_DIR})

#Default GCC Settings
set(TOOLCHAIN_PREFIX ${ARM_TOOLCHAIN_DIR}/arm-none-eabi-)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#Setting ASM and C Compiler Flags for DEBUG and RELEASE Builds
set(ARCH "-mthumb -mthumb-interwork" )
set(CMAKE_C_FLAGS_DEBUG "-O0 -g -Werror ${ARCH}")
set(CMAKE_C_FLAGS_RELEASE "-Os -Werror ${ARCH}")
set(CMAKE_ASM_FLAGS_DEBUG "-g ${ARCH}")
set(CMAKE_ASM_FLAGS_RELEASE "${ARCH}")

#Set Compilers for C & ASM
set(CMAKE_C_COMPILER "${TOOLCHAIN_PREFIX}gcc.exe")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_PREFIX}as.exe")

#set OBJCOPY and SIZE tool
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool") 
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}size CACHE INTERNAL "size tool")

set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
