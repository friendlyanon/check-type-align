#include "config.h"

#ifdef HAVE_SYS_TYPES_H
#  include <sys/types.h>
#endif
#ifdef HAVE_STDINT_H
#  include <stdint.h>
#endif
#ifdef HAVE_STDDEF_H
#  include <stddef.h>
#endif

#include <stdio.h>

#define CHECK(t, m) \
  do { \
    if (_Alignof(t) != m) { \
      printf(#m ": expected %d, got %d (line %d)\n", (int)_Alignof(t), (int)m, \
             __LINE__); \
      result = 1; \
    } \
  } while (0)

#define NODEF(m) \
  do { \
    printf(#m ": not defined (line %d)\n", __LINE__); \
    result = 1; \
  } while (0)

int main(void)
{
  int result = 0;

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

  return result;
}
