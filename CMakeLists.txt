cmake_minimum_required(VERSION 3.9)

project(
    CheckTypeAlign
    VERSION 1
    DESCRIPTION "Check the alignment requirement of a type in CMake"
    LANGUAGES NONE
)

option(CheckTypeAlign_DEVELOPER_MODE "Enable developer mode" OFF)

set(CheckTypeAlign_IS_TOP_LEVEL NO)
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  set(CheckTypeAlign_IS_TOP_LEVEL YES)
endif()

if(NOT CMAKE_SKIP_INSTALL_RULES)
  set(CMAKE_INSTALL_LIBDIR lib CACHE PATH "")

  include(CMakePackageConfigHelpers)
  include(GNUInstallDirs)

  write_basic_package_version_file(
      CheckTypeAlignConfigVersion.cmake
      COMPATIBILITY SameMajorVersion
  )

  set(
      CheckTypeAlign_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATADIR}/CheckTypeAlign"
      CACHE PATH "CMake package config location relative to the install prefix"
  )
  mark_as_advanced(CheckTypeAlign_INSTALL_CMAKEDIR)

  install(
      FILES
      cmake/CheckTypeAlign.c.in
      cmake/CheckTypeAlignConfig.cmake
      cmake/CheckTypeAlignMap.cmake.in
      "${PROJECT_BINARY_DIR}/CheckTypeAlignConfigVersion.cmake"
      DESTINATION "${CheckTypeAlign_INSTALL_CMAKEDIR}"
      COMPONENT CheckTypeAlign_Development
  )
endif()

if(CheckTypeAlign_IS_TOP_LEVEL AND CheckTypeAlign_DEVELOPER_MODE)
  # TODO: add tests
endif()
