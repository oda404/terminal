cmake_minimum_required(VERSION 3.23)
project(libc)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_FLAGS "-fno-builtin -std=c2x ${CMAKE_C_FLAGS}")

# libc.a
add_library(c STATIC
    src/stdlib.c
    src/syscalls.c
    src/fcntl.c
    src/unistd.c
    src/ioctl.c
    src/string.c
    src/mman.c
)
target_include_directories(c PRIVATE include)
install(TARGETS c DESTINATION ${CMAKE_SYSROOT}/usr/lib/)

# Install headers
install(DIRECTORY include/ DESTINATION ${CMAKE_SYSROOT}/usr/include)

# crt0.o
add_library(crt0 STATIC src/crt0.c)
target_include_directories(crt0 PRIVATE include)
install(FILES $<TARGET_OBJECTS:crt0> DESTINATION ${CMAKE_SYSROOT}/usr/lib RENAME crt0.o)
