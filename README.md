# CheckTypeAlign

This CMake module works similarly to [CheckTypeSize][1], with the addition of
the `CHECK_TYPE_ALIGN_FALLBACK_CAST_TYPE` and `CHECK_TYPE_ALIGN_USE_EXTENSION`
cache variables. The former is used only if the C or C++ standard is below 11
and the compiler is not among those that are known by the module to have a
compiler extension for querying the alignment of a type, while the latter can
be set to something like `__alignof__` on Clang or `__alignof` on MSVC to skip
detection or to provide an extension that is not known by the module. Check the
[`CheckTypeAlign.c.in`](cmake/CheckTypeAlign.c.in#L33) source file for known
compilers and their extensions. If you can help expanding the list, please open
an issue.

The only real difference from [CheckTypeSize][1] is due to the way `alignof` is
specified by the C++ and C standards; it cannot accept an expression as its
argument, only a `type-id`. The compiler extensions all support the former,
however the main target is the standard way, so the tests do not cover
expressions.

This module requires CMake >= 3.9.

[1]: https://cmake.org/cmake/help/latest/module/CheckTypeSize.html
