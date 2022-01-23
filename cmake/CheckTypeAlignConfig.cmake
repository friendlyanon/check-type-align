cmake_minimum_required(VERSION 3.9)

include(CheckIncludeFile)
include(CheckIncludeFileCXX)

get_filename_component(
    _CheckTypeAlign_DIRECTORY "${CMAKE_CURRENT_LIST_FILE}"
    DIRECTORY
)

set(
    CHECK_TYPE_ALIGN_FALLBACK_CAST_TYPE "unsigned long long" CACHE STRING
    "The unsigned type to which a pointer can be cast to without warnings"
)
mark_as_advanced(CHECK_TYPE_ALIGN_FALLBACK_CAST_TYPE)

macro(_check_type_align_parse_args)
  set(_CHECK_TYPE_ALIGN_BUILTIN_TYPES_ONLY 0)
  unset(_cta_doing)
  foreach(_cta_arg IN ITEMS ${ARGN})
    if(_cta_arg STREQUAL "BUILTIN_TYPES_ONLY")
      set("_CHECK_TYPE_ALIGN_${_cta_arg}" 1)
      unset(_cta_doing)
    elseif(_cta_arg STREQUAL "LANGUAGE")
      set(_cta_doing "${_cta_arg}")
      set("_CHECK_TYPE_ALIGN_${_cta_doing}" "")
    elseif(_cta_doing STREQUAL "LANGUAGE")
      set("_CHECK_TYPE_ALIGN_${_cta_doing}" "${_cta_arg}")
      unset(_cta_doing)
    else()
      message(FATAL_ERROR "Unknown argument:\n  ${_cta_arg}\n")
    endif()
  endforeach()
  if(_cta_doing STREQUAL "LANGUAGE")
    message(FATAL_ERROR "Missing argument:\n  LANGUAGE requires a value\n")
  endif()
  unset(_cta_doing)
endmacro()

macro(_check_type_align_lang)
  set(_cta_supported C CXX)
  if(NOT DEFINED _CHECK_TYPE_ALIGN_LANGUAGE)
    set(_cta_language C)
  elseif(_CHECK_TYPE_ALIGN_LANGUAGE IN_LIST _cta_supported)
    set(_cta_language "${_CHECK_TYPE_ALIGN_LANGUAGE}")
  else()
    message(FATAL_ERROR "Unknown language:\n  ${_CHECK_TYPE_ALIGN_LANGUAGE}\nSupported languages: ${_cta_supported}.\n")
  endif()
  unset(_cta_supported)
endmacro()

macro(_check_type_align_include_c header variable)
  check_include_file("${header}" "${variable}")
  if(${variable})
    list(APPEND includes "${header}")
  endif()
endmacro()

macro(_check_type_align_include_cxx header variable)
  check_include_file_cxx("${header}" "${variable}")
  if(${variable})
    list(APPEND includes "${header}")
  endif()
endmacro()

macro(_check_type_align_system_types)
  if(_cta_language STREQUAL "C")
    _check_type_align_include_c(sys/types.h HAVE_SYS_TYPES_H)
    _check_type_align_include_c(stdint.h HAVE_STDINT_H)
    _check_type_align_include_c(stddef.h HAVE_STDDEF_H)
  elseif(_cta_language STREQUAL "CXX")
    _check_type_align_include_cxx(sys/types.h HAVE_SYS_TYPES_H)
    if(type MATCHES "^std::")
      _check_type_align_include_cxx(cstdint HAVE_CSTDINT)
      _check_type_align_include_cxx(cstddef HAVE_CSTDDEF)
    else()
      _check_type_align_include_cxx(stdint.h HAVE_STDINT_H)
      _check_type_align_include_cxx(stddef.h HAVE_STDDEF_H)
    endif()
  endif()
endmacro()

macro(_check_type_align_set var)
  if(NOT DEFINED "${var}")
    set("${var}" "")
  endif()
endmacro()

