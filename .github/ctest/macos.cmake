cmake_minimum_required(VERSION 3.14)

get_filename_component(CTEST_SOURCE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
set(CTEST_BINARY_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/build")

set(CTEST_SITE "GitHub Actions")
set(CTEST_BUILD_NAME MacOS)

set(CTEST_USE_LAUNCHERS 1)
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_CONFIGURATION_TYPE Release)

ctest_start(Continuous)
ctest_configure(OPTIONS -DCheckTypeAlign_DEVELOPER_MODE=1)
ctest_build()
ctest_test()
