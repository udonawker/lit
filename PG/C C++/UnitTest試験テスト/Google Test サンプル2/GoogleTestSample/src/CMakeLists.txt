cmake_minimum_required(VERSION 3.12)

set(APP_NAME "sample")
file (GLOB SAMPLE_SOURCES *.cpp)
set (SAMPLE_INCLUDES  ${PROJECT_SOURCE_DIR}/include)

add_executable(${APP_NAME}
    ${SAMPLE_SOURCES}
)

target_include_directories(${APP_NAME} PUBLIC
    ${SAMPLE_INCLUDES}
)
