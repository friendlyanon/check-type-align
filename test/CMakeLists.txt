cmake_minimum_required(VERSION 3.9)

project(CheckTypeAlignTest)

find_package(CheckTypeAlign REQUIRED)
enable_testing()

# Ensure the module uses standard functions
foreach(lang IN ITEMS C CXX)
  set("CMAKE_${lang}_STANDARD" 11)
  set("CMAKE_${lang}_EXTENSIONS" NO)
  set("CMAKE_${lang}_STANDARD_REQUIRED" YES)
endforeach()

# Check C types
check_type_align("void*" ALIGNOF_DATA_PTR)
check_type_align(char ALIGNOF_CHAR)
check_type_align(short ALIGNOF_SHORT)
check_type_align(int ALIGNOF_INT)
check_type_align(long ALIGNOF_LONG)
check_type_align("long long" ALIGNOF_LONG_LONG)
check_type_align(__int64 ALIGNOF___INT64)
check_type_align(size_t ALIGNOF_SIZE_T)
check_type_align(ssize_t ALIGNOF_SSIZE_T)

# Check CXX types
check_type_align(bool ALIGNOF_BOOL LANGUAGE CXX)
check_type_align(uint8_t ALIGNOF_UINT8_T LANGUAGE CXX)
check_type_align(std::uint8_t ALIGNOF_STD_UINT8_T LANGUAGE CXX)

set(CMAKE_REQUIRED_INCLUDES "${PROJECT_SOURCE_DIR}")
set(CMAKE_EXTRA_INCLUDE_FILES someclass.hxx)
check_type_align("decltype(((ns::someclass*)0)->someint)" SIZEOF_NS_CLASSMEMBER_INT LANGUAGE CXX)
check_type_align("decltype(((ns::someclass*)0)->someptr)" SIZEOF_NS_CLASSMEMBER_PTR LANGUAGE CXX)
check_type_align("decltype(((ns::someclass*)0)->somechar)" SIZEOF_NS_CLASSMEMBER_CHAR LANGUAGE CXX)
check_type_align("decltype(((ns::someclass*)0)->somebool)" SIZEOF_NS_CLASSMEMBER_BOOL LANGUAGE CXX)

configure_file(config.h.in config.h @ONLY)
configure_file(config.hxx.in config.hxx @ONLY)

include_directories("${PROJECT_BINARY_DIR}")

add_executable(CheckTypeAlign CheckTypeAlign.c)
add_executable(CheckTypeAlignCXX CheckTypeAlign.cxx)

add_test(NAME CheckTypeAlign.C COMMAND CheckTypeAlign)
add_test(NAME CheckTypeAlign.CXX COMMAND CheckTypeAlignCXX)
