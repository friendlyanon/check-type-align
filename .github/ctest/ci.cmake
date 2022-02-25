cmake_minimum_required(VERSION 3.14)

get_filename_component(CTEST_SOURCE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
set(CTEST_BINARY_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/build")

set(CTEST_SITE "GitHub Actions")
set(CTEST_CONFIGURATION_TYPE Release)

include("${CMAKE_CURRENT_LIST_DIR}/${runner}.cmake")

function(echo what)
  execute_process(COMMAND "${CMAKE_COMMAND}" -E echo "${what}")
endfunction()

ctest_start(Continuous)

echo(::group::Configure)
ctest_configure(RETURN_VALUE ret OPTIONS -DCheckTypeAlign_DEVELOPER_MODE=1)
echo(::endgroup::)

if(ret EQUAL "0")
  echo(::group::Build)
  ctest_build(RETURN_VALUE ret)
  echo(::endgroup::)
endif()

if(ret EQUAL "0")
  echo(::group::Test)
  ctest_test()
  echo(::endgroup::)
endif()
