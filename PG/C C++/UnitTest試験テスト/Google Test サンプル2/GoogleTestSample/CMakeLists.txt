cmake_minimum_required(VERSION 3.12)

project(sample LANGUAGES CXX)

option(BUILD_UNITTEST "Whether to build unittest." ON)

add_subdirectory(src)
if (BUILD_UNITTEST)
    add_subdirectory(test)
endif()