
cmake_minimum_required(VERSION 3.23)
project(init CXX)

add_executable(
    ${PROJECT_NAME}
    core/main.cpp
)

install(TARGETS ${PROJECT_NAME})

terminal_add_project_app()