cmake_minimum_required(VERSION 3.23)
project(libc C)

set(CMAKE_C_FLAGS "-fno-builtin ${CMAKE_C_FLAGS}")

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
# libc depends on kernel headers, so we wait for that
add_dependencies(c dxgmx)
target_include_directories(c PRIVATE include)
install(TARGETS c DESTINATION ${CMAKE_SYSROOT}/usr/lib/)
# Install headers
install(DIRECTORY include/ DESTINATION ${CMAKE_SYSROOT}/usr/include)
# The system depends on libc of course
terminal_core_depends_on(c)

# crt0.o
add_library(crt0 STATIC src/crt0.c)
add_dependencies(crt0 c)
target_include_directories(crt0 PRIVATE include)
install(FILES $<TARGET_OBJECTS:crt0> DESTINATION ${CMAKE_SYSROOT}/usr/lib RENAME crt0.o)
# The system also depends on the c runtime
terminal_core_depends_on(crt0)
