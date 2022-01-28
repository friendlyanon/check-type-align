cmake_minimum_required(VERSION 3.14)

get_filename_component(CTEST_SOURCE_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
set(CTEST_BINARY_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/build")

set(CTEST_SITE "GitHub Actions")
set(CTEST_CONFIGURATION_TYPE Release)

function(group_start group)
  message("::group::${group}")
endfunction()
function(group_end)
  message("::endgroup::")
endfunction()

include("${CMAKE_CURRENT_LIST_DIR}/${runner}.cmake")

ctest_start(Continuous)

group_start(Configure)
ctest_configure(RETURN_VALUE ret OPTIONS "${OPTIONS}")
group_end()

if(ret EQUAL "0")
  group_start(Build)
  ctest_build(RETURN_VALUE ret)
  group_end()
endif()

if(ret EQUAL "0")
  group_start(Test)
  ctest_test()
  group_end()
endif()
