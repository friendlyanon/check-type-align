cmake_minimum_required(VERSION 3.14)

get_filename_component(root "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)

set(CTEST_SOURCE_DIRECTORY "${root}")
set(CTEST_BINARY_DIRECTORY "${root}/build")

set(CTEST_CMAKE_GENERATOR "Visual Studio 16 2019")
set(CTEST_CMAKE_GENERATOR_PLATFORM x64)
set(CTEST_CONFIGURATION_TYPE Release)

ctest_start(Continuous)
ctest_configure(OPTIONS -DCheckTypeAlign_DEVELOPER_MODE=1)
ctest_build()
ctest_test()
