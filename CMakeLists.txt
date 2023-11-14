# Copyright 2023 Alexandru Olaru.
# Distributed under the MIT license.

cmake_minimum_required(VERSION 3.23)
project(terminal)

set(TERMINAL_SOURCE_DIR ${CMAKE_SOURCE_DIR})
set(TERMINAL_SYSROOT ${TERMINAL_SOURCE_DIR}/sysroot)
set(TERMINAL_SYSROOT_IMAGE ${CMAKE_BINARY_DIR}/sysroot_image)
set(TERMINAL_DXGMX_BINARY ${TERMINAL_SYSROOT}/boot/dxgmx)
set(TERMINAL_SYSTEM_ISO ${CMAKE_BINARY_DIR}/terminal.iso)

# Get the calling user's uid
execute_process(COMMAND id -u OUTPUT_VARIABLE TERMINAL_COMPILE_UID)
string(STRIP ${TERMINAL_COMPILE_UID} TERMINAL_COMPILE_UID)

add_custom_target(
    sysroot-ensure-mounted
    COMMAND "${TERMINAL_SOURCE_DIR}/tools/sysroot-is-mounted.sh" "${TERMINAL_SYSROOT}" "||" "(" "echo" "Sysroot is not mounted, trying to mount..." ";" "sudo" "${TERMINAL_SOURCE_DIR}/tools/sysroot-ensure-mounted.sh" "--sysroot-image" "${TERMINAL_SYSROOT_IMAGE}" "--sysroot" "${TERMINAL_SYSROOT}" "--uid" "${TERMINAL_COMPILE_UID}" "--gid" "${TERMINAL_COMPILE_UID}" ")"
    USES_TERMINAL
)
    
add_custom_target(
    sysroot-unmount
    COMMAND "sudo" "${TERMINAL_SOURCE_DIR}/tools/sysroot-unmount.sh" "--sysroot" "${TERMINAL_SYSROOT}"
    USES_TERMINAL
)

include(ExternalProject)
# Add kernel target
ExternalProject_Add(
    dxgmx
    SOURCE_DIR ${TERMINAL_SOURCE_DIR}/kernel
    CONFIGURE_COMMAND ""
    BUILD_ALWAYS true 
    BUILD_COMMAND ${CMAKE_COMMAND} -E env "KERNEL_BIN=dxgmx" "SYSROOT=${TERMINAL_SYSROOT}" make -C <SOURCE_DIR>
    INSTALL_COMMAND ${CMAKE_COMMAND} -E env "KERNEL_BIN=dxgmx" "SYSROOT=${TERMINAL_SYSROOT}" make -C <SOURCE_DIR> install
    BUILD_BYPRODUCTS ${TERMINAL_SYSROOT}/boot/dxgmx
    DEPENDS sysroot-ensure-mounted
)

add_custom_target(terminal_core DEPENDS dxgmx)

add_subdirectory(lib)
add_subdirectory(apps)

add_custom_target(
    sysroot-sync-image
    COMMAND "sync" "-f" "${TERMINAL_SYSROOT}"
    USES_TERMINAL
)

add_custom_target(
    create-grub-iso
    DEPENDS terminal_core
    COMMAND "${TERMINAL_SOURCE_DIR}/tools/create-grub-iso.sh" "--sysroot" "${TERMINAL_SYSROOT}" "--out" "${TERMINAL_SYSTEM_ISO}"
    BYPRODUCTS ${TERMINAL_SYSTEM_ISO}
    USES_TERMINAL
)

add_custom_target(
    run
    DEPENDS terminal_core sysroot-sync-image
    COMMAND "${TERMINAL_SOURCE_DIR}/tools/run-qemu.sh" "-k" "${TERMINAL_DXGMX_BINARY}"
    USES_TERMINAL
)

add_custom_target(
    run-iso
    DEPENDS create-grub-iso
    COMMAND "${TERMINAL_SOURCE_DIR}/tools/run-qemu.sh" "-i" "${TERMINAL_SYSTEM_ISO}"
    USES_TERMINAL
)
