# CheckTypeAlign

This CMake module works exactly like [CheckTypeSize][1], with the addition of
the `CHECK_TYPE_ALIGN_FALLBACK_CAST_TYPE` cache variable. This variable is used
only if the C or C++ standard is below 11 and the compiler is not among those
that are known by the module to have a compiler extension for querying the
alignment of a type.

This module requires CMake >= 3.9.

[1]: https://cmake.org/cmake/help/latest/module/CheckTypeSize.html
