#include "config.h"
#include "config.hxx"
#include "someclass.hxx"

#ifdef HAVE_SYS_TYPES_H
#  include <sys/types.h>
#endif
#ifdef HAVE_STDINT_H
#  include <stdint.h>
#endif
#ifdef HAVE_STDDEF_H
#  include <stddef.h>
#endif
#ifdef HAVE_CSTDINT
#  include <cstdint>
#endif
#ifdef HAVE_CSTDDEF
#  include <cstddef>
#endif

#include <cstdio>

#define CHECK(t, m) \
  do { \
    if (alignof(t) != m) { \
      std::printf(#m ": expected %d, got %d (line %d)\n", (int)alignof(t), \
                  (int)m, __LINE__); \
      result = 1; \
    } \
  } while (0)

#define NODEF(m) \
  do { \
    std::printf(#m ": not defined (line %d)\n", __LINE__); \
    result = 1; \
  } while (0)

int main()
{
  int result = 0;
  ns::someclass y;

/* void* */
#if !defined(HAVE_ALIGNOF_DATA_PTR)
  NODEF(HAVE_ALIGNOF_DATA_PTR);
#endif
#if defined(ALIGNOF_DATA_PTR)
  CHECK(void*, ALIGNOF_DATA_PTR);
#else
  NODEF(ALIGNOF_DATA_PTR);
#endif

/* char */
#if !defined(HAVE_ALIGNOF_CHAR)
  NODEF(HAVE_ALIGNOF_CHAR);
#endif
#if defined(ALIGNOF_CHAR)
  CHECK(char, ALIGNOF_CHAR);
#else
  NODEF(ALIGNOF_CHAR);
#endif

/* short */
#if !defined(HAVE_ALIGNOF_SHORT)
  NODEF(HAVE_ALIGNOF_SHORT);
#endif
#if defined(ALIGNOF_SHORT)
  CHECK(short, ALIGNOF_SHORT);
#else
  NODEF(ALIGNOF_SHORT);
#endif

/* int */
#if !defined(HAVE_ALIGNOF_INT)
  NODEF(HAVE_ALIGNOF_INT);
#endif
#if defined(ALIGNOF_INT)
  CHECK(int, ALIGNOF_INT);
#else
  NODEF(ALIGNOF_INT);
#endif

/* long */
#if !defined(HAVE_ALIGNOF_LONG)
  NODEF(HAVE_ALIGNOF_LONG);
#endif
#if defined(ALIGNOF_LONG)
  CHECK(long, ALIGNOF_LONG);
#else
  NODEF(ALIGNOF_LONG);
#endif

/* long long */
#if defined(ALIGNOF_LONG_LONG)
  CHECK(long long, ALIGNOF_LONG_LONG);
#  if !defined(HAVE_ALIGNOF_LONG_LONG)
  NODEF(HAVE_ALIGNOF_LONG_LONG);
#  endif
#endif

/* __int64 */
#if defined(ALIGNOF___INT64)
  CHECK(__int64, ALIGNOF___INT64);
#  if !defined(HAVE_ALIGNOF___INT64)
  NODEF(HAVE_ALIGNOF___INT64);
#  endif
#elif defined(HAVE_ALIGNOF___INT64)
  NODEF(ALIGNOF___INT64);
#endif

/* size_t */
#if !defined(HAVE_ALIGNOF_SIZE_T)
  NODEF(HAVE_ALIGNOF_SIZE_T);
#endif
#if defined(ALIGNOF_SIZE_T)
  CHECK(size_t, ALIGNOF_SIZE_T);
#else
  NODEF(ALIGNOF_SIZE_T);
#endif

/* ssize_t */
#if defined(ALIGNOF_SSIZE_T)
  CHECK(ssize_t, ALIGNOF_SSIZE_T);
#  if !defined(HAVE_ALIGNOF_SSIZE_T)
  NODEF(HAVE_ALIGNOF_SSIZE_T);
#  endif
#elif defined(HAVE_ALIGNOF_SSIZE_T)
  NODEF(ALIGNOF_SSIZE_T);
#endif

/* bool */
#if defined(ALIGNOF_BOOL)
  CHECK(bool, ALIGNOF_BOOL);
#  if !defined(HAVE_ALIGNOF_BOOL)
  NODEF(HAVE_ALIGNOF_BOOL);
#  endif
#elif defined(HAVE_ALIGNOF_BOOL)
  NODEF(ALIGNOF_BOOL);
#endif

/* uint8_t */
#if defined(ALIGNOF_UINT8_T)
  CHECK(uint8_t, ALIGNOF_UINT8_T);
#  if !defined(HAVE_ALIGNOF_UINT8_T)
  NODEF(HAVE_ALIGNOF_UINT8_T);
#  endif
#elif defined(HAVE_ALIGNOF_UINT8_T)
  NODEF(ALIGNOF_UINT8_T);
#endif

/* std::uint8_t */
#if defined(ALIGNOF_STD_UINT8_T)
  CHECK(std::uint8_t, ALIGNOF_STD_UINT8_T);
#  if !defined(HAVE_ALIGNOF_STD_UINT8_T)
  NODEF(HAVE_ALIGNOF_STD_UINT8_T);
#  endif
#elif defined(HAVE_ALIGNOF_STD_UINT8_T)
  NODEF(ALIGNOF_STD_UINT8_T);
#endif

/* ns::someclass::someint */
#if defined(SIZEOF_NS_CLASSMEMBER_INT)
  CHECK(decltype(y.someint), SIZEOF_NS_CLASSMEMBER_INT);
  CHECK(decltype(y.someint), SIZEOF_INT);
#  if !defined(HAVE_SIZEOF_NS_CLASSMEMBER_INT)
  NODEF(HAVE_SIZEOF_STRUCTMEMBER_INT);
#  endif
#elif defined(HAVE_SIZEOF_STRUCTMEMBER_INT)
  NODEF(SIZEOF_STRUCTMEMBER_INT);
#endif

/* ns::someclass::someptr */
#if defined(SIZEOF_NS_CLASSMEMBER_PTR)
  CHECK(decltype(y.someptr), SIZEOF_NS_CLASSMEMBER_PTR);
  CHECK(decltype(y.someptr), SIZEOF_DATA_PTR);
#  if !defined(HAVE_SIZEOF_NS_CLASSMEMBER_PTR)
  NODEF(HAVE_SIZEOF_NS_CLASSMEMBER_PTR);
#  endif
#elif defined(HAVE_SIZEOF_NS_CLASSMEMBER_PTR)
  NODEF(SIZEOF_NS_CLASSMEMBER_PTR);
#endif

/* ns::someclass::somechar */
#if defined(SIZEOF_NS_CLASSMEMBER_CHAR)
  CHECK(decltype(y.somechar), SIZEOF_NS_CLASSMEMBER_CHAR);
  CHECK(decltype(y.somechar), SIZEOF_CHAR);
#  if !defined(HAVE_SIZEOF_NS_CLASSMEMBER_CHAR)
  NODEF(HAVE_SIZEOF_NS_CLASSMEMBER_CHAR);
#  endif
#elif defined(HAVE_SIZEOF_NS_CLASSMEMBER_CHAR)
  NODEF(SIZEOF_NS_CLASSMEMBER_CHAR);
#endif

/* ns::someclass::somebool */
#if defined(SIZEOF_NS_CLASSMEMBER_BOOL)
  CHECK(decltype(y.somebool), SIZEOF_NS_CLASSMEMBER_BOOL);
  CHECK(decltype(y.somebool), SIZEOF_BOOL);
#  if !defined(HAVE_SIZEOF_NS_CLASSMEMBER_BOOL)
  NODEF(HAVE_SIZEOF_NS_CLASSMEMBER_BOOL);
#  endif
#elif defined(HAVE_SIZEOF_NS_CLASSMEMBER_BOOL)
  NODEF(SIZEOF_NS_CLASSMEMBER_BOOL);
#endif

  /* to avoid possible warnings about unused or write-only variable */
  y.someint = result;

  return y.someint;
}
