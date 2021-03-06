cmake_minimum_required(VERSION 3.12)

set (TEST_SAMPLE "sample_test")
set (TEST_SAMPLE_FIXTURE "sample_test_fixture")

set(GTEST_INCLUDE_PATH /usr/include/gtest)
set(GMOCK_INCLUDE_PATH /usr/include/gmock)
set(GTEST_LIBRARY_PATH "/usr/lib")
set (SAMPLE_INCLUDES  ${PROJECT_SOURCE_DIR}/include)

add_compile_options(-Wall)

link_directories(${GTEST_LIBRARY_PATH})

file(GLOB SAMPLE_SOURCES ${PROJECT_SOURCE_DIR}/src/*.cpp)
list(REMOVE_ITEM SAMPLE_SOURCES ${PROJECT_SOURCE_DIR}/src/main.cpp)
file(GLOB TEST_SOURCES ./test.cpp)
file(GLOB TEST_FIXTURE_SOURCES ./test_fixture.cpp)

add_executable(${TEST_SAMPLE}
    ${TEST_SOURCES}
    ${SAMPLE_SOURCES}
)

add_executable(${TEST_SAMPLE_FIXTURE}
    ${TEST_FIXTURE_SOURCES}
    ${SAMPLE_SOURCES}
)

target_include_directories(${TEST_SAMPLE} PUBLIC
    ${SAMPLE_INCLUDES}
    ${GTEST_INCLUDE_PATH}
    ${GMOCK_INCLUDE_PATH}
)

target_include_directories(${TEST_SAMPLE_FIXTURE} PUBLIC
    ${SAMPLE_INCLUDES}
    ${GTEST_INCLUDE_PATH}
    ${GMOCK_INCLUDE_PATH}
)

target_link_libraries(${TEST_SAMPLE}
    gmock
    gmock_main
    gtest
    gtest_main
    pthread
)

target_link_libraries(${TEST_SAMPLE_FIXTURE}
    gmock
    gmock_main
    gtest
    gtest_main
    pthread
)
