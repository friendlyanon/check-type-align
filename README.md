# CheckTypeAlign

This CMake module works similarly to [CheckTypeSize][1], with the addition of
the `CHECK_TYPE_ALIGN_USE_EXTENSION` cache variable. This can be set to
something like `__alignof__` on Clang or `__alignof` on MSVC to skip detection
or to provide an extension that is not known by the module. Check the
[`CheckTypeAlign.c.in`](cmake/CheckTypeAlign.c.in#L39) source file for known
compilers and their extensions. If you can help expanding the list, please open
an issue.

The only real difference from [CheckTypeSize][1] is due to the way `alignof` is
specified by the C++ and C standards; it cannot accept an expression as its
argument, only a `type-id`. The compiler extensions all support the former,
however the main target is the standard way, so the tests do not cover
expressions. In C++ mode, you can still use `decltype` to convert an expression
to a type.

This module requires CMake >= 3.9.

# Usage

This module is usable as a proper CMake package:

```
find_package(CheckTypeAlign REQUIRED)
check_type_align(int ALIGNOF_INT)
```

Make sure [`find_package`][2] can find it when configuring your project.

[1]: https://cmake.org/cmake/help/latest/module/CheckTypeSize.html
[2]: https://cmake.org/cmake/help/latest/command/find_package.html#config-mode-search-procedure
