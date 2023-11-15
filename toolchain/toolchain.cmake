
# the name of the target operating system
# set(CMAKE_SYSTEM_NAME Terminal-Dxgmx)
set(CMAKE_SYSTEM_NAME Generic)

# which compilers to use for C
set(CMAKE_C_COMPILER $ENV{CC})
set(CMAKE_CXX_COMPILER $ENV{CXX})

set(CMAKE_C_FLAGS "")
# We don't support exceptions, period. And rtti support is going to 
# be implemented when it becomes a problem
set(CMAKE_CXX_FLAGS "-fno-rtti -fno-exceptions")

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED true)

# where is the target environment located
set(CMAKE_SYSROOT $ENV{TERMINAL_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
set(CMAKE_INSTALL_PREFIX ${CMAKE_SYSROOT})

# adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