function(_check_type_align_impl type var builtin)
  set(fallback_cast_type "${CHECK_TYPE_ALIGN_FALLBACK_CAST_TYPE}")

  set(includes "")
  if(NOT builtin)
    _check_type_align_system_types()
  endif()
  if(DEFINED CMAKE_EXTRA_INCLUDE_FILES)
    list(APPEND includes ${CMAKE_EXTRA_INCLUDE_FILES})
  endif()

  if(NOT CMAKE_REQUIRED_QUIET)
    message(STATUS "Check alignment of ${type}")
  endif()

  set(headers "")
  foreach(h IN LISTS includes)
    string(APPEND headers "#include \"${h}\"\n")
  endforeach()

  set(src "${_cta_home}.c")
  if(_cta_language STREQUAL "CXX")
    set(src "${src}pp")
  endif()
  set(bin "${_cta_home}.bin")
  configure_file("${_CheckTypeAlign_DIRECTORY}/CheckTypeAlign.c.in" "${src}" @ONLY)

  _check_type_align_set(CMAKE_REQUIRED_DEFINITIONS)
  _check_type_align_set(CMAKE_REQUIRED_LIBRARIES)
  _check_type_align_set(CMAKE_REQUIRED_FLAGS)
  _check_type_align_set(CMAKE_REQUIRED_INCLUDES)
  set(link_options "")
  if(NOT CMAKE_VERSION VERSION_LESS "3.14")
    _check_type_align_set(CMAKE_REQUIRED_LINK_OPTIONS)
    if(NOT CMAKE_REQUIRED_LINK_OPTIONS STREQUAL "")
      set(link_options LINK_OPTIONS ${CMAKE_REQUIRED_LINK_OPTIONS})
    endif()
  endif()

  try_compile(
      "HAVE_${var}" "${CMAKE_BINARY_DIR}" "${src}"
      COMPILE_DEFINITIONS "${CMAKE_REQUIRED_DEFINITIONS}"
      LINK_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES}"
      ${link_options}
      CMAKE_FLAGS
      "-DCOMPILE_DEFINITIONS:STRING=${CMAKE_REQUIRED_FLAGS}"
      "-DINCLUDE_DIRECTORIES:STRING=${CMAKE_REQUIRED_INCLUDES}"
      OUTPUT_VARIABLE output
      COPY_FILE "${bin}"
  )

  if(NOT "${HAVE_${var}}")
    if(NOT CMAKE_REQUIRED_QUIET)
      message(STATUS "Check alignment of ${type} - failed")
    endif()
    file(READ "${src}" content)
    file(APPEND "${_cta_root}/CMakeError.log" "Determining alignment of ${type} failed with the following output:\n${output}\n${src}:\n${content}\n\n")
    set("${var}" "" CACHE INTERNAL "check_type_align: ${type} unknown")
    file(REMOVE "${_cta_map_file}")
    return()
  endif()

  file(STRINGS "${bin}" strings LIMIT_COUNT 10 REGEX "INFO:align")

  set(regex_align ".*INFO:align\\[0*([^]]*)\\].*")
  set(regex_key " key\\[([^]]*)\\]")
  set(keys "")
  set(code "")
  set(mismatch "")
  set(first 1)
  set(result "")
  foreach(info IN LISTS strings)
    if(NOT info MATCHES "${regex_align}")
      continue()
    endif()

    set(align "${CMAKE_MATCH_1}")
    if(first)
      set(result "${align}")
    elseif(NOT align STREQUAL result)
      set(mismatch 1)
    endif()
    set(first 0)

    string(REGEX MATCH   "${regex_key}"       key "${info}")
    string(REGEX REPLACE "${regex_key}" "\\1" key "${key}")
    if(key)
      string(APPEND code "\nset(${var}-${key} \"${align}\")")
      list(APPEND keys "${key}")
    endif()
  endforeach()

  if(mismatch AND keys)
    configure_file("${_CheckTypeAlign_DIRECTORY}/CheckTypeAlignMap.cmake.in" "${_cta_map_file}" @ONLY)
    set(result 0)
  else()
    file(REMOVE "${_cta_map_file}")
  endif()

  if(mismatch AND NOT keys)
    message(SEND_ERROR "check_type_align found different results, consider setting CMAKE_OSX_ARCHITECTURES or CMAKE_TRY_COMPILE_OSX_ARCHITECTURES to one or no architecture!")
  endif()

  if(NOT CMAKE_REQUIRED_QUIET)
    message(STATUS "Check alignment of ${type} - done")
  endif()
  file(APPEND "${_cta_root}/CMakeOutput.log" "Determining alignment of ${type} passed with the following output:\n${output}\n\n")
  set("${var}" "${result}" CACHE INTERNAL "check_type_align: alignof(${type})")
endfunction()

macro(check_type_align type variable)
  _check_type_align_parse_args(${ARGN})
  _check_type_align_lang()

  set(_cta_root "${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}")
  set(_cta_home "${_cta_root}/CheckTypeAlign/${variable}")
  unset("${variable}_KEYS")
  set(_cta_map_file "${_cta_home}.cmake")
  if(NOT DEFINED "HAVE_${variable}")
    _check_type_align_impl("${type}" "${variable}" "${_CHECK_TYPE_ALIGN_BUILTIN_TYPES_ONLY}")
  endif()
  include("${_cta_map_file}" OPTIONAL)
  unset(_cta_map_file)
  unset(_cta_home)
  unset(_cta_root)
  unset(_cta_language)

  if(DEFINED "${variable}_KEYS")
    set("${variable}_CODE" "")
    set(_cta_if if)
    foreach(key IN LISTS "${variable}_KEYS")
      string(APPEND "${variable}_CODE" "#${_cta_if} defined(${key})\n# define ${variable} ${${variable}-${key}}\n")
      set(_cta_if elif)
    endforeach()
    string(APPEND "${variable}_CODE" "#else\n# error ${variable} unknown\n#endif")
    unset(_cta_if)
  elseif(${variable})
    set("${variable}_CODE" "#define ${variable} ${${variable}}")
  else()
    set("${variable}_CODE" "/* #undef ${variable} */")
  endif()
endmacro()
