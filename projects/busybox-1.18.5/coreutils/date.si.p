##including host/platform-redhat.h
##including busybox/config.h
/* vi: set sw=4 ts=4: */
/*
 * Mini date implementation for busybox
 *
 * by Matthew Grant <grantma@anathoth.gen.nz>
 *
 * iso-format handling added by Robert Griebl <griebl@gmx.de>
 * bugfixes and cleanup by Bernhard Reutner-Fischer
 *
 * Licensed under GPLv2 or later, see file LICENSE in this source tree.
*/

/* This 'date' command supports only 2 time setting formats,
   all the GNU strftime stuff (its in libc, lets use it),
   setting time using UTC and displaying it, as well as
   an RFC 2822 compliant date output for shell scripting
   mail commands */

/* Input parsing code is always bulky - used heavy duty libc stuff as
   much as possible, missed out a lot of bounds checking */

//applet:IF_DATE(APPLET(date, _BB_DIR_BIN, _BB_SUID_DROP))

//kbuild:lib-$(CONFIG_DATE) += date.o

//config:config DATE
//config:	bool "date"
//config:	default y
//config:	help
//config:	  date is used to set the system date or display the
//config:	  current time in the given format.
//config:
//config:config FEATURE_DATE_ISOFMT
//config:	bool "Enable ISO date format output (-I)"
//config:	default y
//config:	depends on DATE
//config:	help
//config:	  Enable option (-I) to output an ISO-8601 compliant
//config:	  date/time string.
//config:
//config:# defaults to "no": stat's nanosecond field is a bit non-portable
//config:config FEATURE_DATE_NANO
//config:	bool "Support %[num]N nanosecond format specifier"
//config:	default n
//config:	depends on DATE && PLATFORM_LINUX # syscall(__NR_clock_gettime)
//config:	help
//config:	  Support %[num]N format specifier. Adds ~250 bytes of code.
//config:
//config:config FEATURE_DATE_COMPAT
//config:	bool "Support weird 'date MMDDhhmm[[YY]YY][.ss]' format"
//config:	default y
//config:	depends on DATE
//config:	help
//config:	  System time can be set by 'date -s DATE' and simply 'date DATE',
//config:	  but formats of DATE string are different. 'date DATE' accepts
//config:	  a rather weird MMDDhhmm[[YY]YY][.ss] format with completely
//config:	  unnatural placement of year between minutes and seconds.
//config:	  date -s (and other commands like touch -d) use more sensible
//config:	  formats (for one, ISO format YYYY-MM-DD hh:mm:ss.ssssss).
//config:
//config:	  With this option off, 'date DATE' is 'date -s DATE' support
//config:	  the same format. With it on, 'date DATE' additionally supports
//config:	  MMDDhhmm[[YY]YY][.ss] format.

/* GNU coreutils 6.9 man page:
 * date [OPTION]... [+FORMAT]
 * date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
 * -d, --date=STRING
 *      display time described by STRING, not `now'
 * -f, --file=DATEFILE
 *      like --date once for each line of DATEFILE
 * -r, --reference=FILE
 *      display the last modification time of FILE
 * -R, --rfc-2822
 *      output date and time in RFC 2822 format.
 *      Example: Mon, 07 Aug 2006 12:34:56 -0600
 * --rfc-3339=TIMESPEC
 *      output date and time in RFC 3339 format.
 *      TIMESPEC='date', 'seconds', or 'ns'
 *      Date and time components are separated by a single space:
 *      2006-08-07 12:34:56-06:00
 * -s, --set=STRING
 *      set time described by STRING
 * -u, --utc, --universal
 *      print or set Coordinated Universal Time
 *
 * Busybox:
 * long options are not supported
 * -f is not supported
 * -I seems to roughly match --rfc-3339, but -I has _optional_ param
 *    (thus "-I seconds" doesn't work, only "-Iseconds"),
 *    and does not support -Ins
 * -D FMT is a bbox extension for _input_ conversion of -d DATE
 */

//usage:#define date_trivial_usage
//usage:       "[OPTIONS] [+FMT] [TIME]"
//usage:#define date_full_usage "\n\n"
//usage:       "Display time (using +FMT), or set time\n"
//usage:     "\nOptions:"
//usage:	IF_NOT_LONG_OPTS(
//usage:     "\n	[-s] TIME	Set time to TIME"
//usage:     "\n	-u		Work in UTC (don't convert to local time)"
//usage:     "\n	-R		Output RFC-2822 compliant date string"
//usage:	) IF_LONG_OPTS(
//usage:     "\n	[-s,--set] TIME	Set time to TIME"
//usage:     "\n	-u,--utc	Work in UTC (don't convert to local time)"
//usage:     "\n	-R,--rfc-2822	Output RFC-2822 compliant date string"
//usage:	)
//usage:	IF_FEATURE_DATE_ISOFMT(
//usage:     "\n	-I[SPEC]	Output ISO-8601 compliant date string"
//usage:     "\n			SPEC='date' (default) for date only,"
//usage:     "\n			'hours', 'minutes', or 'seconds' for date and"
//usage:     "\n			time to the indicated precision"
//usage:	)
//usage:	IF_NOT_LONG_OPTS(
//usage:     "\n	-r FILE		Display last modification time of FILE"
//usage:     "\n	-d TIME		Display TIME, not 'now'"
//usage:	) IF_LONG_OPTS(
//usage:     "\n	-r,--reference FILE	Display last modification time of FILE"
//usage:     "\n	-d,--date TIME	Display TIME, not 'now'"
//usage:	)
//usage:	IF_FEATURE_DATE_ISOFMT(
//usage:     "\n	-D FMT		Use FMT for -d TIME conversion"
//usage:	)
//usage:     "\n"
//usage:     "\nRecognized TIME formats:"
//usage:     "\n	hh:mm[:ss]"
//usage:     "\n	[YYYY.]MM.DD-hh:mm[:ss]"
//usage:     "\n	YYYY-MM-DD hh:mm[:ss]"
//usage:     "\n	[[[[[YY]YY]MM]DD]hh]mm[.ss]"
//usage:
//usage:#define date_example_usage
//usage:       "$ date\n"
//usage:       "Wed Apr 12 18:52:41 MDT 2000\n"

##including libbb.h
/* vi: set sw=4 ts=4: */
/*
 * Busybox main internal header file
 *
 * Based in part on code from sash, Copyright (c) 1999 by David I. Bell
 * Permission has been granted to redistribute this code under GPL.
 *
 * Licensed under GPLv2, see file LICENSE in this source tree.
 */
#if 1
##including platform.h
/* vi: set sw=4 ts=4: */
/*
 * Copyright 2006, Bernhard Reutner-Fischer
 *
 * Licensed under GPLv2 or later, see file LICENSE in this source tree.
 */
#if 1
/* Assume all these functions exist by default.  Platforms where it is not
 * true will #undef them below.
 */
/* Convenience macros to test the version of gcc. */
#if 1
#endif
/* __restrict is known in EGCS 1.2 and above. */
#endif
/* Define macros for some gcc attributes.  This permits us to use the
   macros freely, and know that they will come into play for the
   version of gcc in which they are supported.  */

#endif
#elif 1
#endif
#if 1
#endif
/* "The malloc attribute is used to tell the compiler that a function
 * may be treated as if any non-NULL pointer it returns cannot alias
 * any other pointer valid when the function returns. This will often
 * improve optimization. Standard functions with this property include
 * malloc and calloc. realloc-like functions have this property as long
 * as the old pointer is never referred to (including comparing it
 * to the new pointer) after the function returns a non-NULL value."
 */
/* __NO_INLINE__: some gcc's do not honor inlining! :( */
#elif 1
#endif
/* -fwhole-program makes all symbols local. The attribute externally_visible
   forces a symbol global.  */
#if 1
#endif
/* At 4.4 gcc become much more anal about this, need to use "aliased" types */
#if 1
#endif
/* We use __extension__ in some places to suppress -pedantic warnings
   about GCC extensions.  This feature didn't work properly before
   gcc 2.8.  */
#endif
/* gcc-2.95 had no va_copy but only __va_copy. */
#endif
/* FAST_FUNC is a qualifier which (possibly) makes function call faster
 * and/or smaller by using modified ABI. It is usually only needed
 * on non-static, busybox internal functions. Recent versions of gcc
 * optimize statics automatically. FAST_FUNC on static is required
 * only if you need to match a function pointer's type */
#elif 1
#endif
/* Make all declarations hidden (-fvisibility flag only affects definitions) */
/* (don't include system headers after this until corresponding pop!) */
#if 1
#endif
/* ---- Endian Detection ------------------------------------ */

##including limits.h
/* Copyright (C) 1991, 1992, 1996, 1997, 1998, 1999, 2000, 2005
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.10/5.2.4.2.1 Sizes of integer types	<limits.h>
 */

#if 1
##including features.h
/* Copyright (C) 1991-1993,1995-2007,2009,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
/* These are defined by the user (or the compiler)
   to specify the desired environment:

   __STRICT_ANSI__	ISO Standard C.
   _ISOC99_SOURCE	Extensions to ISO C89 from ISO C99.
   _POSIX_SOURCE	IEEE Std 1003.1.
   _POSIX_C_SOURCE	If ==1, like _POSIX_SOURCE; if >=2 add IEEE Std 1003.2;
			if >=199309L, add IEEE Std 1003.1b-1993;
			if >=199506L, add IEEE Std 1003.1c-1995;
			if >=200112L, all of IEEE 1003.1-2004
			if >=200809L, all of IEEE 1003.1-2008
   _XOPEN_SOURCE	Includes POSIX and XPG things.  Set to 500 if
			Single Unix conformance is wanted, to 600 for the
			sixth revision, to 700 for the seventh revision.
   _XOPEN_SOURCE_EXTENDED XPG things and X/Open Unix extensions.
   _LARGEFILE_SOURCE	Some more functions for correct standard I/O.
   _LARGEFILE64_SOURCE	Additional functionality from LFS for large files.
   _FILE_OFFSET_BITS=N	Select default filesystem interface.
   _BSD_SOURCE		ISO C, POSIX, and 4.3BSD things.
   _SVID_SOURCE		ISO C, POSIX, and SVID things.
   _ATFILE_SOURCE	Additional *at interfaces.
   _GNU_SOURCE		All of the above, plus GNU extensions.
   _REENTRANT		Select additionally reentrant object.
   _THREAD_SAFE		Same as _REENTRANT, often used by other systems.
   _FORTIFY_SOURCE	If set to numeric value > 0 additional security
			measures are defined, according to level.

   The `-ansi' switch to the GNU C compiler defines __STRICT_ANSI__.
   If none of these are defined, the default is to have _SVID_SOURCE,
   _BSD_SOURCE, and _POSIX_SOURCE set to one and _POSIX_C_SOURCE set to
   200112L.  If more than one of these are defined, they accumulate.
   For example __STRICT_ANSI__, _POSIX_SOURCE and _POSIX_C_SOURCE
   together give you ISO C, 1003.1, and 1003.2, but nothing else.

   These are defined by this file and are used by the
   header files to decide what to declare or define:

   __USE_ISOC99		Define ISO C99 things.
   __USE_ISOC95		Define ISO C90 AMD1 (C95) things.
   __USE_POSIX		Define IEEE Std 1003.1 things.
   __USE_POSIX2		Define IEEE Std 1003.2 things.
   __USE_POSIX199309	Define IEEE Std 1003.1, and .1b things.
   __USE_POSIX199506	Define IEEE Std 1003.1, .1b, .1c and .1i things.
   __USE_XOPEN		Define XPG things.
   __USE_XOPEN_EXTENDED	Define X/Open Unix things.
   __USE_UNIX98		Define Single Unix V2 things.
   __USE_XOPEN2K        Define XPG6 things.
   __USE_XOPEN2KXSI     Define XPG6 XSI things.
   __USE_XOPEN2K8XSI    Define XPG7 XSI things.
   __USE_LARGEFILE	Define correct standard I/O things.
   __USE_LARGEFILE64	Define LFS things with separate names.
   __USE_FILE_OFFSET64	Define 64bit interface as default.
   __USE_BSD		Define 4.3BSD things.
   __USE_SVID		Define SVID things.
   __USE_MISC		Define things common to BSD and System V Unix.
   __USE_ATFILE		Define *at interfaces and AT_* constants for them.
   __USE_GNU		Define GNU extensions.
   __USE_REENTRANT	Define reentrant/thread-safe *_r functions.
   __USE_FORTIFY_LEVEL	Additional security measures used, according to level.
   __FAVOR_BSD		Favor 4.3BSD things in cases of conflict.

   The macros `__GNU_LIBRARY__', `__GLIBC__', and `__GLIBC_MINOR__' are
   defined by this file unconditionally.  `__GNU_LIBRARY__' is provided
   only for compatibility.  All new code should use the other symbols
   to test for features.

   All macros listed above as possibly being defined by this file are
   explicitly undefined if they are not explicitly defined.
   Feature-test macros that are not defined by the user or compiler
   but are implied by the other feature-test macros defined (or by the
   lack of any definitions) are defined by the file.  */


/* Undefine everything, so we get a clean slate.  */
/* Suppress kernel-name space pollution unless user expressedly asks
   for it.  */
#if 1
#endif
/* Always use ISO C things.  */
/* Convenience macros to test the versions of glibc and gcc.
   Use them like this:
   #if __GNUC_PREREQ (2,8)
   ... code requiring gcc 2.8 or later ...
   #endif
   Note - they won't work for gcc1 or glibc1, since the _MINOR macros
   were not defined then.  */
#if 1
#endif
/* If _BSD_SOURCE was defined by the user, favor BSD over POSIX.  */
#endif
/* If _GNU_SOURCE was defined by the user, turn on all the other features.  */
#endif
/* If nothing (other than _GNU_SOURCE) is defined,
   define _BSD_SOURCE and _SVID_SOURCE.  */
#if 1
#endif
/* This is to enable the ISO C99 extension.  Also recognize the old macro
   which was used prior to the standard acceptance.  This macro will
   eventually go away and the features enabled by default once the ISO C99
   standard is widely adopted.  */
#if 1
#endif
/* This is to enable the ISO C90 Amendment 1:1995 extension.  */
#if 1
#endif
/* If none of the ANSI/POSIX macros are defined, use POSIX.1 and POSIX.2
   (and IEEE Std 1003.1b-1993 unless _XOPEN_SOURCE is defined).  */
#if 1
#elif 1
#endif
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#endif
#endif
#endif
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#endif
#endif
#elif 1
#endif
/* We do support the IEC 559 math functionality, real and complex.  */
/* wchar_t uses ISO 10646-1 (2nd ed., published 2000-09-15) / Unicode 3.1.  */
/* This macro indicates that the installed library is the GNU C Library.
   For historic reasons the value now is 6 and this will stay from now
   on.  The use of this variable is deprecated.  Use __GLIBC__ and
   __GLIBC_MINOR__ now (see below) when you want to test for a specific
   GNU C library version and use the values in <gnu/lib-names.h> to get
   the sonames of the shared libraries.  */
/* Major and minor version number of the GNU C library package.  Use
   these macros to test for features in specific releases.  */
/* Decide whether a compiler supports the long long datatypes.  */
#if 1
#endif
/* This is here only because every header file already includes this one.  */
#if 1
#if 1
##including sys/cdefs.h
/* Copyright (C) 1992-2001, 2002, 2004, 2005, 2006, 2007, 2009
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
/* We are almost always included from features.h. */
#endif
/* The GNU libc does not support any K&R compilers or the traditional mode
   of ISO C compilers anymore.  Check for some of the combinations not
   anymore supported.  */
#endif
/* Some user header file might have defined this before.  */
#if 1
/* GCC can always grok prototypes.  For C++ programs we add throw()
   to help it optimize the function calls.  But this works only with
   gcc 2.8.x and egcs.  For gcc 3.2 and up we even mark C functions
   as non-throwing using a function attribute since programs can use
   the -fexceptions options for C code as well.  */
#if 1
#endif
#endif
/* These two macros are not used in glibc anymore.  They are kept here
   only because some other projects expect the macros to be defined.  */
/* For these things, GCC behaves the ANSI way normally,
   and the non-ANSI way under -traditional.  */

/* This is not a typedef so `const __ptr_t' does the right thing.  */
/* C++ needs to know that types and declarations are C, not C++.  */
#elif 1
#endif
/* The standard library needs the functions from the ISO C90 standard
   in the std namespace.  At the same time we want to be safe for
   future changes and we include the ISO C99 code in the non-standard
   namespace __c99.  The C++ wrapper header take case of adding the
   definitions to the global namespace.  */
#elif 1
/* For compatibility we do not add the declarations into any
   namespace.  They will end up in the global namespace which is what
   old code expects.  */
#endif
/* Support for bounded pointers.  */
#if 1
#endif
/* Fortify support.  */
#if 1
#endif
/* Support for flexible arrays.  */
#if 1
/* GCC 2.97 supports C99 flexible array members.  */
#endif
/* __asm__ ("xyz") is used throughout the headers to rename functions
   at the assembly language level.  This is wrapped by the __REDIRECT
   macro, in order to support compilers that can do this some other
   way.  When compilers don't support asm-names at all, we have to do
   preprocessor tricks instead (which don't have exactly the right
   semantics, but it's the best we can do).

   Example:
   int __REDIRECT(setpgrp, (__pid_t pid, __pid_t pgrp), setpgid); */

#if 1
#elif 1
#endif
/*
#elif __SOME_OTHER_COMPILER__

# define __REDIRECT(name, proto, alias) name proto; \
	_Pragma("let " #name " = " #alias)
*/
#endif
/* GCC has various useful declarations that can be made with the
   `__attribute__' syntax.  All of the ways we use this do fine if
   they are omitted for compilers that don't understand it. */
#endif
/* At some point during the gcc 2.96 development the `malloc' attribute
   for functions was introduced.  We don't want to use it unconditionally
   (although this would be possible) since it generates warnings.  */
#if 1
#endif
/* At some point during the gcc 2.96 development the `pure' attribute
   for functions was introduced.  We don't want to use it unconditionally
   (although this would be possible) since it generates warnings.  */
#if 1
#endif
/* At some point during the gcc 3.1 development the `used' attribute
   for functions was introduced.  We don't want to use it unconditionally
   (although this would be possible) since it generates warnings.  */
#if 1
#endif
/* gcc allows marking deprecated functions.  */
#if 1
#endif
/* At some point during the gcc 2.8 development the `format_arg' attribute
   for functions was introduced.  We don't want to use it unconditionally
   (although this would be possible) since it generates warnings.
   If several `format_arg' attributes are given for the same function, in
   gcc-3.0 and older, all but the last one are ignored.  In newer gccs,
   all designated arguments are considered.  */
#if 1
#endif
/* At some point during the gcc 2.97 development the `strfmon' format
   attribute for functions was introduced.  We don't want to use it
   unconditionally (although this would be possible) since it
   generates warnings.  */
#if 1
#endif
/* The nonull function attribute allows to mark pointer parameters which
   must not be NULL.  */
#if 1
#endif
/* If fortification mode, we warn about unused results of certain
   function calls which can lead to problems.  */
#if 1
#endif
#endif
#if 1
#endif
/* Forces a function to be always inlined.  */
#if 1
#endif
/* GCC 4.3 and above with -std=c99 or -std=gnu99 implements ISO C99
   inline semantics, unless -fgnu89-inline is used.  */
#if 1
#if 1
#if 1
#endif
#endif
#endif
/* GCC 4.3 and above allow passing all anonymous arguments of an
   __extern_always_inline function to some other vararg function.  */
#if 1
#endif
/* It is possible to compile containing GCC extensions even if GCC is
   run in pedantic mode if the uses are carefully marked using the
   `__extension__' keyword.  But this is not generally available before
   version 2.8.  */
#endif
/* __restrict is known in EGCS 1.2 and above. */
#endif
/* ISO C99 also allows to declare arrays as non-overlapping.  The syntax is
     array_name[restrict]
   GCC 3.1 supports this.  */
#if 1
#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#endif
#if 1
#if 1
#endif
#endif
#endif
#endif
/* If we don't have __REDIRECT, prototypes will be missing if
   __USE_FILE_OFFSET64 but not __USE_LARGEFILE[64]. */
#endif
#endif
/* Decide whether we can define 'extern inline' functions in headers.  */
#endif
/* This is here only because every header file already includes this one.
   Get the definitions of all the appropriate `__stub_FUNCTION' symbols.
   <gnu/stubs.h> contains `#define __stub_FUNCTION' when FUNCTION is a stub
   that will always return failure (and set errno to ENOSYS).  */
##including gnu/stubs.h
/* This file selects the right generated file of `__stub_FUNCTION' macros
   based on the architecture being compiled for.  */

##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#elif 1
##including gnu/stubs-64.h
/* This file is automatically generated.
   It defines a symbol `__stub_FUNCTION' for each function
   in the C library which is a stub, meaning it will fail
   every time called, usually setting errno to ENOSYS.  */

#endif
#endif
#endif
/* Maximum length of any multibyte character in any locale.
   We define this value here since the gcc header does not define
   the correct value.  */
/* If we are not using GNU CC we have to define all the symbols ourself.
   Otherwise use gcc's definitions (see below).  */
#endif
#endif
/* Get the compiler's limits.h, which defines almost all the ISO constants.

    We put this #include_next outside the double inclusion check because
    it should be possible to include this file more than once and still get
    the definitions from gcc's header.  */
#if 1
/* `_GCC_LIMITS_H_' is what GCC's file defines.  */
##including limits.h
/* This administrivia gets added to the beginning of limits.h
   if the system has its own version of limits.h.  */

/* We use _GCC_LIMITS_H_ because we want this not to match
   any macros that the system's limits.h uses for its own purposes.  */
#if 1
#endif
#if 1
/* Number of bits in a `char'.  */
/* Maximum length of a multibyte character.  */
#endif
/* Minimum and maximum values a `signed char' can hold.  */
/* Maximum value an `unsigned char' can hold.  (Minimum is 0).  */
#elif 1
#endif
/* Minimum and maximum values a `char' can hold.  */
#elif 1
#endif
/* Minimum and maximum values a `signed short int' can hold.  */
/* Maximum value an `unsigned short int' can hold.  (Minimum is 0).  */
#elif 1
#endif
/* Minimum and maximum values a `signed int' can hold.  */
/* Maximum value an `unsigned int' can hold.  (Minimum is 0).  */
/* Minimum and maximum values a `signed long int' can hold.
   (Same as `int').  */
/* Maximum value an `unsigned long int' can hold.  (Minimum is 0).  */
#if 1
/* Minimum and maximum values a `signed long long int' can hold.  */
/* Maximum value an `unsigned long long int' can hold.  (Minimum is 0).  */
#endif
#endif
#endif
/* This administrivia gets added to the end of limits.h
   if the system has its own version of limits.h.  */

#endif
#endif
/* The <limits.h> files in some gcc versions don't define LLONG_MIN,
   LLONG_MAX, and ULLONG_MAX.  Instead only the values gcc defined for
   ages are available.  */
#if 1
#endif
#endif
#endif
#endif
#if 1
/* POSIX adds things to <limits.h>.  */
##including bits/posix1_lim.h
/* Copyright (C) 1991-1993,96,98,2000-2003,2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 2.9.2 Minimum Values	Added to <limits.h>
 *
 *	Never include this file directly; use <limits.h> instead.
 */

#if 1
/* These are the standard-mandated minimum values.  */

/* Minimum number of operations in one list I/O call.  */
/* Minimal number of outstanding asynchronous I/O operations.  */
/* Maximum length of arguments to `execve', including environment.  */
/* Maximum simultaneous processes per real user ID.  */
#if 1
#endif
/* Minimal number of timer expiration overruns.  */
/* Maximum length of a host name (not including the terminating null)
   as returned from the GETHOSTNAME function.  */
/* Maximum link count of a file.  */
/* Maximum length of login name.  */
/* Number of bytes in a terminal canonical input queue.  */
/* Number of bytes for which space will be
   available in a terminal input queue.  */
/* Maximum number of message queues open for a process.  */
/* Maximum number of supported message priorities.  */
/* Number of bytes in a filename.  */
/* Number of simultaneous supplementary group IDs per process.  */
#if 1
#endif
/* Number of files one process can have open at once.  */
#if 1
#endif
#endif
/* Number of bytes in a pathname.  */
/* Number of bytes than can be written atomically to a pipe.  */
/* The number of repeated occurrences of a BRE permitted by the
   REGEXEC and REGCOMP functions when using the interval notation.  */
/* Minimal number of realtime signals reserved for the application.  */
/* Number of semaphores a process can have.  */
/* Maximal value of a semaphore.  */
/* Number of pending realtime signals.  */
/* Largest value of a `ssize_t'.  */
/* Number of streams a process can have open at once.  */
/* The number of bytes in a symbolic link.  */
/* The number of symbolic links that can be traversed in the
   resolution of a pathname in the absence of a loop.  */
/* Number of timer for a process.  */
/* Maximum number of characters in a tty name.  */
/* Maximum length of a timezone name (element of `tzname').  */
#endif
/* Maximum clock resolution in nanoseconds.  */
/* Get the implementation-specific values for the above.  */
##including bits/local_lim.h
/* Minimum guaranteed maximum values for system limits.  Linux version.
   Copyright (C) 1993-1998,2000,2002-2004,2008 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If not,
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* The kernel header pollutes the namespace with the NR_OPEN symbol
   and defines LINK_MAX although filesystems have different maxima.  A
   similar thing is true for OPEN_MAX: the limit can be changed at
   runtime and therefore the macro must not be defined.  Remove this
   after including the header if necessary.  */
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
/* The kernel sources contain a file with all the needed information.  */
##including linux/limits.h
#if 1
#endif
/* Have to remove NR_OPEN?  */
#if 1
#endif
/* Have to remove LINK_MAX?  */
#if 1
#endif
/* Have to remove OPEN_MAX?  */
#if 1
#endif
/* Have to remove ARG_MAX?  */
#if 1
#endif
/* The number of data keys per process.  */
/* This is the value this implementation supports.  */
/* Controlling the iterations of destructors for thread-specific data.  */
/* Number of iterations this implementation does.  */
/* The number of threads per process.  */
/* We have no predefined limit on the number of threads.  */
/* Maximum amount by which a process can descrease its asynchronous I/O
   priority level.  */
/* Minimum size for a thread.  We are free to choose a reasonable value.  */
/* Maximum number of timer expiration overruns.  */
/* Maximum tty name length.  */
/* Maximum login name length.  This is arbitrary.  */
/* Maximum host name length.  */
/* Maximum message queue priority level.  */
/* Maximum value the semaphore can have.  */
#if 1
#endif
/* This value is a guaranteed minimum maximum.
   The current maximum can be got from `sysconf'.  */

#endif
#endif
#endif
#if 1
##including bits/posix2_lim.h
/* Copyright (C) 1991, 1996, 1999, 2000, 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; include <limits.h> instead.
 */

#if 1
/* The maximum `ibase' and `obase' values allowed by the `bc' utility.  */
/* The maximum number of elements allowed in an array by the `bc' utility.  */
/* The maximum `scale' value allowed by the `bc' utility.  */
/* The maximum length of a string constant accepted by the `bc' utility.  */
/* The maximum number of weights that can be assigned to an entry of
   the LC_COLLATE `order' keyword in the locale definition file.  */
/* The maximum number of expressions that can be nested
   within parentheses by the `expr' utility.  */
/* The maximum length, in bytes, of an input line.  */
/* The maximum number of repeated occurrences of a regular expression
   permitted when using the interval notation `\{M,N\}'.  */
/* The maximum number of bytes in a character class name.  We have no
   fixed limit, 2048 is a high number.  */
/* These values are implementation-specific,
   and may vary within the implementation.
   Their precise values can be obtained from sysconf.  */

#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
/* This value is defined like this in regex.h.  */
#endif
#endif
#endif
#elif 1
##including byteswap.h
/* Copyright (C) 1997 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
/* Get the machine specific, optimized definitions.  */
##including bits/byteswap.h
/* Macros to swap the order of bytes in integer values.
   Copyright (C) 1997, 1998, 2000, 2002, 2003, 2007, 2008
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#if 1
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
/* Swap bytes in 16 bit value.  */
#if 1
#endif
/* Swap bytes in 32 bit value.  */
#if 1
#if 1
/* To swap the bytes in a word the i486 processors and up provide the
   `bswap' opcode.  On i386 we have to use three instructions.  */
#endif
#endif
#if 1
/* Swap bytes in 64 bit value.  */
#if 1
#endif
#endif
#endif
/* The following definitions must all be macros since otherwise some
   of the possible optimizations are not possible.  */

/* Return a value with all bytes in the 16 bit argument swapped.  */
/* Return a value with all bytes in the 32 bit argument swapped.  */
#if 1
/* Return a value with all bytes in the 64 bit argument swapped.  */
#endif
#endif
##including endian.h
/* Copyright (C) 1992, 1996, 1997, 2000, 2008 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
/* Definitions for byte order, according to significance of bytes,
   from low addresses to high addresses.  The value is what you get by
   putting '4' in the most significant byte, '3' in the second most
   significant byte, '2' in the second least significant byte, and '1'
   in the least significant byte, and then writing down one digit for
   each byte, starting with the byte at the lowest address at the left,
   and proceeding to the byte with the highest address at the right.  */

/* This file defines `__BYTE_ORDER' for the particular machine.  */
##including bits/endian.h
/* x86_64 is little-endian.  */

#endif
/* Some machines may need to use a different endianness for floating point
   values.  */
#if 1
#endif
#if 1
#endif
#endif
#if 1
/* Conversion interfaces.  */
##including bits/byteswap.h
/* Macros to swap the order of bytes in integer values.
   Copyright (C) 1997, 1998, 2000, 2002, 2003, 2007, 2008
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#endif
#elif 1
#endif
#endif
#endif
#endif
#elif 1
#endif
#endif
/* SWAP_LEnn means "convert CPU<->little_endian by swapping bytes" */
#elif 1
#endif
/* ---- Unaligned access ------------------------------------ */

/* NB: unaligned parameter should be a pointer, aligned one -
 * a lvalue. This makes it more likely to not swap them by mistake
 */
#if 1
##including stdint.h
/* Copyright (C) 1997,1998,1999,2000,2001,2006 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99: 7.18 Integer types <stdint.h>
 */

#if 1
##including features.h
##including bits/wchar.h
/* wchar_t type related definitions.
   Copyright (C) 2000 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
/* Exact integral types.  */

/* Signed.  */

/* There is some amount of overlap with <sys/types.h> as known by inet code */
#if 1
typedef signed char		int8_t;
typedef short int		int16_t;
typedef int			int32_t;
#if 1
typedef long int		int64_t;
#endif
#endif
/* Unsigned.  */
typedef unsigned char		uint8_t;
typedef unsigned short int	uint16_t;
#if 1
typedef unsigned int		uint32_t;
#endif
#if 1
typedef unsigned long int	uint64_t;
#endif
/* Small types.  */

/* Signed.  */
typedef signed char		int_least8_t;
typedef short int		int_least16_t;
typedef int			int_least32_t;
#if 1
typedef long int		int_least64_t;
#endif
/* Unsigned.  */
typedef unsigned char		uint_least8_t;
typedef unsigned short int	uint_least16_t;
typedef unsigned int		uint_least32_t;
#if 1
typedef unsigned long int	uint_least64_t;
#endif
/* Fast types.  */

/* Signed.  */
typedef signed char		int_fast8_t;
#if 1
typedef long int		int_fast16_t;
typedef long int		int_fast32_t;
typedef long int		int_fast64_t;
#endif
/* Unsigned.  */
typedef unsigned char		uint_fast8_t;
#if 1
typedef unsigned long int	uint_fast16_t;
typedef unsigned long int	uint_fast32_t;
typedef unsigned long int	uint_fast64_t;
#endif
/* Types for `void *' pointers.  */
#if 1
#if 1
typedef long int		intptr_t;
#endif
typedef unsigned long int	uintptr_t;
#endif
/* Largest integral types.  */
#if 1
typedef long int		intmax_t;
typedef unsigned long int	uintmax_t;
#endif
/* The ISO C99 standard specifies that in C++ implementations these
   macros should only be defined if explicitly requested.  */
#if 1
#if 1
#endif
/* Limits of integral types.  */

/* Minimum of signed integral types.  */
/* Maximum of signed integral types.  */
/* Maximum of unsigned integral types.  */
/* Minimum of signed integral types having a minimum size.  */
/* Maximum of signed integral types having a minimum size.  */
/* Maximum of unsigned integral types having a minimum size.  */
/* Minimum of fast signed integral types having a minimum size.  */
#if 1
#endif
/* Maximum of fast signed integral types having a minimum size.  */
#if 1
#endif
/* Maximum of fast unsigned integral types having a minimum size.  */
#if 1
#endif
/* Values to test for integral types holding `void *' pointer.  */
#if 1
#endif
/* Minimum for largest signed integral type.  */
/* Maximum for largest signed integral type.  */
/* Maximum for largest unsigned integral type.  */
/* Limits of other integer types.  */

/* Limits of `ptrdiff_t' type.  */
#if 1
#endif
/* Limits of `sig_atomic_t'.  */
/* Limit of `size_t' type.  */
#if 1
#endif
/* Limits of `wchar_t'.  */
#if 1
/* These constants might also be defined in <wchar.h>.  */
#endif
/* Limits of `wint_t'.  */
#endif
/* The ISO C99 standard specifies that in C++ implementations these
   should only be defined if explicitly requested.  */
#if 1
/* Signed.  */
#if 1
#endif
/* Unsigned.  */
#if 1
#endif
/* Maximal type.  */
#if 1
#endif
#endif
#endif
typedef int      bb__aliased_int      __attribute__((__may_alias__));
typedef uint16_t bb__aliased_uint16_t __attribute__((__may_alias__));
typedef uint32_t bb__aliased_uint32_t __attribute__((__may_alias__));
/* #elif ... - add your favorite arch today! */
#endif
/* ---- Compiler dependent settings ------------------------- */

#elif 1
#endif
/*----- Kernel versioning ------------------------------------*/

/* ---- Miscellaneous --------------------------------------- */

#if 1
##including features.h
#endif
/* Size-saving "small" ints (arch-dependent) */
#if 1
/* add other arches which benefit from this... */
typedef signed char smallint;
typedef unsigned char smalluint;
#endif
/* ISO C Standard:  7.16  Boolean type and values  <stdbool.h> */
#elif 1
/* modern system, so use it */
##including stdbool.h
/* Copyright (C) 1998, 1999, 2000, 2009 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.16  Boolean type and values  <stdbool.h>
 */

#if 1
#if 1
#endif
/* Signal that all the definitions are present.  */
#endif
#endif
/* Try to defeat gcc's alignment of "char message[]"-like data */
#if 1
#endif
/* uclibc does not implement daemon() for no-mmu systems.
 * For 0.9.29 and svn, __ARCH_USE_MMU__ indicates no-mmu reliably.
 * For earlier versions there is no reliable way to check if we are building
 * for a mmu-less system.
 */
#if (defined CONFIG_NOMMU)
#elif !(defined CONFIG_NOMMU)
#endif
/* Don't use lchown with glibc older than 2.1.x */
#endif
#elif 1
#endif
#if 1
#endif
#endif
#endif
#endif
/*
 * Now, define prototypes for all the functions defined in platform.c
 * These must come after all the HAVE_* macros are defined (or not)
 */

#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
##including ctype.h
/* Copyright (C) 1991,92,93,95,96,97,98,99,2001,2002,2004,2007,2008,2009
   	Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard 7.4: Character handling	<ctype.h>
 */

#if 1
##including features.h
##including bits/types.h
/* bits/types.h -- definitions of __*_t types underlying *_t types.
   Copyright (C) 2002, 2003, 2004, 2005, 2007 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; use <sys/types.h> instead.
 */

#if 1
##including features.h
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
/* Convenience types.  */
typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;

/* Fixed-size types, underlying types depend on word size and compiler.  */
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
#if 1
typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;
#endif
/* quad_t is also 64 bits.  */
#if 1
typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
#endif
/* The machine-dependent file <bits/typesizes.h> defines __*_T_TYPE
   macros for each of the OS types we define below.  The definitions
   of those macros must use the following macros for underlying types.
   We define __S<SIZE>_TYPE and __U<SIZE>_TYPE for the signed and unsigned
   variants of each of the following integer types on this machine.

	16		-- "natural" 16-bit type (always short)
	32		-- "natural" 32-bit type (always int)
	64		-- "natural" 64-bit type (long or long long)
	LONG32		-- 32-bit type, traditionally long
	QUAD		-- 64-bit type, always long long
	WORD		-- natural type of __WORDSIZE bits (int or long)
	LONGWORD	-- type of __WORDSIZE bits, traditionally long

   We distinguish WORD/LONGWORD, 32/LONG32, and 64/QUAD so that the
   conventional uses of `long' or `long long' type modifiers match the
   types we define, even when a less-adorned type would be the same size.
   This matters for (somewhat) portably writing printf/scanf formats for
   these types, where using the appropriate l or ll format modifiers can
   make the typedefs and the formats match up across all GNU platforms.  If
   we used `long' when it's 64 bits where `long long' is expected, then the
   compiler would warn about the formats not matching the argument types,
   and the programmer changing them to shut up the compiler would break the
   program's portability.

   Here we assume what is presently the case in all the GCC configurations
   we support: long long is always 64 bits, long is always word/address size,
   and int is always 32 bits.  */

#elif 1
/* No need to mark the typedef with __extension__.   */
#endif
##including bits/typesizes.h
/* bits/typesizes.h -- underlying types for *_t.  Generic version.
   Copyright (C) 2002, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#if 1
/* See <bits/types.h> for the meaning of these macros.  This file exists so
   that <bits/types.h> need not vary across different GNU platforms.  */

/* Number of descriptors that can fit in an `fd_set'.  */
#endif
typedef unsignedlongint __dev_t;	/* Type of device numbers.  */
typedef unsignedint __uid_t;	/* Type of user identifications.  */
typedef unsignedint __gid_t;	/* Type of group identifications.  */
typedef unsignedlongint __ino_t;	/* Type of file serial numbers.  */
typedef unsignedlongint __ino64_t;	/* Type of file serial numbers (LFS).*/
typedef unsignedint __mode_t;	/* Type of file attribute bitmasks.  */
typedef unsignedlongint __nlink_t;	/* Type of file link counts.  */
typedef longint __off_t;	/* Type of file sizes and offsets.  */
typedef longint __off64_t;	/* Type of file sizes and offsets (LFS).  */
typedef int __pid_t;	/* Type of process identifications.  */
typedef struct{int__val[2];} __fsid_t;	/* Type of file system IDs.  */
typedef longint __clock_t;	/* Type of CPU usage counts.  */
typedef unsignedlongint __rlim_t;	/* Type for resource measurement.  */
typedef unsignedlongint __rlim64_t;	/* Type for resource measurement (LFS).  */
typedef unsignedint __id_t;		/* General type for IDs.  */
typedef longint __time_t;	/* Seconds since the Epoch.  */
typedef unsignedint __useconds_t; /* Count of microseconds.  */
typedef longint __suseconds_t; /* Signed count of microseconds.  */

typedef int __daddr_t;	/* The type of a disk address.  */
typedef longint __swblk_t;	/* Type of a swap block maybe?  */
typedef int __key_t;	/* Type of an IPC key.  */

/* Clock ID used in clock and timer functions.  */
typedef int __clockid_t;

/* Timer ID returned by `timer_create'.  */
typedef void* __timer_t;

/* Type to represent block size.  */
typedef longint __blksize_t;

/* Types from the Large File Support interface.  */

/* Type to count number of disk blocks.  */
typedef longint __blkcnt_t;
typedef longint __blkcnt64_t;

/* Type to count file system blocks.  */
typedef unsignedlongint __fsblkcnt_t;
typedef unsignedlongint __fsblkcnt64_t;

/* Type to count file system nodes.  */
typedef unsignedlongint __fsfilcnt_t;
typedef unsignedlongint __fsfilcnt64_t;

typedef longint __ssize_t; /* Type of a byte count, or error.  */

/* These few don't really vary by system, they always correspond
   to one of the other defined types.  */
typedef __off64_t __loff_t;	/* Type of file sizes and offsets (LFS).  */
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;

/* Duplicates info from stdint.h but this is used in unistd.h.  */
typedef longint __intptr_t;

/* Duplicate info from sys/socket.h.  */
typedef unsignedint __socklen_t;


#endif


#if 1
/* These are all the characteristics of characters.
   If there get to be more than 16 distinct characteristics,
   many things must be changed that use `unsigned short int's.

   The characteristics are stored always in network byte order (big
   endian).  We define the bit value interpretations here dependent on the
   machine's byte order.  */

##including endian.h
#elif 1
#endif
enum
{
  _ISupper = ((0)<8?((1<<(0))<<8):((1<<(0))>>8)),	/* UPPERCASE.  */
  _ISlower = ((1)<8?((1<<(1))<<8):((1<<(1))>>8)),	/* lowercase.  */
  _ISalpha = ((2)<8?((1<<(2))<<8):((1<<(2))>>8)),	/* Alphabetic.  */
  _ISdigit = ((3)<8?((1<<(3))<<8):((1<<(3))>>8)),	/* Numeric.  */
  _ISxdigit = ((4)<8?((1<<(4))<<8):((1<<(4))>>8)),	/* Hexadecimal numeric.  */
  _ISspace = ((5)<8?((1<<(5))<<8):((1<<(5))>>8)),	/* Whitespace.  */
  _ISprint = ((6)<8?((1<<(6))<<8):((1<<(6))>>8)),	/* Printing.  */
  _ISgraph = ((7)<8?((1<<(7))<<8):((1<<(7))>>8)),	/* Graphical.  */
  _ISblank = ((8)<8?((1<<(8))<<8):((1<<(8))>>8)),	/* Blank (usually SPC and TAB).  */
  _IScntrl = ((9)<8?((1<<(9))<<8):((1<<(9))>>8)),	/* Control character.  */
  _ISpunct = ((10)<8?((1<<(10))<<8):((1<<(10))>>8)),	/* Punctuation.  */
  _ISalnum = ((11)<8?((1<<(11))<<8):((1<<(11))>>8))	/* Alphanumeric.  */
};
#endif
/* These are defined in ctype-info.c.
   The declarations here must match those in localeinfo.h.

   In the thread-specific locale model (see `uselocale' in <locale.h>)
   we cannot use global variables for these as was done in the past.
   Instead, the following accessor functions return the address of
   each variable, which is local to the current thread if multithreaded.

   These point into arrays of 384, so they can be indexed by any `unsigned
   char' value [0,255]; by EOF (-1); or by any `signed char' value
   [-128,-1).  ISO C requires that the ctype functions work for `unsigned
   char' values and for EOF; we also support negative `signed char' values
   for broken old programs.  The case conversion arrays are of `int's
   rather than `unsigned char's because tolower (EOF) must be EOF, which
   doesn't fit into an `unsigned char'.  But today more important is that
   the arrays are also used for multi-byte character sets.  */
extern const unsigned short int **__ctype_b_loc (void)
     __attribute__((__nothrow__)) __attribute__ ((const));
extern const __int32_t **__ctype_tolower_loc (void)
     __attribute__((__nothrow__)) __attribute__ ((const));
extern const __int32_t **__ctype_toupper_loc (void)
     __attribute__((__nothrow__)) __attribute__ ((const));



/* The following names are all functions:
     int isCHARACTERISTIC(int c);
   which return nonzero iff C has CHARACTERISTIC.
   For the meaning of the characteristic names, see the `enum' above.  */
externint isalnum(int) __attribute__((__nothrow__));
externint isalpha(int) __attribute__((__nothrow__));
externint iscntrl(int) __attribute__((__nothrow__));
externint isdigit(int) __attribute__((__nothrow__));
externint islower(int) __attribute__((__nothrow__));
externint isgraph(int) __attribute__((__nothrow__));
externint isprint(int) __attribute__((__nothrow__));
externint ispunct(int) __attribute__((__nothrow__));
externint isspace(int) __attribute__((__nothrow__));
externint isupper(int) __attribute__((__nothrow__));
externint isxdigit(int) __attribute__((__nothrow__));


/* Return the lowercase version of C.  */
extern int tolower (int __c) __attribute__((__nothrow__));

/* Return the uppercase version of C.  */
extern int toupper (int __c) __attribute__((__nothrow__));




/* ISO C99 introduced one new function.  */
#if 1


externint isblank(int) __attribute__((__nothrow__));


#endif
#endif
#if 1
/* Return nonzero iff C is in the ASCII set
   (i.e., is no more than 7 bits wide).  */
extern int isascii (int __c) __attribute__((__nothrow__));

/* Return the part of C that is in the ASCII set
   (i.e., the low-order 7 bits of C).  */
extern int toascii (int __c) __attribute__((__nothrow__));

/* These are the same as `toupper' and `tolower' except that they do not
   check the argument for being in the range of a `char'.  */
externint _toupper(int) __attribute__((__nothrow__));
externint _tolower(int) __attribute__((__nothrow__));
#endif
/* This code is needed for the optimized mapping functions.  */
#if 1
#if 1
#endif
#endif
#endif
#if 1
#endif
#endif
#if 1
/* The concept of one static locale per category is not very well
   thought out.  Many applications will need to process its data using
   information from several different locales.  Another application is
   the implementation of the internationalization handling in the
   upcoming ISO C++ standard library.  To support this another set of
   the functions using locale data exist which have an additional
   argument.

   Attention: all these functions are *not* standardized in any form.
   This is a proof-of-concept implementation.  */

/* Structure for reentrant locale using functions.  This is an
   (almost) opaque type for the user level programs.  */
##including xlocale.h
/* Definition of locale datatype.
   Copyright (C) 1997,2000,2002,2009,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1997.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
/* Structure for reentrant locale using functions.  This is an
   (almost) opaque type for the user level programs.  The file and
   this data structure is not standardized.  Don't rely on it.  It can
   go away without warning.  */
typedef struct __locale_struct
{
  /* Note: LC_ALL is not a valid index into this array.  */
  struct __locale_data *__locales[13]; /* 13 = __LC_LAST. */

  /* To increase the speed of this solution we add some special members.  */
  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;

  /* Note: LC_ALL is not a valid index into this array.  */
  const char *__names[13];
} *__locale_t;

/* POSIX 2008 makes locale_t official.  */
typedef __locale_t locale_t;

#endif
/* These definitions are similar to the ones above but all functions
   take as an argument a handle for the locale which shall be used.  */
/* The following names are all functions:
     int isCHARACTERISTIC(int c, locale_t *locale);
   which return nonzero iff C has CHARACTERISTIC.
   For the meaning of the characteristic names, see the `enum' above.  */
externint isalnum_l(int,__locale_t) __attribute__((__nothrow__));
externint isalpha_l(int,__locale_t) __attribute__((__nothrow__));
externint iscntrl_l(int,__locale_t) __attribute__((__nothrow__));
externint isdigit_l(int,__locale_t) __attribute__((__nothrow__));
externint islower_l(int,__locale_t) __attribute__((__nothrow__));
externint isgraph_l(int,__locale_t) __attribute__((__nothrow__));
externint isprint_l(int,__locale_t) __attribute__((__nothrow__));
externint ispunct_l(int,__locale_t) __attribute__((__nothrow__));
externint isspace_l(int,__locale_t) __attribute__((__nothrow__));
externint isupper_l(int,__locale_t) __attribute__((__nothrow__));
externint isxdigit_l(int,__locale_t) __attribute__((__nothrow__));

externint isblank_l(int,__locale_t) __attribute__((__nothrow__));


/* Return the lowercase version of C in locale L.  */
extern int __tolower_l (int __c, __locale_t __l) __attribute__((__nothrow__));
extern int tolower_l (int __c, __locale_t __l) __attribute__((__nothrow__));

/* Return the uppercase version of C.  */
extern int __toupper_l (int __c, __locale_t __l) __attribute__((__nothrow__));
extern int toupper_l (int __c, __locale_t __l) __attribute__((__nothrow__));

#endif
#if 1
#if 1
#endif
#if 1
#endif
#endif
#endif


#endif
##including dirent.h
/* Copyright (C) 1991-2000,2003-2005,2009,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 5.1.2 Directory Operations	<dirent.h>
 */

#if 1
##including features.h


##including bits/types.h
#endif
/* This file defines `struct dirent'.

   It defines the macro `_DIRENT_HAVE_D_NAMLEN' iff there is a `d_namlen'
   member that gives the length of `d_name'.

   It defines the macro `_DIRENT_HAVE_D_RECLEN' iff there is a `d_reclen'
   member that gives the size of the entire directory entry.

   It defines the macro `_DIRENT_HAVE_D_OFF' iff there is a `d_off'
   member that gives the file offset of the next directory entry.

   It defines the macro `_DIRENT_HAVE_D_TYPE' iff there is a `d_type'
   member that gives the type of the file.
 */

##including bits/dirent.h
/* Copyright (C) 1996, 1997 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
struct dirent
  {
#if 1
__ino_t d_ino;
    __off_t d_off;
#endif
unsigned short int d_reclen;
    unsigned char d_type;
    char d_name[256];		/* We must not include limits.h! */
  };

#endif
#endif
/* These macros extract size information from a `struct dirent *'.
   They may evaluate their argument multiple times, so it must not
   have side effects.  Each of these may involve a relatively costly
   call to `strlen' on some systems, so these values should be cached.

   _D_EXACT_NAMLEN (DP)	returns the length of DP->d_name, not including
   its terminating null character.

   _D_ALLOC_NAMLEN (DP)	returns a size at least (_D_EXACT_NAMLEN (DP) + 1);
   that is, the allocation size needed to hold the DP->d_name string.
   Use this macro when you don't need the exact length, just an upper bound.
   This macro is less likely to require calling `strlen' than _D_EXACT_NAMLEN.
   */

#elif 1
#if 1
#endif
#endif
#if 1
/* File types for `d_type'.  */
enum
  {
    DT_UNKNOWN = 0,
DT_FIFO = 1,
DT_CHR = 2,
DT_DIR = 4,
DT_BLK = 6,
DT_REG = 8,
DT_LNK = 10,
DT_SOCK = 12,
DT_WHT = 14
};

/* Convert between stat structure types and directory types.  */
#endif
/* This is the data type of directory stream objects.
   The actual structure is opaque to users.  */
typedef struct __dirstream DIR;

/* Open a directory stream on NAME.
   Return a DIR stream on the directory, or NULL if it could not be opened.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern DIR *opendir (const char *__name) __attribute__((__nonnull__ (1)));

#if 1
/* Same as opendir, but open the stream on the file descriptor FD.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern DIR *fdopendir (int __fd);
#endif
/* Close the directory stream DIRP.
   Return 0 if successful, -1 if not.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int closedir (DIR *__dirp) __attribute__((__nonnull__ (1)));

/* Read a directory entry from DIRP.  Return a pointer to a `struct
   dirent' describing the entry, or NULL for EOF or error.  The
   storage returned may be overwritten by a later readdir call on the
   same DIR stream.

   If the Large File Support API is selected we have to use the
   appropriate interface.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
#if 1
extern struct dirent *readdir (DIR *__dirp) __attribute__((__nonnull__ (1)));
#endif
#endif
#if 1
/* Reentrant version of `readdir'.  Return in RESULT a pointer to the
   next entry.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
#if 1
extern int readdir_r (DIR *__restrict __dirp,
		      struct dirent *__restrict __entry,
		      struct dirent **__restrict __result)
     __attribute__((__nonnull__ (1, 2, 3)));
#endif
#endif
#endif
/* Rewind DIRP to the beginning of the directory.  */
extern void rewinddir (DIR *__dirp) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
##including bits/types.h
/* Seek to position POS on DIRP.  */
extern void seekdir (DIR *__dirp, long int __pos) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Return the current position of DIRP.  */
extern long int telldir (DIR *__dirp) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* Return the file descriptor used by DIRP.  */
extern int dirfd (DIR *__dirp) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#endif
#if 1
#if 1
/* Get the definitions of the POSIX.1 limits.  */
##including bits/posix1_lim.h
/* `MAXNAMLEN' is the BSD name for what POSIX calls `NAME_MAX'.  */
#if 1
#endif
#endif
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#elif 1
#endif
#endif
#if 1
typedef longunsignedint size_t;
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif
/* Scan the directory DIR, calling SELECTOR on each directory entry.
   Entries for which SELECT returns nonzero are individually malloc'd,
   sorted using qsort with CMP, and collected in a malloc'd array in
   *NAMELIST.  Returns the number of entries selected, or -1 on error.  */
#if 1
extern int scandir (const char *__restrict __dir,
		    struct dirent ***__restrict __namelist,
		    int (*__selector) (const struct dirent *),
		    int (*__cmp) (const struct dirent **,
				  const struct dirent **))
     __attribute__((__nonnull__ (1, 2)));
#endif
#endif
/* Function to compare two `struct dirent's alphabetically.  */
#if 1
extern int alphasort (const struct dirent **__e1,
		      const struct dirent **__e2)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif
#endif
#if 1
/* Read directory entries from FD into BUF, reading at most NBYTES.
   Reading starts at offset *BASEP, and *BASEP is updated with the new
   position after reading.  Returns the number of bytes read; zero when at
   end of directory; or -1 for errors.  */
#if 1
extern __ssize_t getdirentries (int __fd, char *__restrict __buf,
				size_t __nbytes,
				__off_t *__restrict __basep)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 4)));
#endif
#endif
#endif
#endif


#endif
##including errno.h
/* Copyright (C) 1991,92,93,94,95,96,97,2002 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.5 Errors	<errno.h>
 */

#if 1
/* The includer defined __need_Emath if he wants only the definitions
   of EDOM and ERANGE, and not everything else.  */
#if 1
##including features.h
#endif


/* Get the error number constants from the system-specific file.
   This file will test __need_Emath and _ERRNO_H.  */
##including bits/errno.h
/* Error constants.  Linux specific version.
   Copyright (C) 1996-1999, 2005, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including linux/errno.h
#if 1
##including asm/errno.h
##including asm-generic/errno.h
#if 1
##including asm-generic/errno-base.h
#if 1
#endif
/* for robust mutexes */
#endif
#endif
/* Linux has no ENOTSUP error code.  */
/* Older Linux versions also had no ECANCELED error code.  */
#endif
/* Support for error codes to support robust mutexes was added later, too.  */
#endif
#endif
#if 1
/* Function to get address of global `errno' variable.  */
extern int *__errno_location (void) __attribute__((__nothrow__)) __attribute__ ((__const__));

#if 1
/* When using threads, errno is a per-thread value.  */
#endif
#endif
#endif
#endif
#if 1
/* Declare the `errno' variable, unless it's defined as a macro by
   bits/errno.h.  This is the case in GNU, where it is a per-thread
   variable.  This redeclaration using the macro still works, but it
   will be a function declaration without a prototype and may trigger
   a -Wstrict-prototypes warning.  */
#endif
#endif
#endif


#endif
/* The Hurd <bits/errno.h> defines `error_t' as an enumerated type so
   that printing `error_t' values in the debugger shows the names.  We
   might need this definition sometimes even if this file was included
   before.  */
#endif
##including fcntl.h
/* Copyright (C) 1991,1992,1994-2001,2003,2004,2005,2006,2007,2009,2010
	Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 6.5 File Control Operations	<fcntl.h>
 */

#if 1
##including features.h
/* This must be early so <bits/fcntl.h> can define types winningly.  */


/* Get the definitions of O_*, F_*, FD_*: all the
   numbers and flag bits for `open', `fcntl', et al.  */
##including bits/fcntl.h
/* O_*, F_*, FD_* bit values for Linux/x86-64.
   Copyright (C) 2001,2002,2004,2006,2007,2009,2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including sys/types.h
/* Copyright (C) 1991,1992,1994-2002,2006,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 2.6 Primitive System Data Types	<sys/types.h>
 */

#if 1
##including features.h


##including bits/types.h
#if 1
#if 1
typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;
#endif
#endif
typedef __loff_t loff_t;

#if 1
#if 1
typedef __ino_t ino_t;
#endif
#endif
#endif
#if 1
typedef __dev_t dev_t;
#endif
#if 1
typedef __gid_t gid_t;
#endif
#if 1
typedef __mode_t mode_t;
#endif
#if 1
typedef __nlink_t nlink_t;
#endif
#if 1
typedef __uid_t uid_t;
#endif
#if 1
#if 1
typedef __off_t off_t;
#endif
#endif
#endif
#if 1
typedef __pid_t pid_t;
#endif
#if 1
typedef __id_t id_t;
#endif
#if 1
typedef __ssize_t ssize_t;
#endif
#if 1
#if 1
typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;
#endif
#endif
#if 1
typedef __key_t key_t;
#endif
#if 1
#endif
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#endif
#endif
#if 1
##including bits/types.h

/* Returned by `clock'.  */
typedef __clock_t clock_t;

#if 1

#endif
#endif
#if 1
##including bits/types.h

/* Returned by `time'.  */
typedef __time_t time_t;

#if 1

#endif
#endif
#if 1
##including bits/types.h
/* Clock ID used in clock and timer functions.  */
typedef __clockid_t clockid_t;

#endif
#if 1
##including bits/types.h
/* Timer ID returned by `timer_create'.  */
typedef __timer_t timer_t;

#endif
#endif
#endif
#endif
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif
#if 1
/* Old compatibility names for C types.  */
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
#endif
/* These size-specific names are used by some of the inet code.  */

#elif 1
/* For GCC 2.7 and later, we can use specific type-size attributes.  */
#endif
typedefunsignedintu_int8_t__attribute__((__mode__(__QI__)));
typedefunsignedintu_int16_t__attribute__((__mode__(__HI__)));
typedefunsignedintu_int32_t__attribute__((__mode__(__SI__)));
typedefunsignedintu_int64_t__attribute__((__mode__(__DI__)));

typedef int register_t __attribute__ ((__mode__ (__word__)));


/* Some code from BIND tests this macro to see if the types above are
   defined.  */
#endif
#if 1
/* In BSD <sys/types.h> is expected to define BYTE_ORDER.  */
##including endian.h
/* It also defines `fd_set' and the FD_* macros for `select'.  */
##including sys/select.h
/* `fd_set' type and related macros, and `select'/`pselect' declarations.
   Copyright (C) 1996-2003, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*	POSIX 1003.1g: 6.2 Select from File Descriptor Sets <sys/select.h>  */

#if 1
##including features.h
/* Get definition of needed basic types.  */
##including bits/types.h
/* Get __FD_* definitions.  */
##including bits/select.h
/* Copyright (C) 1997,1998,1999,2001,2008,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#if 1
#if 1
#endif
#endif
/* Get __sigset_t.  */
##including bits/sigset.h
/* __sig_atomic_t, __sigset_t, and related definitions.  Linux version.
   Copyright (C) 1991, 1992, 1994, 1996, 1997, 2007
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
typedef int __sig_atomic_t;

/* A `sigset_t' has a bit for each signal.  */

typedef struct
  {
    unsigned long int __val[(1024/(8*sizeof(unsignedlongint)))];
  } __sigset_t;

#endif
/* We only want to define these functions if <signal.h> was actually
   included; otherwise we were included just to define the types.  Since we
   are namespace-clean, it wouldn't hurt to define extra macros.  But
   trouble can be caused by functions being defined (e.g., any global
   register vars declared later will cause compilation errors).  */

#endif
#if 1
typedef __sigset_t sigset_t;
#endif
/* Get definition of timer specification structures.  */
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#endif
#endif
#endif
#endif
#endif
#endif
#if 1
##including bits/types.h
/* POSIX.1b structure for a time value.  This is like a `struct timeval' but
   has nanoseconds instead of microseconds.  */
struct timespec
  {
    __time_t tv_sec;		/* Seconds.  */
    long int tv_nsec;		/* Nanoseconds.  */
  };

#endif
#endif
#endif
##including bits/time.h
/* System-dependent timing definitions.  Generic version.
   Copyright (C) 1996,1997,1999-2002,2003,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; use <time.h> instead.
 */

#endif
#if 1
#if 1
##including bits/types.h
/* A time value that is accurate to the nearest
   microsecond but also has a range of years.  */
struct timeval
  {
    __time_t tv_sec;		/* Seconds.  */
    __suseconds_t tv_usec;	/* Microseconds.  */
  };
#endif
#endif
#if 1
typedef __suseconds_t suseconds_t;
#endif
/* The fd_set member is required to be an array of longs.  */
typedef long int __fd_mask;

/* Some versions of <linux/posix_types.h> define these macros.  */
/* It's easier to assume 8-bit bytes than to get CHAR_BIT.  */
/* fd_set for select and pselect.  */
typedef struct
  {
    /* XPG4.2 requires this member name.  Otherwise avoid the name
       from the global namespace.  */
#elif 1
__fd_mask __fds_bits[1024 / (8*(int)sizeof(__fd_mask))];
#endif
} fd_set;

/* Maximum number of file descriptors in `fd_set'.  */
#if 1
/* Sometimes the fd_set member is assumed to have this type.  */
typedef __fd_mask fd_mask;

/* Number of bits per word of `fd_set' (some code assumes this is 32).  */
#endif
/* Access macros for `fd_set'.  */


/* Check the first NFDS descriptors each in READFDS (if not NULL) for read
   readiness, in WRITEFDS (if not NULL) for write readiness, and in EXCEPTFDS
   (if not NULL) for exceptional conditions.  If TIMEOUT is not NULL, time out
   after waiting the interval specified therein.  Returns the number of ready
   descriptors, or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int select (int __nfds, fd_set *__restrict __readfds,
		   fd_set *__restrict __writefds,
		   fd_set *__restrict __exceptfds,
		   struct timeval *__restrict __timeout);

#if 1
/* Same as above only that the TIMEOUT value is given with higher
   resolution and a sigmask which is been set temporarily.  This version
   should be used.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int pselect (int __nfds, fd_set *__restrict __readfds,
		    fd_set *__restrict __writefds,
		    fd_set *__restrict __exceptfds,
		    const struct timespec *__restrict __timeout,
		    const __sigset_t *__restrict __sigmask);
#endif


#endif
/* BSD defines these symbols, so we follow.  */
##including sys/sysmacros.h
/* Definitions of macros to access `dev_t' values.
   Copyright (C) 1996, 1997, 1999, 2003, 2004, 2007
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
/* If the compiler does not know long long it is out of luck.  We are
   not going to hack weird hacks to support the dev_t representation
   they need.  */
#if 1
__extension__
extern unsigned int gnu_dev_major (unsigned long long int __dev)
     __attribute__((__nothrow__));
__extension__
extern unsigned int gnu_dev_minor (unsigned long long int __dev)
     __attribute__((__nothrow__));
__extension__
extern unsigned long long int gnu_dev_makedev (unsigned int __major,
					       unsigned int __minor)
     __attribute__((__nothrow__));

#endif
/* Access the functions with their traditional names.  */
#endif
#endif
#endif
#if 1
typedef __blksize_t blksize_t;
#endif
/* Types from the Large File Support interface.  */
#if 1
#if 1
typedef __blkcnt_t blkcnt_t;	 /* Type to count number of disk blocks.  */
#endif
#if 1
typedef __fsblkcnt_t fsblkcnt_t; /* Type to count file system blocks.  */
#endif
#if 1
typedef __fsfilcnt_t fsfilcnt_t; /* Type to count file system inodes.  */
#endif
#endif
#endif
/* Now add the thread types.  */
#if 1
##including bits/pthreadtypes.h
/* Copyright (C) 2002,2003,2004,2005,2006,2007 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Ulrich Drepper <drepper@redhat.com>, 2002.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#if 1
#endif
/* Thread identifiers.  The structure of the attribute type is not
   exposed on purpose.  */
typedef unsigned long int pthread_t;


typedef union
{
  char __size[56];
  long int __align;
} pthread_attr_t;


#if 1
typedef struct __pthread_internal_list
{
  struct __pthread_internal_list *__prev;
  struct __pthread_internal_list *__next;
} __pthread_list_t;
#endif
/* Data structures for mutex handling.  The structure of the attribute
   type is not exposed on purpose.  */
typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;
#if 1
unsigned int __nusers;
#endif
/* KIND must stay at this position in the structure to maintain
       binary compatibility.  */
    int __kind;
#if 1
int __spins;
    __pthread_list_t __list;
#endif
} __data;
  char __size[40];
  long int __align;
} pthread_mutex_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;


/* Data structure for conditional variable handling.  The structure of
   the attribute type is not exposed on purpose.  */
typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;


/* Keys for thread-specific data */
typedef unsigned int pthread_key_t;


/* Once-only execution */
typedef int pthread_once_t;


#if 1
/* Data structure for read-write lock variable handling.  The
   structure of the attribute type is not exposed on purpose.  */
typedef union
{
#if 1
struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    int __writer;
    int __shared;
    unsigned long int __pad1;
    unsigned long int __pad2;
    /* FLAGS must stay at this position in the structure to maintain
       binary compatibility.  */
    unsigned int __flags;
  } __data;
#endif
char __size[56];
  long int __align;
} pthread_rwlock_t;

typedef union
{
  char __size[8];
  long int __align;
} pthread_rwlockattr_t;
#endif
#if 1
/* POSIX spinlock data type.  */
typedef volatile int pthread_spinlock_t;


/* POSIX barriers data type.  The structure of the type is
   deliberately not exposed.  */
typedef union
{
  char __size[32];
  long int __align;
} pthread_barrier_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_barrierattr_t;
#endif
#endif
#endif
#endif


#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#endif
/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
   located on a few file systems.  */
#if 1
#endif
#endif
/* For now Linux has synchronisity options for data and read operations.
   We define the symbols here but let them do the same as O_SYNC since
   this is a superset.	*/
#if 1
#endif
#endif
/* Values for the second argument to `fcntl'.  */
#if 1
/* Not necessary, we always have 64-bit offsets.  */
#endif
#if 1
#endif
#endif
#endif
#if 1
#endif
/* For F_[GET|SET]FD.  */
/* For posix fcntl() and `l_type' field of a `struct flock' for lockf().  */
/* For old implementation of bsd flock().  */
#if 1
/* Operations for bsd flock(), also used by the kernel implementation.	*/
#endif
#endif
#endif
struct flock
  {
    short int l_type;	/* Type of lock: F_RDLCK, F_WRLCK, or F_UNLCK.	*/
    short int l_whence;	/* Where `l_start' is relative to (like `lseek').  */
#if 1
__off_t l_start;	/* Offset where the lock begins.  */
    __off_t l_len;	/* Size of the locked area; zero means until EOF.  */
#endif
__pid_t l_pid;	/* Process holding the lock.  */
  };

#endif
#endif
/* Define some more compatibility macros to be backward compatible with
   BSD systems which did not managed to hide these kernel macros.  */
#if 1
#endif
/* Advise to `posix_fadvise'.  */
#if 1
#endif
#endif


#endif

/* For XPG all symbols from <sys/stat.h> should also be available.  */
#if 1
##including bits/types.h
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
##including bits/stat.h
/* Copyright (C) 1999-2003,2009,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#if 1
/* Versions of the `struct stat' data structure.  */
#elif 1
/* x86-64 versions of the `xmknod' interface.  */
#endif
struct stat
  {
    __dev_t st_dev;		/* Device.  */
#endif
#if 1
__ino_t st_ino;		/* File serial number.	*/
#endif
#elif 1
__nlink_t st_nlink;		/* Link count.  */
    __mode_t st_mode;		/* File mode.  */
#endif
__uid_t st_uid;		/* User ID of the file's owner.	*/
    __gid_t st_gid;		/* Group ID of the file's group.*/
#if 1
int __pad0;
#endif
__dev_t st_rdev;		/* Device number, if device.  */
#endif
#if 1
__off_t st_size;			/* Size of file, in bytes.  */
#endif
__blksize_t st_blksize;	/* Optimal block size for I/O.  */
#if 1
__blkcnt_t st_blocks;		/* Number 512-byte blocks allocated. */
#endif
#if 1
/* Nanosecond resolution timestamps are stored in a format
       equivalent to 'struct timespec'.  This is the type used
       whenever possible but the Unix namespace rules do not allow the
       identifier 'timespec' to appear in the <sys/stat.h> header.
       Therefore we have to handle the use of this header in strictly
       standard-compliant sources special.  */
    struct timespec st_atim;		/* Time of last access.  */
    struct timespec st_mtim;		/* Time of last modification.  */
    struct timespec st_ctim;		/* Time of last status change.  */
#endif
#if 1
long int __unused[3];
#endif
};

#endif
/* Tell code we have these members.  */
/* Nanosecond resolution time values are supported.  */
/* Encoding of the file mode.  */

/* File types.  */
/* POSIX.1b objects.  Note that these macros always evaluate to zero.  But
   they do it by enforcing the correct use of the macros.  */
/* Protection bits.  */

#if 1
#endif
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
/* Protection bits.  */

#if 1
/* Save swapped text after use (sticky bit).  This is pretty well obsolete.  */
#endif
/* Read, write, and execute by owner.  */
/* Read, write, and execute by group.  */
/* Read, write, and execute by others.  */
#endif
#if 1
#if 1
/* Values for the second argument to access.
   These may be OR'd together.  */
#endif
#endif
/* XPG wants the following symbols.   <stdio.h> has the same definitions.  */
#if 1
#endif
#if 1
#endif
/* Do the file control operation described by CMD on FD.
   The remaining arguments are interpreted depending on CMD.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int fcntl (int __fd, int __cmd, ...);

/* Open FILE and return a new file descriptor for it, or -1 on error.
   OFLAG determines the type of access used.  If O_CREAT is on OFLAG,
   the third argument is taken as a `mode_t', the mode of the created file.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
#if 1
extern int open (const char *__file, int __oflag, ...) __attribute__((__nonnull__ (1)));
#endif
#endif
#if 1
/* Similar to `open' but a relative path name is interpreted relative to
   the directory for which FD is a descriptor.

   NOTE: some other `openat' implementation support additional functionality
   through this interface, especially using the O_XATTR flag.  This is not
   yet supported here.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
#if 1
extern int openat (int __fd, const char *__file, int __oflag, ...)
     __attribute__((__nonnull__ (2)));
#endif
#endif
#endif
/* Create and open FILE, with mode MODE.  This takes an `int' MODE
   argument because that is what `mode_t' will be widened to.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
#if 1
extern int creat (const char *__file, __mode_t __mode) __attribute__((__nonnull__ (1)));
#endif
#endif
#if 1
/* NOTE: These declarations also appear in <unistd.h>; be sure to keep both
   files consistent.  Some systems have them there and some here, and some
   software depends on the macros being defined without including both.  */

/* `lockf' is a simpler interface to the locking facilities of `fcntl'.
   LEN is always relative to the current file position.
   The CMD argument is one of the following.  */

#if 1
extern int lockf (int __fd, int __cmd, __off_t __len);
#endif
#endif
#endif
#if 1
/* Advice the system about the expected behaviour of the application with
   respect to the file associated with FD.  */
#if 1
extern int posix_fadvise (int __fd, __off_t __offset, __off_t __len,
			  int __advise) __attribute__((__nothrow__));
#endif
#endif
/* Reserve storage for the data of the file associated with FD.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
#if 1
extern int posix_fallocate (int __fd, __off_t __offset, __off_t __len);
#endif
#endif
#endif
/* Define some inlines helping to catch common problems.  */
#endif


#endif
##including inttypes.h
/* Copyright (C) 1997-2001, 2004, 2007 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99: 7.8 Format conversion of integer types	<inttypes.h>
 */

#if 1
##including features.h
/* Get the type definitions.  */
##including stdint.h
/* Get a definition for wchar_t.  But we must not define wchar_t itself.  */
#if 1
#elif 1
typedef int __gwchar_t;
#endif
#endif
/* The ISO C99 standard specifies that these macros must only be
   defined if explicitly requested.  */
#if 1
#if 1
#endif
/* Macros for printing format specifiers.  */

/* Decimal notation.  */
/* Octal notation.  */
/* Unsigned integers.  */
/* lowercase hexadecimal notation.  */
/* UPPERCASE hexadecimal notation.  */
/* Macros for printing `intmax_t' and `uintmax_t'.  */
/* Macros for printing `intptr_t' and `uintptr_t'.  */
/* Macros for scanning format specifiers.  */

/* Signed decimal notation.  */
/* Signed decimal notation.  */
/* Unsigned decimal notation.  */
/* Octal notation.  */
/* Hexadecimal notation.  */
/* Macros for scanning `intmax_t' and `uintmax_t'.  */
/* Macros for scaning `intptr_t' and `uintptr_t'.  */
#endif


#if 1
/* We have to define the `uintmax_t' type using `ldiv_t'.  */
typedef struct
  {
    long int quot;		/* Quotient.  */
    long int rem;		/* Remainder.  */
  } imaxdiv_t;

#endif
/* Compute absolute value of N.  */
extern intmax_t imaxabs (intmax_t __n) __attribute__((__nothrow__)) __attribute__ ((__const__));

/* Return the `imaxdiv_t' representation of the value of NUMER over DENOM. */
extern imaxdiv_t imaxdiv (intmax_t __numer, intmax_t __denom)
      __attribute__((__nothrow__)) __attribute__ ((__const__));

/* Like `strtol' but convert to `intmax_t'.  */
extern intmax_t strtoimax (const char *__restrict __nptr,
			   char **__restrict __endptr, int __base) __attribute__((__nothrow__));

/* Like `strtoul' but convert to `uintmax_t'.  */
extern uintmax_t strtoumax (const char *__restrict __nptr,
			    char ** __restrict __endptr, int __base) __attribute__((__nothrow__));

/* Like `wcstol' but convert to `intmax_t'.  */
extern intmax_t wcstoimax (const __gwchar_t *__restrict __nptr,
			   __gwchar_t **__restrict __endptr, int __base)
     __attribute__((__nothrow__));

/* Like `wcstoul' but convert to `uintmax_t'.  */
extern uintmax_t wcstoumax (const __gwchar_t *__restrict __nptr,
			    __gwchar_t ** __restrict __endptr, int __base)
     __attribute__((__nothrow__));

#endif


#endif
##including netdb.h
  /* Copyright (C) 1996-2004, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/* All data returned by the network data base library are supplied in
   host order and returned in network order (suitable for use in
   system calls).  */

#if 1
##including features.h
##including netinet/in.h
/* Copyright (C) 1991-2001, 2003, 2004, 2006, 2007, 2008
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including stdint.h
##including sys/socket.h
/* Declarations of socket constants, types, and functions.
   Copyright (C) 1991,92,1994-2001,2003,2005,2007,2008
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h


##including sys/uio.h
/* Copyright (C) 1991,1992,1996-1999,2003,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including sys/types.h


/* This file defines `struct iovec'.  */
##including bits/uio.h
/* Copyright (C) 1996, 1997, 2006 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#if 1
##including sys/types.h
/* We should normally use the Linux kernel header file to define this
   type and macros but this calls for trouble because of the header
   includes other kernel headers.  */

/* Size of object which can be written atomically.

   This macro has different values in different kernel versions.  The
   latest versions of the kernel use 1024 and this is good choice.  Since
   the C library implementation of readv/writev is able to emulate the
   functionality even if the currently running kernel does not support
   this large value the readv/writev call will not fail because of this.  */
/* Structure for scatter/gather I/O.  */
struct iovec
  {
    void *iov_base;	/* Pointer to data.  */
    size_t iov_len;	/* Length of data.  */
  };

#endif
/* Read data from file descriptor FD, and put the result in the
   buffers described by IOVEC, which is a vector of COUNT 'struct iovec's.
   The buffers are filled in the order specified.
   Operates just like 'read' (see <unistd.h>) except that data are
   put in IOVEC instead of a contiguous buffer.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t readv (int __fd, const struct iovec *__iovec, int __count)
  ;

/* Write data pointed by the buffers described by IOVEC, which
   is a vector of COUNT 'struct iovec's, to file descriptor FD.
   The data is written in the order specified.
   Operates just like 'write' (see <unistd.h>) except that the data
   are taken from IOVEC instead of a contiguous buffer.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t writev (int __fd, const struct iovec *__iovec, int __count)
  ;


#if 1
#if 1
/* Read data from file descriptor FD at the given position OFFSET
   without change the file pointer, and put the result in the buffers
   described by IOVEC, which is a vector of COUNT 'struct iovec's.
   The buffers are filled in the order specified.  Operates just like
   'pread' (see <unistd.h>) except that data are put in IOVEC instead
   of a contiguous buffer.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t preadv (int __fd, const struct iovec *__iovec, int __count,
		       __off_t __offset) ;

/* Write data pointed by the buffers described by IOVEC, which is a
   vector of COUNT 'struct iovec's, to file descriptor FD at the given
   position OFFSET without change the file pointer.  The data is
   written in the order specified.  Operates just like 'pwrite' (see
   <unistd.h>) except that the data are taken from IOVEC instead of a
   contiguous buffer.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t pwritev (int __fd, const struct iovec *__iovec, int __count,
			__off_t __offset) ;
#endif
#endif
#endif


#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif
#endif
/* This operating system-specific header file defines the SOCK_*, PF_*,
   AF_*, MSG_*, SOL_*, and SO_* constants, and the `struct sockaddr',
   `struct msghdr', and `struct linger' types.  */
##including bits/socket.h
/* System-specific socket constants and types.  Linux version.
   Copyright (C) 1991, 1992, 1994-2001, 2004, 2006, 2007, 2008, 2009, 2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif
##including sys/types.h
/* Type for length arguments in socket calls.  */
#if 1
typedef __socklen_t socklen_t;
#endif
/* Types of sockets.  */
enum __socket_type
{
  SOCK_STREAM = 1,		/* Sequenced, reliable, connection-based
				   byte streams.  */
SOCK_DGRAM = 2,		/* Connectionless, unreliable datagrams
				   of fixed maximum length.  */
SOCK_RAW = 3,			/* Raw protocol interface.  */
SOCK_RDM = 4,			/* Reliably-delivered messages.  */
SOCK_SEQPACKET = 5,		/* Sequenced, reliable, connection-based,
				   datagrams of fixed maximum length.  */
SOCK_DCCP = 6,		/* Datagram Congestion Control Protocol.  */
SOCK_PACKET = 10,		/* Linux specific way of getting packets
				   at the dev level.  For writing rarp and
				   other similar things on the user level. */
/* Flags to be ORed into the type parameter of socket and socketpair and
     used for the flags parameter of paccept.  */

  SOCK_CLOEXEC = 02000000,	/* Atomically set close-on-exec flag for the
				   new descriptor(s).  */
SOCK_NONBLOCK = 04000		/* Atomically mark descriptor(s) as
				   non-blocking.  */
};

/* Protocol families.  */
/* Address families.  */
/* Socket level values.  Others are defined in the appropriate headers.

   XXX These definitions also should go into the appropriate headers as
   far as they are available.  */
/* Maximum queue length specifiable by listen.  */
/* Get the definition of the macro to define the common sockaddr members.  */
##including bits/sockaddr.h
/* Definition of `struct sockaddr_*' common members.  Generic/4.2 BSD version.
   Copyright (C) 1995,1996,1997,1998,2000,2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; use <sys/socket.h> instead.
 */

#if 1
/* POSIX.1g specifies this type name for the `sa_family' member.  */
typedef unsigned short int sa_family_t;

/* This macro is used to declare the initial common members
   of the data types used for socket addresses, `struct sockaddr',
   `struct sockaddr_in', `struct sockaddr_un', etc.  */

#endif
/* Structure describing a generic socket address.  */
struct sockaddr
  {
    sa_family_t sa_family;	/* Common data: address family and length.  */
    char sa_data[14];		/* Address data.  */
  };


/* Structure large enough to hold any socket address (with the historical
   exception of AF_UNIX).  We reserve 128 bytes.  */
struct sockaddr_storage
  {
    sa_family_t ss_family;	/* Address family, etc.  */
    unsignedlongint __ss_align;	/* Force desired alignment.  */
    char __ss_padding[(128-(2*sizeof(unsignedlongint)))];
  };


/* Bits in the FLAGS argument to `send', `recv', et al.  */
enum
  {
    MSG_OOB		= 0x01,	/* Process out-of-band data.  */
MSG_PEEK		= 0x02,	/* Peek at incoming messages.  */
MSG_DONTROUTE	= 0x04,	/* Don't use local routing.  */
#endif
MSG_CTRUNC		= 0x08,	/* Control data lost before delivery.  */
MSG_PROXY		= 0x10,	/* Supply or ask second address.  */
MSG_TRUNC		= 0x20,
MSG_DONTWAIT	= 0x40, /* Nonblocking IO.  */
MSG_EOR		= 0x80, /* End of record.  */
MSG_WAITALL		= 0x100, /* Wait for a full request.  */
MSG_FIN		= 0x200,
MSG_SYN		= 0x400,
MSG_CONFIRM		= 0x800, /* Confirm path validity.  */
MSG_RST		= 0x1000,
MSG_ERRQUEUE	= 0x2000, /* Fetch message from error queue.  */
MSG_NOSIGNAL	= 0x4000, /* Do not generate SIGPIPE.  */
MSG_MORE		= 0x8000,  /* Sender will send more.  */
MSG_WAITFORONE	= 0x10000, /* Wait for at least one packet to return.*/
MSG_CMSG_CLOEXEC	= 0x40000000	/* Set close_on_exit for file
					   descriptor received through
					   SCM_RIGHTS.  */
};


/* Structure describing messages sent by
   `sendmsg' and received by `recvmsg'.  */
struct msghdr
  {
    void *msg_name;		/* Address to send to/receive from.  */
    socklen_t msg_namelen;	/* Length of address data.  */

    struct iovec *msg_iov;	/* Vector of data to send/receive into.  */
    size_t msg_iovlen;		/* Number of elements in the vector.  */

    void *msg_control;		/* Ancillary data (eg BSD filedesc passing). */
    size_t msg_controllen;	/* Ancillary data buffer length.
				   !! The type should be socklen_t but the
				   definition of the kernel is incompatible
				   with this.  */

    int msg_flags;		/* Flags on received message.  */
  };

#endif
/* Structure used for storage of ancillary data object information.  */
struct cmsghdr
  {
    size_t cmsg_len;		/* Length of data in cmsg_data plus length
				   of cmsghdr structure.
				   !! The type should be socklen_t but the
				   definition of the kernel is incompatible
				   with this.  */
    int cmsg_level;		/* Originating protocol.  */
    int cmsg_type;		/* Protocol specific type.  */
#if 1
__extension__ unsigned char __cmsg_data []; /* Ancillary data.  */
#endif
};

/* Ancillary data object manipulation macros.  */
#if 1
#endif
extern struct cmsghdr *__cmsg_nxthdr (struct msghdr *__mhdr,
				      struct cmsghdr *__cmsg) __attribute__((__nothrow__));
#endif
/* Socket level message types.  This must match the definitions in
   <linux/socket.h>.  */
enum
  {
    SCM_RIGHTS = 0x01		/* Transfer file descriptors.  */
#endif
};

#endif
/* Ugly workaround for unclean kernel headers.  */
#endif
/* Get socket manipulation related informations from kernel headers.  */
##including asm/socket.h
##including asm-generic/socket.h
#if 1
##including asm/sockios.h
##including asm-generic/sockios.h
#if 1
/* Socket-level I/O control calls. */
#endif
/* For setsockopt(2) */
/* To add :#define SO_REUSEPORT 15 */

#if 1
#endif
/* Security levels - as per NRL IPv6 - don't actually do anything */
/* Socket filtering */
#endif
#endif
/* Structure used to manipulate the SO_LINGER option.  */
struct linger
  {
    int l_onoff;		/* Nonzero to linger on close.  */
    int l_linger;		/* Time to linger.  */
  };




/* Receive a message as described by MESSAGE from socket FD.
   Returns the number of bytes read or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int recvmmsg (int __fd, struct mmsghdr *__vmessages,
		     unsigned int __vlen, int __flags,
		     const struct timespec *__tmo);



#endif
#if 1
/* This is the 4.3 BSD `struct sockaddr' format, which is used as wire
   format in the grotty old 4.3 `talk' protocol.  */
struct osockaddr
  {
    unsigned short int sa_family;
    unsigned char sa_data[14];
  };
#endif
/* The following constants should be used for the second parameter of
   `shutdown'.  */
enum
{
  SHUT_RD = 0,		/* No more receptions.  */
SHUT_WR,		/* No more transmissions.  */
SHUT_RDWR		/* No more receptions or transmissions.  */
};

/* This is the type we use for generic socket address arguments.

   With GCC 2.7 and later, the funky union causes redeclarations or
   uses with any of the listed types to be allowed without complaint.
   G++ 2.7 does not support transparent unions so there we want the
   old-style declaration, too.  */
#if 1
#endif
/* Create a new socket of type TYPE in domain DOMAIN, using
   protocol PROTOCOL.  If PROTOCOL is zero, one is chosen automatically.
   Returns a file descriptor for the new socket, or -1 for errors.  */
extern int socket (int __domain, int __type, int __protocol) __attribute__((__nothrow__));

/* Create two new sockets, of type TYPE in domain DOMAIN and using
   protocol PROTOCOL, which are connected to each other, and put file
   descriptors for them in FDS[0] and FDS[1].  If PROTOCOL is zero,
   one will be chosen automatically.  Returns 0 on success, -1 for errors.  */
extern int socketpair (int __domain, int __type, int __protocol,
		       int __fds[2]) __attribute__((__nothrow__));

/* Give the socket FD the local address ADDR (which is LEN bytes long).  */
extern int bind (int __fd, conststructsockaddr* __addr, socklen_t __len)
     __attribute__((__nothrow__));

/* Put the local address of FD into *ADDR and its length in *LEN.  */
extern int getsockname (int __fd, structsockaddr*__restrict __addr,
			socklen_t *__restrict __len) __attribute__((__nothrow__));

/* Open a connection on socket FD to peer at ADDR (which LEN bytes long).
   For connectionless socket types, just set the default address to send to
   and the only address from which to accept transmissions.
   Return 0 on success, -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int connect (int __fd, conststructsockaddr* __addr, socklen_t __len);

/* Put the address of the peer connected to socket FD into *ADDR
   (which is *LEN bytes long), and its actual length into *LEN.  */
extern int getpeername (int __fd, structsockaddr*__restrict __addr,
			socklen_t *__restrict __len) __attribute__((__nothrow__));


/* Send N bytes of BUF to socket FD.  Returns the number sent or -1.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t send (int __fd, const void *__buf, size_t __n, int __flags);

/* Read N bytes into BUF from socket FD.
   Returns the number read or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t recv (int __fd, void *__buf, size_t __n, int __flags);

/* Send N bytes of BUF on socket FD to peer at address ADDR (which is
   ADDR_LEN bytes long).  Returns the number sent, or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t sendto (int __fd, const void *__buf, size_t __n,
		       int __flags, conststructsockaddr* __addr,
		       socklen_t __addr_len);

/* Read N bytes into BUF through socket FD.
   If ADDR is not NULL, fill in *ADDR_LEN bytes of it with tha address of
   the sender, and store the actual size of the address in *ADDR_LEN.
   Returns the number of bytes read or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t recvfrom (int __fd, void *__restrict __buf, size_t __n,
			 int __flags, structsockaddr*__restrict __addr,
			 socklen_t *__restrict __addr_len);


/* Send a message described MESSAGE on socket FD.
   Returns the number of bytes sent, or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t sendmsg (int __fd, const struct msghdr *__message,
			int __flags);

/* Receive a message as described by MESSAGE from socket FD.
   Returns the number of bytes read or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t recvmsg (int __fd, struct msghdr *__message, int __flags);


/* Put the current value for socket FD's option OPTNAME at protocol level LEVEL
   into OPTVAL (which is *OPTLEN bytes long), and set *OPTLEN to the value's
   actual length.  Returns 0 on success, -1 for errors.  */
extern int getsockopt (int __fd, int __level, int __optname,
		       void *__restrict __optval,
		       socklen_t *__restrict __optlen) __attribute__((__nothrow__));

/* Set socket FD's option OPTNAME at protocol level LEVEL
   to *OPTVAL (which is OPTLEN bytes long).
   Returns 0 on success, -1 for errors.  */
extern int setsockopt (int __fd, int __level, int __optname,
		       const void *__optval, socklen_t __optlen) __attribute__((__nothrow__));


/* Prepare to accept connections on socket FD.
   N connection requests will be queued before further requests are refused.
   Returns 0 on success, -1 for errors.  */
extern int listen (int __fd, int __n) __attribute__((__nothrow__));

/* Await a connection on socket FD.
   When a connection arrives, open a new socket to communicate with it,
   set *ADDR (which is *ADDR_LEN bytes long) to the address of the connecting
   peer and *ADDR_LEN to the address's actual length, and return the
   new socket's descriptor, or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int accept (int __fd, structsockaddr*__restrict __addr,
		   socklen_t *__restrict __addr_len);

#endif
/* Shut down all or part of the connection open on socket FD.
   HOW determines what to shut down:
     SHUT_RD   = No more receptions;
     SHUT_WR   = No more transmissions;
     SHUT_RDWR = No more receptions or transmissions.
   Returns 0 on success, -1 for errors.  */
extern int shutdown (int __fd, int __how) __attribute__((__nothrow__));


#if 1
/* Determine wheter socket is at a out-of-band mark.  */
extern int sockatmark (int __fd) __attribute__((__nothrow__));
#endif
#if 1
/* FDTYPE is S_IFSOCK or another S_IF* macro defined in <sys/stat.h>;
   returns 1 if FD is open on an object of the indicated type, 0 if not,
   or -1 for errors (setting errno).  */
extern int isfdtype (int __fd, int __fdtype) __attribute__((__nothrow__));
#endif
/* Define some macros helping to catch buffer overflows.  */
#endif


#endif
##including bits/types.h


/* Standard well-defined IP protocols.  */
enum
  {
    IPPROTO_IP = 0,	   /* Dummy protocol for TCP.  */
IPPROTO_HOPOPTS = 0,   /* IPv6 Hop-by-Hop options.  */
IPPROTO_ICMP = 1,	   /* Internet Control Message Protocol.  */
IPPROTO_IGMP = 2,	   /* Internet Group Management Protocol. */
IPPROTO_IPIP = 4,	   /* IPIP tunnels (older KA9Q tunnels use 94).  */
IPPROTO_TCP = 6,	   /* Transmission Control Protocol.  */
IPPROTO_EGP = 8,	   /* Exterior Gateway Protocol.  */
IPPROTO_PUP = 12,	   /* PUP protocol.  */
IPPROTO_UDP = 17,	   /* User Datagram Protocol.  */
IPPROTO_IDP = 22,	   /* XNS IDP protocol.  */
IPPROTO_TP = 29,	   /* SO Transport Protocol Class 4.  */
IPPROTO_DCCP = 33,	   /* Datagram Congestion Control Protocol.  */
IPPROTO_IPV6 = 41,     /* IPv6 header.  */
IPPROTO_ROUTING = 43,  /* IPv6 routing header.  */
IPPROTO_FRAGMENT = 44, /* IPv6 fragmentation header.  */
IPPROTO_RSVP = 46,	   /* Reservation Protocol.  */
IPPROTO_GRE = 47,	   /* General Routing Encapsulation.  */
IPPROTO_ESP = 50,      /* encapsulating security payload.  */
IPPROTO_AH = 51,       /* authentication header.  */
IPPROTO_ICMPV6 = 58,   /* ICMPv6.  */
IPPROTO_NONE = 59,     /* IPv6 no next header.  */
IPPROTO_DSTOPTS = 60,  /* IPv6 destination options.  */
IPPROTO_MTP = 92,	   /* Multicast Transport Protocol.  */
IPPROTO_ENCAP = 98,	   /* Encapsulation Header.  */
IPPROTO_PIM = 103,	   /* Protocol Independent Multicast.  */
IPPROTO_COMP = 108,	   /* Compression Header Protocol.  */
IPPROTO_SCTP = 132,	   /* Stream Control Transmission Protocol.  */
IPPROTO_UDPLITE = 136, /* UDP-Lite protocol.  */
IPPROTO_RAW = 255,	   /* Raw IP packets.  */
IPPROTO_MAX
  };


/* Type to represent a port.  */
typedef uint16_t in_port_t;

/* Standard well-known ports.  */
enum
  {
    IPPORT_ECHO = 7,		/* Echo service.  */
    IPPORT_DISCARD = 9,		/* Discard transmissions service.  */
    IPPORT_SYSTAT = 11,		/* System status service.  */
    IPPORT_DAYTIME = 13,	/* Time of day service.  */
    IPPORT_NETSTAT = 15,	/* Network status service.  */
    IPPORT_FTP = 21,		/* File Transfer Protocol.  */
    IPPORT_TELNET = 23,		/* Telnet protocol.  */
    IPPORT_SMTP = 25,		/* Simple Mail Transfer Protocol.  */
    IPPORT_TIMESERVER = 37,	/* Timeserver service.  */
    IPPORT_NAMESERVER = 42,	/* Domain Name Service.  */
    IPPORT_WHOIS = 43,		/* Internet Whois service.  */
    IPPORT_MTP = 57,

    IPPORT_TFTP = 69,		/* Trivial File Transfer Protocol.  */
    IPPORT_RJE = 77,
    IPPORT_FINGER = 79,		/* Finger service.  */
    IPPORT_TTYLINK = 87,
    IPPORT_SUPDUP = 95,		/* SUPDUP protocol.  */


    IPPORT_EXECSERVER = 512,	/* execd service.  */
    IPPORT_LOGINSERVER = 513,	/* rlogind service.  */
    IPPORT_CMDSERVER = 514,
    IPPORT_EFSSERVER = 520,

    /* UDP ports.  */
    IPPORT_BIFFUDP = 512,
    IPPORT_WHOSERVER = 513,
    IPPORT_ROUTESERVER = 520,

    /* Ports less than this value are reserved for privileged processes.  */
    IPPORT_RESERVED = 1024,

    /* Ports greater this value are reserved for (non-privileged) servers.  */
    IPPORT_USERRESERVED = 5000
  };


/* Internet address.  */
typedef uint32_t in_addr_t;
struct in_addr
  {
    in_addr_t s_addr;
  };


/* Definitions of the bits in an Internet address integer.

   On subnets, host and network parts are found according to
   the subnet mask, not these masks.  */

/* Address to accept any incoming messages.  */
/* Address to send to all hosts.  */
/* Address indicating an error return.  */
/* Network number for local host loopback.  */
/* Address to loopback in software to local host.  */
#if 1
#endif
/* Defines for Multicast INADDR.  */
/* IPv6 address */
struct in6_addr
  {
    union
      {
	uint8_t	__u6_addr8[16];
#if 1
uint16_t __u6_addr16[8];
	uint32_t __u6_addr32[4];
#endif
} __in6_u;
#if 1
#endif
};

extern const struct in6_addr in6addr_any;        /* :: */
extern const struct in6_addr in6addr_loopback;   /* ::1 */
/* Structure describing an Internet socket address.  */
struct sockaddr_in
  {
    sa_family_t sin_family;
    in_port_t sin_port;			/* Port number.  */
    struct in_addr sin_addr;		/* Internet address.  */

    /* Pad to size of `struct sockaddr'.  */
    unsigned char sin_zero[sizeof (struct sockaddr) -
			   (sizeof(unsignedshortint)) -
			   sizeof (in_port_t) -
			   sizeof (struct in_addr)];
  };

/* Ditto, for IPv6.  */
struct sockaddr_in6
  {
    sa_family_t sin6_family;
    in_port_t sin6_port;	/* Transport layer port # */
    uint32_t sin6_flowinfo;	/* IPv6 flow information */
    struct in6_addr sin6_addr;	/* IPv6 address */
    uint32_t sin6_scope_id;	/* IPv6 scope-id */
  };


#if 1
/* IPv4 multicast request.  */
struct ip_mreq
  {
    /* IP multicast address of group.  */
    struct in_addr imr_multiaddr;

    /* Local IP address of interface.  */
    struct in_addr imr_interface;
  };

struct ip_mreq_source
  {
    /* IP multicast address of group.  */
    struct in_addr imr_multiaddr;

    /* IP address of source.  */
    struct in_addr imr_interface;

    /* IP address of interface.  */
    struct in_addr imr_sourceaddr;
  };
#endif
/* Likewise, for IPv6.  */
struct ipv6_mreq
  {
    /* IPv6 multicast address of group */
    struct in6_addr ipv6mr_multiaddr;

    /* local interface */
    unsigned int ipv6mr_interface;
  };


#if 1
/* Multicast group request.  */
struct group_req
  {
    /* Interface index.  */
    uint32_t gr_interface;

    /* Group address.  */
    struct sockaddr_storage gr_group;
  };

struct group_source_req
  {
    /* Interface index.  */
    uint32_t gsr_interface;

    /* Group address.  */
    struct sockaddr_storage gsr_group;

    /* Source address.  */
    struct sockaddr_storage gsr_source;
  };


/* Full-state filter operations.  */
struct ip_msfilter
  {
    /* IP multicast address of group.  */
    struct in_addr imsf_multiaddr;

    /* Local IP address of interface.  */
    struct in_addr imsf_interface;

    /* Filter mode.  */
    uint32_t imsf_fmode;

    /* Number of source addresses.  */
    uint32_t imsf_numsrc;
    /* Source addresses.  */
    struct in_addr imsf_slist[1];
  };

struct group_filter
  {
    /* Interface index.  */
    uint32_t gf_interface;

    /* Group address.  */
    struct sockaddr_storage gf_group;

    /* Filter mode.  */
    uint32_t gf_fmode;

    /* Number of source addresses.  */
    uint32_t gf_numsrc;
    /* Source addresses.  */
    struct sockaddr_storage gf_slist[1];
};

#endif
/* Get system-specific definitions.  */
##including bits/in.h
/* Copyright (C) 1991-1999, 2000, 2004, 2008, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/* Linux version.  */

#endif
/* Options for use with `getsockopt' and `setsockopt' at the IP level.
   The first word in the comment at the right is the data type used;
   "bool" means a boolean value stored in an `int'.  */
/* For BSD compatibility.  */
#if 1
#endif
/* TProxy original addresses */
/* IP_MTU_DISCOVER arguments.  */
/* To select the IP level.  */
#if 1
/* Structure used to describe IP options for IP_OPTIONS and IP_RETOPTS.
   The `ip_dst' field is used for the first-hop gateway when using a
   source route (this gets put into the header proper).  */
struct ip_opts
  {
    struct in_addr ip_dst;	/* First hop; zero without source route.  */
    char ip_opts[40];		/* Actually variable in size.  */
  };

/* Like `struct ip_mreq' but including interface specification by index.  */
struct ip_mreqn
  {
    struct in_addr imr_multiaddr;	/* IP multicast address of group */
    struct in_addr imr_address;		/* local IP address of interface */
    int	imr_ifindex;			/* Interface index */
  };

/* Structure used for IP_PKTINFO.  */
struct in_pktinfo
  {
    int ipi_ifindex;			/* Interface index  */
    struct in_addr ipi_spec_dst;	/* Routing destination address  */
    struct in_addr ipi_addr;		/* Header destination address  */
  };
#endif
/* Options for use with `getsockopt' and `setsockopt' at the IPv6 level.
   The first word in the comment at the right is the data type used;
   "bool" means a boolean value stored in an `int'.  */
/* Obsolete synonyms for the above.  */
/* IPV6_MTU_DISCOVER values.  */
/* Socket level values for IPv6.  */
/* Routing header options for IPv6.  */
/* Functions to convert between host and network byte order.

   Please note that these functions normally take `unsigned long int' or
   `unsigned short int' values as arguments and also return them.  But
   this was a short-sighted decision since on different systems the types
   may have different representations but the values are always the same.  */

extern uint32_t ntohl (uint32_t __netlong) __attribute__((__nothrow__)) __attribute__ ((__const__));
extern uint16_t ntohs (uint16_t __netshort)
     __attribute__((__nothrow__)) __attribute__ ((__const__));
extern uint32_t htonl (uint32_t __hostlong)
     __attribute__((__nothrow__)) __attribute__ ((__const__));
extern uint16_t htons (uint16_t __hostshort)
     __attribute__((__nothrow__)) __attribute__ ((__const__));

##including endian.h
/* Get machine dependent optimized versions of byte swapping functions.  */
##including bits/byteswap.h
/* Macros to swap the order of bytes in integer values.
   Copyright (C) 1997, 1998, 2000, 2002, 2003, 2007, 2008
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#endif
#endif
#if 1
/* Bind socket to a privileged IP port.  */
extern int bindresvport (int __sockfd, struct sockaddr_in *__sock_in) __attribute__((__nothrow__));

/* The IPv6 version of this function.  */
extern int bindresvport6 (int __sockfd, struct sockaddr_in6 *__sock_in)
     __attribute__((__nothrow__));
#endif
#endif


#endif
##including stdint.h
#if 1
/* This is necessary to make this include file properly replace the
   Sun version.  */
##including rpc/netdb.h
/* @(#)netdb.h	2.1 88/07/29 3.9 RPCSRC */
/*
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 *     * Neither the name of Sun Microsystems, Inc. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 *   FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *   COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 *   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *   GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 *   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*	@(#)rpc.h 1.8 87/07/24 SMI	*/

/* Cleaned up for GNU C library roland@gnu.ai.mit.edu:
   added multiple inclusion protection and use of <sys/cdefs.h>.
   In GNU this file is #include'd by <netdb.h>.  */

#if 1
##including features.h
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif


struct rpcent
{
  char *r_name;		/* Name of server for this rpc program.  */
  char **r_aliases;	/* Alias list.  */
  int r_number;		/* RPC program number.  */
};

extern void setrpcent (int __stayopen) __attribute__((__nothrow__));
extern void endrpcent (void) __attribute__((__nothrow__));
extern struct rpcent *getrpcbyname (const char *__name) __attribute__((__nothrow__));
extern struct rpcent *getrpcbynumber (int __number) __attribute__((__nothrow__));
extern struct rpcent *getrpcent (void) __attribute__((__nothrow__));

#if 1
extern int getrpcbyname_r (const char *__name, struct rpcent *__result_buf,
			   char *__buffer, size_t __buflen,
			   struct rpcent **__result) __attribute__((__nothrow__));

extern int getrpcbynumber_r (int __number, struct rpcent *__result_buf,
			     char *__buffer, size_t __buflen,
			     struct rpcent **__result) __attribute__((__nothrow__));

extern int getrpcent_r (struct rpcent *__result_buf, char *__buffer,
			size_t __buflen, struct rpcent **__result) __attribute__((__nothrow__));
#endif


#endif
#endif
#endif
##including bits/netdb.h
/* Copyright (C) 1996, 1997, 1998, 1999, 2000 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Description of data base entry for a single network.  NOTE: here a
   poor assumption is made.  The network number is expected to fit
   into an unsigned long int variable.  */
struct netent
{
  char *n_name;			/* Official name of network.  */
  char **n_aliases;		/* Alias list.  */
  int n_addrtype;		/* Net address type.  */
  uint32_t n_net;		/* Network number.  */
};
/* Absolute file name for network data base files.  */


#if 1
/* Error status for non-reentrant lookup functions.
   We use a macro to access always the thread-specific `h_errno' variable.  */
/* Function to get address of global `h_errno' variable.  */
extern int *__h_errno_location (void) __attribute__((__nothrow__)) __attribute__ ((__const__));


/* Possible values left in `h_errno'.  */
#endif
#if 1
#endif
#if 1
/* Highest reserved Internet port number.  */
#endif
#endif
#if 1
/* Print error indicated by `h_errno' variable on standard error.  STR
   if non-null is printed before the error string.  */
extern void herror (const char *__str) __attribute__((__nothrow__));

/* Return string associated with error ERR_NUM.  */
extern const char *hstrerror (int __err_num) __attribute__((__nothrow__));
#endif
/* Description of data base entry for a single host.  */
struct hostent
{
  char *h_name;			/* Official name of host.  */
  char **h_aliases;		/* Alias list.  */
  int h_addrtype;		/* Host address type.  */
  int h_length;			/* Length of address.  */
  char **h_addr_list;		/* List of addresses from name server.  */
#if 1
#endif
};

/* Open host data base files and mark them as staying open even after
   a later search if STAY_OPEN is non-zero.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void sethostent (int __stay_open);

/* Close host data base files and clear `stay open' flag.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void endhostent (void);

/* Get next entry from host data base file.  Open data base if
   necessary.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct hostent *gethostent (void);

/* Return entry from host data base which address match ADDR with
   length LEN and type TYPE.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct hostent *gethostbyaddr (const void *__addr, __socklen_t __len,
				      int __type);

/* Return entry from host data base for host with NAME.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct hostent *gethostbyname (const char *__name);

#if 1
/* Return entry from host data base for host with NAME.  AF must be
   set to the address type which is `AF_INET' for IPv4 or `AF_INET6'
   for IPv6.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct hostent *gethostbyname2 (const char *__name, int __af);

/* Reentrant versions of the functions above.  The additional
   arguments specify a buffer of BUFLEN starting at BUF.  The last
   argument is a pointer to a variable which gets the value which
   would be stored in the global variable `herrno' by the
   non-reentrant functions.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern int gethostent_r (struct hostent *__restrict __result_buf,
			 char *__restrict __buf, size_t __buflen,
			 struct hostent **__restrict __result,
			 int *__restrict __h_errnop);

extern int gethostbyaddr_r (const void *__restrict __addr, __socklen_t __len,
			    int __type,
			    struct hostent *__restrict __result_buf,
			    char *__restrict __buf, size_t __buflen,
			    struct hostent **__restrict __result,
			    int *__restrict __h_errnop);

extern int gethostbyname_r (const char *__restrict __name,
			    struct hostent *__restrict __result_buf,
			    char *__restrict __buf, size_t __buflen,
			    struct hostent **__restrict __result,
			    int *__restrict __h_errnop);

extern int gethostbyname2_r (const char *__restrict __name, int __af,
			     struct hostent *__restrict __result_buf,
			     char *__restrict __buf, size_t __buflen,
			     struct hostent **__restrict __result,
			     int *__restrict __h_errnop);
#endif
/* Open network data base files and mark them as staying open even
   after a later search if STAY_OPEN is non-zero.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void setnetent (int __stay_open);

/* Close network data base files and clear `stay open' flag.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void endnetent (void);

/* Get next entry from network data base file.  Open data base if
   necessary.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct netent *getnetent (void);

/* Return entry from network data base which address match NET and
   type TYPE.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct netent *getnetbyaddr (uint32_t __net, int __type);

/* Return entry from network data base for network with NAME.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct netent *getnetbyname (const char *__name);

#if 1
/* Reentrant versions of the functions above.  The additional
   arguments specify a buffer of BUFLEN starting at BUF.  The last
   argument is a pointer to a variable which gets the value which
   would be stored in the global variable `herrno' by the
   non-reentrant functions.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern int getnetent_r (struct netent *__restrict __result_buf,
			char *__restrict __buf, size_t __buflen,
			struct netent **__restrict __result,
			int *__restrict __h_errnop);

extern int getnetbyaddr_r (uint32_t __net, int __type,
			   struct netent *__restrict __result_buf,
			   char *__restrict __buf, size_t __buflen,
			   struct netent **__restrict __result,
			   int *__restrict __h_errnop);

extern int getnetbyname_r (const char *__restrict __name,
			   struct netent *__restrict __result_buf,
			   char *__restrict __buf, size_t __buflen,
			   struct netent **__restrict __result,
			   int *__restrict __h_errnop);
#endif
/* Description of data base entry for a single service.  */
struct servent
{
  char *s_name;			/* Official service name.  */
  char **s_aliases;		/* Alias list.  */
  int s_port;			/* Port number.  */
  char *s_proto;		/* Protocol to use.  */
};

/* Open service data base files and mark them as staying open even
   after a later search if STAY_OPEN is non-zero.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void setservent (int __stay_open);

/* Close service data base files and clear `stay open' flag.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void endservent (void);

/* Get next entry from service data base file.  Open data base if
   necessary.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct servent *getservent (void);

/* Return entry from network data base for network with NAME and
   protocol PROTO.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct servent *getservbyname (const char *__name,
				      const char *__proto);

/* Return entry from service data base which matches port PORT and
   protocol PROTO.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct servent *getservbyport (int __port, const char *__proto);


#if 1
/* Reentrant versions of the functions above.  The additional
   arguments specify a buffer of BUFLEN starting at BUF.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern int getservent_r (struct servent *__restrict __result_buf,
			 char *__restrict __buf, size_t __buflen,
			 struct servent **__restrict __result);

extern int getservbyname_r (const char *__restrict __name,
			    const char *__restrict __proto,
			    struct servent *__restrict __result_buf,
			    char *__restrict __buf, size_t __buflen,
			    struct servent **__restrict __result);

extern int getservbyport_r (int __port, const char *__restrict __proto,
			    struct servent *__restrict __result_buf,
			    char *__restrict __buf, size_t __buflen,
			    struct servent **__restrict __result);
#endif
/* Description of data base entry for a single service.  */
struct protoent
{
  char *p_name;			/* Official protocol name.  */
  char **p_aliases;		/* Alias list.  */
  int p_proto;			/* Protocol number.  */
};

/* Open protocol data base files and mark them as staying open even
   after a later search if STAY_OPEN is non-zero.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void setprotoent (int __stay_open);

/* Close protocol data base files and clear `stay open' flag.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void endprotoent (void);

/* Get next entry from protocol data base file.  Open data base if
   necessary.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct protoent *getprotoent (void);

/* Return entry from protocol data base for network with NAME.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct protoent *getprotobyname (const char *__name);

/* Return entry from protocol data base which number is PROTO.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct protoent *getprotobynumber (int __proto);


#if 1
/* Reentrant versions of the functions above.  The additional
   arguments specify a buffer of BUFLEN starting at BUF.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern int getprotoent_r (struct protoent *__restrict __result_buf,
			  char *__restrict __buf, size_t __buflen,
			  struct protoent **__restrict __result);

extern int getprotobyname_r (const char *__restrict __name,
			     struct protoent *__restrict __result_buf,
			     char *__restrict __buf, size_t __buflen,
			     struct protoent **__restrict __result);

extern int getprotobynumber_r (int __proto,
			       struct protoent *__restrict __result_buf,
			       char *__restrict __buf, size_t __buflen,
			       struct protoent **__restrict __result);


/* Establish network group NETGROUP for enumeration.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int setnetgrent (const char *__netgroup);

/* Free all space allocated by previous `setnetgrent' call.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern void endnetgrent (void);

/* Get next member of netgroup established by last `setnetgrent' call
   and return pointers to elements in HOSTP, USERP, and DOMAINP.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int getnetgrent (char **__restrict __hostp,
			char **__restrict __userp,
			char **__restrict __domainp);


/* Test whether NETGROUP contains the triple (HOST,USER,DOMAIN).

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int innetgr (const char *__netgroup, const char *__host,
		    const char *__user, const char *__domain);

/* Reentrant version of `getnetgrent' where result is placed in BUFFER.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int getnetgrent_r (char **__restrict __hostp,
			  char **__restrict __userp,
			  char **__restrict __domainp,
			  char *__restrict __buffer, size_t __buflen);
#endif
#if 1
/* Call `rshd' at port RPORT on remote machine *AHOST to execute CMD.
   The local user is LOCUSER, on the remote machine the command is
   executed as REMUSER.  In *FD2P the descriptor to the socket for the
   connection is returned.  The caller must have the right to use a
   reserved port.  When the function returns *AHOST contains the
   official host name.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int rcmd (char **__restrict __ahost, unsigned short int __rport,
		 const char *__restrict __locuser,
		 const char *__restrict __remuser,
		 const char *__restrict __cmd, int *__restrict __fd2p);

/* This is the equivalent function where the protocol can be selected
   and which therefore can be used for IPv6.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int rcmd_af (char **__restrict __ahost, unsigned short int __rport,
		    const char *__restrict __locuser,
		    const char *__restrict __remuser,
		    const char *__restrict __cmd, int *__restrict __fd2p,
		    sa_family_t __af);

/* Call `rexecd' at port RPORT on remote machine *AHOST to execute
   CMD.  The process runs at the remote machine using the ID of user
   NAME whose cleartext password is PASSWD.  In *FD2P the descriptor
   to the socket for the connection is returned.  When the function
   returns *AHOST contains the official host name.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int rexec (char **__restrict __ahost, int __rport,
		  const char *__restrict __name,
		  const char *__restrict __pass,
		  const char *__restrict __cmd, int *__restrict __fd2p);

/* This is the equivalent function where the protocol can be selected
   and which therefore can be used for IPv6.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int rexec_af (char **__restrict __ahost, int __rport,
		     const char *__restrict __name,
		     const char *__restrict __pass,
		     const char *__restrict __cmd, int *__restrict __fd2p,
		     sa_family_t __af);

/* Check whether user REMUSER on system RHOST is allowed to login as LOCUSER.
   If SUSER is not zero the user tries to become superuser.  Return 0 if
   it is possible.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int ruserok (const char *__rhost, int __suser,
		    const char *__remuser, const char *__locuser);

/* This is the equivalent function where the protocol can be selected
   and which therefore can be used for IPv6.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int ruserok_af (const char *__rhost, int __suser,
		       const char *__remuser, const char *__locuser,
		       sa_family_t __af);

/* Check whether user REMUSER on system indicated by IPv4 address
   RADDR is allowed to login as LOCUSER.  Non-IPv4 (e.g., IPv6) are
   not supported.  If SUSER is not zero the user tries to become
   superuser.  Return 0 if it is possible.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int iruserok (uint32_t __raddr, int __suser,
		     const char *__remuser, const char *__locuser);

/* This is the equivalent function where the pfamiliy if the address
   pointed to by RADDR is determined by the value of AF.  It therefore
   can be used for IPv6

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int iruserok_af (const void *__raddr, int __suser,
			const char *__remuser, const char *__locuser,
			sa_family_t __af);

/* Try to allocate reserved port, returning a descriptor for a socket opened
   at this port or -1 if unsuccessful.  The search for an available port
   will start at ALPORT and continues with lower numbers.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int rresvport (int *__alport);

/* This is the equivalent function where the protocol can be selected
   and which therefore can be used for IPv6.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int rresvport_af (int *__alport, sa_family_t __af);
#endif
/* Extension from POSIX.1g.  */
#if 1
/* Structure to contain information about address of a service provider.  */
struct addrinfo
{
  int ai_flags;			/* Input flags.  */
  int ai_family;		/* Protocol family for socket.  */
  int ai_socktype;		/* Socket type.  */
  int ai_protocol;		/* Protocol for socket.  */
  socklen_t ai_addrlen;		/* Length of socket address.  */
  struct sockaddr *ai_addr;	/* Socket address for socket.  */
  char *ai_canonname;		/* Canonical name for service location.  */
  struct addrinfo *ai_next;	/* Pointer to next in list.  */
};

#endif
/* Possible values for `ai_flags' field in `addrinfo' structure.  */
#endif
/* Error values for `getaddrinfo' function.  */
#endif
#if 1
#endif
#endif
/* Translate name of a service location and/or a service name to set of
   socket addresses.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int getaddrinfo (const char *__restrict __name,
			const char *__restrict __service,
			const struct addrinfo *__restrict __req,
			struct addrinfo **__restrict __pai);

/* Free `addrinfo' structure AI including associated storage.  */
extern void freeaddrinfo (struct addrinfo *__ai) __attribute__((__nothrow__));

/* Convert error return from getaddrinfo() to a string.  */
extern const char *gai_strerror (int __ecode) __attribute__((__nothrow__));

/* Translate a socket address to a location and service name.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int getnameinfo (const struct sockaddr *__restrict __sa,
			socklen_t __salen, char *__restrict __host,
			socklen_t __hostlen, char *__restrict __serv,
			socklen_t __servlen, unsigned int __flags);
#endif
#endif


#endif
##including setjmp.h
/* Copyright (C) 1991-1999,2001,2002,2007,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.13 Nonlocal jumps	<setjmp.h>
 */

#if 1
##including features.h


##including bits/setjmp.h
/* Copyright (C) 2001,2002,2003,2005,2006 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/* Define the machine-dependent type `jmp_buf'.  x86-64 version.  */
#if 1
#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#if 1
#if 1
typedef long int __jmp_buf[8];
#endif
#endif
#endif
##including bits/sigset.h
/* Calling environment, plus possibly a saved signal mask.  */
struct __jmp_buf_tag
  {
    /* NOTE: The machine-dependent definitions of `__sigsetjmp'
       assume that a `jmp_buf' begins with a `__jmp_buf' and that
       `__mask_was_saved' follows it.  Do not move these members
       or add others before it.  */
    __jmp_buf __jmpbuf;		/* Calling environment.  */
    int __mask_was_saved;	/* Saved the signal mask?  */
    __sigset_t __saved_mask;	/* Saved signal mask.  */
  };




typedef struct __jmp_buf_tag jmp_buf[1];

/* Store the calling environment in ENV, also saving the signal mask.
   Return 0.  */
extern int setjmp (jmp_buf __env) __attribute__((__nothrow__));



/* Store the calling environment in ENV, also saving the
   signal mask if SAVEMASK is nonzero.  Return 0.
   This is the internal name for `sigsetjmp'.  */
extern int __sigsetjmp (struct __jmp_buf_tag __env[1], int __savemask) __attribute__((__nothrow__));

#if 1
/* Store the calling environment in ENV, not saving the signal mask.
   Return 0.  */
extern int _setjmp (struct __jmp_buf_tag __env[1]) __attribute__((__nothrow__));

/* Do not save the signal mask.  This is equivalent to the `_setjmp'
   BSD function.  */
#endif


/* Jump to the environment saved in ENV, making the
   `setjmp' call there return VAL, or 1 if VAL is 0.  */
extern void longjmp (struct __jmp_buf_tag __env[1], int __val)
     __attribute__((__nothrow__)) __attribute__ ((__noreturn__));



#if 1
/* Same.  Usually `_longjmp' is used with `_setjmp', which does not save
   the signal mask.  But it is how ENV was saved that determines whether
   `longjmp' restores the mask; `_longjmp' is just an alias.  */
extern void _longjmp (struct __jmp_buf_tag __env[1], int __val)
     __attribute__((__nothrow__)) __attribute__ ((__noreturn__));
#endif
#if 1
/* Use the same type for `jmp_buf' and `sigjmp_buf'.
   The `__mask_was_saved' flag determines whether
   or not `longjmp' will restore the signal mask.  */
typedef struct __jmp_buf_tag sigjmp_buf[1];

/* Store the calling environment in ENV, also saving the
   signal mask if SAVEMASK is nonzero.  Return 0.  */
/* Jump to the environment saved in ENV, making the
   sigsetjmp call there return VAL, or 1 if VAL is 0.
   Restore the signal mask if that sigsetjmp call saved it.
   This is just an alias `longjmp'.  */
extern void siglongjmp (sigjmp_buf __env, int __val)
     __attribute__((__nothrow__)) __attribute__ ((__noreturn__));
#endif
/* Define helper functions to catch unsafe code.  */
#endif


#endif
##including signal.h
/* Copyright (C) 1991-2004, 2007, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.14 Signal handling <signal.h>
 */

#if 1
#if 1
#endif
##including features.h


##including bits/sigset.h
/* An integral type that can be modified atomically, without the
   possibility of a signal arriving in the middle of the operation.  */
#if 1
#if 1

typedef __sig_atomic_t sig_atomic_t;

#endif
#endif
#if 1
#endif
#endif
#if 1
##including bits/types.h
##including bits/signum.h
/* Signal number definitions.  Linux version.
   Copyright (C) 1995,1996,1997,1998,1999,2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
/* Fake signal functions.  */
#endif
/* Signals.  */
/* These are the hard limits of the kernel.  These values should not be
   used directly at user level.  */
#endif
#if 1
#endif
#endif
#endif
#endif
#if 1
/* We need `struct timespec' later on.  */
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
/* Get the `siginfo_t' type plus the needed symbols.  */
##including bits/siginfo.h
/* siginfo_t, sigevent and constants.  Linux version.
   Copyright (C) 1997-2002, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#if 1
/* Type for data associated with a signal.  */
typedef union sigval
  {
    int sival_int;
    void *sival_ptr;
  } sigval_t;
#endif
#if 1
#if 1
#endif
typedef struct siginfo
  {
    int si_signo;		/* Signal number.  */
    int si_errno;		/* If non-zero, an errno value associated with
				   this signal, as defined in <errno.h>.  */
    int si_code;		/* Signal code.  */

    union
      {
	int _pad[((128/sizeof(int))-4)];

	 /* kill().  */
	struct
	  {
	    __pid_t si_pid;	/* Sending process ID.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	  } _kill;

	/* POSIX.1b timers.  */
	struct
	  {
	    int si_tid;		/* Timer ID.  */
	    int si_overrun;	/* Overrun count.  */
	    sigval_t si_sigval;	/* Signal value.  */
	  } _timer;

	/* POSIX.1b signals.  */
	struct
	  {
	    __pid_t si_pid;	/* Sending process ID.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	    sigval_t si_sigval;	/* Signal value.  */
	  } _rt;

	/* SIGCHLD.  */
	struct
	  {
	    __pid_t si_pid;	/* Which child.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	    int si_status;	/* Exit value or signal.  */
	    __clock_t si_utime;
	    __clock_t si_stime;
	  } _sigchld;

	/* SIGILL, SIGFPE, SIGSEGV, SIGBUS.  */
	struct
	  {
	    void *si_addr;	/* Faulting insn/memory ref.  */
	  } _sigfault;

	/* SIGPOLL.  */
	struct
	  {
	    long int si_band;	/* Band event for SIGPOLL.  */
	    int si_fd;
	  } _sigpoll;
      } _sifields;
  } siginfo_t;


/* X/Open requires some more fields with fixed names.  */
/* Values for `si_code'.  Positive values are reserved for kernel-generated
   signals.  */
enum
{
  SI_ASYNCNL = -60,		/* Sent by asynch name lookup completion.  */
SI_TKILL = -6,		/* Sent by tkill.  */
SI_SIGIO,			/* Sent by queued SIGIO. */
SI_ASYNCIO,			/* Sent by AIO completion.  */
SI_MESGQ,			/* Sent by real time mesq state change.  */
SI_TIMER,			/* Sent by timer expiration.  */
SI_QUEUE,			/* Sent by sigqueue.  */
SI_USER,			/* Sent by kill, sigsend, raise.  */
SI_KERNEL = 0x80		/* Send by kernel.  */
};


/* `si_code' values for SIGILL signal.  */
enum
{
  ILL_ILLOPC = 1,		/* Illegal opcode.  */
ILL_ILLOPN,			/* Illegal operand.  */
ILL_ILLADR,			/* Illegal addressing mode.  */
ILL_ILLTRP,			/* Illegal trap. */
ILL_PRVOPC,			/* Privileged opcode.  */
ILL_PRVREG,			/* Privileged register.  */
ILL_COPROC,			/* Coprocessor error.  */
ILL_BADSTK			/* Internal stack error.  */
};

/* `si_code' values for SIGFPE signal.  */
enum
{
  FPE_INTDIV = 1,		/* Integer divide by zero.  */
FPE_INTOVF,			/* Integer overflow.  */
FPE_FLTDIV,			/* Floating point divide by zero.  */
FPE_FLTOVF,			/* Floating point overflow.  */
FPE_FLTUND,			/* Floating point underflow.  */
FPE_FLTRES,			/* Floating point inexact result.  */
FPE_FLTINV,			/* Floating point invalid operation.  */
FPE_FLTSUB			/* Subscript out of range.  */
};

/* `si_code' values for SIGSEGV signal.  */
enum
{
  SEGV_MAPERR = 1,		/* Address not mapped to object.  */
SEGV_ACCERR			/* Invalid permissions for mapped object.  */
};

/* `si_code' values for SIGBUS signal.  */
enum
{
  BUS_ADRALN = 1,		/* Invalid address alignment.  */
BUS_ADRERR,			/* Non-existant physical address.  */
BUS_OBJERR			/* Object specific hardware error.  */
};

/* `si_code' values for SIGTRAP signal.  */
enum
{
  TRAP_BRKPT = 1,		/* Process breakpoint.  */
TRAP_TRACE			/* Process trace trap.  */
};

/* `si_code' values for SIGCHLD signal.  */
enum
{
  CLD_EXITED = 1,		/* Child has exited.  */
CLD_KILLED,			/* Child was killed.  */
CLD_DUMPED,			/* Child terminated abnormally.  */
CLD_TRAPPED,			/* Traced child has trapped.  */
CLD_STOPPED,			/* Child has stopped.  */
CLD_CONTINUED			/* Stopped child has continued.  */
};

/* `si_code' values for SIGPOLL signal.  */
enum
{
  POLL_IN = 1,			/* Data input available.  */
POLL_OUT,			/* Output buffers available.  */
POLL_MSG,			/* Input message available.   */
POLL_ERR,			/* I/O error.  */
POLL_PRI,			/* High priority input available.  */
POLL_HUP			/* Device disconnected.  */
};

#endif
#if 1
/* Structure to transport application-defined values with signals.  */
#if 1
#endif
typedef struct sigevent
  {
    sigval_t sigev_value;
    int sigev_signo;
    int sigev_notify;

    union
      {
	int _pad[((64/sizeof(int))-4)];

	/* When SIGEV_SIGNAL and SIGEV_THREAD_ID set, LWP ID of the
	   thread to receive the signal.  */
	__pid_t _tid;

	struct
	  {
	    void (*_function) (sigval_t);	/* Function to start.  */
	    void *_attribute;			/* Really pthread_attr_t.  */
	  } _sigev_thread;
      } _sigev_un;
  } sigevent_t;

/* POSIX names to access some of the members.  */
/* `sigev_notify' values.  */
enum
{
  SIGEV_SIGNAL = 0,		/* Notify via signal.  */
SIGEV_NONE,			/* Other notification: meaningless.  */
SIGEV_THREAD,			/* Deliver via thread creation.  */
SIGEV_THREAD_ID = 4		/* Send signal to specific thread.  */
};

#endif
#endif
/* Type of a signal handler.  */
typedef void (*__sighandler_t) (int);

/* The X/Open definition of `signal' specifies the SVID semantic.  Use
   the additional function `sysv_signal' when X/Open compatibility is
   requested.  */
extern __sighandler_t __sysv_signal (int __sig, __sighandler_t __handler)
     __attribute__((__nothrow__));
#endif
/* Set the handler for the signal SIG to HANDLER, returning the old
   handler, or SIG_ERR on error.
   By default `signal' has the BSD semantic.  */

#if 1
extern __sighandler_t signal (int __sig, __sighandler_t __handler)
     __attribute__((__nothrow__));
#endif


#endif
/* Send signal SIG to process number PID.  If PID is zero,
   send SIG to all processes in the current process's process group.
   If PID is < -1, send SIG to all processes in process group - PID.  */
#if 1
extern int kill (__pid_t __pid, int __sig) __attribute__((__nothrow__));
#endif
#if 1
/* Send SIG to all processes in process group PGRP.
   If PGRP is zero, send SIG to all processes in
   the current process's process group.  */
extern int killpg (__pid_t __pgrp, int __sig) __attribute__((__nothrow__));
#endif

/* Raise signal SIG, i.e., send SIG to yourself.  */
extern int raise (int __sig) __attribute__((__nothrow__));


#if 1
/* SVID names for the same things.  */
extern __sighandler_t ssignal (int __sig, __sighandler_t __handler)
     __attribute__((__nothrow__));
extern int gsignal (int __sig) __attribute__((__nothrow__));
#endif
#if 1
/* Print a message describing the meaning of the given signal number.  */
extern void psignal (int __sig, const char *__s);
#endif
#if 1
/* Print a message describing the meaning of the given signal information.  */
extern void psiginfo (const siginfo_t *__pinfo, const char *__s);
#endif
/* The `sigpause' function has two different interfaces.  The original
   BSD definition defines the argument as a mask of the signal, while
   the more modern interface in X/Open defines it as the signal
   number.  We go with the BSD version unless the user explicitly
   selects the X/Open version.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int __sigpause (int __sig_or_mask, int __is_sig);

#elif 1
#endif
#endif
#if 1
/* None of the following functions should be used anymore.  They are here
   only for compatibility.  A single word (`int') is not guaranteed to be
   enough to hold a complete signal mask and therefore these functions
   simply do not work in many situations.  Use `sigprocmask' instead.  */

/* Compute mask for signal SIG.  */
/* Block signals in MASK, returning the old mask.  */
extern int sigblock (int __mask) __attribute__((__nothrow__)) __attribute__((__deprecated__));

/* Set the mask of blocked signals to MASK, returning the old mask.  */
extern int sigsetmask (int __mask) __attribute__((__nothrow__)) __attribute__((__deprecated__));

/* Return currently selected signal mask.  */
extern int siggetmask (void) __attribute__((__nothrow__)) __attribute__((__deprecated__));
#endif
#if 1
#endif
#endif
/* 4.4 BSD uses the name `sig_t' for this.  */
#if 1
typedef __sighandler_t sig_t;
#endif
#if 1
/* Clear all signals from SET.  */
extern int sigemptyset (sigset_t *__set) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Set all signals in SET.  */
extern int sigfillset (sigset_t *__set) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Add SIGNO to SET.  */
extern int sigaddset (sigset_t *__set, int __signo) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Remove SIGNO from SET.  */
extern int sigdelset (sigset_t *__set, int __signo) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Return 1 if SIGNO is in SET, 0 if not.  */
extern int sigismember (const sigset_t *__set, int __signo)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#endif
/* Get the system-specific definitions of `struct sigaction'
   and the `SA_*' and `SIG_*'. constants.  */
##including bits/sigaction.h
/* The proper definitions for Linux's sigaction.
   Copyright (C) 1993-1999, 2000, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Structure describing the action to be taken when a signal arrives.  */
struct sigaction
  {
    /* Signal handler.  */
#if 1
union
      {
	/* Used if SA_SIGINFO is not set.  */
	__sighandler_t sa_handler;
	/* Used if SA_SIGINFO is set.  */
	void (*sa_sigaction) (int, siginfo_t *, void *);
      }
    __sigaction_handler;
#endif
/* Additional set of signals to be blocked.  */
    __sigset_t sa_mask;

    /* Special flags.  */
    int sa_flags;

    /* Restore handler.  */
    void (*sa_restorer) (void);
  };

/* Bits in `sa_flags'.  */
#if 1
#endif
#if 1
#endif
#if 1
/* Some aliases for the SA_ constants.  */
#endif
/* Values for the HOW argument to `sigprocmask'.  */
/* Get and/or change the set of blocked signals.  */
extern int sigprocmask (int __how, const sigset_t *__restrict __set,
			sigset_t *__restrict __oset) __attribute__((__nothrow__));

/* Change the set of blocked signals to SET,
   wait until a signal arrives, and restore the set of blocked signals.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int sigsuspend (const sigset_t *__set) __attribute__((__nonnull__ (1)));

/* Get and/or set the action for signal SIG.  */
extern int sigaction (int __sig, const struct sigaction *__restrict __act,
		      struct sigaction *__restrict __oact) __attribute__((__nothrow__));

/* Put in SET all signals that are blocked and waiting to be delivered.  */
extern int sigpending (sigset_t *__set) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));


/* Select any of pending signals from SET or wait for any to arrive.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int sigwait (const sigset_t *__restrict __set, int *__restrict __sig)
     __attribute__((__nonnull__ (1, 2)));

#if 1
/* Select any of pending signals from SET and place information in INFO.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int sigwaitinfo (const sigset_t *__restrict __set,
			siginfo_t *__restrict __info) __attribute__((__nonnull__ (1)));

/* Select any of pending signals from SET and place information in INFO.
   Wait the time specified by TIMEOUT if no signal is pending.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int sigtimedwait (const sigset_t *__restrict __set,
			 siginfo_t *__restrict __info,
			 const struct timespec *__restrict __timeout)
     __attribute__((__nonnull__ (1)));

/* Send signal SIG to the process PID.  Associate data in VAL with the
   signal.  */
extern int sigqueue (__pid_t __pid, int __sig, const union sigval __val)
     __attribute__((__nothrow__));
#endif
#endif
#if 1
/* Names of the signals.  This variable exists only for compatibility.
   Use `strsignal' instead (see <string.h>).  */
extern const char *const _sys_siglist[65];
extern const char *const sys_siglist[65];

/* Structure passed to `sigvec'.  */
struct sigvec
  {
    __sighandler_t sv_handler;	/* Signal handler.  */
    int sv_mask;		/* Mask of signals to be blocked.  */

    int sv_flags;		/* Flags (see below).  */
};

/* Bits in `sv_flags'.  */
/* If VEC is non-NULL, set the handler for SIG to the `sv_handler' member
   of VEC.  The signals in `sv_mask' will be blocked while the handler runs.
   If the SV_RESETHAND bit is set in `sv_flags', the handler for SIG will be
   reset to SIG_DFL before `sv_handler' is entered.  If OVEC is non-NULL,
   it is filled in with the old information for SIG.  */
extern int sigvec (int __sig, const struct sigvec *__vec,
		   struct sigvec *__ovec) __attribute__((__nothrow__));


/* Get machine-dependent `struct sigcontext' and signal subcodes.  */
##including bits/sigcontext.h
/* Copyright (C) 2002 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
struct _fpreg
{
  unsigned short significand[4];
  unsigned short exponent;
};

struct _fpxreg
{
  unsigned short significand[4];
  unsigned short exponent;
  unsigned short padding[3];
};

struct _xmmreg
{
  __uint32_t	element[4];
};



#elif 1
struct _fpstate
{
  /* FPU environment matching the 64-bit FXSAVE layout.  */
  __uint16_t		cwd;
  __uint16_t		swd;
  __uint16_t		ftw;
  __uint16_t		fop;
  __uint64_t		rip;
  __uint64_t		rdp;
  __uint32_t		mxcsr;
  __uint32_t		mxcr_mask;
  struct _fpxreg	_st[8];
  struct _xmmreg	_xmm[16];
  __uint32_t		padding[24];
};

struct sigcontext
{
  unsigned long r8;
  unsigned long r9;
  unsigned long r10;
  unsigned long r11;
  unsigned long r12;
  unsigned long r13;
  unsigned long r14;
  unsigned long r15;
  unsigned long rdi;
  unsigned long rsi;
  unsigned long rbp;
  unsigned long rbx;
  unsigned long rdx;
  unsigned long rax;
  unsigned long rcx;
  unsigned long rsp;
  unsigned long rip;
  unsigned long eflags;
  unsigned short cs;
  unsigned short gs;
  unsigned short fs;
  unsigned short __pad0;
  unsigned long err;
  unsigned long trapno;
  unsigned long oldmask;
  unsigned long cr2;
  struct _fpstate * fpstate;
  unsigned long __reserved1 [8];
};

#endif
#endif
/* Restore the state saved in SCP.  */
extern int sigreturn (struct sigcontext *__scp) __attribute__((__nothrow__));

#endif
#if 1
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif
/* If INTERRUPT is nonzero, make signal SIG interrupt system calls
   (causing them to fail with EINTR); if INTERRUPT is zero, make system
   calls be restarted after signal SIG.  */
extern int siginterrupt (int __sig, int __interrupt) __attribute__((__nothrow__));

##including bits/sigstack.h
/* sigstack, sigaltstack definitions.
   Copyright (C) 1998, 1999 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Structure describing a signal stack (obsolete).  */
struct sigstack
  {
    void *ss_sp;		/* Signal stack pointer.  */
    int ss_onstack;		/* Nonzero if executing on this stack.  */
  };


/* Possible values for `ss_flags.'.  */
enum
{
  SS_ONSTACK = 1,
SS_DISABLE
};

/* Minimum stack size for a signal handler.  */
/* System default stack size.  */
/* Alternate, preferred interface.  */
typedef struct sigaltstack
  {
    void *ss_sp;
    int ss_flags;
    size_t ss_size;
  } stack_t;
#if 1
/* This will define `ucontext_t' and `mcontext_t'.  */
##including sys/ucontext.h
/* Copyright (C) 2001, 2002 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including signal.h
/* Copyright (C) 1991-2004, 2007, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.14 Signal handling <signal.h>
 */

#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
/* We need the signal context definitions even if they are not used
   included in <signal.h>.  */
##including bits/sigcontext.h
#if 1
/* Type for general register.  */
typedef long int greg_t;

/* Number of general registers.  */
/* Container for all general registers.  */
typedef greg_t gregset_t[23];

#endif
struct _libc_fpxreg
{
  unsigned short int significand[4];
  unsigned short int exponent;
  unsigned short int padding[3];
};

struct _libc_xmmreg
{
  __uint32_t	element[4];
};

struct _libc_fpstate
{
  /* 64-bit FXSAVE format.  */
  __uint16_t		cwd;
  __uint16_t		swd;
  __uint16_t		ftw;
  __uint16_t		fop;
  __uint64_t		rip;
  __uint64_t		rdp;
  __uint32_t		mxcsr;
  __uint32_t		mxcr_mask;
  struct _libc_fpxreg	_st[8];
  struct _libc_xmmreg	_xmm[16];
  __uint32_t		padding[24];
};

/* Structure to describe FPU registers.  */
typedef struct _libc_fpstate *fpregset_t;

/* Context to describe whole processor state.  */
typedef struct
  {
    gregset_t gregs;
    /* Note that fpregs is a pointer.  */
    fpregset_t fpregs;
    unsigned long __reserved1 [8];
} mcontext_t;

/* Userlevel context.  */
typedef struct ucontext
  {
    unsigned long int uc_flags;
    struct ucontext *uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    __sigset_t uc_sigmask;
    struct _libc_fpstate __fpregs_mem;
  } ucontext_t;

#endif
#endif
#endif
/* Run signals handlers on the stack specified by SS (if not NULL).
   If OSS is not NULL, it is filled in with the old signal stack status.
   This interface is obsolete and on many platform not implemented.  */
extern int sigstack (struct sigstack *__ss, struct sigstack *__oss)
     __attribute__((__nothrow__)) __attribute__((__deprecated__));

/* Alternate signal handler stack interface.
   This interface should always be preferred over `sigstack'.  */
extern int sigaltstack (const struct sigaltstack *__restrict __ss,
			struct sigaltstack *__restrict __oss) __attribute__((__nothrow__));

#endif
#endif
#if 1
/* Some of the functions for handling signals in threaded programs must
   be defined here.  */
##including bits/pthreadtypes.h
##including bits/sigthread.h
/* Signal handling function for threaded programs.
   Copyright (C) 1998, 1999, 2000, 2002, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If not,
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

#if 1
#endif
/* Functions for handling signals. */

/* Modify the signal mask for the calling thread.  The arguments have
   the same meaning as for sigprocmask(2). */
extern int pthread_sigmask (int __how,
			    const __sigset_t *__restrict __newmask,
			    __sigset_t *__restrict __oldmask)__attribute__((__nothrow__));

/* Send signal SIGNO to the given thread. */
extern int pthread_kill (pthread_t __threadid, int __signo) __attribute__((__nothrow__));

#endif
#endif
#endif
/* The following functions are used internally in the C library and in
   other code which need deep insights.  */

/* Return number of available real-time signal with highest priority.  */
extern int __libc_current_sigrtmin (void) __attribute__((__nothrow__));
/* Return number of available real-time signal with lowest priority.  */
extern int __libc_current_sigrtmax (void) __attribute__((__nothrow__));

#endif


#endif
##including stdint.h
##including stdio.h
/* Define ISO C stdio on top of C++ iostreams.
   Copyright (C) 1991, 1994-2008, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.19 Input/output	<stdio.h>
 */

#if 1
#if 1
##including features.h


##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#endif
#endif
##including bits/types.h
#endif
#if 1
/* Define outside of namespace so the C++ is happy.  */
struct _IO_FILE;


/* The opaque type of streams.  This is the definition used elsewhere.  */
typedef struct _IO_FILE FILE;

#if 1

#endif
#endif
#if 1
/* The opaque type of streams.  This is the definition used elsewhere.  */
typedef struct _IO_FILE __FILE;

#endif
#if 1
##including libio.h
/* Copyright (C) 1991-1995,1997-2006,2007,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Written by Per Bothner <bothner@cygnus.com>.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.

   As a special exception, if you link the code in this file with
   files compiled with a GNU compiler to produce an executable,
   that does not cause the resulting executable to be covered by
   the GNU Lesser General Public License.  This exception does not
   however invalidate any other reasons why the executable file
   might be covered by the GNU Lesser General Public License.
   This exception applies to code released by its copyright holders
   in files containing the exception.  */

#if 1
##including _G_config.h
/* This file is needed by libio to define various configuration parameters.
   These are always the same in the GNU C library.  */

#if 1
/* Define types for libio in terms of the standard internal type names.  */

##including bits/types.h
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#endif
#endif
#endif
##including wchar.h
/* Copyright (C) 1995-2008, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *      ISO C99 Standard: 7.24
 *	Extended multibyte and wide character utilities	<wchar.h>
 */

#if 1
#endif
#endif
#endif
#if 1
/* Conversion state information.  */
typedef struct
{
  int __count;
  union
  {
#if 1
unsignedint __wch;
#endif
char __wchb[4];
  } __value;		/* Value so far.  */
} __mbstate_t;
#endif
/* The rest of the file is only used if used if __need_mbstate_t is not
   defined.  */
#endif
#endif
/* Undefine all __need_* constants in case we are included to get those
   constants but the whole file was already read.  */
typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
#endif
typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));

/* These library features are always available in the GNU C library.  */
/* This is defined by <bits/stat.h> if `st_blksize' exists.  */
/* These are the vtbl details for ELF.  */
#if 1
#endif
#endif
/* ALL of these should be defined in _G_config.h */
#if 1
/* This define avoids name pollution if we're using GNU stdarg.h */
##including stdarg.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2009 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.15  Variable arguments  <stdarg.h>
 */

#if 1
#if 1
#endif
/* Define __gnuc_va_list.  */

#if 1
typedef __builtin_va_list __gnuc_va_list;
#endif
/* Define the standard macros for the user,
   if this invocation was from the user program.  */
#endif
#endif
#endif
#if 1
#endif
#endif
#endif
/* For backward compatibility */
#if 1
#endif
#endif
#endif
#if 1
#endif
#endif
/* Magic numbers and bits for the _flags field.
   The magic numbers use the high-order bits of _flags;
   the remaining bits are available for variable flags.
   Note: The magic numbers must all be negative if stdio
   emulation is desired. */

#endif
#endif
/* These are "formatting flags" matching the iostream fmtflags enum values. */
struct _IO_jump_t;  struct _IO_FILE;

/* Handle lock.  */
#elif 1
typedef void _IO_lock_t;
#endif
/* A streammarker remembers a position in a buffer. */

struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  /* If _pos >= 0
 it points to _buf->Gbase()+_pos. FIXME comment */
  /* if _pos < 0, it points to _buf->eBptr()+_pos. FIXME comment */
  int _pos;
#endif
};

/* This is the structure from the libstdc++ codecvt class.  */
enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};

#endif
struct _IO_FILE {
  int _flags;		/* High-order word is _IO_MAGIC; rest is flags. */
/* The following pointers correspond to the C++ streambuf protocol. */
  /* Note:  Tk uses the _IO_read_ptr and _IO_read_end fields directly. */
  char* _IO_read_ptr;	/* Current read pointer */
  char* _IO_read_end;	/* End of get area. */
  char* _IO_read_base;	/* Start of putback+get area. */
  char* _IO_write_base;	/* Start of put area. */
  char* _IO_write_ptr;	/* Current put pointer. */
  char* _IO_write_end;	/* End of put area. */
  char* _IO_buf_base;	/* Start of reserve area. */
  char* _IO_buf_end;	/* End of reserve area. */
  /* The following fields are used to support backing up and undo. */
  char *_IO_save_base; /* Pointer to start of non-current get area. */
  char *_IO_backup_base;  /* Pointer to first valid character of backup area */
  char *_IO_save_end; /* Pointer to end of non-current get area. */

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;
#elif 1
int _flags2;
#endif
__off_t _old_offset; /* This used to be _offset but it's too small.  */

/* 1+column number of pbase(); 0 is unknown. */
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];

  /*  char* _save_gptr;  char* _save_egptr; */

  _IO_lock_t *_lock;
#endif
#endif
};

#if 1
typedef struct _IO_FILE _IO_FILE;
#endif
struct _IO_FILE_plus;

extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
#if 1
#endif
/* Functions to do I/O and file management for a stream.  */

/* Read NBYTES bytes from COOKIE into a buffer pointed to by BUF.
   Return number of bytes read.  */
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);

/* Write N bytes pointed to by BUF to COOKIE.  Write all N bytes
   unless there is an error.  Return number of bytes written, or -1 if
   there is an error without writing anything.  If the file has been
   opened for append (__mode.__append set), then set the file pointer
   to the end of the file and then do the write; if not, just write at
   the current file pointer.  */
typedef __ssize_t __io_write_fn (void *__cookie, const char *__buf,
				 size_t __n);

/* Move COOKIE's file position to *POS bytes from the
   beginning of the file (if W is SEEK_SET),
   the current position (if W is SEEK_CUR),
   or the end of the file (if W is SEEK_END).
   Set *POS to the new file position.
   Returns zero if successful, nonzero if not.  */
typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);

/* Close COOKIE.  */
typedef int __io_close_fn (void *__cookie);


#endif
#endif
extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);
#endif
#if 1
#endif
#endif
extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__((__nothrow__));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__((__nothrow__));

extern int _IO_peekc_locked (_IO_FILE *__fp);

/* This one is for Emacs. */
extern void _IO_flockfile (_IO_FILE *) __attribute__((__nothrow__));
extern void _IO_funlockfile (_IO_FILE *) __attribute__((__nothrow__));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__((__nothrow__));

#elif 1
#endif
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
			__gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
			 __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);

extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);

extern void _IO_free_backup_area (_IO_FILE *) __attribute__((__nothrow__));

#endif
#endif
#endif
#endif
#if 1
#if 1
#if 1
typedef __gnuc_va_list va_list;
#endif
#endif
#endif
#if 1
#endif
#endif
#endif
#endif
/* The type of the second argument to `fgetpos' and `fsetpos'.  */

#if 1
typedef _G_fpos_t fpos_t;
#endif

#endif
/* The possibilities for the third argument to `setvbuf'.  */
/* Default buffer size.  */
#if 1
#endif
/* End of file character.
   Some things throughout the library rely on this being -1.  */
#endif
/* The possibilities for the third argument to `fseek'.
   These values should not be changed.  */
#if 1
/* Default path prefix for `tempnam' and `tmpnam'.  */
#endif
/* Get the values:
   L_tmpnam	How long an array of chars must be to be passed to `tmpnam'.
   TMP_MAX	The minimum number of unique filenames generated by tmpnam
   		(and tempnam when it uses tmpnam's name space),
		or tempnam (the two are separate).
   L_ctermid	How long an array to pass to `ctermid'.
   L_cuserid	How long an array to pass to `cuserid'.
   FOPEN_MAX	Minimum number of files that can be open at once.
   FILENAME_MAX	Maximum length of a filename.  */
##including bits/stdio_lim.h
/* Copyright (C) 1994, 1997, 1998, 1999, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#if 1
#if 1
#endif
#endif
#endif
#if 1
#endif
#endif
/* Standard streams.  */
extern struct _IO_FILE *stdin;		/* Standard input stream.  */
extern struct _IO_FILE *stdout;		/* Standard output stream.  */
extern struct _IO_FILE *stderr;		/* Standard error output stream.  */
#if 1
/* C89/C99 say they're macros.  Make them happy.  */
#endif

/* Remove file FILENAME.  */
extern int remove (const char *__filename) __attribute__((__nothrow__));
/* Rename file OLD to NEW.  */
extern int rename (const char *__old, const char *__new) __attribute__((__nothrow__));


#if 1
/* Rename file OLD relative to OLDFD to NEW relative to NEWFD.  */
extern int renameat (int __oldfd, const char *__old, int __newfd,
		     const char *__new) __attribute__((__nothrow__));
#endif

/* Create a temporary file and open it read/write.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
#if 1
extern FILE *tmpfile (void) ;
#endif
#endif
/* Generate a temporary filename.  */
extern char *tmpnam (char *__s) __attribute__((__nothrow__)) ;


#if 1
/* This is the reentrant variant of `tmpnam'.  The only difference is
   that it does not allow S to be NULL.  */
extern char *tmpnam_r (char *__s) __attribute__((__nothrow__)) ;
#endif
#if 1
/* Generate a unique temporary filename using up to five characters of PFX
   if it is not NULL.  The directory to put this file in is searched for
   as follows: First the environment variable "TMPDIR" is checked.
   If it contains the name of a writable directory, that directory is used.
   If not and if DIR is not NULL, that value is checked.  If that fails,
   P_tmpdir is tried and finally "/tmp".  The storage for the filename
   is allocated by `malloc'.  */
extern char *tempnam (const char *__dir, const char *__pfx)
     __attribute__((__nothrow__)) __attribute__((__malloc__)) ;
#endif

/* Close STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fclose (FILE *__stream);
/* Flush STREAM, or all streams if STREAM is NULL.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fflush (FILE *__stream);


#if 1
/* Faster versions when locking is not required.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int fflush_unlocked (FILE *__stream);
#endif
#endif

#if 1
/* Open a file and create a new stream for it.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern FILE *fopen (const char *__restrict __filename,
		    const char *__restrict __modes) ;
/* Open a file, replacing an existing stream with it.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern FILE *freopen (const char *__restrict __filename,
		      const char *__restrict __modes,
		      FILE *__restrict __stream) ;
#endif

#endif
#if 1
/* Create a new stream that refers to an existing system file descriptor.  */
extern FILE *fdopen (int __fd, const char *__modes) __attribute__((__nothrow__)) ;
#endif
#endif
#if 1
/* Create a new stream that refers to a memory buffer.  */
extern FILE *fmemopen (void *__s, size_t __len, const char *__modes)
  __attribute__((__nothrow__)) ;

/* Open a stream that writes into a malloc'd buffer that is expanded as
   necessary.  *BUFLOC and *SIZELOC are updated with the buffer's location
   and the number of characters written on fflush or fclose.  */
extern FILE *open_memstream (char **__bufloc, size_t *__sizeloc) __attribute__((__nothrow__)) ;
#endif

/* If BUF is NULL, make STREAM unbuffered.
   Else make it use buffer BUF, of size BUFSIZ.  */
extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__((__nothrow__));
/* Make STREAM use buffering mode MODE.
   If BUF is not NULL, use N bytes of it for buffering;
   else allocate an internal buffer N bytes long.  */
extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
		    int __modes, size_t __n) __attribute__((__nothrow__));


#if 1
/* If BUF is NULL, make STREAM unbuffered.
   Else make it use SIZE bytes of BUF for buffering.  */
extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
		       size_t __size) __attribute__((__nothrow__));

/* Make STREAM line-buffered.  */
extern void setlinebuf (FILE *__stream) __attribute__((__nothrow__));
#endif

/* Write formatted output to STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fprintf (FILE *__restrict __stream,
		    const char *__restrict __format, ...);
/* Write formatted output to stdout.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int printf (const char *__restrict __format, ...);
/* Write formatted output to S.  */
extern int sprintf (char *__restrict __s,
		    const char *__restrict __format, ...) __attribute__((__nothrow__));

/* Write formatted output to S from argument list ARG.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int vfprintf (FILE *__restrict __s, const char *__restrict __format,
		     __gnuc_va_list __arg);
/* Write formatted output to stdout from argument list ARG.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int vprintf (const char *__restrict __format, __gnuc_va_list __arg);
/* Write formatted output to S from argument list ARG.  */
extern int vsprintf (char *__restrict __s, const char *__restrict __format,
		     __gnuc_va_list __arg) __attribute__((__nothrow__));


#if 1

/* Maximum chars of output to write in MAXLEN.  */
extern int snprintf (char *__restrict __s, size_t __maxlen,
		     const char *__restrict __format, ...)
     __attribute__((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 4)));

extern int vsnprintf (char *__restrict __s, size_t __maxlen,
		      const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 0)));

#endif
#endif
#if 1
/* Write formatted output to a file descriptor.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern int vdprintf (int __fd, const char *__restrict __fmt,
		     __gnuc_va_list __arg)
     __attribute__ ((__format__ (__printf__, 2, 0)));
extern int dprintf (int __fd, const char *__restrict __fmt, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));
#endif

/* Read formatted input from STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fscanf (FILE *__restrict __stream,
		   const char *__restrict __format, ...) ;
/* Read formatted input from stdin.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int scanf (const char *__restrict __format, ...) ;
/* Read formatted input from S.  */
extern int sscanf (const char *__restrict __s,
		   const char *__restrict __format, ...) __attribute__((__nothrow__));

#if 1
#if 1
/* For strict ISO C99 or POSIX compliance disallow %as, %aS and %a[
   GNU extension which conflicts with valid %a followed by letter
   s, S or [.  */
extern int fscanf (FILE *__restrict __stream,
				const char *__restrict __format, ...)__asm__("" "__isoc99_fscanf") ;
extern int scanf (const char *__restrict __format, ...)__asm__("" "__isoc99_scanf") ;
extern int sscanf (const char *__restrict __s,
				    const char *__restrict __format, ...)__asm__("" "__isoc99_sscanf") __attribute__((__nothrow__));
#endif
#endif


#if 1

/* Read formatted input from S into argument list ARG.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int vfscanf (FILE *__restrict __s, const char *__restrict __format,
		    __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;

/* Read formatted input from stdin into argument list ARG.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int vscanf (const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;

/* Read formatted input from S into argument list ARG.  */
extern int vsscanf (const char *__restrict __s,
		    const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__((__nothrow__)) __attribute__ ((__format__ (__scanf__, 2, 0)));

#if 1
#if 1
/* For strict ISO C99 or POSIX compliance disallow %as, %aS and %a[
   GNU extension which conflicts with valid %a followed by letter
   s, S or [.  */
extern int vfscanf (FILE *__restrict __s,
			const char *__restrict __format, __gnuc_va_list __arg)__asm__("" "__isoc99_vfscanf")
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (const char *__restrict __format,
				__gnuc_va_list __arg)__asm__("" "__isoc99_vscanf")
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (const char *__restrict __s,
			    const char *__restrict __format,
			    __gnuc_va_list __arg)__asm__("" "__isoc99_vsscanf") __attribute__((__nothrow__))
     __attribute__ ((__format__ (__scanf__, 2, 0)));
#endif
#endif

#endif

/* Read a character from STREAM.

   These functions are possible cancellation points and therefore not
   marked with __THROW.  */
extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);

/* Read a character from stdin.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int getchar (void);


/* The C standard explicitly says this is a macro, so we always do the
   optimization for it.  */
#if 1
/* These are defined in POSIX.1:1996.

   These functions are possible cancellation points and therefore not
   marked with __THROW.  */
extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);
#endif
#if 1
/* Faster version when locking is not necessary.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int fgetc_unlocked (FILE *__stream);
#endif

/* Write a character to STREAM.

   These functions are possible cancellation points and therefore not
   marked with __THROW.

   These functions is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);

/* Write a character to stdout.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int putchar (int __c);


/* The C standard explicitly says this can be a macro,
   so we always do the optimization for it.  */
#if 1
/* Faster version when locking is not necessary.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int fputc_unlocked (int __c, FILE *__stream);
#endif
#if 1
/* These are defined in POSIX.1:1996.

   These functions are possible cancellation points and therefore not
   marked with __THROW.  */
extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);
#endif
#if 1
/* Get a word (int) from STREAM.  */
extern int getw (FILE *__stream);

/* Write a word (int) to STREAM.  */
extern int putw (int __w, FILE *__stream);
#endif

/* Get a newline-terminated string of finite length from STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;

/* Get a newline-terminated string from stdin, removing the newline.
   DO NOT USE THIS FUNCTION!!  There is no limit on how much it will read.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern char *gets (char *__s) ;


#endif
#if 1
/* Read up to (and including) a DELIMITER from STREAM into *LINEPTR
   (and null-terminate it). *LINEPTR is a pointer returned from malloc (or
   NULL), pointing to *N characters of space.  It is realloc'd as
   necessary.  Returns the number of characters read (not including the
   null terminator), or -1 on error or EOF.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern __ssize_t __getdelim (char **__restrict __lineptr,
			       size_t *__restrict __n, int __delimiter,
			       FILE *__restrict __stream) ;
extern __ssize_t getdelim (char **__restrict __lineptr,
			     size_t *__restrict __n, int __delimiter,
			     FILE *__restrict __stream) ;

/* Like `getdelim', but reads up to a newline.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern __ssize_t getline (char **__restrict __lineptr,
			    size_t *__restrict __n,
			    FILE *__restrict __stream) ;
#endif

/* Write a string to STREAM.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern int fputs (const char *__restrict __s, FILE *__restrict __stream);

/* Write a string, followed by a newline, to stdout.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern int puts (const char *__s);


/* Push a character back onto the input buffer of STREAM.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern int ungetc (int __c, FILE *__stream);


/* Read chunks of generic data from STREAM.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern size_t fread (void *__restrict __ptr, size_t __size,
		     size_t __n, FILE *__restrict __stream) ;
/* Write chunks of generic data to STREAM.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern size_t fwrite (const void *__restrict __ptr, size_t __size,
		      size_t __n, FILE *__restrict __s) ;


#endif
#if 1
/* Faster versions when locking is not necessary.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
			      size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (const void *__restrict __ptr, size_t __size,
			       size_t __n, FILE *__restrict __stream) ;
#endif

/* Seek to a certain position on STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fseek (FILE *__stream, long int __off, int __whence);
/* Return the current position of STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern long int ftell (FILE *__stream) ;
/* Rewind to the beginning of STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void rewind (FILE *__stream);


/* The Single Unix Specification, Version 2, specifies an alternative,
   more adequate interface for the two functions above which deal with
   file offset.  `long int' is not the right type.  These definitions
   are originally defined in the Large File Support API.  */

#if 1
#if 1
/* Seek to a certain position on STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fseeko (FILE *__stream, __off_t __off, int __whence);
/* Return the current position of STREAM.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern __off_t ftello (FILE *__stream) ;
#endif
#endif

#if 1
/* Get STREAM's position.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);
/* Set STREAM's position.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int fsetpos (FILE *__stream, const fpos_t *__pos);
#endif


#endif

/* Clear the error and EOF indicators for STREAM.  */
extern void clearerr (FILE *__stream) __attribute__((__nothrow__));
/* Return the EOF indicator for STREAM.  */
extern int feof (FILE *__stream) __attribute__((__nothrow__)) ;
/* Return the error indicator for STREAM.  */
extern int ferror (FILE *__stream) __attribute__((__nothrow__)) ;


#if 1
/* Faster versions when locking is not required.  */
extern void clearerr_unlocked (FILE *__stream) __attribute__((__nothrow__));
extern int feof_unlocked (FILE *__stream) __attribute__((__nothrow__)) ;
extern int ferror_unlocked (FILE *__stream) __attribute__((__nothrow__)) ;
#endif

/* Print a message describing the meaning of the value of errno.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void perror (const char *__s);


/* Provide the declarations for `sys_errlist' and `sys_nerr' if they
   are available on this system.  Even if available, these variables
   should not be used directly.  The `strerror' function provides
   all the necessary functionality.  */
##including bits/sys_errlist.h
/* Declare sys_errlist and sys_nerr, or don't.  Compatibility (do) version.
   Copyright (C) 2002 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* sys_errlist and sys_nerr are deprecated.  Use strerror instead.  */

#if 1
extern int sys_nerr;
extern const char *const sys_errlist[];
#endif
#endif
#if 1
/* Return the system file descriptor for STREAM.  */
extern int fileno (FILE *__stream) __attribute__((__nothrow__)) ;
#endif
#if 1
/* Faster version when locking is not required.  */
extern int fileno_unlocked (FILE *__stream) __attribute__((__nothrow__)) ;
#endif
#if 1
/* Create a new stream connected to a pipe running the given command.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern FILE *popen (const char *__command, const char *__modes) ;

/* Close a stream opened by popen and return the status of its child.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int pclose (FILE *__stream);
#endif
#if 1
/* Return the name of the controlling terminal.  */
extern char *ctermid (char *__s) __attribute__((__nothrow__));
#endif
#endif
#endif
#if 1
/* These are defined in POSIX.1:1996.  */

/* Acquire ownership of STREAM.  */
extern void flockfile (FILE *__stream) __attribute__((__nothrow__));

/* Try to acquire ownership of STREAM but do not block if it is not
   possible.  */
extern int ftrylockfile (FILE *__stream) __attribute__((__nothrow__)) ;

/* Relinquish the ownership granted for STREAM.  */
extern void funlockfile (FILE *__stream) __attribute__((__nothrow__));
#endif
#endif
/* If we are compiling with optimizing read this file.  It contains
   several optimizing inline functions and macros.  */
#endif
#endif
#endif


#endif
#endif
##including stdlib.h
/* Copyright (C) 1991-2007, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.20 General utilities	<stdlib.h>
 */

#if 1
##including features.h
/* Get size_t, wchar_t and NULL from <stddef.h>.  */
#if 1
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
/* On BSD/386 1.1, at least, machine/ansi.h defines _BSD_WCHAR_T_
   instead of _WCHAR_T_, and _BSD_RUNE_T_ (which, unlike the other
   symbols in the _FOO_T_ family, stays defined even after its
   corresponding type is defined).  If we define wchar_t, then we
   must undef _WCHAR_T_; for BSD/386 1.1 (and perhaps others), if
   we undef _WCHAR_T_, then we must also define rune_t, since 
   headers like runetype.h assume that if machine/ansi.h is included,
   and _BSD_WCHAR_T_ is not defined, then rune_t is available.
   machine/ansi.h says, "Note that _WCHAR_T_ and _RUNE_T_ must be of
   the same type." */
#if 1
#endif
#endif
/* FreeBSD 5 can't be handled well using "traditional" logic above
   since it no longer defines _BSD_RUNE_T_ yet still desires to export
   rune_t in some cases... */
#endif
#endif
#if 1
typedef int wchar_t;
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#endif
#endif


#if 1
#if 1
/* XPG requires a few symbols from <sys/wait.h> being defined.  */
##including bits/waitflags.h
/* Definitions of flag bits for `waitpid' et al.
   Copyright (C) 1992,1996,1997,2000,2004,2005 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Bits in the third argument to `waitpid'.  */
/* Bits in the fourth argument to `waitid'.  */
##including bits/waitstatus.h
/* Definitions of status bits for `wait' et al.
   Copyright (C) 1992,1994,1996,1997,2000,2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Everything extant so far uses these same bits.  */


/* If WIFEXITED(STATUS), the low-order 8 bits of the status.  */
/* If WIFSIGNALED(STATUS), the terminating signal.  */
/* If WIFSTOPPED(STATUS), the signal that stopped the child.  */
/* Nonzero if STATUS indicates normal termination.  */
/* Nonzero if STATUS indicates termination by a signal.  */
/* Nonzero if STATUS indicates the child is stopped.  */
/* Nonzero if STATUS indicates the child continued after a stop.  We only
   define this if <bits/waitflags.h> provides the WCONTINUED flag bit.  */
#if 1
#endif
/* Nonzero if STATUS indicates the child dumped core.  */
/* Macros for constructing status values.  */
#if 1
##including endian.h
union wait
  {
    int w_status;
    struct
      {
#endif
#endif
} __wait_terminated;
    struct
      {
#endif
#endif
} __wait_stopped;
  };

#endif
#if 1
/* Lots of hair to allow traditional BSD use of `union wait'
   as well as POSIX.1 use of `int' for the status word.  */

#if 1
#endif
/* This is the type of the argument to `wait'.  The funky union
   causes redeclarations with either `int *' or `union wait *' to be
   allowed without complaint.  __WAIT_STATUS_DEFN is the type used in
   the actual function definitions.  */

#elif 1
/* This works in GCC 2.6.1 and later.  */
typedef union
  {
    union wait *__uptr;
    int *__iptr;
  } __WAIT_STATUS __attribute__ ((__transparent_union__));
#endif
#endif
/* Define the macros <sys/wait.h> also would define this way.  */
#if 1
#endif
#endif

/* Returned by `div'.  */
typedef struct
  {
    int quot;			/* Quotient.  */
    int rem;			/* Remainder.  */
  } div_t;

/* Returned by `ldiv'.  */
#if 1
typedef struct
  {
    long int quot;		/* Quotient.  */
    long int rem;		/* Remainder.  */
  } ldiv_t;
#endif


#if 1

/* Returned by `lldiv'.  */
__extension__ typedef struct
  {
    long long int quot;		/* Quotient.  */
    long long int rem;		/* Remainder.  */
  } lldiv_t;

#endif
/* The largest number rand will return (same as INT_MAX).  */
/* We define these the same for all machines.
   Changes from this to the outside world should be done in `_exit'.  */
/* Maximum length of a multibyte character in the current locale.  */
extern size_t __ctype_get_mb_cur_max (void) __attribute__((__nothrow__)) ;



/* Convert a string to a floating-point number.  */
extern double atof (const char *__nptr)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1))) ;
/* Convert a string to an integer.  */
extern int atoi (const char *__nptr)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1))) ;
/* Convert a string to a long integer.  */
extern long int atol (const char *__nptr)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1))) ;


#if 1

/* Convert a string to a long long integer.  */
__extension__ extern long long int atoll (const char *__nptr)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1))) ;

#endif

/* Convert a string to a floating-point number.  */
extern double strtod (const char *__restrict __nptr,
		      char **__restrict __endptr)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;


#if 1

/* Likewise for `float' and `long double' sizes of floating-point numbers.  */
extern float strtof (const char *__restrict __nptr,
		     char **__restrict __endptr) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

extern long double strtold (const char *__restrict __nptr,
			    char **__restrict __endptr)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

#endif

/* Convert a string to a long integer.  */
extern long int strtol (const char *__restrict __nptr,
			char **__restrict __endptr, int __base)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
/* Convert a string to an unsigned long integer.  */
extern unsigned long int strtoul (const char *__restrict __nptr,
				  char **__restrict __endptr, int __base)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;


#if 1
/* Convert a string to a quadword integer.  */
__extension__
extern long long int strtoq (const char *__restrict __nptr,
			     char **__restrict __endptr, int __base)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
/* Convert a string to an unsigned quadword integer.  */
__extension__
extern unsigned long long int strtouq (const char *__restrict __nptr,
				       char **__restrict __endptr, int __base)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
#endif
#if 1

/* Convert a string to a quadword integer.  */
__extension__
extern long long int strtoll (const char *__restrict __nptr,
			      char **__restrict __endptr, int __base)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
/* Convert a string to an unsigned quadword integer.  */
__extension__
extern unsigned long long int strtoull (const char *__restrict __nptr,
					char **__restrict __endptr, int __base)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

#endif
#endif
#endif
#if 1
/* Convert N to base 64 using the digits "./0-9A-Za-z", least-significant
   digit first.  Returns a pointer to static storage overwritten by the
   next call.  */
extern char *l64a (long int __n) __attribute__((__nothrow__)) ;

/* Read a number from a string S in base 64 as above.  */
extern long int a64l (const char *__s)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1))) ;

#endif
#if 1
##including sys/types.h
/* These are the functions that actually do things.  The `random', `srandom',
   `initstate' and `setstate' functions are those from BSD Unices.
   The `rand' and `srand' functions are required by the ANSI standard.
   We provide both interfaces to the same random number generator.  */
/* Return a random long integer between 0 and RAND_MAX inclusive.  */
extern long int random (void) __attribute__((__nothrow__));

/* Seed the random number generator with the given number.  */
extern void srandom (unsigned int __seed) __attribute__((__nothrow__));

/* Initialize the random number generator to use state buffer STATEBUF,
   of length STATELEN, and seed it with SEED.  Optimal lengths are 8, 16,
   32, 64, 128 and 256, the bigger the better; values less than 8 will
   cause an error and values greater than 256 will be rounded down.  */
extern char *initstate (unsigned int __seed, char *__statebuf,
			size_t __statelen) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));

/* Switch the random number generator to state buffer STATEBUF,
   which should have been previously initialized by `initstate'.  */
extern char *setstate (char *__statebuf) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));


#if 1
/* Reentrant versions of the `random' family of functions.
   These functions all use the following data structure to contain
   state, rather than global state variables.  */

struct random_data
  {
    int32_t *fptr;		/* Front pointer.  */
    int32_t *rptr;		/* Rear pointer.  */
    int32_t *state;		/* Array of state values.  */
    int rand_type;		/* Type of random number generator.  */
    int rand_deg;		/* Degree of random number generator.  */
    int rand_sep;		/* Distance between front and rear.  */
    int32_t *end_ptr;		/* Pointer behind state table.  */
  };

extern int random_r (struct random_data *__restrict __buf,
		     int32_t *__restrict __result) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

extern int srandom_r (unsigned int __seed, struct random_data *__buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
			size_t __statelen,
			struct random_data *__restrict __buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 4)));

extern int setstate_r (char *__restrict __statebuf,
		       struct random_data *__restrict __buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif

/* Return a random integer between 0 and RAND_MAX inclusive.  */
extern int rand (void) __attribute__((__nothrow__));
/* Seed the random number generator with the given number.  */
extern void srand (unsigned int __seed) __attribute__((__nothrow__));


#if 1
/* Reentrant interface according to POSIX.1.  */
extern int rand_r (unsigned int *__seed) __attribute__((__nothrow__));
#endif
#if 1
/* System V style 48-bit random number generator functions.  */

/* Return non-negative, double-precision floating-point value in [0.0,1.0).  */
extern double drand48 (void) __attribute__((__nothrow__));
extern double erand48 (unsigned short int __xsubi[3]) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Return non-negative, long integer in [0,2^31).  */
extern long int lrand48 (void) __attribute__((__nothrow__));
extern long int nrand48 (unsigned short int __xsubi[3])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Return signed, long integers in [-2^31,2^31).  */
extern long int mrand48 (void) __attribute__((__nothrow__));
extern long int jrand48 (unsigned short int __xsubi[3])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Seed random number generator.  */
extern void srand48 (long int __seedval) __attribute__((__nothrow__));
extern unsigned short int *seed48 (unsigned short int __seed16v[3])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
extern void lcong48 (unsigned short int __param[7]) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Data structure for communication with thread safe versions.  This
   type is to be regarded as opaque.  It's only exported because users
   have to allocate objects of this type.  */
struct drand48_data
  {
    unsigned short int __x[3];	/* Current state.  */
    unsigned short int __old_x[3]; /* Old state.  */
    unsigned short int __c;	/* Additive const. in congruential formula.  */
    unsigned short int __init;	/* Flag for initializing.  */
    unsigned long long int __a;	/* Factor in congruential formula.  */
  };

/* Return non-negative, double-precision floating-point value in [0.0,1.0).  */
extern int drand48_r (struct drand48_data *__restrict __buffer,
		      double *__restrict __result) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
extern int erand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      double *__restrict __result) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Return non-negative, long integer in [0,2^31).  */
extern int lrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
extern int nrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Return signed, long integers in [-2^31,2^31).  */
extern int mrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
extern int jrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Seed random number generator.  */
extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));

extern int seed48_r (unsigned short int __seed16v[3],
		     struct drand48_data *__buffer) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

extern int lcong48_r (unsigned short int __param[7],
		      struct drand48_data *__buffer)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif
#endif
#if 1

/* Allocate SIZE bytes of memory.  */
extern void *malloc (size_t __size) __attribute__((__nothrow__)) __attribute__((__malloc__)) ;
/* Allocate NMEMB elements of SIZE bytes each, all initialized to 0.  */
extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__((__nothrow__)) __attribute__((__malloc__)) ;

#endif
#if 1

/* Re-allocate the previously allocated block
   in PTR, making the new block SIZE bytes long.  */
/* __attribute_malloc__ is not used, because if realloc returns
   the same pointer that was passed to it, aliasing needs to be allowed
   between objects pointed by the old and new pointers.  */
extern void *realloc (void *__ptr, size_t __size)
     __attribute__((__nothrow__)) __attribute__((__warn_unused_result__));
/* Free a block allocated by `malloc', `realloc' or `calloc'.  */
extern void free (void *__ptr) __attribute__((__nothrow__));


#if 1
/* Free a block.  An alias for `free'.	(Sun Unices).  */
extern void cfree (void *__ptr) __attribute__((__nothrow__));
#endif
#if 1
##including alloca.h
/* Copyright (C) 1992, 1996, 1997, 1998, 1999 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#endif
#endif
#endif


/* Remove any previous definitions.  */
/* Allocate a block that will be freed when the calling function exits.  */
extern void *alloca (size_t __size) __attribute__((__nothrow__));

#if 1
#endif


#endif
#endif
#if 1
/* Allocate SIZE bytes on a page boundary.  The storage cannot be freed.  */
extern void *valloc (size_t __size) __attribute__((__nothrow__)) __attribute__((__malloc__)) ;
#endif
#if 1
/* Allocate memory of SIZE bytes with an alignment of ALIGNMENT.  */
extern int posix_memalign (void **__memptr, size_t __alignment, size_t __size)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
#endif

/* Abort execution and generate a core-dump.  */
extern void abort (void) __attribute__((__nothrow__)) __attribute__ ((__noreturn__));


/* Register a function to be called when `exit' is called.  */
extern int atexit (void (*__func) (void)) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#endif


#if 1
/* Register a function to be called with the status
   given to `exit' and the given argument.  */
extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif

/* Call all functions registered with `atexit' and `on_exit',
   in the reverse of the order in which they were registered,
   perform stdio cleanup, and terminate program execution with STATUS.  */
extern void exit (int __status) __attribute__((__nothrow__)) __attribute__ ((__noreturn__));

#endif


#if 1

/* Terminate the program with STATUS without calling any of the
   functions registered with `atexit' or `on_exit'.  */
extern void _Exit (int __status) __attribute__((__nothrow__)) __attribute__ ((__noreturn__));

#endif

/* Return the value of envariable NAME, or NULL if it doesn't exist.  */
extern char *getenv (const char *__name) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;


/* This function is similar to the above but returns NULL if the
   programs is running with SUID or SGID enabled.  */
extern char *__secure_getenv (const char *__name)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

#if 1
/* The SVID says this is in <stdio.h>, but this seems a better place.	*/
/* Put STRING, which is of the form "NAME=VALUE", in the environment.
   If there is no `=', remove NAME from the environment.  */
extern int putenv (char *__string) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* Set NAME to VALUE in the environment.
   If REPLACE is nonzero, overwrite an existing value.  */
extern int setenv (const char *__name, const char *__value, int __replace)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));

/* Remove the variable NAME from the environment.  */
extern int unsetenv (const char *__name) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* The `clearenv' was planned to be added to POSIX.1 but probably
   never made it.  Nevertheless the POSIX.9 standard (POSIX bindings
   for Fortran 77) requires this function.  */
extern int clearenv (void) __attribute__((__nothrow__));
#endif
#if 1
/* Generate a unique temporary file name from TEMPLATE.
   The last six characters of TEMPLATE must be "XXXXXX";
   they are replaced with a string that makes the file name unique.
   Returns TEMPLATE, or a null pointer if it cannot get a unique file name.  */
extern char *mktemp (char *__template) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
#endif
#if 1
/* Generate a unique temporary file name from TEMPLATE.
   The last six characters of TEMPLATE must be "XXXXXX";
   they are replaced with a string that makes the filename unique.
   Returns a file descriptor open on the file for reading and writing,
   or -1 if it cannot create a uniquely-named file.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
#if 1
extern int mkstemp (char *__template) __attribute__((__nonnull__ (1))) ;
#endif
#endif
#endif
#if 1
/* Similar to mkstemp, but the template can have a suffix after the
   XXXXXX.  The length of the suffix is specified in the second
   parameter.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
#if 1
extern int mkstemps (char *__template, int __suffixlen) __attribute__((__nonnull__ (1))) ;
#endif
#endif
#endif
#if 1
/* Create a unique temporary directory from TEMPLATE.
   The last six characters of TEMPLATE must be "XXXXXX";
   they are replaced with a string that makes the directory name unique.
   Returns TEMPLATE, or a null pointer if it cannot get a unique name.
   The directory is created mode 700.  */
extern char *mkdtemp (char *__template) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
#endif
#endif

/* Execute the given line as a shell command.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int system (const char *__command) ;



#endif
#if 1
/* Return the canonical absolute name of file NAME.  If RESOLVED is
   null, the result is malloc'd; otherwise, if the canonical name is
   PATH_MAX chars or more, returns null with `errno' set to
   ENAMETOOLONG; if the name fits in fewer than PATH_MAX chars,
   returns the name in RESOLVED.  */
extern char *realpath (const char *__restrict __name,
		       char *__restrict __resolved) __attribute__((__nothrow__)) ;
#endif
/* Shorthand for type of comparison functions.  */
#if 1
typedef int (*__compar_fn_t) (const void *, const void *);

#endif
#endif
#endif

/* Do a binary search for KEY in BASE, which consists of NMEMB elements
   of SIZE bytes each, using COMPAR to perform the comparisons.  */
extern void *bsearch (const void *__key, const void *__base,
		      size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__((__nonnull__ (1, 2, 5))) ;

/* Sort NMEMB elements of BASE, of SIZE bytes each,
   using COMPAR to perform the comparisons.  */
extern void qsort (void *__base, size_t __nmemb, size_t __size,
		   __compar_fn_t __compar) __attribute__((__nonnull__ (1, 4)));
#endif
/* Return the absolute value of X.  */
extern int abs (int __x) __attribute__((__nothrow__)) __attribute__ ((__const__)) ;
extern long int labs (long int __x) __attribute__((__nothrow__)) __attribute__ ((__const__)) ;


#if 1
__extension__ extern long long int llabs (long long int __x)
     __attribute__((__nothrow__)) __attribute__ ((__const__)) ;
#endif

/* Return the `div_t', `ldiv_t' or `lldiv_t' representation
   of the value of NUMER over DENOM. */
/* GCC may have built-ins for these someday.  */
extern div_t div (int __numer, int __denom)
     __attribute__((__nothrow__)) __attribute__ ((__const__)) ;
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__((__nothrow__)) __attribute__ ((__const__)) ;


#if 1

__extension__ extern lldiv_t lldiv (long long int __numer,
				    long long int __denom)
     __attribute__((__nothrow__)) __attribute__ ((__const__)) ;

#endif
#if 1
/* Convert floating point numbers to strings.  The returned values are
   valid only until another call to the same function.  */

/* Convert VALUE to a string with NDIGIT digits and return a pointer to
   this.  Set *DECPT with the position of the decimal character and *SIGN
   with the sign of the number.  */
extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign) __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4))) ;

/* Convert VALUE to a string rounded to NDIGIT decimal digits.  Set *DECPT
   with the position of the decimal character and *SIGN with the sign of
   the number.  */
extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign) __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4))) ;

/* If possible convert VALUE to a string with NDIGIT significant digits.
   Otherwise use exponential representation.  The resulting string will
   be written to BUF.  */
extern char *gcvt (double __value, int __ndigit, char *__buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3))) ;


#if 1
/* Long double versions of above functions.  */
extern char *qecvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4))) ;
extern char *qfcvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4))) ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3))) ;


/* Reentrant version of the functions above which provide their own
   buffers.  */
extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len) __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4, 5)));
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len) __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4, 5)));

extern int qecvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4, 5)));
extern int qfcvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4, 5)));
#endif
#endif

/* Return the length of the multibyte character
   in S, which is no longer than N.  */
extern int mblen (const char *__s, size_t __n) __attribute__((__nothrow__)) ;
/* Return the length of the given multibyte character,
   putting its `wchar_t' representation in *PWC.  */
extern int mbtowc (wchar_t *__restrict __pwc,
		   const char *__restrict __s, size_t __n) __attribute__((__nothrow__)) ;
/* Put the multibyte character represented
   by WCHAR in S, returning its length.  */
extern int wctomb (char *__s, wchar_t __wchar) __attribute__((__nothrow__)) ;


/* Convert a multibyte string to a wide char string.  */
extern size_t mbstowcs (wchar_t *__restrict  __pwcs,
			const char *__restrict __s, size_t __n) __attribute__((__nothrow__));
/* Convert a wide char string to multibyte string.  */
extern size_t wcstombs (char *__restrict __s,
			const wchar_t *__restrict __pwcs, size_t __n)
     __attribute__((__nothrow__));



#if 1
/* Determine whether the string value of RESPONSE matches the affirmation
   or negative response expression as specified by the LC_MESSAGES category
   in the program's current locale.  Returns 1 if affirmative, 0 if
   negative, and -1 if not matching.  */
extern int rpmatch (const char *__response) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
#endif
#if 1
/* Parse comma separated suboption from *OPTIONP and match against
   strings in TOKENS.  If found return index and set *VALUEP to
   optional value introduced by an equal sign.  If the suboption is
   not part of TOKENS return in *VALUEP beginning of unknown
   suboption.  On exit *OPTIONP is set to the beginning of the next
   token or at the terminating NUL character.  */
extern int getsubopt (char **__restrict __optionp,
		      char *const *__restrict __tokens,
		      char **__restrict __valuep)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2, 3))) ;
#endif
#endif
/* X/Open pseudo terminal handling.  */

#endif
#endif
#endif
#if 1
/* Put the 1 minute, 5 minute and 15 minute load averages into the first
   NELEM elements of LOADAVG.  Return the number written (never more than
   three, but may be less than NELEM), or -1 if an error occurred.  */
extern int getloadavg (double __loadavg[], int __nelem)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
/* Define some macros helping to catch buffer overflows.  */
#endif
#endif
#endif


#endif
##including stdarg.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2009 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.15  Variable arguments  <stdarg.h>
 */

#if 1
#if 1
#if 1
#endif
/* Define __gnuc_va_list.  */

#endif
/* Define the standard macros for the user,
   if this invocation was from the user program.  */
#if 1
#if 1
#endif
/* Define va_list, if desired, from __gnuc_va_list. */
/* We deliberately do not define va_list when called from
   stdio.h, because ANSI C says that stdio.h is not supposed to define
   va_list.  stdio.h needs to have access to that data type, 
   but must not use that name.  It should use the name __gnuc_va_list,
   which is safe because it is reserved for the implementation.  */

#endif
#endif
#elif 1
/* The macro _VA_LIST_ is the same thing used by this file in Ultrix.
   But on BSD NET2 we must not test or define or undef it.
   (Note that the comments in NET 2's ansi.h
   are incorrect for _VA_LIST_--see stdio.h!)  */
#if 1
/* The macro _VA_LIST_DEFINED is used in Windows NT 3.5  */
#endif
#if 1
#endif
#if 1
#endif
#endif
#if 1
#endif
#if 1
#endif
#endif
#endif
#endif
#endif
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#if 1
/* snaroff@next.com says the NeXT needs this.  */
/* Irix 5.1 needs this.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#if 1
#endif
typedef longint ptrdiff_t;
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
##including string.h
/* Copyright (C) 1991-1993,1995-2004,2007,2009,2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.21 String handling	<string.h>
 */

#if 1
##including features.h


/* Get size_t and NULL from <stddef.h>.  */
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
/* Tell the caller that we provide correct C++ prototypes.  */
#endif

/* Copy N bytes of SRC to DEST.  */
extern void *memcpy (void *__restrict __dest,
		     const void *__restrict __src, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
/* Copy N bytes of SRC to DEST, guaranteeing
   correct behavior for overlapping strings.  */
extern void *memmove (void *__dest, const void *__src, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));


/* Copy no more than N bytes of SRC to DEST, stopping when C is found.
   Return the position in DEST one byte past where C was copied,
   or NULL if C was not found in the first N bytes of SRC.  */
#if 1
extern void *memccpy (void *__restrict __dest, const void *__restrict __src,
		      int __c, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif

/* Set N bytes of S to C.  */
extern void *memset (void *__s, int __c, size_t __n) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Compare N bytes of S1 and S2.  */
extern int memcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));

/* Search N bytes of S for C.  */
#elif 1
extern void *memchr (const void *__s, int __c, size_t __n)
      __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));
#endif


#endif

/* Copy SRC to DEST.  */
extern char *strcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
/* Copy no more than N characters of SRC to DEST.  */
extern char *strncpy (char *__restrict __dest,
		      const char *__restrict __src, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Append SRC onto DEST.  */
extern char *strcat (char *__restrict __dest, const char *__restrict __src)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
/* Append no more than N characters from SRC onto DEST.  */
extern char *strncat (char *__restrict __dest, const char *__restrict __src,
		      size_t __n) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Compare S1 and S2.  */
extern int strcmp (const char *__s1, const char *__s2)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
/* Compare N characters of S1 and S2.  */
extern int strncmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));

/* Compare the collated forms of S1 and S2.  */
extern int strcoll (const char *__s1, const char *__s2)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
/* Put a transformation of SRC into no more than N bytes of DEST.  */
extern size_t strxfrm (char *__restrict __dest,
		       const char *__restrict __src, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));


#if 1
/* The following functions are equivalent to the both above but they
   take the locale they use for the collation as an extra argument.
   This is not standardsized but something like will come.  */
##including xlocale.h
/* Compare the collated forms of S1 and S2 using rules from L.  */
extern int strcoll_l (const char *__s1, const char *__s2, __locale_t __l)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2, 3)));
/* Put a transformation of SRC into no more than N bytes of DEST.  */
extern size_t strxfrm_l (char *__dest, const char *__src, size_t __n,
			 __locale_t __l) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 4)));
#endif
#if 1
/* Duplicate S, returning an identical malloc'd string.  */
extern char *strdup (const char *__s)
     __attribute__((__nothrow__)) __attribute__((__malloc__)) __attribute__((__nonnull__ (1)));
#endif
/* Return a malloc'd copy of at most N bytes of STRING.  The
   resultant string is terminated even if no null terminator
   appears before STRING[N].  */
#if 1
extern char *strndup (const char *__string, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__malloc__)) __attribute__((__nonnull__ (1)));
#endif
#endif

/* Find the first occurrence of C in S.  */
#elif 1
extern char *strchr (const char *__s, int __c)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));
#endif
/* Find the last occurrence of C in S.  */
#elif 1
extern char *strrchr (const char *__s, int __c)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));
#endif


#endif

/* Return the length of the initial segment of S which
   consists entirely of characters not in REJECT.  */
extern size_t strcspn (const char *__s, const char *__reject)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
/* Return the length of the initial segment of S which
   consists entirely of characters in ACCEPT.  */
extern size_t strspn (const char *__s, const char *__accept)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
/* Find the first occurrence in S of any character in ACCEPT.  */
#elif 1
extern char *strpbrk (const char *__s, const char *__accept)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
#endif
/* Find the first occurrence of NEEDLE in HAYSTACK.  */
#elif 1
extern char *strstr (const char *__haystack, const char *__needle)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
#endif
/* Divide S into tokens separated by characters in DELIM.  */
extern char *strtok (char *__restrict __s, const char *__restrict __delim)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));


/* Divide S into tokens separated by characters in DELIM.  Information
   passed between calls are stored in SAVE_PTR.  */
extern char *__strtok_r (char *__restrict __s,
			 const char *__restrict __delim,
			 char **__restrict __save_ptr)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 3)));
#if 1
extern char *strtok_r (char *__restrict __s, const char *__restrict __delim,
		       char **__restrict __save_ptr)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 3)));
#endif
#endif
#endif

/* Return the length of S.  */
extern size_t strlen (const char *__s)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));


#if 1
/* Find the length of STRING, but scan at most MAXLEN characters.
   If no '\0' terminator is found in that many characters, return MAXLEN.  */
extern size_t strnlen (const char *__string, size_t __maxlen)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));
#endif

/* Return a string describing the meaning of the `errno' code in ERRNUM.  */
extern char *strerror (int __errnum) __attribute__((__nothrow__));

#if 1
/* Reentrant version of `strerror'.
   There are 2 flavors of `strerror_r', GNU which returns the string
   and may or may not use the supplied temporary buffer and POSIX one
   which fills the string into the buffer.
   To use the POSIX version, -D_XOPEN_SOURCE=600 or -D_POSIX_C_SOURCE=200112L
   without -D_GNU_SOURCE is needed, otherwise the GNU version is
   preferred.  */
#if 1
/* Fill BUF with a string describing the meaning of the `errno' code in
   ERRNUM.  */
#if 1
extern int strerror_r (int __errnum, char *__buf, size_t __buflen)__asm__("" "__xpg_strerror_r") __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
#endif
#endif
#if 1
/* Translate error number to string according to the locale L.  */
extern char *strerror_l (int __errnum, __locale_t __l) __attribute__((__nothrow__));
#endif
/* We define this function always since `bzero' is sometimes needed when
   the namespace rules does not allow this.  */
extern void __bzero (void *__s, size_t __n) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Copy N bytes of SRC to DEST (like memmove, but args reversed).  */
extern void bcopy (const void *__src, void *__dest, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Set N bytes of S to 0.  */
extern void bzero (void *__s, size_t __n) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Compare N bytes of S1 and S2 (same as memcmp).  */
extern int bcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));

/* Find the first occurrence of C in S (same as strchr).  */
#elif 1
extern char *index (const char *__s, int __c)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));
#endif
/* Find the last occurrence of C in S (same as strrchr).  */
#elif 1
extern char *rindex (const char *__s, int __c)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1)));
#endif
/* Return the position of the first bit set in I, or 0 if none are set.
   The least-significant bit is position 1, the most-significant 32.  */
extern int ffs (int __i) __attribute__((__nothrow__)) __attribute__ ((__const__));

/* The following two functions are non-standard but necessary for non-32 bit
   platforms.  */
#endif
/* Compare S1 and S2, ignoring case.  */
extern int strcasecmp (const char *__s1, const char *__s2)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));

/* Compare no more than N chars of S1 and S2, ignoring case.  */
extern int strncasecmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__pure__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif
#if 1
/* Return the next DELIM-delimited token from *STRINGP,
   terminating it with a '\0', and update *STRINGP to point past it.  */
extern char *strsep (char **__restrict __stringp,
		     const char *__restrict __delim)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif
#if 1
/* Return a string describing the meaning of the signal number in SIG.  */
extern char *strsignal (int __sig) __attribute__((__nothrow__));

/* Copy SRC to DEST, returning the address of the terminating '\0' in DEST.  */
extern char *__stpcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
extern char *stpcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Copy no more than N characters of SRC to DEST, returning the address of
   the last character written into DEST.  */
extern char *__stpncpy (char *__restrict __dest,
			const char *__restrict __src, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
extern char *stpncpy (char *__restrict __dest,
		      const char *__restrict __src, size_t __n)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif
#if 1
#endif
#endif
#endif


#endif
##including sys/poll.h
/* Compatibility definitions for System V `poll' interface.
   Copyright (C) 1994,1996-2001,2004,2005,2006 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
/* Get the platform dependent bits of `poll'.  */
##including bits/poll.h
/* Copyright (C) 1997, 2001, 2006, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Event types that can be polled for.  These bits may be set in `events'
   to indicate the interesting event types; they will appear in `revents'
   to indicate the status of the file descriptor.  */
#if 1
/* These values are defined in XPG4.2.  */
#endif
#endif
/* Event types always implicitly polled for.  These bits need not be set in
   `events', but they will appear in `revents' to indicate the status of
   the file descriptor.  */
#endif
/* Type used for the number of file descriptors.  */
typedef unsigned long int nfds_t;

/* Data structure describing a polling request.  */
struct pollfd
  {
    int fd;			/* File descriptor to poll.  */
    short int events;		/* Types of events poller cares about.  */
    short int revents;		/* Types of events that actually occurred.  */
  };




/* Poll the file descriptors described by the NFDS structures starting at
   FDS.  If TIMEOUT is nonzero and not -1, allow TIMEOUT milliseconds for
   an event to occur; if TIMEOUT is -1, block until an event occurs.
   Returns the number of file descriptors with events, zero if timed out,
   or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int poll (struct pollfd *__fds, nfds_t __nfds, int __timeout);

#endif


#endif
##including sys/ioctl.h
/* Copyright (C) 1991, 92, 93, 94, 96, 98, 99 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h


/* Get the list of `ioctl' requests and related constants.  */
##including bits/ioctls.h
/* Copyright (C) 1996, 1997, 1998, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Use the definitions from the kernel header files.  */
##including asm/ioctls.h
##including asm-generic/ioctls.h
#if 1
##including linux/ioctl.h
#if 1
##including asm/ioctl.h
##including asm-generic/ioctl.h
#if 1
/* ioctl command encoding: 32 bits total, command in lower 16 bits,
 * size of the parameter structure in the lower 14 bits of the
 * upper 16 bits.
 * Encoding the size of the parameter structure in the ioctl request
 * is useful for catching programs compiled with old versions
 * and to avoid overwriting user space outside the user buffer area.
 * The highest 2 bits are reserved for indicating the ``access mode''.
 * NOTE: This limits the max parameter size to 16kB -1 !
 */

/*
 * The following is for compatibility across the various Linux
 * platforms.  The generic ioctl numbering scheme doesn't really enforce
 * a type field.  De facto, however, the top 8 bits of the lower 16
 * bits are indeed used as a type field, so we might just as well make
 * this explicit here.  Please be sure to use the decoding macros
 * below from now on.
 */
/*
 * Let any architecture override either of the following before
 * including this file.
 */

#if 1
#endif
#if 1
#endif
/*
 * Direction bits, which any architecture can choose to override
 * before including this file.
 */

#if 1
#endif
#if 1
#endif
#if 1
#endif
/* used to create numbers */
/* used to decode ioctl numbers.. */
/* ...and for the drivers/sound files... */

#endif
#endif
/*
 * These are the most common definitions for tty ioctl numbers.
 * Most of them do not use the recommended _IOC(), but there is
 * probably some source code out there hardcoding the number,
 * so we might as well use them for all new platforms.
 *
 * The architectures that use different values here typically
 * try to be compatible with some Unix variants for the same
 * architecture.
 */

/* 0x54 is just a magic number to make these relatively unique ('T') */

/*
 * some architectures define FIOQSIZE as 0x545E, which is used for
 * TIOCGHAYESESP on others
 */
#if 1
#endif
/* Used for packet mode */
#endif
/* Routing table calls.  */
/* Socket configuration controls. */
/* ARP cache control calls. */
		    /*  0x8950 - 0x8952  * obsolete calls, don't re-use */
/* RARP cache control calls. */
/* Driver configuration calls */

/* DLCI configuration calls */

/* Device private ioctl calls.  */

/* These 16 ioctls are available to devices via the do_ioctl() device
   vector.  Each device should include this file and redefine these
   names as their own. Because these are device dependent it is a good
   idea _NOT_ to issue them to random objects and hope.  */

/*
 *	These 16 ioctl calls are protocol private
 */

/* Define some types used by `ioctl' requests.  */
##including bits/ioctl-types.h
/* Structure types for pre-termios terminal ioctls.  Linux version.
   Copyright (C) 1996, 1997, 1999, 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Get definition of constants for use with `ioctl'.  */
##including asm/ioctls.h
##including asm-generic/ioctls.h
struct winsize
  {
    unsigned short int ws_row;
    unsigned short int ws_col;
    unsigned short int ws_xpixel;
    unsigned short int ws_ypixel;
  };

struct termio
  {
    unsigned short int c_iflag;		/* input mode flags */
    unsigned short int c_oflag;		/* output mode flags */
    unsigned short int c_cflag;		/* control mode flags */
    unsigned short int c_lflag;		/* local mode flags */
    unsigned char c_line;		/* line discipline */
    unsigned char c_cc[8];		/* control characters */
};

/* modem lines */
/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */

/* line disciplines */
/* On a Unix system, the system <sys/ioctl.h> probably defines some of
   the symbols we define in <sys/ttydefaults.h> (usually with the same
   values).  The code to generate <bits/ioctls.h> has omitted these
   symbols to avoid the conflict, but a Unix program expects <sys/ioctl.h>
   to define them, so we must include <sys/ttydefaults.h> here.  */
##including sys/ttydefaults.h
/*-
 * Copyright (c) 1982, 1986, 1993
 *	The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)ttydefaults.h	8.4 (Berkeley) 1/21/94
 */

/*
 * System wide defaults for terminal state.  Linux version.
 */
#if 1
/*
 * Defaults on "first" open.
 */
/*
 * Control Character Defaults
 */
#elif 1
#endif
#elif 1
#endif
/* compat */
/* PROTECTED INCLUSION ENDS HERE */
#endif
/*
 * #define TTYDEFCHARS to include an array of default control characters.
 */
#endif
/* Perform the I/O control operation specified by REQUEST on FD.
   One argument may follow; its presence and type depend on REQUEST.
   Return value depends on REQUEST.  Usually -1 indicates error.  */
extern int ioctl (int __fd, unsigned long int __request, ...) __attribute__((__nothrow__));



#endif
##including sys/mman.h
/* Definitions for BSD-style memory management.
   Copyright (C) 1994-2000, 2003, 2004, 2005 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including bits/types.h
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
#endif
#endif
##including bits/mman.h
/* Definitions for POSIX memory map interface.  Linux/x86_64 version.
   Copyright (C) 2001, 2003, 2005, 2006, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* The following definitions basically come from the kernel headers.
   But the kernel header is not namespace clean.  */


/* Protections are chosen from these bits, OR'd together.  The
   implementation does not necessarily support PROT_EXEC or PROT_WRITE
   without PROT_READ.  The only guarantees are that no writing will be
   allowed without PROT_WRITE and no access will be allowed for PROT_NONE. */

/* Sharing types (must choose one and only one of these).  */
#if 1
#endif
/* Other flags.  */
#if 1
#endif
/* These are Linux-specific.  */
#if 1
#endif
/* Flags to `msync'.  */
/* Flags for `mlockall'.  */
/* Flags for `mremap'.  */
#endif
/* Advice to `madvise'.  */
#if 1
#endif
/* The POSIX people had to invent similar names for the same things.  */
#if 1
#endif
/* Return value of `mmap' in case of an error.  */

/* Map addresses starting near ADDR and extending for LEN bytes.  from
   OFFSET into the file FD describes according to PROT and FLAGS.  If ADDR
   is nonzero, it is the desired mapping address.  If the MAP_FIXED bit is
   set in FLAGS, the mapping will be at ADDR exactly (which must be
   page-aligned); otherwise the system chooses a convenient nearby address.
   The return value is the actual mapping address chosen or MAP_FAILED
   for errors (in which case `errno' is set).  A successful `mmap' call
   deallocates any previous mapping for the affected region.  */

#if 1
extern void *mmap (void *__addr, size_t __len, int __prot,
		   int __flags, int __fd, __off_t __offset) __attribute__((__nothrow__));
#endif
#endif
/* Deallocate any mapping for the region starting at ADDR and extending LEN
   bytes.  Returns 0 if successful, -1 for errors (and sets errno).  */
extern int munmap (void *__addr, size_t __len) __attribute__((__nothrow__));

/* Change the memory protection of the region starting at ADDR and
   extending LEN bytes to PROT.  Returns 0 if successful, -1 for errors
   (and sets errno).  */
extern int mprotect (void *__addr, size_t __len, int __prot) __attribute__((__nothrow__));

/* Synchronize the region starting at ADDR and extending LEN bytes with the
   file it maps.  Filesystem operations on a file being mapped are
   unpredictable before this is done.  Flags are from the MS_* set.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int msync (void *__addr, size_t __len, int __flags);

#if 1
/* Advise the system about particular usage patterns the program follows
   for the region starting at ADDR and extending LEN bytes.  */
extern int madvise (void *__addr, size_t __len, int __advice) __attribute__((__nothrow__));
#endif
#if 1
/* This is the POSIX name for this function.  */
extern int posix_madvise (void *__addr, size_t __len, int __advice) __attribute__((__nothrow__));
#endif
/* Guarantee all whole pages mapped by the range [ADDR,ADDR+LEN) to
   be memory resident.  */
extern int mlock (const void *__addr, size_t __len) __attribute__((__nothrow__));

/* Unlock whole pages previously mapped by the range [ADDR,ADDR+LEN).  */
extern int munlock (const void *__addr, size_t __len) __attribute__((__nothrow__));

/* Cause all currently mapped pages of the process to be memory resident
   until unlocked by a call to the `munlockall', until the process exits,
   or until the process calls `execve'.  */
extern int mlockall (int __flags) __attribute__((__nothrow__));

/* All currently mapped pages of the process' address space become
   unlocked.  */
extern int munlockall (void) __attribute__((__nothrow__));

#if 1
/* mincore returns the memory residency status of the pages in the
   current process's address space specified by [start, start + len).
   The status is returned in a vector of bytes.  The least significant
   bit of each byte is 1 if the referenced page is in memory, otherwise
   it is zero.  */
extern int mincore (void *__start, size_t __len, unsigned char *__vec)
     __attribute__((__nothrow__));
#endif
#endif
/* Open shared memory segment.  */
extern int shm_open (const char *__name, int __oflag, mode_t __mode);

/* Remove shared memory segment.  */
extern int shm_unlink (const char *__name);



#endif
##including sys/socket.h
##including sys/stat.h
/* Copyright (C) 1991, 1992, 1995-2004, 2005, 2006, 2007, 2009, 2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 5.6 File Characteristics	<sys/stat.h>
 */

#if 1
##including features.h
##including bits/types.h
#if 1
#if 1
#endif
#if 1
#endif
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if 1
/* The Single Unix specification says that some more types are
   available here.  */
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif


##including bits/stat.h
/* Copyright (C) 1999-2003,2009,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#endif
#if 1
#if 1
#endif
#if 1
#endif
#if 1
#endif
#endif
/* Test macros for file types.	*/

#if 1
#endif
#if 1
#endif
#endif
#if 1
#endif
/* These are from POSIX.1b.  If the objects are not implemented using separate
   distinct file types, the macros always will evaluate to zero.  Unlike the
   other S_* macros the following three take a pointer to a `struct stat'
   object as the argument.  */
#if 1
#endif
/* Protection bits.  */

#if 1
/* Save swapped text after use (sticky bit).  This is pretty well obsolete.  */
#endif
/* Read, write, and execute by owner.  */
#if 1
#endif
/* Read, write, and execute by group.  */
/* Read, write, and execute by others.  */
#if 1
/* Macros for common mode bit masks.  */
#endif
#if 1
/* Get file attributes for FILE and put them in BUF.  */
extern int stat (const char *__restrict __file,
		 struct stat *__restrict __buf) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Get file attributes for the file, device, pipe, or socket
   that file descriptor FD is open on and put them in BUF.  */
extern int fstat (int __fd, struct stat *__buf) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
#endif
#if 1
/* Similar to stat, get the attributes for FILE and put them in BUF.
   Relative path names are interpreted relative to FD unless FD is
   AT_FDCWD.  */
#if 1
extern int fstatat (int __fd, const char *__restrict __file,
		    struct stat *__restrict __buf, int __flag)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 3)));
#endif
#endif
#endif
#if 1
#if 1
/* Get file attributes about FILE and put them in BUF.
   If FILE is a symbolic link, do not follow it.  */
extern int lstat (const char *__restrict __file,
		  struct stat *__restrict __buf) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif
#endif
/* Set file access permissions for FILE to MODE.
   If FILE is a symbolic link, this affects its target instead.  */
extern int chmod (const char *__file, __mode_t __mode)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Set file access permissions for FILE to MODE.
   If FILE is a symbolic link, this affects the link itself
   rather than its target.  */
extern int lchmod (const char *__file, __mode_t __mode)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
/* Set file access permissions of the file FD is open on to MODE.  */
#if 1
extern int fchmod (int __fd, __mode_t __mode) __attribute__((__nothrow__));
#endif
#if 1
/* Set file access permissions of FILE relative to
   the directory FD is open on.  */
extern int fchmodat (int __fd, const char *__file, __mode_t __mode,
		     int __flag)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2))) ;
#endif
/* Set the file creation mask of the current process to MASK,
   and return the old creation mask.  */
extern __mode_t umask (__mode_t __mask) __attribute__((__nothrow__));

#endif
/* Create a new directory named PATH, with permission bits MODE.  */
extern int mkdir (const char *__path, __mode_t __mode)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Like mkdir, create a new directory with permission bits MODE.  But
   interpret relative PATH names relative to the directory associated
   with FD.  */
extern int mkdirat (int __fd, const char *__path, __mode_t __mode)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
/* Create a device file named PATH, with permission and special bits MODE
   and device number DEV (which can be constructed from major and minor
   device numbers with the `makedev' macro above).  */
#if 1
extern int mknod (const char *__path, __mode_t __mode, __dev_t __dev)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Like mknod, create a new device file with permission bits MODE and
   device number DEV.  But interpret relative PATH names relative to
   the directory associated with FD.  */
extern int mknodat (int __fd, const char *__path, __mode_t __mode,
		    __dev_t __dev) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
#endif
/* Create a new FIFO named PATH, with permission bits MODE.  */
extern int mkfifo (const char *__path, __mode_t __mode)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Like mkfifo, create a new FIFO with permission bits MODE.  But
   interpret relative PATH names relative to the directory associated
   with FD.  */
extern int mkfifoat (int __fd, const char *__path, __mode_t __mode)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif

#if 1
/* Set file access and modification times relative to directory file
   descriptor.  */
extern int utimensat (int __fd, const char *__path,
		      const struct timespec __times[2],
		      int __flags)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
#if 1
/* Set file access and modification times of the file associated with FD.  */
extern int futimens (int __fd, const struct timespec __times[2]) __attribute__((__nothrow__));
#endif

/* To allow the `struct stat' structure and the file type `mode_t'
   bits to vary without changing shared library major version number,
   the `stat' family of functions and `mknod' are in fact inline
   wrappers around calls to `xstat', `fxstat', `lxstat', and `xmknod',
   which all take a leading version-number argument designating the
   data structure and bits used.  <bits/stat.h> defines _STAT_VER with
   the version number corresponding to `struct stat' as defined in
   that file; and _MKNOD_VER with the version number corresponding to
   the S_IF* macros defined therein.  It is arranged that when not
   inlined these function are always statically linked; that way a
   dynamically-linked executable always encodes the version number
   corresponding to the data structures it uses, so the `x' functions
   in the shared library can adapt without needing to recompile all
   callers.  */

#endif
#if 1
#endif
/* Wrappers for stat and mknod system calls.  */
#if 1
extern int __fxstat (int __ver, int __fildes, struct stat *__stat_buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3)));
extern int __xstat (int __ver, const char *__filename,
		    struct stat *__stat_buf) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 3)));
extern int __lxstat (int __ver, const char *__filename,
		     struct stat *__stat_buf) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 3)));
extern int __fxstatat (int __ver, int __fildes, const char *__filename,
		       struct stat *__stat_buf, int __flag)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 4)));
#endif
#endif
extern int __xmknod (int __ver, const char *__path, __mode_t __mode,
		     __dev_t *__dev) __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 4)));

extern int __xmknodat (int __ver, int __fd, const char *__path,
		       __mode_t __mode, __dev_t *__dev)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (3, 5)));

#endif



#endif
##including sys/time.h
/* Copyright (C) 1991-1994,1996-2003,2005,2006,2009
	Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including bits/types.h
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
##including bits/time.h
/* System-dependent timing definitions.  Generic version.
   Copyright (C) 1996,1997,1999-2002,2003,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; use <time.h> instead.
 */

#endif
#if 1
#endif
#endif
##including sys/select.h
#endif


#endif
#if 1
/* Structure crudely representing a timezone.
   This is obsolete and should never be used.  */
struct timezone
  {
    int tz_minuteswest;		/* Minutes west of GMT.  */
    int tz_dsttime;		/* Nonzero if DST is ever in effect.  */
  };

typedef struct timezone *__restrict __timezone_ptr_t;
#endif
/* Get the current time of day and timezone information,
   putting it into *TV and *TZ.  If TZ is NULL, *TZ is not filled.
   Returns 0 on success, -1 on errors.
   NOTE: This form of timezone information is obsolete.
   Use the functions and variables declared in <time.h> instead.  */
extern int gettimeofday (struct timeval *__restrict __tv,
			 __timezone_ptr_t __tz) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Set the current time of day and timezone information.
   This call is restricted to the super-user.  */
extern int settimeofday (const struct timeval *__tv,
			 const struct timezone *__tz)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Adjust the current time of day by the amount in DELTA.
   If OLDDELTA is not NULL, it is filled in with the amount
   of time adjustment remaining to be done from the last `adjtime' call.
   This call is restricted to the super-user.  */
extern int adjtime (const struct timeval *__delta,
		    struct timeval *__olddelta) __attribute__((__nothrow__));
#endif
/* Values for the first argument to `getitimer' and `setitimer'.  */
enum __itimer_which
  {
    /* Timers run in real time.  */
    ITIMER_REAL = 0,
/* Timers run only when the process is executing.  */
    ITIMER_VIRTUAL = 1,
/* Timers run when the process is executing and when
       the system is executing on behalf of the process.  */
    ITIMER_PROF = 2
};

/* Type of the second argument to `getitimer' and
   the second and third arguments `setitimer'.  */
struct itimerval
  {
    /* Value to put into `it_value' when the timer expires.  */
    struct timeval it_interval;
    /* Time to the next timer expiration.  */
    struct timeval it_value;
  };

#elif 1
typedef int __itimer_which_t;
#endif
/* Set *VALUE to the current setting of timer WHICH.
   Return 0 on success, -1 on errors.  */
extern int getitimer (__itimer_which_t __which,
		      struct itimerval *__value) __attribute__((__nothrow__));

/* Set the timer WHICH to *NEW.  If OLD is not NULL,
   set *OLD to the old value of timer WHICH.
   Returns 0 on success, -1 on errors.  */
extern int setitimer (__itimer_which_t __which,
		      const struct itimerval *__restrict __new,
		      struct itimerval *__restrict __old) __attribute__((__nothrow__));

/* Change the access time of FILE to TVP[0] and the modification time of
   FILE to TVP[1].  If TVP is a null pointer, use the current time instead.
   Returns 0 on success, -1 on errors.  */
extern int utimes (const char *__file, const struct timeval __tvp[2])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Same as `utimes', but does not follow symbolic links.  */
extern int lutimes (const char *__file, const struct timeval __tvp[2])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Same as `utimes', but takes an open file descriptor instead of a name.  */
extern int futimes (int __fd, const struct timeval __tvp[2]) __attribute__((__nothrow__));
#endif
#endif
#if 1
/* Convenience macros for operations on timevals.
   NOTE: `timercmp' does not work for >= or <=.  */
#endif


#endif
##including sys/types.h
##including sys/wait.h
/* Copyright (C) 1991-1994,1996-2001,2003,2004,2005,2007,2009,2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 3.2.1 Wait for Process Termination	<sys/wait.h>
 */

#if 1
##including features.h


##including signal.h
/* Copyright (C) 1991-2004, 2007, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.14 Signal handling <signal.h>
 */

#endif
##including sys/resource.h
/* Copyright (C) 1992,94,1996-2000,2002,2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
/* Get the system-dependent definitions of structures and bit values.  */
##including bits/resource.h
/* Bit values & structures for resource limits.  Linux version.
   Copyright (C) 1994, 1996, 1997, 1998, 1999, 2000, 2004, 2005, 2008, 2009
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including bits/types.h
/* Transmute defines to enumerations.  The macro re-definitions are
   necessary because some programs want to test for operating system
   features with #ifdef RUSAGE_SELF.  In ISO C the reflexive
   definition is a no-op.  */

/* Kinds of resource limit.  */
enum __rlimit_resource
{
  /* Per-process CPU limit, in seconds.  */
  RLIMIT_CPU = 0,
/* Largest file that can be created, in bytes.  */
  RLIMIT_FSIZE = 1,
/* Maximum size of data segment, in bytes.  */
  RLIMIT_DATA = 2,
/* Maximum size of stack segment, in bytes.  */
  RLIMIT_STACK = 3,
/* Largest core file that can be created, in bytes.  */
  RLIMIT_CORE = 4,
/* Largest resident set size, in bytes.
     This affects swapping; processes that are exceeding their
     resident set size will be more likely to have physical memory
     taken from them.  */
  __RLIMIT_RSS = 5,
/* Number of open files.  */
  RLIMIT_NOFILE = 7,
  __RLIMIT_OFILE = RLIMIT_NOFILE, /* BSD name for same.  */
/* Address space limit.  */
  RLIMIT_AS = 9,
/* Number of processes.  */
  __RLIMIT_NPROC = 6,
/* Locked-in-memory address space.  */
  __RLIMIT_MEMLOCK = 8,
/* Maximum number of file locks.  */
  __RLIMIT_LOCKS = 10,
/* Maximum number of pending signals.  */
  __RLIMIT_SIGPENDING = 11,
/* Maximum bytes in POSIX message queues.  */
  __RLIMIT_MSGQUEUE = 12,
/* Maximum nice priority allowed to raise to.
     Nice levels 19 .. -20 correspond to 0 .. 39
     values of this resource limit.  */
  __RLIMIT_NICE = 13,
/* Maximum realtime priority allowed for non-priviledged
     processes.  */
  __RLIMIT_RTPRIO = 14,
__RLIMIT_NLIMITS = 15,
  __RLIM_NLIMITS = __RLIMIT_NLIMITS
};

/* Value to indicate that there is no limit.  */
#if 1
#endif
#endif
/* We can represent all limits.  */
/* Type for resource quantity measurement.  */
#if 1
typedef __rlim_t rlim_t;
#endif
#endif
struct rlimit
  {
    /* The current (soft) limit.  */
    rlim_t rlim_cur;
    /* The hard limit.  */
    rlim_t rlim_max;
  };

#endif
/* Whose usage statistics do you want?  */
enum __rusage_who
{
  /* The calling process.  */
  RUSAGE_SELF = 0,
/* All of its terminated child processes.  */
  RUSAGE_CHILDREN = -1
#endif
};

##including bits/time.h
/* System-dependent timing definitions.  Generic version.
   Copyright (C) 1996,1997,1999-2002,2003,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; use <time.h> instead.
 */

#endif
#if 1
#endif
#endif
/* Structure which says how much of each resource has been used.  */
struct rusage
  {
    /* Total amount of user time used.  */
    struct timeval ru_utime;
    /* Total amount of system time used.  */
    struct timeval ru_stime;
    /* Maximum resident set size (in kilobytes).  */
    long int ru_maxrss;
    /* Amount of sharing of text segment memory
       with other processes (kilobyte-seconds).  */
    long int ru_ixrss;
    /* Amount of data segment memory used (kilobyte-seconds).  */
    long int ru_idrss;
    /* Amount of stack memory used (kilobyte-seconds).  */
    long int ru_isrss;
    /* Number of soft page faults (i.e. those serviced by reclaiming
       a page from the list of pages awaiting reallocation.  */
    long int ru_minflt;
    /* Number of hard page faults (i.e. those that required I/O).  */
    long int ru_majflt;
    /* Number of times a process was swapped out of physical memory.  */
    long int ru_nswap;
    /* Number of input operations via the file system.  Note: This
       and `ru_oublock' do not include operations with the cache.  */
    long int ru_inblock;
    /* Number of output operations via the file system.  */
    long int ru_oublock;
    /* Number of IPC messages sent.  */
    long int ru_msgsnd;
    /* Number of IPC messages received.  */
    long int ru_msgrcv;
    /* Number of signals delivered.  */
    long int ru_nsignals;
    /* Number of voluntary context switches, i.e. because the process
       gave up the process before it had to (usually to wait for some
       resource to be available).  */
    long int ru_nvcsw;
    /* Number of involuntary context switches, i.e. a higher priority process
       became runnable or the current process used up its time slice.  */
    long int ru_nivcsw;
  };

/* Priority limits.  */
/* The type of the WHICH argument to `getpriority' and `setpriority',
   indicating what flavor of entity the WHO argument specifies.  */
enum __priority_which
{
  PRIO_PROCESS = 0,		/* WHO is a process ID.  */
PRIO_PGRP = 1,		/* WHO is a process group ID.  */
PRIO_USER = 2			/* WHO is a user ID.  */
};
#endif


/* The X/Open standard defines that all the functions below must use
   `int' as the type for the first argument.  When we are compiling with
   GNU extensions we change this slightly to provide better error
   checking.  */
#elif 1
typedef int __rlimit_resource_t;
typedef int __rusage_who_t;
typedef int __priority_which_t;
#endif
/* Put the soft and hard limits for RESOURCE in *RLIMITS.
   Returns 0 if successful, -1 if not (and sets errno).  */
#if 1
extern int getrlimit (__rlimit_resource_t __resource,
		      struct rlimit *__rlimits) __attribute__((__nothrow__));
#endif
#endif
/* Set the soft and hard limits for RESOURCE to *RLIMITS.
   Only the super-user can increase hard limits.
   Return 0 if successful, -1 if not (and sets errno).  */
#if 1
extern int setrlimit (__rlimit_resource_t __resource,
		      const struct rlimit *__rlimits) __attribute__((__nothrow__));
#endif
#endif
/* Return resource usage information on process indicated by WHO
   and put it in *USAGE.  Returns 0 for success, -1 for failure.  */
extern int getrusage (__rusage_who_t __who, struct rusage *__usage) __attribute__((__nothrow__));

/* Return the highest priority of any process specified by WHICH and WHO
   (see above); if WHO is zero, the current process, process group, or user
   (as specified by WHO) is used.  A lower priority number means higher
   priority.  Priorities range from PRIO_MIN to PRIO_MAX (above).  */
extern int getpriority (__priority_which_t __which, id_t __who) __attribute__((__nothrow__));

/* Set the priority of all processes specified by WHICH and WHO (see above)
   to PRIO.  Returns 0 on success, -1 on errors.  */
extern int setpriority (__priority_which_t __which, id_t __who, int __prio)
     __attribute__((__nothrow__));



#endif
/* These macros could also be defined in <stdlib.h>.  */
#endif
#if 1
#endif
/* The following values are used by the `waitid' function.  */
#if 1
typedef enum
{
  P_ALL,		/* Wait for any child.  */
  P_PID,		/* Wait for specified process.  */
  P_PGID		/* Wait for members of process group.  */
} idtype_t;
#endif
/* Wait for a child to die.  When one does, put its status in *STAT_LOC
   and return its process ID.  For errors, return (pid_t) -1.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern __pid_t wait (__WAIT_STATUS __stat_loc);

#if 1
/* Special values for the PID argument to `waitpid' and `wait4'.  */
#endif
/* Wait for a child matching PID to die.
   If PID is greater than 0, match any process whose process ID is PID.
   If PID is (pid_t) -1, match any process.
   If PID is (pid_t) 0, match any process with the
   same process group as the current process.
   If PID is less than -1, match any process whose
   process group is the absolute value of PID.
   If the WNOHANG bit is set in OPTIONS, and that child
   is not already dead, return (pid_t) 0.  If successful,
   return PID and store the dead child's status in STAT_LOC.
   Return (pid_t) -1 for errors.  If the WUNTRACED bit is
   set in OPTIONS, return status for stopped children; otherwise don't.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern __pid_t waitpid (__pid_t __pid, int *__stat_loc, int __options);

#if 1
##including bits/siginfo.h
/* siginfo_t, sigevent and constants.  Linux version.
   Copyright (C) 1997-2002, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
#endif
#endif
#endif
/* Wait for a childing matching IDTYPE and ID to change the status and
   place appropriate information in *INFOP.
   If IDTYPE is P_PID, match any process whose process ID is ID.
   If IDTYPE is P_PGID, match any process whose process group is ID.
   If IDTYPE is P_ALL, match any process.
   If the WNOHANG bit is set in OPTIONS, and that child
   is not already dead, clear *INFOP and return 0.  If successful, store
   exit code and status in *INFOP.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int waitid (idtype_t __idtype, __id_t __id, siginfo_t *__infop,
		   int __options);
#endif
#if 1
/* This being here makes the prototypes valid whether or not
   we have already included <sys/resource.h> to define `struct rusage'.  */
struct rusage;

/* Wait for a child to exit.  When one does, put its status in *STAT_LOC and
   return its process ID.  For errors return (pid_t) -1.  If USAGE is not
   nil, store information about the child's resource usage there.  If the
   WUNTRACED bit is set in OPTIONS, return status for stopped children;
   otherwise don't.  */
extern __pid_t wait3 (__WAIT_STATUS __stat_loc, int __options,
		      struct rusage * __usage) __attribute__((__nothrow__));
#endif
#if 1
/* PID is like waitpid.  Other args are like wait3.  */
extern __pid_t wait4 (__pid_t __pid, __WAIT_STATUS __stat_loc, int __options,
		      struct rusage *__usage) __attribute__((__nothrow__));
#endif


#endif
##including termios.h
/* Copyright (C) 1991-1994,1996-1999,2003,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 7.1-2 General Terminal Interface	<termios.h>
 */

#if 1
##including features.h
#if 1
/* We need `pid_t'.  */
##including bits/types.h
#endif
#endif


/* Get the system-dependent definitions of `struct termios', `tcflag_t',
   `cc_t', `speed_t', and all the macros specifying the flag bits.  */
##including bits/termios.h
/* termios type and macro definitions.  Linux version.
   Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2003, 2005
	Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
typedef unsigned char	cc_t;
typedef unsigned int	speed_t;
typedef unsigned int	tcflag_t;

struct termios
  {
    tcflag_t c_iflag;		/* input mode flags */
    tcflag_t c_oflag;		/* output mode flags */
    tcflag_t c_cflag;		/* control mode flags */
    tcflag_t c_lflag;		/* local mode flags */
    cc_t c_line;			/* line discipline */
    cc_t c_cc[32];		/* control characters */
    speed_t c_ispeed;		/* input speed */
    speed_t c_ospeed;		/* output speed */
};

/* c_cc characters */
/* c_iflag bits */
/* c_oflag bits */
#if 1
#endif
#if 1
#endif
/* c_cflag bit meaning */
#if 1
#endif
#if 1
#endif
#if 1
#endif
#if 1
#endif
/* c_lflag bits */
#if 1
#endif
#if 1
#endif
/* tcflow() and TCXONC use these */
/* tcflush() and TCFLSH use these */
/* tcsetattr uses these */
#if 1
/* Compare a character C to a value VAL from the `c_cc' array in a
   `struct termios'.  If VAL is _POSIX_VDISABLE, no character can match it.  */
#endif
/* Return the output baud rate stored in *TERMIOS_P.  */
extern speed_t cfgetospeed (const struct termios *__termios_p) __attribute__((__nothrow__));

/* Return the input baud rate stored in *TERMIOS_P.  */
extern speed_t cfgetispeed (const struct termios *__termios_p) __attribute__((__nothrow__));

/* Set the output baud rate stored in *TERMIOS_P to SPEED.  */
extern int cfsetospeed (struct termios *__termios_p, speed_t __speed) __attribute__((__nothrow__));

/* Set the input baud rate stored in *TERMIOS_P to SPEED.  */
extern int cfsetispeed (struct termios *__termios_p, speed_t __speed) __attribute__((__nothrow__));

#if 1
/* Set both the input and output baud rates in *TERMIOS_OP to SPEED.  */
extern int cfsetspeed (struct termios *__termios_p, speed_t __speed) __attribute__((__nothrow__));
#endif
/* Put the state of FD into *TERMIOS_P.  */
extern int tcgetattr (int __fd, struct termios *__termios_p) __attribute__((__nothrow__));

/* Set the state of FD to *TERMIOS_P.
   Values for OPTIONAL_ACTIONS (TCSA*) are in <bits/termios.h>.  */
extern int tcsetattr (int __fd, int __optional_actions,
		      const struct termios *__termios_p) __attribute__((__nothrow__));


#if 1
/* Set *TERMIOS_P to indicate raw mode.  */
extern void cfmakeraw (struct termios *__termios_p) __attribute__((__nothrow__));
#endif
/* Send zero bits on FD.  */
extern int tcsendbreak (int __fd, int __duration) __attribute__((__nothrow__));

/* Wait for pending output to be written on FD.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int tcdrain (int __fd);

/* Flush pending data on FD.
   Values for QUEUE_SELECTOR (TC{I,O,IO}FLUSH) are in <bits/termios.h>.  */
extern int tcflush (int __fd, int __queue_selector) __attribute__((__nothrow__));

/* Suspend or restart transmission on FD.
   Values for ACTION (TC[IO]{OFF,ON}) are in <bits/termios.h>.  */
extern int tcflow (int __fd, int __action) __attribute__((__nothrow__));


#endif
#if 1
##including sys/ttydefaults.h
#endif


#endif
##including time.h
/* Copyright (C) 1991-2003,2006,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.23 Date and time	<time.h>
 */

#if 1
#if 1
##including features.h


#endif
#if 1
/* Get size_t and NULL from <stddef.h>.  */
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
/* This defines CLOCKS_PER_SEC, which is the number of processor clock
   ticks per second.  */
##including bits/time.h
/* System-dependent timing definitions.  Generic version.
   Copyright (C) 1996,1997,1999-2002,2003,2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * Never include this file directly; use <time.h> instead.
 */

#if 1
#if 1
/* ISO/IEC 9899:1990 7.12.1: <time.h>
   The macro `CLOCKS_PER_SEC' is the number per second of the value
   returned by the `clock' function. */
/* CAE XSH, Issue 4, Version 2: <time.h>
   The value of CLOCKS_PER_SEC is required to be 1 million on all
   XSI-conformant systems. */
#endif
#if 1
/* Identifier for system-wide realtime clock.  */
/* Monotonic system-wide clock.  */
/* High-resolution timer from the CPU.  */
/* Thread-specific CPU-time clock.  */
/* Monotonic system-wide clock, not adjusted for frequency scaling.  */
/* Identifier for system-wide realtime clock, updated only on ticks.  */
/* Monotonic system-wide clock, updated only on ticks.  */
/* Flag to indicate time is absolute.  */
#endif
#endif
#endif
#endif
/* This is the obsolete POSIX.1-1988 name for the same constant.  */
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if 1

/* Used by other time functions.  */
struct tm
{
  int tm_sec;			/* Seconds.	[0-60] (1 leap second) */
  int tm_min;			/* Minutes.	[0-59] */
  int tm_hour;			/* Hours.	[0-23] */
  int tm_mday;			/* Day.		[1-31] */
  int tm_mon;			/* Month.	[0-11] */
  int tm_year;			/* Year	- 1900.  */
  int tm_wday;			/* Day of week.	[0-6] */
  int tm_yday;			/* Days in year.[0-365]	*/
  int tm_isdst;			/* DST.		[-1/0/1]*/

#if 1
long int tm_gmtoff;		/* Seconds east of UTC.  */
  const char *tm_zone;	/* Timezone abbreviation.  */
#endif
};

#if 1

#endif
#if 1
/* POSIX.1b structure for timer start values and intervals.  */
struct itimerspec
  {
    struct timespec it_interval;
    struct timespec it_value;
  };

/* We can use a simple forward declaration.  */
struct sigevent;

#endif
#if 1
#endif
#endif

/* Time used by the program so far (user time + system time).
   The result / CLOCKS_PER_SECOND is program time in seconds.  */
extern clock_t clock (void) __attribute__((__nothrow__));

/* Return the current time and put it in *TIMER if TIMER is not NULL.  */
extern time_t time (time_t *__timer) __attribute__((__nothrow__));

/* Return the difference between TIME1 and TIME0.  */
extern double difftime (time_t __time1, time_t __time0)
     __attribute__((__nothrow__)) __attribute__ ((__const__));

/* Return the `time_t' representation of TP and normalize TP.  */
extern time_t mktime (struct tm *__tp) __attribute__((__nothrow__));


/* Format TP into S according to FORMAT.
   Write no more than MAXSIZE characters and return the number
   of characters written, or 0 if it would exceed MAXSIZE.  */
extern size_t strftime (char *__restrict __s, size_t __maxsize,
			const char *__restrict __format,
			const struct tm *__restrict __tp) __attribute__((__nothrow__));


#endif
#if 1
/* Similar to the two functions above but take the information from
   the provided locale and not the global locale.  */
##including xlocale.h
extern size_t strftime_l (char *__restrict __s, size_t __maxsize,
			  const char *__restrict __format,
			  const struct tm *__restrict __tp,
			  __locale_t __loc) __attribute__((__nothrow__));
#endif
#endif

/* Return the `struct tm' representation of *TIMER
   in Universal Coordinated Time (aka Greenwich Mean Time).  */
extern struct tm *gmtime (const time_t *__timer) __attribute__((__nothrow__));

/* Return the `struct tm' representation
   of *TIMER in the local timezone.  */
extern struct tm *localtime (const time_t *__timer) __attribute__((__nothrow__));


#if 1
/* Return the `struct tm' representation of *TIMER in UTC,
   using *TP to store the result.  */
extern struct tm *gmtime_r (const time_t *__restrict __timer,
			    struct tm *__restrict __tp) __attribute__((__nothrow__));

/* Return the `struct tm' representation of *TIMER in local time,
   using *TP to store the result.  */
extern struct tm *localtime_r (const time_t *__restrict __timer,
			       struct tm *__restrict __tp) __attribute__((__nothrow__));
#endif

/* Return a string of the form "Day Mon dd hh:mm:ss yyyy\n"
   that is the representation of TP in this format.  */
extern char *asctime (const struct tm *__tp) __attribute__((__nothrow__));

/* Equivalent to `asctime (localtime (timer))'.  */
extern char *ctime (const time_t *__timer) __attribute__((__nothrow__));


#if 1
/* Reentrant versions of the above functions.  */

/* Return in BUF a string of the form "Day Mon dd hh:mm:ss yyyy\n"
   that is the representation of TP in this format.  */
extern char *asctime_r (const struct tm *__restrict __tp,
			char *__restrict __buf) __attribute__((__nothrow__));

/* Equivalent to `asctime_r (localtime_r (timer, *TMP*), buf)'.  */
extern char *ctime_r (const time_t *__restrict __timer,
		      char *__restrict __buf) __attribute__((__nothrow__));
#endif
/* Defined in localtime.c.  */
extern char *__tzname[2];	/* Current timezone names.  */
extern int __daylight;		/* If daylight-saving time is ever in use.  */
extern long int __timezone;	/* Seconds west of UTC.  */


#if 1
/* Same as above.  */
extern char *tzname[2];

/* Set time conversion information from the TZ environment variable.
   If TZ is not defined, a locale-dependent default is used.  */
extern void tzset (void) __attribute__((__nothrow__));
#endif
#if 1
extern int daylight;
extern long int timezone;
#endif
#if 1
/* Set the system time to *WHEN.
   This call is restricted to the superuser.  */
extern int stime (const time_t *__when) __attribute__((__nothrow__));
#endif
/* Nonzero if YEAR is a leap year (every 4 years,
   except every 100th isn't, and every 400th is).  */
#if 1
/* Miscellaneous functions many Unices inherited from the public domain
   localtime package.  These are included only for compatibility.  */

/* Like `mktime', but for TP represents Universal Time, not local time.  */
extern time_t timegm (struct tm *__tp) __attribute__((__nothrow__));

/* Another name for `mktime'.  */
extern time_t timelocal (struct tm *__tp) __attribute__((__nothrow__));

/* Return the number of days in YEAR.  */
extern int dysize (int __year) __attribute__((__nothrow__))  __attribute__ ((__const__));
#endif
#if 1
/* Pause execution for a number of nanoseconds.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int nanosleep (const struct timespec *__requested_time,
		      struct timespec *__remaining);


/* Get resolution of clock CLOCK_ID.  */
extern int clock_getres (clockid_t __clock_id, struct timespec *__res) __attribute__((__nothrow__));

/* Get current value of clock CLOCK_ID and store it in TP.  */
extern int clock_gettime (clockid_t __clock_id, struct timespec *__tp) __attribute__((__nothrow__));

/* Set clock CLOCK_ID to value TP.  */
extern int clock_settime (clockid_t __clock_id, const struct timespec *__tp)
     __attribute__((__nothrow__));

#if 1
/* High-resolution sleep with the specified clock.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int clock_nanosleep (clockid_t __clock_id, int __flags,
			    const struct timespec *__req,
			    struct timespec *__rem);

/* Return clock ID for CPU-time clock.  */
extern int clock_getcpuclockid (pid_t __pid, clockid_t *__clock_id) __attribute__((__nothrow__));
#endif
/* Create new per-process timer using CLOCK_ID.  */
extern int timer_create (clockid_t __clock_id,
			 struct sigevent *__restrict __evp,
			 timer_t *__restrict __timerid) __attribute__((__nothrow__));

/* Delete timer TIMERID.  */
extern int timer_delete (timer_t __timerid) __attribute__((__nothrow__));

/* Set timer TIMERID to VALUE, returning old value in OVLAUE.  */
extern int timer_settime (timer_t __timerid, int __flags,
			  const struct itimerspec *__restrict __value,
			  struct itimerspec *__restrict __ovalue) __attribute__((__nothrow__));

/* Get current value of timer TIMERID and store it in VLAUE.  */
extern int timer_gettime (timer_t __timerid, struct itimerspec *__value)
     __attribute__((__nothrow__));

/* Get expiration overrun for timer TIMERID.  */
extern int timer_getoverrun (timer_t __timerid) __attribute__((__nothrow__));
#endif
#endif
#endif


#endif
#endif
##including unistd.h
/* Copyright (C) 1991-2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 2.10 Symbolic Constants		<unistd.h>
 */

#if 1
##including features.h


/* These may be used to determine what facilities are present at compile time.
   Their values can be obtained at run time from `sysconf'.  */

#if 1
/* POSIX Standard approved as ISO/IEC 9945-1 as of September 2008.  */
#endif
/* These are not #ifdef __USE_POSIX2 because they are
   in the theoretically application-owned namespace.  */

#if 1
/* The utilities on GNU systems also correspond to this version.  */
#endif
/* The utilities on GNU systems also correspond to this version.  */
/* If defined, the implementation supports the
   C Language Bindings Option.  */
/* If defined, the implementation supports the
   C Language Development Utilities Option.  */
/* If defined, the implementation supports the
   Software Development Utilities Option.  */
/* If defined, the implementation supports the
   creation of locales with the localedef utility.  */
/* X/Open version number to which the library conforms.  It is selectable.  */
#if 1
#endif
/* Commands and utilities from XPG4 are available.  */
/* We are compatible with the old published standards as well.  */
/* The X/Open Unix extensions are available.  */
/* Encryption is present.  */
/* The enhanced internationalization capabilities according to XPG4.2
   are present.  */
/* The legacy interfaces are also available.  */
/* Get values of POSIX options:

   If these symbols are defined, the corresponding features are
   always available.  If not, they may be available sometimes.
   The current values can be obtained with `sysconf'.

   _POSIX_JOB_CONTROL		Job control is supported.
   _POSIX_SAVED_IDS		Processes have a saved set-user-ID
				and a saved set-group-ID.
   _POSIX_REALTIME_SIGNALS	Real-time, queued signals are supported.
   _POSIX_PRIORITY_SCHEDULING	Priority scheduling is supported.
   _POSIX_TIMERS		POSIX.4 clocks and timers are supported.
   _POSIX_ASYNCHRONOUS_IO	Asynchronous I/O is supported.
   _POSIX_PRIORITIZED_IO	Prioritized asynchronous I/O is supported.
   _POSIX_SYNCHRONIZED_IO	Synchronizing file data is supported.
   _POSIX_FSYNC			The fsync function is present.
   _POSIX_MAPPED_FILES		Mapping of files to memory is supported.
   _POSIX_MEMLOCK		Locking of all memory is supported.
   _POSIX_MEMLOCK_RANGE		Locking of ranges of memory is supported.
   _POSIX_MEMORY_PROTECTION	Setting of memory protections is supported.
   _POSIX_MESSAGE_PASSING	POSIX.4 message queues are supported.
   _POSIX_SEMAPHORES		POSIX.4 counting semaphores are supported.
   _POSIX_SHARED_MEMORY_OBJECTS	POSIX.4 shared memory objects are supported.
   _POSIX_THREADS		POSIX.1c pthreads are supported.
   _POSIX_THREAD_ATTR_STACKADDR	Thread stack address attribute option supported.
   _POSIX_THREAD_ATTR_STACKSIZE	Thread stack size attribute option supported.
   _POSIX_THREAD_SAFE_FUNCTIONS	Thread-safe functions are supported.
   _POSIX_THREAD_PRIORITY_SCHEDULING
				POSIX.1c thread execution scheduling supported.
   _POSIX_THREAD_PRIO_INHERIT	Thread priority inheritance option supported.
   _POSIX_THREAD_PRIO_PROTECT	Thread priority protection option supported.
   _POSIX_THREAD_PROCESS_SHARED	Process-shared synchronization supported.
   _POSIX_PII			Protocol-independent interfaces are supported.
   _POSIX_PII_XTI		XTI protocol-indep. interfaces are supported.
   _POSIX_PII_SOCKET		Socket protocol-indep. interfaces are supported.
   _POSIX_PII_INTERNET		Internet family of protocols supported.
   _POSIX_PII_INTERNET_STREAM	Connection-mode Internet protocol supported.
   _POSIX_PII_INTERNET_DGRAM	Connectionless Internet protocol supported.
   _POSIX_PII_OSI		ISO/OSI family of protocols supported.
   _POSIX_PII_OSI_COTS		Connection-mode ISO/OSI service supported.
   _POSIX_PII_OSI_CLTS		Connectionless ISO/OSI service supported.
   _POSIX_POLL			Implementation supports `poll' function.
   _POSIX_SELECT		Implementation supports `select' and `pselect'.

   _XOPEN_REALTIME		X/Open realtime support is available.
   _XOPEN_REALTIME_THREADS	X/Open realtime thread support is available.
   _XOPEN_SHM			Shared memory interface according to XPG4.2.

   _XBS5_ILP32_OFF32		Implementation provides environment with 32-bit
				int, long, pointer, and off_t types.
   _XBS5_ILP32_OFFBIG		Implementation provides environment with 32-bit
				int, long, and pointer and off_t with at least
				64 bits.
   _XBS5_LP64_OFF64		Implementation provides environment with 32-bit
				int, and 64-bit long, pointer, and off_t types.
   _XBS5_LPBIG_OFFBIG		Implementation provides environment with at
				least 32 bits int and long, pointer, and off_t
				with at least 64 bits.

   If any of these symbols is defined as -1, the corresponding option is not
   true for any file.  If any is defined as other than -1, the corresponding
   option is true for all files.  If a symbol is not defined at all, the value
   for a specific file can be obtained from `pathconf' and `fpathconf'.

   _POSIX_CHOWN_RESTRICTED	Only the super user can use `chown' to change
				the owner of a file.  `chown' can only be used
				to change the group ID of a file to a group of
				which the calling process is a member.
   _POSIX_NO_TRUNC		Pathname components longer than
				NAME_MAX generate an error.
   _POSIX_VDISABLE		If defined, if the value of an element of the
				`c_cc' member of `struct termios' is
				_POSIX_VDISABLE, no character will have the
				effect associated with that element.
   _POSIX_SYNC_IO		Synchronous I/O may be performed.
   _POSIX_ASYNC_IO		Asynchronous I/O may be performed.
   _POSIX_PRIO_IO		Prioritized Asynchronous I/O may be performed.

   Support for the Large File Support interface is not generally available.
   If it is available the following constants are defined to one.
   _LFS64_LARGEFILE		Low-level I/O supports large files.
   _LFS64_STDIO			Standard I/O supports large files.
   */

##including bits/posix_opt.h
/* Define POSIX options for Linux.
   Copyright (C) 1996-2004, 2006, 2008, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If not,
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

#if 1
/* Job control is supported.  */
/* Processes have a saved set-user-ID and a saved set-group-ID.  */
/* Priority scheduling is supported.  */
/* Synchronizing file data is supported.  */
/* The fsync function is present.  */
/* Mapping of files to memory is supported.  */
/* Locking of all memory is supported.  */
/* Locking of ranges of memory is supported.  */
/* Setting of memory protections is supported.  */
/* Some filesystems allow all users to change file ownership.  */
/* `c_cc' member of 'struct termios' structure can be disabled by
   using the value _POSIX_VDISABLE.  */
/* Filenames are not silently truncated.  */
/* X/Open realtime support is available.  */
/* X/Open thread realtime support is available.  */
/* XPG4.2 shared memory is supported.  */
/* Tell we have POSIX threads.  */
/* We have the reentrant functions described in POSIX.  */
/* We provide priority scheduling for threads.  */
/* We support user-defined stack sizes.  */
/* We support user-defined stacks.  */
/* We support priority inheritence.  */
/* We support priority protection, though only for non-robust
   mutexes.  */
#if 1
/* We support priority inheritence for robust mutexes.  */
/* We do not support priority protection for robust mutexes.  */
#endif
/* We support POSIX.1b semaphores.  */
/* Real-time signals are supported.  */
/* We support asynchronous I/O.  */
/* Alternative name for Unix98.  */
/* Support for prioritization is also available.  */
/* The LFS support in asynchronous I/O is also available.  */
/* The rest of the LFS is also available.  */
/* POSIX shared memory objects are implemented.  */
/* CPU-time clocks support needs to be checked at runtime.  */
/* Clock support in threads must be also checked at runtime.  */
/* GNU libc provides regular expression handling.  */
/* Reader/Writer locks are available.  */
/* We have a POSIX shell.  */
/* We support the Timeouts option.  */
/* We support spinlocks.  */
/* The `spawn' function family is supported.  */
/* We have POSIX timers.  */
/* The barrier functions are available.  */
/* POSIX message queues are available.  */
/* Thread process-shared synchronization is supported.  */
/* The monotonic clock might be available.  */
/* The clock selection interfaces are available.  */
/* Advisory information interfaces are available.  */
/* IPv6 support is available.  */
/* Raw socket support is available.  */
/* We have at least one terminal.  */
/* Neither process nor thread sporadic server interfaces is available.  */
/* trace.h is not available.  */
/* Typed memory objects are not available.  */
/* Streams are not available.  */
#endif
/* Get the environment definitions from Unix98.  */
#if 1
##including bits/environments.h
/* Copyright (C) 1999, 2001, 2004, 2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if 1
#endif
/* This header should define the following symbols under the described
   situations.  A value `1' means that the model is always supported,
   `-1' means it is never supported.  Undefined means it cannot be
   statically decided.

   _POSIX_V7_ILP32_OFF32   32bit int, long, pointers, and off_t type
   _POSIX_V7_ILP32_OFFBIG  32bit int, long, and pointers and larger off_t type

   _POSIX_V7_LP64_OFF32	   64bit long and pointers and 32bit off_t type
   _POSIX_V7_LPBIG_OFFBIG  64bit long and pointers and large off_t type

   The macros _POSIX_V6_ILP32_OFF32, _POSIX_V6_ILP32_OFFBIG,
   _POSIX_V6_LP64_OFF32, _POSIX_V6_LPBIG_OFFBIG, _XBS5_ILP32_OFF32,
   _XBS5_ILP32_OFFBIG, _XBS5_LP64_OFF32, and _XBS5_LPBIG_OFFBIG were
   used in previous versions of the Unix standard and are available
   only for compatibility.
*/

#if 1
/* Environments with 32-bit wide pointers are optionally provided.
   Therefore following macros aren't defined:
   # undef _POSIX_V7_ILP32_OFF32
   # undef _POSIX_V7_ILP32_OFFBIG
   # undef _POSIX_V6_ILP32_OFF32
   # undef _POSIX_V6_ILP32_OFFBIG
   # undef _XBS5_ILP32_OFF32
   # undef _XBS5_ILP32_OFFBIG
   and users need to check at runtime.  */

/* We also have no use (for now) for an environment with bigger pointers
   and offsets.  */
/* By default we have 64-bit wide `long int', pointers and `off_t'.  */
#endif
#endif
/* Standard file descriptors.  */
/* All functions that are not declared anywhere else.  */

##including bits/types.h
#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
#if 1
/* The Single Unix specification says that some more types are
   available here.  */
#endif
#endif
#endif
#endif
#if 1
typedef __useconds_t useconds_t;
#endif
#endif
#endif
#if 1
#endif
#endif
#if 1
#endif
#endif
/* Values for the second argument to access.
   These may be OR'd together.  */
/* Test for access to NAME using the real UID and real GID.  */
extern int access (const char *__name, int __type) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#endif
#if 1
/* Test for access to FILE relative to the directory FD is open on.
   If AT_EACCESS is set in FLAG, then use effective IDs like `eaccess',
   otherwise use real IDs like `access'.  */
extern int faccessat (int __fd, const char *__file, int __type, int __flag)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2))) ;
#endif
/* Values for the WHENCE argument to lseek.  */
#endif
#if 1
/* Old BSD names for the same constants; just for compatibility.  */
#endif
/* Move FD's file position to OFFSET bytes from the
   beginning of the file (if WHENCE is SEEK_SET),
   the current position (if WHENCE is SEEK_CUR),
   or the end of the file (if WHENCE is SEEK_END).
   Return the new file position.  */
#if 1
extern __off_t lseek (int __fd, __off_t __offset, int __whence) __attribute__((__nothrow__));
#endif
#endif
/* Close the file descriptor FD.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int close (int __fd);

/* Read NBYTES into BUF from FD.  Return the
   number read, -1 for errors or 0 for EOF.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t read (int __fd, void *__buf, size_t __nbytes) ;

/* Write N bytes of BUF to FD.  Return the number written, or -1.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t write (int __fd, const void *__buf, size_t __n) ;

#if 1
#if 1
/* Read NBYTES into BUF from FD at the given position OFFSET without
   changing the file pointer.  Return the number read, -1 for errors
   or 0 for EOF.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t pread (int __fd, void *__buf, size_t __nbytes,
		      __off_t __offset) ;

/* Write N bytes of BUF to FD at the given position OFFSET without
   changing the file pointer.  Return the number written, or -1.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern ssize_t pwrite (int __fd, const void *__buf, size_t __n,
		       __off_t __offset) ;
#endif
#endif
#endif
/* Create a one-way communication channel (pipe).
   If successful, two file descriptors are stored in PIPEDES;
   bytes written on PIPEDES[1] can be read from PIPEDES[0].
   Returns 0 if successful, -1 if not.  */
extern int pipe (int __pipedes[2]) __attribute__((__nothrow__)) ;

#endif
/* Schedule an alarm.  In SECONDS seconds, the process will get a SIGALRM.
   If SECONDS is zero, any currently scheduled alarm will be cancelled.
   The function returns the number of seconds remaining until the last
   alarm scheduled would have signaled, or zero if there wasn't one.
   There is no return value to indicate an error, but you can set `errno'
   to 0 and check its value after calling `alarm', and this might tell you.
   The signal may come late due to processor scheduling.  */
extern unsigned int alarm (unsigned int __seconds) __attribute__((__nothrow__));

/* Make the process sleep for SECONDS seconds, or until a signal arrives
   and is not ignored.  The function returns the number of seconds less
   than SECONDS which it actually slept (thus zero if it slept the full time).
   If a signal handler does a `longjmp' or modifies the handling of the
   SIGALRM signal while inside `sleep' call, the handling of the SIGALRM
   signal afterwards is undefined.  There is no return value to indicate
   error, but if `sleep' returns SECONDS, it probably didn't work.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern unsigned int sleep (unsigned int __seconds);

#if 1
/* Set an alarm to go off (generating a SIGALRM signal) in VALUE
   microseconds.  If INTERVAL is nonzero, when the alarm goes off, the
   timer is reset to go off every INTERVAL microseconds thereafter.
   Returns the number of microseconds remaining before the alarm.  */
extern __useconds_t ualarm (__useconds_t __value, __useconds_t __interval)
     __attribute__((__nothrow__));

/* Sleep USECONDS microseconds, or until a signal arrives that is not blocked
   or ignored.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int usleep (__useconds_t __useconds);
#endif
/* Suspend the process until a signal arrives.
   This always returns -1 and sets `errno' to EINTR.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int pause (void);


/* Change the owner and group of FILE.  */
extern int chown (const char *__file, __uid_t __owner, __gid_t __group)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

#if 1
/* Change the owner and group of the file that FD is open on.  */
extern int fchown (int __fd, __uid_t __owner, __gid_t __group) __attribute__((__nothrow__)) ;


/* Change owner and group of FILE, if it is a symbolic
   link the ownership of the symbolic link is changed.  */
extern int lchown (const char *__file, __uid_t __owner, __gid_t __group)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

#endif
#if 1
/* Change the owner and group of FILE relative to the directory FD is open
   on.  */
extern int fchownat (int __fd, const char *__file, __uid_t __owner,
		     __gid_t __group, int __flag)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2))) ;
#endif
/* Change the process's working directory to PATH.  */
extern int chdir (const char *__path) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

#if 1
/* Change the process's working directory to the one FD is open on.  */
extern int fchdir (int __fd) __attribute__((__nothrow__)) ;
#endif
/* Get the pathname of the current working directory,
   and put it in SIZE bytes of BUF.  Returns NULL if the
   directory couldn't be determined or SIZE was too small.
   If successful, returns BUF.  In GNU, if BUF is NULL,
   an array is allocated with `malloc'; the array is SIZE
   bytes long, unless SIZE == 0, in which case it is as
   big as necessary.  */
extern char *getcwd (char *__buf, size_t __size) __attribute__((__nothrow__)) ;

#endif
#if 1
/* Put the absolute pathname of the current working directory in BUF.
   If successful, return BUF.  If not, put an error message in
   BUF and return NULL.  BUF should be at least PATH_MAX bytes long.  */
extern char *getwd (char *__buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) __attribute__((__deprecated__)) ;
#endif
/* Duplicate FD, returning a new file descriptor on the same file.  */
extern int dup (int __fd) __attribute__((__nothrow__)) ;

/* Duplicate FD to FD2, closing FD2 and making it open on the same file.  */
extern int dup2 (int __fd, int __fd2) __attribute__((__nothrow__));

#endif
/* NULL-terminated array of "NAME=VALUE" environment variables.  */
extern char **__environ;
#endif
/* Replace the current process, executing PATH with arguments ARGV and
   environment ENVP.  ARGV and ENVP are terminated by NULL pointers.  */
extern int execve (const char *__path, char *const __argv[],
		   char *const __envp[]) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

#if 1
/* Execute the file FD refers to, overlaying the running program image.
   ARGV and ENVP are passed to the new program, as for `execve'.  */
extern int fexecve (int __fd, char *const __argv[], char *const __envp[])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
/* Execute PATH with arguments ARGV and environment from `environ'.  */
extern int execv (const char *__path, char *const __argv[])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Execute PATH with all arguments after PATH until a NULL pointer,
   and the argument after that for environment.  */
extern int execle (const char *__path, const char *__arg, ...)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Execute PATH with all arguments after PATH until
   a NULL pointer and environment from `environ'.  */
extern int execl (const char *__path, const char *__arg, ...)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Execute FILE, searching in the `PATH' environment variable if it contains
   no slashes, with arguments ARGV and environment from `environ'.  */
extern int execvp (const char *__file, char *const __argv[])
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

/* Execute FILE, searching in the `PATH' environment variable if
   it contains no slashes, with all arguments after FILE until a
   NULL pointer and environment from `environ'.  */
extern int execlp (const char *__file, const char *__arg, ...)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));

#endif
#if 1
/* Add INC to priority of the current process.  */
extern int nice (int __inc) __attribute__((__nothrow__)) ;
#endif
/* Terminate program execution with the low-order 8 bits of STATUS.  */
extern void _exit (int __status) __attribute__ ((__noreturn__));


/* Get the `_PC_*' symbols for the NAME argument to `pathconf' and `fpathconf';
   the `_SC_*' symbols for the NAME argument to `sysconf';
   and the `_CS_*' symbols for the NAME argument to `confstr'.  */
##including bits/confname.h
/* `sysconf', `pathconf', and `confstr' NAME values.  Generic version.
   Copyright (C) 1993,1995-1998,2000,2001,2003,2004,2007,2009,2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
/* Values for the NAME argument to `pathconf' and `fpathconf'.  */
enum
  {
    _PC_LINK_MAX,
_PC_MAX_CANON,
_PC_MAX_INPUT,
_PC_NAME_MAX,
_PC_PATH_MAX,
_PC_PIPE_BUF,
_PC_CHOWN_RESTRICTED,
_PC_NO_TRUNC,
_PC_VDISABLE,
_PC_SYNC_IO,
_PC_ASYNC_IO,
_PC_PRIO_IO,
_PC_SOCK_MAXBUF,
_PC_FILESIZEBITS,
_PC_REC_INCR_XFER_SIZE,
_PC_REC_MAX_XFER_SIZE,
_PC_REC_MIN_XFER_SIZE,
_PC_REC_XFER_ALIGN,
_PC_ALLOC_SIZE_MIN,
_PC_SYMLINK_MAX,
_PC_2_SYMLINKS
};

/* Values for the argument to `sysconf'.  */
enum
  {
    _SC_ARG_MAX,
_SC_CHILD_MAX,
_SC_CLK_TCK,
_SC_NGROUPS_MAX,
_SC_OPEN_MAX,
_SC_STREAM_MAX,
_SC_TZNAME_MAX,
_SC_JOB_CONTROL,
_SC_SAVED_IDS,
_SC_REALTIME_SIGNALS,
_SC_PRIORITY_SCHEDULING,
_SC_TIMERS,
_SC_ASYNCHRONOUS_IO,
_SC_PRIORITIZED_IO,
_SC_SYNCHRONIZED_IO,
_SC_FSYNC,
_SC_MAPPED_FILES,
_SC_MEMLOCK,
_SC_MEMLOCK_RANGE,
_SC_MEMORY_PROTECTION,
_SC_MESSAGE_PASSING,
_SC_SEMAPHORES,
_SC_SHARED_MEMORY_OBJECTS,
_SC_AIO_LISTIO_MAX,
_SC_AIO_MAX,
_SC_AIO_PRIO_DELTA_MAX,
_SC_DELAYTIMER_MAX,
_SC_MQ_OPEN_MAX,
_SC_MQ_PRIO_MAX,
_SC_VERSION,
_SC_PAGESIZE,
_SC_RTSIG_MAX,
_SC_SEM_NSEMS_MAX,
_SC_SEM_VALUE_MAX,
_SC_SIGQUEUE_MAX,
_SC_TIMER_MAX,
/* Values for the argument to `sysconf'
       corresponding to _POSIX2_* symbols.  */
    _SC_BC_BASE_MAX,
_SC_BC_DIM_MAX,
_SC_BC_SCALE_MAX,
_SC_BC_STRING_MAX,
_SC_COLL_WEIGHTS_MAX,
_SC_EQUIV_CLASS_MAX,
_SC_EXPR_NEST_MAX,
_SC_LINE_MAX,
_SC_RE_DUP_MAX,
_SC_CHARCLASS_NAME_MAX,
_SC_2_VERSION,
_SC_2_C_BIND,
_SC_2_C_DEV,
_SC_2_FORT_DEV,
_SC_2_FORT_RUN,
_SC_2_SW_DEV,
_SC_2_LOCALEDEF,
_SC_PII,
_SC_PII_XTI,
_SC_PII_SOCKET,
_SC_PII_INTERNET,
_SC_PII_OSI,
_SC_POLL,
_SC_SELECT,
_SC_UIO_MAXIOV,
_SC_IOV_MAX = _SC_UIO_MAXIOV,
_SC_PII_INTERNET_STREAM,
_SC_PII_INTERNET_DGRAM,
_SC_PII_OSI_COTS,
_SC_PII_OSI_CLTS,
_SC_PII_OSI_M,
_SC_T_IOV_MAX,
/* Values according to POSIX 1003.1c (POSIX threads).  */
    _SC_THREADS,
_SC_THREAD_SAFE_FUNCTIONS,
_SC_GETGR_R_SIZE_MAX,
_SC_GETPW_R_SIZE_MAX,
_SC_LOGIN_NAME_MAX,
_SC_TTY_NAME_MAX,
_SC_THREAD_DESTRUCTOR_ITERATIONS,
_SC_THREAD_KEYS_MAX,
_SC_THREAD_STACK_MIN,
_SC_THREAD_THREADS_MAX,
_SC_THREAD_ATTR_STACKADDR,
_SC_THREAD_ATTR_STACKSIZE,
_SC_THREAD_PRIORITY_SCHEDULING,
_SC_THREAD_PRIO_INHERIT,
_SC_THREAD_PRIO_PROTECT,
_SC_THREAD_PROCESS_SHARED,
_SC_NPROCESSORS_CONF,
_SC_NPROCESSORS_ONLN,
_SC_PHYS_PAGES,
_SC_AVPHYS_PAGES,
_SC_ATEXIT_MAX,
_SC_PASS_MAX,
_SC_XOPEN_VERSION,
_SC_XOPEN_XCU_VERSION,
_SC_XOPEN_UNIX,
_SC_XOPEN_CRYPT,
_SC_XOPEN_ENH_I18N,
_SC_XOPEN_SHM,
_SC_2_CHAR_TERM,
_SC_2_C_VERSION,
_SC_2_UPE,
_SC_XOPEN_XPG2,
_SC_XOPEN_XPG3,
_SC_XOPEN_XPG4,
_SC_CHAR_BIT,
_SC_CHAR_MAX,
_SC_CHAR_MIN,
_SC_INT_MAX,
_SC_INT_MIN,
_SC_LONG_BIT,
_SC_WORD_BIT,
_SC_MB_LEN_MAX,
_SC_NZERO,
_SC_SSIZE_MAX,
_SC_SCHAR_MAX,
_SC_SCHAR_MIN,
_SC_SHRT_MAX,
_SC_SHRT_MIN,
_SC_UCHAR_MAX,
_SC_UINT_MAX,
_SC_ULONG_MAX,
_SC_USHRT_MAX,
_SC_NL_ARGMAX,
_SC_NL_LANGMAX,
_SC_NL_MSGMAX,
_SC_NL_NMAX,
_SC_NL_SETMAX,
_SC_NL_TEXTMAX,
_SC_XBS5_ILP32_OFF32,
_SC_XBS5_ILP32_OFFBIG,
_SC_XBS5_LP64_OFF64,
_SC_XBS5_LPBIG_OFFBIG,
_SC_XOPEN_LEGACY,
_SC_XOPEN_REALTIME,
_SC_XOPEN_REALTIME_THREADS,
_SC_ADVISORY_INFO,
_SC_BARRIERS,
_SC_BASE,
_SC_C_LANG_SUPPORT,
_SC_C_LANG_SUPPORT_R,
_SC_CLOCK_SELECTION,
_SC_CPUTIME,
_SC_THREAD_CPUTIME,
_SC_DEVICE_IO,
_SC_DEVICE_SPECIFIC,
_SC_DEVICE_SPECIFIC_R,
_SC_FD_MGMT,
_SC_FIFO,
_SC_PIPE,
_SC_FILE_ATTRIBUTES,
_SC_FILE_LOCKING,
_SC_FILE_SYSTEM,
_SC_MONOTONIC_CLOCK,
_SC_MULTI_PROCESS,
_SC_SINGLE_PROCESS,
_SC_NETWORKING,
_SC_READER_WRITER_LOCKS,
_SC_SPIN_LOCKS,
_SC_REGEXP,
_SC_REGEX_VERSION,
_SC_SHELL,
_SC_SIGNALS,
_SC_SPAWN,
_SC_SPORADIC_SERVER,
_SC_THREAD_SPORADIC_SERVER,
_SC_SYSTEM_DATABASE,
_SC_SYSTEM_DATABASE_R,
_SC_TIMEOUTS,
_SC_TYPED_MEMORY_OBJECTS,
_SC_USER_GROUPS,
_SC_USER_GROUPS_R,
_SC_2_PBS,
_SC_2_PBS_ACCOUNTING,
_SC_2_PBS_LOCATE,
_SC_2_PBS_MESSAGE,
_SC_2_PBS_TRACK,
_SC_SYMLOOP_MAX,
_SC_STREAMS,
_SC_2_PBS_CHECKPOINT,
_SC_V6_ILP32_OFF32,
_SC_V6_ILP32_OFFBIG,
_SC_V6_LP64_OFF64,
_SC_V6_LPBIG_OFFBIG,
_SC_HOST_NAME_MAX,
_SC_TRACE,
_SC_TRACE_EVENT_FILTER,
_SC_TRACE_INHERIT,
_SC_TRACE_LOG,
_SC_LEVEL1_ICACHE_SIZE,
_SC_LEVEL1_ICACHE_ASSOC,
_SC_LEVEL1_ICACHE_LINESIZE,
_SC_LEVEL1_DCACHE_SIZE,
_SC_LEVEL1_DCACHE_ASSOC,
_SC_LEVEL1_DCACHE_LINESIZE,
_SC_LEVEL2_CACHE_SIZE,
_SC_LEVEL2_CACHE_ASSOC,
_SC_LEVEL2_CACHE_LINESIZE,
_SC_LEVEL3_CACHE_SIZE,
_SC_LEVEL3_CACHE_ASSOC,
_SC_LEVEL3_CACHE_LINESIZE,
_SC_LEVEL4_CACHE_SIZE,
_SC_LEVEL4_CACHE_ASSOC,
_SC_LEVEL4_CACHE_LINESIZE,
/* Leave room here, maybe we need a few more cache levels some day.  */

    _SC_IPV6 = _SC_LEVEL1_ICACHE_SIZE + 50,
_SC_RAW_SOCKETS,
_SC_V7_ILP32_OFF32,
_SC_V7_ILP32_OFFBIG,
_SC_V7_LP64_OFF64,
_SC_V7_LPBIG_OFFBIG,
_SC_SS_REPL_MAX,
_SC_TRACE_EVENT_NAME_MAX,
_SC_TRACE_NAME_MAX,
_SC_TRACE_SYS_MAX,
_SC_TRACE_USER_EVENT_MAX,
_SC_XOPEN_STREAMS,
_SC_THREAD_ROBUST_PRIO_INHERIT,
_SC_THREAD_ROBUST_PRIO_PROTECT
};

/* Values for the NAME argument to `confstr'.  */
enum
  {
    _CS_PATH,			/* The default search path.  */
_CS_V6_WIDTH_RESTRICTED_ENVS,
_CS_GNU_LIBC_VERSION,
_CS_GNU_LIBPTHREAD_VERSION,
_CS_V5_WIDTH_RESTRICTED_ENVS,
_CS_V7_WIDTH_RESTRICTED_ENVS,
_CS_LFS_CFLAGS = 1000,
_CS_LFS_LDFLAGS,
_CS_LFS_LIBS,
_CS_LFS_LINTFLAGS,
_CS_LFS64_CFLAGS,
_CS_LFS64_LDFLAGS,
_CS_LFS64_LIBS,
_CS_LFS64_LINTFLAGS,
_CS_XBS5_ILP32_OFF32_CFLAGS = 1100,
_CS_XBS5_ILP32_OFF32_LDFLAGS,
_CS_XBS5_ILP32_OFF32_LIBS,
_CS_XBS5_ILP32_OFF32_LINTFLAGS,
_CS_XBS5_ILP32_OFFBIG_CFLAGS,
_CS_XBS5_ILP32_OFFBIG_LDFLAGS,
_CS_XBS5_ILP32_OFFBIG_LIBS,
_CS_XBS5_ILP32_OFFBIG_LINTFLAGS,
_CS_XBS5_LP64_OFF64_CFLAGS,
_CS_XBS5_LP64_OFF64_LDFLAGS,
_CS_XBS5_LP64_OFF64_LIBS,
_CS_XBS5_LP64_OFF64_LINTFLAGS,
_CS_XBS5_LPBIG_OFFBIG_CFLAGS,
_CS_XBS5_LPBIG_OFFBIG_LDFLAGS,
_CS_XBS5_LPBIG_OFFBIG_LIBS,
_CS_XBS5_LPBIG_OFFBIG_LINTFLAGS,
_CS_POSIX_V6_ILP32_OFF32_CFLAGS,
_CS_POSIX_V6_ILP32_OFF32_LDFLAGS,
_CS_POSIX_V6_ILP32_OFF32_LIBS,
_CS_POSIX_V6_ILP32_OFF32_LINTFLAGS,
_CS_POSIX_V6_ILP32_OFFBIG_CFLAGS,
_CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS,
_CS_POSIX_V6_ILP32_OFFBIG_LIBS,
_CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS,
_CS_POSIX_V6_LP64_OFF64_CFLAGS,
_CS_POSIX_V6_LP64_OFF64_LDFLAGS,
_CS_POSIX_V6_LP64_OFF64_LIBS,
_CS_POSIX_V6_LP64_OFF64_LINTFLAGS,
_CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS,
_CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS,
_CS_POSIX_V6_LPBIG_OFFBIG_LIBS,
_CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS,
_CS_POSIX_V7_ILP32_OFF32_CFLAGS,
_CS_POSIX_V7_ILP32_OFF32_LDFLAGS,
_CS_POSIX_V7_ILP32_OFF32_LIBS,
_CS_POSIX_V7_ILP32_OFF32_LINTFLAGS,
_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS,
_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS,
_CS_POSIX_V7_ILP32_OFFBIG_LIBS,
_CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS,
_CS_POSIX_V7_LP64_OFF64_CFLAGS,
_CS_POSIX_V7_LP64_OFF64_LDFLAGS,
_CS_POSIX_V7_LP64_OFF64_LIBS,
_CS_POSIX_V7_LP64_OFF64_LINTFLAGS,
_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS,
_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS,
_CS_POSIX_V7_LPBIG_OFFBIG_LIBS,
_CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS,
_CS_V6_ENV,
_CS_V7_ENV
};
/* Get file-specific configuration information about PATH.  */
extern long int pathconf (const char *__path, int __name)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

/* Get file-specific configuration about descriptor FD.  */
extern long int fpathconf (int __fd, int __name) __attribute__((__nothrow__));

/* Get the value of the system variable NAME.  */
extern long int sysconf (int __name) __attribute__((__nothrow__));

#if 1
/* Get the value of the string-valued system variable NAME.  */
extern size_t confstr (int __name, char *__buf, size_t __len) __attribute__((__nothrow__));
#endif
/* Get the process ID of the calling process.  */
extern __pid_t getpid (void) __attribute__((__nothrow__));

/* Get the process ID of the calling process's parent.  */
extern __pid_t getppid (void) __attribute__((__nothrow__));

/* Get the process group ID of the calling process.
   This function is different on old BSD. */
#if 1
extern __pid_t getpgrp (void) __attribute__((__nothrow__));
#endif
/* Get the process group ID of process PID.  */
extern __pid_t __getpgid (__pid_t __pid) __attribute__((__nothrow__));
#if 1
extern __pid_t getpgid (__pid_t __pid) __attribute__((__nothrow__));
#endif
/* Set the process group ID of the process matching PID to PGID.
   If PID is zero, the current process's process group ID is set.
   If PGID is zero, the process ID of the process is used.  */
extern int setpgid (__pid_t __pid, __pid_t __pgid) __attribute__((__nothrow__));

#if 1
/* Both System V and BSD have `setpgrp' functions, but with different
   calling conventions.  The BSD function is the same as POSIX.1 `setpgid'
   (above).  The System V function takes no arguments and puts the calling
   process in its on group like `setpgid (0, 0)'.

   New programs should always use `setpgid' instead.

   The default in GNU is to provide the System V function.  The BSD
   function is available under -D_BSD_SOURCE.  */

#if 1
/* Set the process group ID of the calling process to its own PID.
   This is exactly the same as `setpgid (0, 0)'.  */
extern int setpgrp (void) __attribute__((__nothrow__));

#endif
#endif
/* Create a new session with the calling process as its leader.
   The process group IDs of the session and the calling process
   are set to the process ID of the calling process, which is returned.  */
extern __pid_t setsid (void) __attribute__((__nothrow__));

#if 1
/* Return the session ID of the given process.  */
extern __pid_t getsid (__pid_t __pid) __attribute__((__nothrow__));
#endif
/* Get the real user ID of the calling process.  */
extern __uid_t getuid (void) __attribute__((__nothrow__));

/* Get the effective user ID of the calling process.  */
extern __uid_t geteuid (void) __attribute__((__nothrow__));

/* Get the real group ID of the calling process.  */
extern __gid_t getgid (void) __attribute__((__nothrow__));

/* Get the effective group ID of the calling process.  */
extern __gid_t getegid (void) __attribute__((__nothrow__));

/* If SIZE is zero, return the number of supplementary groups
   the calling process is in.  Otherwise, fill in the group IDs
   of its supplementary groups in LIST and return the number written.  */
extern int getgroups (int __size, __gid_t __list[]) __attribute__((__nothrow__)) ;

#endif
/* Set the user ID of the calling process to UID.
   If the calling process is the super-user, set the real
   and effective user IDs, and the saved set-user-ID to UID;
   if not, the effective user ID is set to UID.  */
extern int setuid (__uid_t __uid) __attribute__((__nothrow__));

#if 1
/* Set the real user ID of the calling process to RUID,
   and the effective user ID of the calling process to EUID.  */
extern int setreuid (__uid_t __ruid, __uid_t __euid) __attribute__((__nothrow__));
#endif
#if 1
/* Set the effective user ID of the calling process to UID.  */
extern int seteuid (__uid_t __uid) __attribute__((__nothrow__));
#endif
/* Set the group ID of the calling process to GID.
   If the calling process is the super-user, set the real
   and effective group IDs, and the saved set-group-ID to GID;
   if not, the effective group ID is set to GID.  */
extern int setgid (__gid_t __gid) __attribute__((__nothrow__));

#if 1
/* Set the real group ID of the calling process to RGID,
   and the effective group ID of the calling process to EGID.  */
extern int setregid (__gid_t __rgid, __gid_t __egid) __attribute__((__nothrow__));
#endif
#if 1
/* Set the effective group ID of the calling process to GID.  */
extern int setegid (__gid_t __gid) __attribute__((__nothrow__));
#endif
#endif
/* Clone the calling process, creating an exact copy.
   Return -1 for errors, 0 to the new process,
   and the process ID of the new process to the old process.  */
extern __pid_t fork (void) __attribute__((__nothrow__));

#if 1
/* Clone the calling process, but without copying the whole address space.
   The calling process is suspended until the new process exits or is
   replaced by a call to `execve'.  Return -1 for errors, 0 to the new process,
   and the process ID of the new process to the old process.  */
extern __pid_t vfork (void) __attribute__((__nothrow__));
#endif
/* Return the pathname of the terminal FD is open on, or NULL on errors.
   The returned storage is good only until the next call to this function.  */
extern char *ttyname (int __fd) __attribute__((__nothrow__));

/* Store at most BUFLEN characters of the pathname of the terminal FD is
   open on in BUF.  Return 0 on success, otherwise an error number.  */
extern int ttyname_r (int __fd, char *__buf, size_t __buflen)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2))) ;

/* Return 1 if FD is a valid descriptor associated
   with a terminal, zero if not.  */
extern int isatty (int __fd) __attribute__((__nothrow__));

#if 1
/* Return the index into the active-logins file (utmp) for
   the controlling terminal.  */
extern int ttyslot (void) __attribute__((__nothrow__));
#endif
/* Make a link to FROM named TO.  */
extern int link (const char *__from, const char *__to)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2))) ;

#if 1
/* Like link but relative paths in TO and FROM are interpreted relative
   to FROMFD and TOFD respectively.  */
extern int linkat (int __fromfd, const char *__from, int __tofd,
		   const char *__to, int __flags)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 4))) ;
#endif
#if 1
/* Make a symbolic link to FROM named TO.  */
extern int symlink (const char *__from, const char *__to)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2))) ;

/* Read the contents of the symbolic link PATH into no more than
   LEN bytes of BUF.  The contents are not null-terminated.
   Returns the number of characters read, or -1 for errors.  */
extern ssize_t readlink (const char *__restrict __path,
			 char *__restrict __buf, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2))) ;
#endif
#if 1
/* Like symlink but a relative path in TO is interpreted relative to TOFD.  */
extern int symlinkat (const char *__from, int __tofd,
		      const char *__to) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 3))) ;

/* Like readlink but a relative PATH is interpreted relative to FD.  */
extern ssize_t readlinkat (int __fd, const char *__restrict __path,
			   char *__restrict __buf, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2, 3))) ;
#endif
/* Remove the link NAME.  */
extern int unlink (const char *__name) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));

#if 1
/* Remove the link NAME relative to FD.  */
extern int unlinkat (int __fd, const char *__name, int __flag)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
/* Remove the directory PATH.  */
extern int rmdir (const char *__path) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));


/* Return the foreground process group ID of FD.  */
extern __pid_t tcgetpgrp (int __fd) __attribute__((__nothrow__));

/* Set the foreground process group ID of FD set PGRP_ID.  */
extern int tcsetpgrp (int __fd, __pid_t __pgrp_id) __attribute__((__nothrow__));


/* Return the login name of the user.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern char *getlogin (void);
#if 1
/* Return at most NAME_LEN characters of the login name of the user in NAME.
   If it cannot be determined or some other error occurred, return the error
   code.  Otherwise return 0.

   This function is a possible cancellation points and therefore not
   marked with __THROW.  */
extern int getlogin_r (char *__name, size_t __name_len) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* Set the login name returned by `getlogin'.  */
extern int setlogin (const char *__name) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* Get definitions and prototypes for functions to process the
   arguments in ARGV (ARGC of them, minus the program name) for
   options given in OPTS.  */
##including getopt.h
/* Declarations for getopt.
   Copyright (C) 1989-1994,1996-1999,2001,2003,2004,2009,2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
#endif
/* If __GNU_LIBRARY__ is not already defined, either we are being used
   standalone, or this is the first header included in the source file.
   If we are being used with glibc, we need to include <features.h>, but
   that does not exist if we are standalone.  So: if __GNU_LIBRARY__ is
   not defined, include <ctype.h>, which will pull in <features.h> for us
   if it's from glibc.  (Why ctype.h?  It's guaranteed to exist and it
   doesn't flood the namespace with stuff the way some other headers do.)  */
#endif
#endif
#endif
/* For communication from `getopt' to the caller.
   When `getopt' finds an option that takes an argument,
   the argument value is returned here.
   Also, when `ordering' is RETURN_IN_ORDER,
   each non-option ARGV-element is returned here.  */

extern char *optarg;

/* Index in ARGV of the next element to be scanned.
   This is used for communication to and from the caller
   and for communication between successive calls to `getopt'.

   On entry to `getopt', zero means this is the first call; initialize.

   When `getopt' returns -1, this is the index of the first of the
   non-option elements that the caller should itself scan.

   Otherwise, `optind' communicates from one call to the next
   how much of ARGV has been scanned so far.  */

extern int optind;

/* Callers store zero here to inhibit the error message `getopt' prints
   for unrecognized options.  */

extern int opterr;

/* Set to an option character which was unrecognized.  */

extern int optopt;

#endif
/* Get definitions and prototypes for functions to process the
   arguments in ARGV (ARGC of them, minus the program name) for
   options given in OPTS.

   Return the option character from OPTS just read.  Return -1 when
   there are no more options.  For unrecognized options, or options
   missing arguments, `optopt' is set to the option letter, and '?' is
   returned.

   The OPTS string is a list of characters which are recognized option
   letters, optionally followed by colons, specifying that that letter
   takes an argument, to be placed in `optarg'.

   If a letter in OPTS is followed by two colons, its argument is
   optional.  This behavior is specific to the GNU `getopt'.

   The argument `--' causes premature termination of argument
   scanning, explicitly telling `getopt' that there are no more
   options.

   If OPTS begins with `--', then non-option arguments are treated as
   arguments to the option '\0'.  This behavior is specific to the GNU
   `getopt'.  */

#if 1
/* Many other libraries have conflicting prototypes for getopt, with
   differences in the consts, in stdlib.h.  To avoid compilation
   errors, only prototype getopt for the GNU C library.  */
extern int getopt (int ___argc, char *const *___argv, const char *__shortopts)
       __attribute__((__nothrow__));

#endif
#endif
#endif
#endif
/* Make sure we later can get all the definitions and declarations.  */
#endif
#endif
#if 1
/* Put the name of the current host in no more than LEN bytes of NAME.
   The result is null-terminated if LEN is large enough for the full
   name and the terminator.  */
extern int gethostname (char *__name, size_t __len) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* Set the name of the current host to NAME, which is LEN bytes long.
   This call is restricted to the super-user.  */
extern int sethostname (const char *__name, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

/* Set the current machine's Internet number to ID.
   This call is restricted to the super-user.  */
extern int sethostid (long int __id) __attribute__((__nothrow__)) ;


/* Get and set the NIS (aka YP) domain name, if any.
   Called just like `gethostname' and `sethostname'.
   The NIS domain name is usually the empty string when not using NIS.  */
extern int getdomainname (char *__name, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
extern int setdomainname (const char *__name, size_t __len)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;


/* Revoke access permissions to all processes currently communicating
   with the control terminal, and then send a SIGHUP signal to the process
   group of the control terminal.  */
extern int vhangup (void) __attribute__((__nothrow__));

/* Revoke the access of all descriptors currently open on FILE.  */
extern int revoke (const char *__file) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;


/* Enable statistical profiling, writing samples of the PC into at most
   SIZE bytes of SAMPLE_BUFFER; every processor clock tick while profiling
   is enabled, the system examines the user PC and increments
   SAMPLE_BUFFER[((PC - OFFSET) / 2) * SCALE / 65536].  If SCALE is zero,
   disable profiling.  Returns zero on success, -1 on error.  */
extern int profil (unsigned short int *__sample_buffer, size_t __size,
		   size_t __offset, unsigned int __scale)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1)));


/* Turn accounting on if NAME is an existing file.  The system will then write
   a record for each process as it terminates, to this file.  If NAME is NULL,
   turn accounting off.  This call is restricted to the super-user.  */
extern int acct (const char *__name) __attribute__((__nothrow__));


/* Successive calls return the shells listed in `/etc/shells'.  */
extern char *getusershell (void) __attribute__((__nothrow__));
extern void endusershell (void) __attribute__((__nothrow__)); /* Discard cached info.  */
extern void setusershell (void) __attribute__((__nothrow__)); /* Rewind and re-read the file.  */


/* Put the program in the background, and dissociate from the controlling
   terminal.  If NOCHDIR is zero, do `chdir ("/")'.  If NOCLOSE is zero,
   redirects stdin, stdout, and stderr to /dev/null.  */
extern int daemon (int __nochdir, int __noclose) __attribute__((__nothrow__)) ;
#endif
#if 1
/* Make PATH be the root directory (the starting point for absolute paths).
   This call is restricted to the super-user.  */
extern int chroot (const char *__path) __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;

/* Prompt with PROMPT and read a string from the terminal without echoing.
   Uses /dev/tty if possible; otherwise stderr and stdin.  */
extern char *getpass (const char *__prompt) __attribute__((__nonnull__ (1)));
#endif
#if 1
/* Make all changes done to FD actually appear on disk.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int fsync (int __fd);
#endif
#if 1
/* Return identifier for the current host.  */
extern long int gethostid (void);

/* Make all changes done to all files actually appear on disk.  */
extern void sync (void) __attribute__((__nothrow__));


#if 1
/* Return the number of bytes in a page.  This is the system's page size,
   which is not necessarily the same as the hardware page size.  */
extern int getpagesize (void)  __attribute__((__nothrow__)) __attribute__ ((__const__));


/* Return the maximum number of file descriptors
   the current process could possibly have.  */
extern int getdtablesize (void) __attribute__((__nothrow__));
#endif
#endif
#if 1
/* Truncate FILE to LENGTH bytes.  */
#if 1
extern int truncate (const char *__file, __off_t __length)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1))) ;
#endif
#endif
/* Truncate the file FD is open on to LENGTH bytes.  */
#if 1
extern int ftruncate (int __fd, __off_t __length) __attribute__((__nothrow__)) ;
#endif
#endif
#endif
#if 1
/* Set the end of accessible data space (aka "the break") to ADDR.
   Returns zero on success and -1 for errors (with errno set).  */
extern int brk (void *__addr) __attribute__((__nothrow__)) ;

/* Increase or decrease the end of accessible data space by DELTA bytes.
   If successful, returns the address the previous end of data space
   (i.e. the beginning of the new space, if DELTA > 0);
   returns (void *) -1 for errors (with errno set).  */
extern void *sbrk (intptr_t __delta) __attribute__((__nothrow__));
#endif
#if 1
/* Invoke `system call' number SYSNO, passing it the remaining arguments.
   This is completely system-dependent, and not often useful.

   In Unix, `syscall' sets `errno' for all errors and most calls return -1
   for errors; in many systems you cannot pass arguments or get return
   values for all system calls (`pipe', `fork', and `getppid' typically
   among them).

   In Mach, all system calls take normal arguments and always return an
   error code (zero for success).  */
extern long int syscall (long int __sysno, ...) __attribute__((__nothrow__));

#endif
#endif
#endif
#if 1
/* Synchronize at least the data part of a file with the underlying
   media.  */
extern int fdatasync (int __fildes);
#endif
/* XPG4.2 specifies that prototypes for the encryption functions must
   be defined here.  */
#endif
/* The Single Unix specification demands this prototype to be here.
   It is also found in <stdio.h>.  */
#if 1
/* Return the name of the controlling terminal.  */
extern char *ctermid (char *__s) __attribute__((__nothrow__));
#endif
/* Define some macros helping to catch buffer overflows.  */
#endif


#endif
##including sys/param.h
/* Copyright (C) 1995-1997,2000,2001,2003,2008 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
#if 1
#endif
##including limits.h
##including linux/limits.h
##including linux/param.h
#if 1
##including asm/param.h
##including asm-generic/param.h
#if 1
#if 1
#endif
#if 1
#endif
#if 1
#endif
#endif
#endif
/* The kernel headers defines ARG_MAX.  The value is wrong, though.  */
#endif
/* BSD names for some <limits.h> values.  */

#if 1
#endif
/* The following are not really correct but it is a value we used for a
   long time and which seems to be usable.  People should not use NOFILE
   and NCARGS anyway.  */
##including sys/types.h
/* Bit map related macros.  */
/* Macros for counting and rounding.  */
#if 1
#endif
#if 1
#endif
/* Macros for min/max.  */
/* Unit of `st_blocks'.  */
#endif
#if 1
##including mntent.h
/* Utilities for reading/writing fstab, mtab, etc.
   Copyright (C) 1995, 1996, 1997, 1998, 1999 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including stdio.h
/* Define ISO C stdio on top of C++ iostreams.
   Copyright (C) 1991, 1994-2008, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.19 Input/output	<stdio.h>
 */

#endif
##including paths.h
/*
 * Copyright (c) 1989, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)paths.h	8.1 (Berkeley) 6/2/93
 */

#if 1
/* Default search path. */
/* All standard utilities path. */
/* Provide trailing slash, since mostly used for building pathnames. */
#endif
/* File listing canonical interesting mount points.  */
/* File listing currently active mount points.  */
/* General filesystem types.  */
/* Generic mount options.  */


/* Structure describing a mount table entry.  */
struct mntent
  {
    char *mnt_fsname;		/* Device or server for filesystem.  */
    char *mnt_dir;		/* Directory mounted on.  */
    char *mnt_type;		/* Type of filesystem: ufs, nfs, etc.  */
    char *mnt_opts;		/* Comma-separated options for fs.  */
    int mnt_freq;		/* Dump frequency (in days).  */
    int mnt_passno;		/* Pass number for `fsck'.  */
  };


/* Prepare to begin reading and/or writing mount table entries from the
   beginning of FILE.  MODE is as for `fopen'.  */
extern FILE *setmntent (const char *__file, const char *__mode) __attribute__((__nothrow__));

/* Read one mount table entry from STREAM.  Returns a pointer to storage
   reused on the next call, or null for EOF or error (use feof/ferror to
   check).  */
extern struct mntent *getmntent (FILE *__stream) __attribute__((__nothrow__));

#if 1
/* Reentrant version of the above function.  */
extern struct mntent *getmntent_r (FILE *__restrict __stream,
				   struct mntent *__restrict __result,
				   char *__restrict __buffer,
				   int __bufsize) __attribute__((__nothrow__));
#endif
/* Write the mount table entry described by MNT to STREAM.
   Return zero on success, nonzero on failure.  */
extern int addmntent (FILE *__restrict __stream,
		      const struct mntent *__restrict __mnt) __attribute__((__nothrow__));

/* Close a stream opened with `setmntent'.  */
extern int endmntent (FILE *__stream) __attribute__((__nothrow__));

/* Search MNT->mnt_opts for an option matching OPT.
   Returns the address of the substring, or null if none found.  */
extern char *hasmntopt (const struct mntent *__mnt,
			const char *__opt) __attribute__((__nothrow__));




#endif
#endif
#if 1
##including sys/statfs.h
/* Definitions for getting information about a filesystem.
   Copyright (C) 1996, 1997, 1998, 1999, 2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
/* Get the system-specific definition of `struct statfs'.  */
##including bits/statfs.h
/* Copyright (C) 1997, 1998, 2000, 2002, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
##including bits/types.h
struct statfs
  {
    longint f_type;
    longint f_bsize;
#if 1
__fsblkcnt_t f_blocks;
    __fsblkcnt_t f_bfree;
    __fsblkcnt_t f_bavail;
    __fsfilcnt_t f_files;
    __fsfilcnt_t f_ffree;
#endif
__fsid_t f_fsid;
    longint f_namelen;
    longint f_frsize;
    longint f_spare[5];
  };

#endif
/* Tell code we have these members.  */


/* Return information about the filesystem on which FILE resides.  */
#if 1
extern int statfs (const char *__file, struct statfs *__buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (1, 2)));
#endif
#endif
/* Return information about the filesystem containing the file FILDES
   refers to.  */
#if 1
extern int fstatfs (int __fildes, struct statfs *__buf)
     __attribute__((__nothrow__)) __attribute__((__nonnull__ (2)));
#endif
#endif


#endif
#endif
#if (defined CONFIG_SELINUX)
##including selinux/selinux.h
#if (defined CONFIG_SELINUX)
##including sys/types.h
##including stdarg.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2009 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.15  Variable arguments  <stdarg.h>
 */

#endif
#endif
/* Return 1 if we are running on a SELinux kernel, or 0 if not or -1 if we get an error. */
extern int is_selinux_enabled(void);
/* Return 1 if we are running on a SELinux MLS kernel, or 0 otherwise. */
extern int is_selinux_mls_enabled(void);

typedef char *security_context_t;

/* Free the memory allocated for a context by any of the below get* calls. */
extern void freecon(security_context_t con);

/* Free the memory allocated for a context array by security_compute_user. */
extern void freeconary(security_context_t * con);

/* Wrappers for the /proc/pid/attr API. */

/* Get current context, and set *con to refer to it.
   Caller must free via freecon. */
extern int getcon(security_context_t * con);
extern int getcon_raw(security_context_t * con);

/* Set the current security context to con.  
   Note that use of this function requires that the entire application
   be trusted to maintain any desired separation between the old and new 
   security contexts, unlike exec-based transitions performed via setexeccon.  
   When possible, decompose your application and use setexeccon()+execve() 
   instead. Note that the application may lose access to its open descriptors
   as a result of a setcon() unless policy allows it to use descriptors opened
   by the old context. */
extern int setcon(security_context_t con);
extern int setcon_raw(security_context_t con);

/* Get context of process identified by pid, and 
   set *con to refer to it.  Caller must free via freecon. */
extern int getpidcon(pid_t pid, security_context_t * con);
extern int getpidcon_raw(pid_t pid, security_context_t * con);

/* Get previous context (prior to last exec), and set *con to refer to it.
   Caller must free via freecon. */
extern int getprevcon(security_context_t * con);
extern int getprevcon_raw(security_context_t * con);

/* Get exec context, and set *con to refer to it.
   Sets *con to NULL if no exec context has been set, i.e. using default.
   If non-NULL, caller must free via freecon. */
extern int getexeccon(security_context_t * con);
extern int getexeccon_raw(security_context_t * con);

/* Set exec security context for the next execve. 
   Call with NULL if you want to reset to the default. */
extern int setexeccon(security_context_t con);
extern int setexeccon_raw(security_context_t con);

/* Get fscreate context, and set *con to refer to it.
   Sets *con to NULL if no fs create context has been set, i.e. using default.
   If non-NULL, caller must free via freecon. */
extern int getfscreatecon(security_context_t * con);
extern int getfscreatecon_raw(security_context_t * con);

/* Set the fscreate security context for subsequent file creations.
   Call with NULL if you want to reset to the default. */
extern int setfscreatecon(security_context_t context);
extern int setfscreatecon_raw(security_context_t context);

/* Get keycreate context, and set *con to refer to it.
   Sets *con to NULL if no key create context has been set, i.e. using default.
   If non-NULL, caller must free via freecon. */
extern int getkeycreatecon(security_context_t * con);
extern int getkeycreatecon_raw(security_context_t * con);

/* Set the keycreate security context for subsequent key creations.
   Call with NULL if you want to reset to the default. */
extern int setkeycreatecon(security_context_t context);
extern int setkeycreatecon_raw(security_context_t context);

/* Get sockcreate context, and set *con to refer to it.
   Sets *con to NULL if no socket create context has been set, i.e. using default.
   If non-NULL, caller must free via freecon. */
extern int getsockcreatecon(security_context_t * con);
extern int getsockcreatecon_raw(security_context_t * con);

/* Set the sockcreate security context for subsequent socket creations.
   Call with NULL if you want to reset to the default. */
extern int setsockcreatecon(security_context_t context);
extern int setsockcreatecon_raw(security_context_t context);

/* Wrappers for the xattr API. */

/* Get file context, and set *con to refer to it.
   Caller must free via freecon. */
extern int getfilecon(const char *path, security_context_t * con);
extern int getfilecon_raw(const char *path, security_context_t * con);
extern int lgetfilecon(const char *path, security_context_t * con);
extern int lgetfilecon_raw(const char *path, security_context_t * con);
extern int fgetfilecon(int fd, security_context_t * con);
extern int fgetfilecon_raw(int fd, security_context_t * con);

/* Set file context */
extern int setfilecon(const char *path, security_context_t con);
extern int setfilecon_raw(const char *path, security_context_t con);
extern int lsetfilecon(const char *path, security_context_t con);
extern int lsetfilecon_raw(const char *path, security_context_t con);
extern int fsetfilecon(int fd, security_context_t con);
extern int fsetfilecon_raw(int fd, security_context_t con);

/* Wrappers for the socket API */

/* Get context of peer socket, and set *con to refer to it.
   Caller must free via freecon. */
extern int getpeercon(int fd, security_context_t * con);
extern int getpeercon_raw(int fd, security_context_t * con);

/* Wrappers for the selinuxfs (policy) API. */

typedef unsigned int access_vector_t;
typedef unsigned short security_class_t;

struct av_decision {
	access_vector_t allowed;
	access_vector_t decided;
	access_vector_t auditallow;
	access_vector_t auditdeny;
	unsigned int seqno;
	unsigned int flags;
};

/* Definitions of av_decision.flags */
/* Structure for passing options, used by AVC and label subsystems */
struct selinux_opt {
	int type;
	const char *value;
};

/* Callback facilities */
union selinux_callback {
	/* log the printf-style format and arguments,
	   with the type code indicating the type of message */
	int 
#if (defined CONFIG_SELINUX)
__attribute__ ((format(printf, 2, 3)))
#endif
(*func_log) (int type, const char *fmt, ...);
	/* store a string representation of auditdata (corresponding
	   to the given security class) into msgbuf. */
	int (*func_audit) (void *auditdata, security_class_t cls,
			   char *msgbuf, size_t msgbufsize);
	/* validate the supplied context, modifying if necessary */
	int (*func_validate) (security_context_t *ctx);
	/* netlink callback for setenforce message */
	int (*func_setenforce) (int enforcing);
	/* netlink callback for policyload message */
	int (*func_policyload) (int seqno);
};

extern union selinux_callback selinux_get_callback(int type);
extern void selinux_set_callback(int type, union selinux_callback cb);

	/* Logging type codes, passed to the logging callback */
/* Compute an access decision. */
extern int security_compute_av(security_context_t scon,
			       security_context_t tcon,
			       security_class_t tclass,
			       access_vector_t requested,
			       struct av_decision *avd);
extern int security_compute_av_raw(security_context_t scon,
				   security_context_t tcon,
				   security_class_t tclass,
				   access_vector_t requested,
				   struct av_decision *avd);

extern int security_compute_av_flags(security_context_t scon,
				     security_context_t tcon,
				     security_class_t tclass,
				     access_vector_t requested,
				     struct av_decision *avd);
extern int security_compute_av_flags_raw(security_context_t scon,
					 security_context_t tcon,
					 security_class_t tclass,
					 access_vector_t requested,
					 struct av_decision *avd);

/* Compute a labeling decision and set *newcon to refer to it.
   Caller must free via freecon. */
extern int security_compute_create(security_context_t scon,
				   security_context_t tcon,
				   security_class_t tclass,
				   security_context_t * newcon);
extern int security_compute_create_raw(security_context_t scon,
				       security_context_t tcon,
				       security_class_t tclass,
				       security_context_t * newcon);

/* Compute a relabeling decision and set *newcon to refer to it.
   Caller must free via freecon. */
extern int security_compute_relabel(security_context_t scon,
				    security_context_t tcon,
				    security_class_t tclass,
				    security_context_t * newcon);
extern int security_compute_relabel_raw(security_context_t scon,
					security_context_t tcon,
					security_class_t tclass,
					security_context_t * newcon);

/* Compute a polyinstantiation member decision and set *newcon to refer to it.
   Caller must free via freecon. */
extern int security_compute_member(security_context_t scon,
				   security_context_t tcon,
				   security_class_t tclass,
				   security_context_t * newcon);
extern int security_compute_member_raw(security_context_t scon,
				       security_context_t tcon,
				       security_class_t tclass,
				       security_context_t * newcon);

/* Compute the set of reachable user contexts and set *con to refer to 
   the NULL-terminated array of contexts.  Caller must free via freeconary. */
extern int security_compute_user(security_context_t scon,
				 const char *username,
				 security_context_t ** con);
extern int security_compute_user_raw(security_context_t scon,
				     const char *username,
				     security_context_t ** con);

/* Load a policy configuration. */
extern int security_load_policy(void *data, size_t len);

/* Get the context of an initial kernel security identifier by name.  
   Caller must free via freecon */
extern int security_get_initial_context(const char *name,
					security_context_t * con);
extern int security_get_initial_context_raw(const char *name,
					    security_context_t * con);

/*
 * Make a policy image and load it.
 * This function provides a higher level interface for loading policy
 * than security_load_policy, internally determining the right policy
 * version, locating and opening the policy file, mapping it into memory,
 * manipulating it as needed for current boolean settings and/or local 
 * definitions, and then calling security_load_policy to load it.
 *
 * 'preservebools' is a boolean flag indicating whether current 
 * policy boolean values should be preserved into the new policy (if 1) 
 * or reset to the saved policy settings (if 0).  The former case is the
 * default for policy reloads, while the latter case is an option for policy
 * reloads but is primarily for the initial policy load.
 */
extern int selinux_mkload_policy(int preservebools);

/* 
 * Perform the initial policy load.
 * This function determines the desired enforcing mode, sets the
 * the *enforce argument accordingly for the caller to use, sets the 
 * SELinux kernel enforcing status to match it, and loads the policy.
 * It also internally handles the initial selinuxfs mount required to
 * perform these actions.
 *
 * The function returns 0 if everything including the policy load succeeds.
 * In this case, init is expected to re-exec itself in order to transition
 * to the proper security context.
 * Otherwise, the function returns -1, and init must check *enforce to
 * determine how to proceed.  If enforcing (*enforce > 0), then init should
 * halt the system.  Otherwise, init may proceed normally without a re-exec.
 */
extern int selinux_init_load_policy(int *enforce);

/* Translate boolean strict to name value pair. */
typedef struct {
	char *name;
	int value;
} SELboolean;
/* save a list of booleans in a single transaction.  */
extern int security_set_boolean_list(size_t boolcnt,
				     SELboolean * boollist, int permanent);

/* Load policy boolean settings.
   Path may be NULL, in which case the booleans are loaded from
   the active policy boolean configuration file. */
extern int security_load_booleans(char *path);

/* Check the validity of a security context. */
extern int security_check_context(security_context_t con);
extern int security_check_context_raw(security_context_t con);

/* Canonicalize a security context. */
extern int security_canonicalize_context(security_context_t con,
					 security_context_t * canoncon);
extern int security_canonicalize_context_raw(security_context_t con,
					     security_context_t * canoncon);

/* Get the enforce flag value. */
extern int security_getenforce(void);

/* Set the enforce flag value. */
extern int security_setenforce(int value);

/* Get the behavior for undefined classes/permissions */
extern int security_deny_unknown(void);

/* Disable SELinux at runtime (must be done prior to initial policy load). */
extern int security_disable(void);

/* Get the policy version number. */
extern int security_policyvers(void);

/* Get the boolean names */
extern int security_get_boolean_names(char ***names, int *len);

/* Get the pending value for the boolean */
extern int security_get_boolean_pending(const char *name);

/* Get the active value for the boolean */
extern int security_get_boolean_active(const char *name);

/* Set the pending value for the boolean */
extern int security_set_boolean(const char *name, int value);

/* Commit the pending values for the booleans */
extern int security_commit_booleans(void);

/* Userspace class mapping support */
struct security_class_mapping {
	const char *name;
	const char *perms[sizeof(access_vector_t) * 8 + 1];
};

extern int selinux_set_mapping(struct security_class_mapping *map);

/* Common helpers */

/* Convert between security class values and string names */
extern security_class_t string_to_security_class(const char *name);
extern const char *security_class_to_string(security_class_t cls);

/* Convert between individual access vector permissions and string names */
extern const char *security_av_perm_to_string(security_class_t tclass,
					      access_vector_t perm);
extern access_vector_t string_to_av_perm(security_class_t tclass,
					 const char *name);

/* Returns an access vector in a string representation.  User must free the
 * returned string via free(). */
extern int security_av_string(security_class_t tclass,
			      access_vector_t av, char **result);

/* Display an access vector in a string representation. */
extern void print_access_vector(security_class_t tclass, access_vector_t av);

/* Set the function used by matchpathcon_init when displaying
   errors about the file_contexts configuration.  If not set,
   then this defaults to fprintf(stderr, fmt, ...). */
extern void set_matchpathcon_printf(void (*f) (const char *fmt, ...));

/* Set the function used by matchpathcon_init when checking the
   validity of a context in the file contexts configuration.  If not set,
   then this defaults to a test based on security_check_context().  
   The function is also responsible for reporting any such error, and
   may include the 'path' and 'lineno' in such error messages. */
extern void set_matchpathcon_invalidcon(int (*f) (const char *path,
						  unsigned lineno,
						  char *context));

/* Same as above, but also allows canonicalization of the context,
   by changing *context to refer to the canonical form.  If not set,
   and invalidcon is also not set, then this defaults to calling
   security_canonicalize_context(). */
extern void set_matchpathcon_canoncon(int (*f) (const char *path,
						unsigned lineno,
						char **context));

/* Set flags controlling operation of matchpathcon_init or matchpathcon. */
extern void set_matchpathcon_flags(unsigned int flags);

/* Load the file contexts configuration specified by 'path'
   into memory for use by subsequent matchpathcon calls.  
   If 'path' is NULL, then load the active file contexts configuration,
   i.e. the path returned by selinux_file_context_path().
   Unless the MATCHPATHCON_BASEONLY flag has been set, this
   function also checks for a 'path'.homedirs file and 
   a 'path'.local file and loads additional specifications 
   from them if present. */
extern int matchpathcon_init(const char *path);

/* Same as matchpathcon_init, but only load entries with
   regexes that have stems that are prefixes of 'prefix'. */
extern int matchpathcon_init_prefix(const char *path, const char *prefix);

/* Free the memory allocated by matchpathcon_init. */
extern void matchpathcon_fini(void);

/* Match the specified pathname and mode against the file contexts
   configuration and set *con to refer to the resulting context.
   'mode' can be 0 to disable mode matching.
   Caller must free via freecon.
   If matchpathcon_init has not already been called, then this function
   will call it upon its first invocation with a NULL path. */
extern int matchpathcon(const char *path,
			mode_t mode, security_context_t * con);

/* Same as above, but return a specification index for 
   later use in a matchpathcon_filespec_add() call - see below. */
extern int matchpathcon_index(const char *path,
			      mode_t mode, security_context_t * con);

/* Maintain an association between an inode and a specification index,
   and check whether a conflicting specification is already associated
   with the same inode (e.g. due to multiple hard links).  If so, then
   use the latter of the two specifications based on their order in the 
   file contexts configuration.  Return the used specification index. */
extern int matchpathcon_filespec_add(ino_t ino, int specind, const char *file);

/* Destroy any inode associations that have been added, e.g. to restart
   for a new filesystem. */
extern void matchpathcon_filespec_destroy(void);

/* Display statistics on the hash table usage for the associations. */
extern void matchpathcon_filespec_eval(void);

/* Check to see whether any specifications had no matches and report them.
   The 'str' is used as a prefix for any warning messages. */
extern void matchpathcon_checkmatches(char *str);

/* Match the specified media and against the media contexts 
   configuration and set *con to refer to the resulting context.
   Caller must free con via freecon. */
extern int matchmediacon(const char *media, security_context_t * con);

/*
  selinux_getenforcemode reads the /etc/selinux/config file and determines 
  whether the machine should be started in enforcing (1), permissive (0) or 
  disabled (-1) mode.
 */
extern int selinux_getenforcemode(int *enforce);

/*
  selinux_getpolicytype reads the /etc/selinux/config file and determines 
  what the default policy for the machine is.  Calling application must 
  free policytype.
 */
extern int selinux_getpolicytype(char **policytype);

/*
  selinux_policy_root reads the /etc/selinux/config file and returns 
  the directory path under which the compiled policy file and context 
  configuration files exist.
 */
extern const char *selinux_policy_root(void);

/* These functions return the paths to specific files under the 
   policy root directory. */
extern const char *selinux_binary_policy_path(void);
extern const char *selinux_failsafe_context_path(void);
extern const char *selinux_removable_context_path(void);
extern const char *selinux_default_context_path(void);
extern const char *selinux_user_contexts_path(void);
extern const char *selinux_file_context_path(void);
extern const char *selinux_file_context_homedir_path(void);
extern const char *selinux_file_context_local_path(void);
extern const char *selinux_file_context_subs_path(void);
extern const char *selinux_homedir_context_path(void);
extern const char *selinux_media_context_path(void);
extern const char *selinux_virtual_domain_context_path(void);
extern const char *selinux_virtual_image_context_path(void);
extern const char *selinux_x_context_path(void);
extern const char *selinux_sepgsql_context_path(void);
extern const char *selinux_contexts_path(void);
extern const char *selinux_securetty_types_path(void);
extern const char *selinux_booleans_path(void);
extern const char *selinux_customizable_types_path(void);
extern const char *selinux_users_path(void);
extern const char *selinux_usersconf_path(void);
extern const char *selinux_translations_path(void);
extern const char *selinux_colors_path(void);
extern const char *selinux_netfilter_context_path(void);
extern const char *selinux_path(void);

/* Check a permission in the passwd class.
   Return 0 if granted or -1 otherwise. */
extern int selinux_check_passwd_access(access_vector_t requested);
extern int checkPasswdAccess(access_vector_t requested);

/* Check if the tty_context is defined as a securetty
   Return 0 if secure, < 0 otherwise. */
extern int selinux_check_securetty_context(security_context_t tty_context);

/* Set the path to the selinuxfs mount point explicitly.
   Normally, this is determined automatically during libselinux 
   initialization, but this is not always possible, e.g. for /sbin/init
   which performs the initial mount of selinuxfs. */
void set_selinuxmnt(char *mnt);

/* Execute a helper for rpm in an appropriate security context. */
extern int rpm_execcon(unsigned int verified,
		       const char *filename,
		       char *const argv[], char *const envp[]);

/* Returns whether a file context is customizable, and should not 
   be relabeled . */
extern int is_context_customizable(security_context_t scontext);

/* Perform context translation between the human-readable format
   ("translated") and the internal system format ("raw"). 
   Caller must free the resulting context via freecon.  
   Returns -1 upon an error or 0 otherwise.
   If passed NULL, sets the returned context to NULL and returns 0. */
extern int selinux_trans_to_raw_context(security_context_t trans,
					security_context_t * rawp);
extern int selinux_raw_to_trans_context(security_context_t raw,
					security_context_t * transp);

/* Perform context translation between security contexts
   and display colors.  Returns a space-separated list of ten
   ten hex RGB triples prefixed by hash marks, e.g. "#ff0000".
   Caller must free the resulting string via free.
   Returns -1 upon an error or 0 otherwise. */
extern int selinux_raw_context_to_color(security_context_t raw,
					char **color_str);

/* Get the SELinux username and level to use for a given Linux username. 
   These values may then be passed into the get_ordered_context_list*
   and get_default_context* functions to obtain a context for the user.
   Returns 0 on success or -1 otherwise.
   Caller must free the returned strings via free. */
extern int getseuserbyname(const char *linuxuser, char **seuser, char **level);

/* Get the SELinux username and level to use for a given Linux username and service. 
   These values may then be passed into the get_ordered_context_list*
   and get_default_context* functions to obtain a context for the user.
   Returns 0 on success or -1 otherwise.
   Caller must free the returned strings via free. */
extern int getseuser(const char *username, const char *service, 
		     char **r_seuser, char **r_level);

/* Compare two file contexts, return 0 if equivalent. */
extern int selinux_file_context_cmp(const security_context_t a,
			     const security_context_t b);

/* 
 * Verify the context of the file 'path' against policy.
 * Return 0 if correct. 
 */
extern int selinux_file_context_verify(const char *path, mode_t mode);

/* This function sets the file context on to the system defaults returns 0 on success */
extern int selinux_lsetfilecon_default(const char *path);

/* 
 * Force a reset of the loaded configuration
 * WARNING: This is not thread safe. Be very sure that no other threads
 * are calling into libselinux when this is called.
 */
extern void selinux_reset_config(void);

#endif
#endif
##including selinux/context.h
#if (defined CONFIG_SELINUX)
#endif
/*
 * Functions to deal with security contexts in user space.
 */

	typedef struct {
		void *ptr;
	} context_s_t;

	typedef context_s_t *context_t;

/* Return a new context initialized to a context string */

	extern context_t context_new(const char *);

/* 
 * Return a pointer to the string value of the context_t
 * Valid until the next call to context_str or context_free 
 * for the same context_t*
 */

	extern char *context_str(context_t);

/* Free the storage used by a context */
	extern void context_free(context_t);

/* Get a pointer to the string value of a context component */

	extern const char *context_type_get(context_t);
	extern const char *context_range_get(context_t);
	extern const char *context_role_get(context_t);
	extern const char *context_user_get(context_t);

/* Set a context component.  Returns nonzero if unsuccessful */

	extern int context_type_set(context_t, const char *);
	extern int context_range_set(context_t, const char *);
	extern int context_role_set(context_t, const char *);
	extern int context_user_set(context_t, const char *);

#endif
#endif
##including selinux/flask.h
/* This file is automatically generated.  Do not edit. */
#if (defined CONFIG_SELINUX)
/*
 * Security object class definitions
 */
/*
 * Security identifier indices for initial entities
 */
#endif
##including selinux/av_permissions.h
/* This file is automatically generated.  Do not edit. */
#endif
#if (defined CONFIG_LOCALE_SUPPORT)
##including locale.h
/* Copyright (C) 1991,1992,1995-2002,2007,2009 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.11 Localization	<locale.h>
 */

#if (defined CONFIG_LOCALE_SUPPORT)
##including features.h
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if (defined CONFIG_LOCALE_SUPPORT)
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if (defined CONFIG_LOCALE_SUPPORT)
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if (defined CONFIG_LOCALE_SUPPORT)
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if (defined CONFIG_LOCALE_SUPPORT)
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if (defined CONFIG_LOCALE_SUPPORT)
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if (defined CONFIG_LOCALE_SUPPORT)
#elif (defined CONFIG_LOCALE_SUPPORT)
#if (defined CONFIG_LOCALE_SUPPORT)
#endif
#endif
#endif
#if (defined CONFIG_LOCALE_SUPPORT)
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
##including bits/locale.h
/* Definition of locale category symbol values.
   Copyright (C) 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#endif
#if (defined CONFIG_LOCALE_SUPPORT)
enum
{
  __LC_CTYPE = 0,
  __LC_NUMERIC = 1,
  __LC_TIME = 2,
  __LC_COLLATE = 3,
  __LC_MONETARY = 4,
  __LC_MESSAGES = 5,
  __LC_ALL = 6,
  __LC_PAPER = 7,
  __LC_NAME = 8,
  __LC_ADDRESS = 9,
  __LC_TELEPHONE = 10,
  __LC_MEASUREMENT = 11,
  __LC_IDENTIFICATION = 12
};

#endif
#if 1
#endif


/* These are the possibilities for the first argument to setlocale.
   The code assumes that the lowest LC_* symbol has the value zero.  */
#if 1
#endif


/* Structure giving information about numeric and monetary notation.  */
struct lconv
{
  /* Numeric (non-monetary) information.  */

  char *decimal_point;		/* Decimal point character.  */
  char *thousands_sep;		/* Thousands separator.  */
  /* Each element is the number of digits in each group;
     elements with higher indices are farther left.
     An element with value CHAR_MAX means that no further grouping is done.
     An element with value 0 means that the previous element is used
     for all groups farther left.  */
  char *grouping;

  /* Monetary information.  */

  /* First three chars are a currency symbol from ISO 4217.
     Fourth char is the separator.  Fifth char is '\0'.  */
  char *int_curr_symbol;
  char *currency_symbol;	/* Local currency symbol.  */
  char *mon_decimal_point;	/* Decimal point character.  */
  char *mon_thousands_sep;	/* Thousands separator.  */
  char *mon_grouping;		/* Like `grouping' element (above).  */
  char *positive_sign;		/* Sign for positive values.  */
  char *negative_sign;		/* Sign for negative values.  */
  char int_frac_digits;		/* Int'l fractional digits.  */
  char frac_digits;		/* Local fractional digits.  */
  /* 1 if currency_symbol precedes a positive value, 0 if succeeds.  */
  char p_cs_precedes;
  /* 1 iff a space separates currency_symbol from a positive value.  */
  char p_sep_by_space;
  /* 1 if currency_symbol precedes a negative value, 0 if succeeds.  */
  char n_cs_precedes;
  /* 1 iff a space separates currency_symbol from a negative value.  */
  char n_sep_by_space;
  /* Positive and negative sign positions:
     0 Parentheses surround the quantity and currency_symbol.
     1 The sign string precedes the quantity and currency_symbol.
     2 The sign string follows the quantity and currency_symbol.
     3 The sign string immediately precedes the currency_symbol.
     4 The sign string immediately follows the currency_symbol.  */
  char p_sign_posn;
  char n_sign_posn;
#if (defined CONFIG_LOCALE_SUPPORT)
/* 1 if int_curr_symbol precedes a positive value, 0 if succeeds.  */
  char int_p_cs_precedes;
  /* 1 iff a space separates int_curr_symbol from a positive value.  */
  char int_p_sep_by_space;
  /* 1 if int_curr_symbol precedes a negative value, 0 if succeeds.  */
  char int_n_cs_precedes;
  /* 1 iff a space separates int_curr_symbol from a negative value.  */
  char int_n_sep_by_space;
  /* Positive and negative sign positions:
     0 Parentheses surround the quantity and int_curr_symbol.
     1 The sign string precedes the quantity and int_curr_symbol.
     2 The sign string follows the quantity and int_curr_symbol.
     3 The sign string immediately precedes the int_curr_symbol.
     4 The sign string immediately follows the int_curr_symbol.  */
  char int_p_sign_posn;
  char int_n_sign_posn;
#endif
};


/* Set and/or return the current locale.  */
extern char *setlocale (int __category, 
#if 1
const
#endif
 char *__locale) 
#if 1
__attribute__((__nothrow__))
#endif
;

/* Return the numeric/monetary information for the current locale.  */
extern struct lconv *localeconv (void) 
#if 1
__attribute__((__nothrow__))
#endif
;

#if 1
#endif



#if (defined CONFIG_LOCALE_SUPPORT)
/* The concept of one static locale per category is not very well
   thought out.  Many applications will need to process its data using
   information from several different locales.  Another application is
   the implementation of the internationalization handling in the
   upcoming ISO C++ standard library.  To support this another set of
   the functions using locale data exist which have an additional
   argument.

   Attention: all these functions are *not* standardized in any form.
   This is a proof-of-concept implementation.  */

/* Get locale datatype definition.  */
##including xlocale.h
/* Return a reference to a data structure representing a set of locale
   datasets.  Unlike for the CATEGORY parameter for `setlocale' the
   CATEGORY_MASK parameter here uses a single bit for each category,
   made by OR'ing together LC_*_MASK bits above.  */
extern __locale_t newlocale (int __category_mask, 
#if 1
const
#endif
 char *__locale,
			     __locale_t __base) 
#if 1
__attribute__((__nothrow__))
#endif
;

/* These are the bits that can be set in the CATEGORY_MASK argument to
   `newlocale'.  In the GNU implementation, LC_FOO_MASK has the value
   of (1 << LC_FOO), but this is not a part of the interface that
   callers can assume will be true.  */
/* Return a duplicate of the set of locale in DATASET.  All usage
   counters are increased if necessary.  */
extern __locale_t duplocale (__locale_t __dataset) 
#if 1
__attribute__((__nothrow__))
#endif
;

/* Free the data associated with a locale dataset previously returned
   by a call to `setlocale_r'.  */
extern void freelocale (__locale_t __dataset) 
#if 1
__attribute__((__nothrow__))
#endif
;

/* Switch the current thread's locale to DATASET.
   If DATASET is null, instead just return the current setting.
   The special value LC_GLOBAL_LOCALE is the initial setting
   for all threads and can also be installed any time, meaning
   the thread uses the global settings controlled by `setlocale'.  */
extern __locale_t uselocale (__locale_t __dataset) 
#if 1
__attribute__((__nothrow__))
#endif
;

/* This value can be passed to `uselocale' and may be returned by it.
   Passing this value to any other function has undefined behavior.  */
#endif
#if 1
#endif


#endif
#elif !(defined CONFIG_LOCALE_SUPPORT)
#endif
#endif
##including pwd.h
/* Copyright (C) 1991,1992,1995-2001,2003,2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 9.2.2 User Database Access	<pwd.h>
 */

#if 1
##including features.h


##including bits/types.h
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
#if 1
/* The Single Unix specification says that some more types are
   available here.  */
#endif
#endif
#endif
/* The passwd structure.  */
struct passwd
{
  char *pw_name;		/* Username.  */
  char *pw_passwd;		/* Password.  */
  __uid_t pw_uid;		/* User ID.  */
  __gid_t pw_gid;		/* Group ID.  */
  char *pw_gecos;		/* Real name.  */
  char *pw_dir;			/* Home directory.  */
  char *pw_shell;		/* Shell program.  */
};


#if 1
##including stdio.h
/* Define ISO C stdio on top of C++ iostreams.
   Copyright (C) 1991, 1994-2008, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.19 Input/output	<stdio.h>
 */

#endif
#endif
#if 1
/* Rewind the password-file stream.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void setpwent (void);

/* Close the password-file stream.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void endpwent (void);

/* Read an entry from the password-file stream, opening it if necessary.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct passwd *getpwent (void);
#endif
#if 1
/* Read an entry from STREAM.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct passwd *fgetpwent (FILE *__stream);

/* Write the given entry onto the given stream.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int putpwent (const struct passwd *__restrict __p,
		     FILE *__restrict __f);
#endif
/* Search for an entry with a matching user ID.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct passwd *getpwuid (__uid_t __uid);

/* Search for an entry with a matching username.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct passwd *getpwnam (const char *__name);

#if 1
#if 1
/* Reasonable value for the buffer sized used in the reentrant
   functions below.  But better use `sysconf'.  */
#endif
/* Reentrant versions of some of the functions above.

   PLEASE NOTE: the `getpwent_r' function is not (yet) standardized.
   The interface may change in later versions of this library.  But
   the interface is designed following the principals used for the
   other reentrant functions so the chances are good this is what the
   POSIX people would choose.  */

#if 1
/* This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int getpwent_r (struct passwd *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct passwd **__restrict __result);
#endif
extern int getpwuid_r (__uid_t __uid,
		       struct passwd *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct passwd **__restrict __result);

extern int getpwnam_r (const char *__restrict __name,
		       struct passwd *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct passwd **__restrict __result);


#if 1
/* Read an entry from STREAM.  This function is not standardized and
   probably never will.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int fgetpwent_r (FILE *__restrict __stream,
			struct passwd *__restrict __resultbuf,
			char *__restrict __buffer, size_t __buflen,
			struct passwd **__restrict __result);
#endif
#endif
#endif


#endif
##including grp.h
/* Copyright (C) 1991,1992,1995-2001,2003,2004,2010
   Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	POSIX Standard: 9.2.1 Group Database Access	<grp.h>
 */

#if 1
##including features.h


##including bits/types.h
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
/* For the Single Unix specification we must define this type here.  */
#endif
/* The group structure.	 */
struct group
  {
    char *gr_name;		/* Group name.	*/
    char *gr_passwd;		/* Password.	*/
    __gid_t gr_gid;		/* Group ID.	*/
    char **gr_mem;		/* Member list.	*/
  };


#if 1
##including stdio.h
/* Define ISO C stdio on top of C++ iostreams.
   Copyright (C) 1991, 1994-2008, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.19 Input/output	<stdio.h>
 */

#endif
#endif
#if 1
/* Rewind the group-file stream.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void setgrent (void);
#endif
#if 1
/* Close the group-file stream.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern void endgrent (void);

/* Read an entry from the group-file stream, opening it if necessary.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct group *getgrent (void);
#endif
#if 1
/* Read a group entry from STREAM.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct group *fgetgrent (FILE *__stream);
#endif
#endif
/* Search for an entry with a matching group ID.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct group *getgrgid (__gid_t __gid);

/* Search for an entry with a matching group name.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern struct group *getgrnam (const char *__name);

#if 1
#if 1
/* Reasonable value for the buffer sized used in the reentrant
   functions below.  But better use `sysconf'.  */
#endif
/* Reentrant versions of some of the functions above.

   PLEASE NOTE: the `getgrent_r' function is not (yet) standardized.
   The interface may change in later versions of this library.  But
   the interface is designed following the principals used for the
   other reentrant functions so the chances are good this is what the
   POSIX people would choose.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */

#endif
/* Search for an entry with a matching group ID.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int getgrgid_r (__gid_t __gid, struct group *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct group **__restrict __result);

/* Search for an entry with a matching group name.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
extern int getgrnam_r (const char *__restrict __name,
		       struct group *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct group **__restrict __result);

#if 1
/* Read a group entry from STREAM.  This function is not standardized
   an probably never will.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int fgetgrent_r (FILE *__restrict __stream,
			struct group *__restrict __resultbuf,
			char *__restrict __buffer, size_t __buflen,
			struct group **__restrict __result);
#endif
#endif
#if 1
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if 1
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if 1
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if 1
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if 1
#elif 1
#if 1
#endif
#endif
#endif
#if 1
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
/* Set the group set for the current user to GROUPS (N of them).  */
extern int setgroups (size_t __n, const __gid_t *__groups) __attribute__((__nothrow__));

/* Store at most *NGROUPS members of the group set for USER into
   *GROUPS.  Also include GROUP.  The actual number of groups found is
   returned in *NGROUPS.  Return -1 if the if *NGROUPS is too small.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int getgrouplist (const char *__user, __gid_t __group,
			 __gid_t *__groups, int *__ngroups);

/* Initialize the group set for the current user
   by reading the group database and using all groups
   of which USER is a member.  Also include GROUP.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int initgroups (const char *__user, __gid_t __group);

#endif


#endif
#if (defined CONFIG_FEATURE_SHADOWPASSWDS)
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
/* If using busybox's shadow implementation, do not include the shadow.h
 * header as the toolchain may not provide it at all.
 */
##including shadow.h
/* Copyright (C) 1996, 1997, 1998, 1999, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/* Declaration of types and functions for shadow password suite.  */

#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
##including features.h
##including paths.h
##including stdio.h
/* Define ISO C stdio on top of C++ iostreams.
   Copyright (C) 1991, 1994-2008, 2009, 2010 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 *	ISO C99 Standard: 7.19 Input/output	<stdio.h>
 */

#endif
##including stddef.h
/* Copyright (C) 1989, 1997, 1998, 1999, 2000, 2002, 2004, 2009
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

/*
 * ISO C Standard:  7.17  Common definitions  <stddef.h>
 */
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
/* Any one of these symbols __need_* means that GNU libc
   wants us just to define one data type.  So don't define
   the symbols that indicate this file's entire job has been done.  */
#endif
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
/* This avoids lossage on SunOS but only if stdtypes.h comes first.
   There's no way to win with the other order!  Sun lossage.  */

/* On 4.3bsd-net2, make sure ansi.h is included, so we have
   one less case to deal with in the following.  */
#endif
/* On FreeBSD 5, machine/ansi.h does not exist anymore... */
#endif
/* In 4.3bsd-net2, machine/ansi.h defines these symbols, which are
   defined if the corresponding type is *not* defined.
   FreeBSD-2.1 defines _MACHINE_ANSI_H_ instead of _ANSI_H_ */
#endif
/* Sequent's header files use _PTRDIFF_T_ in some conflicting way.
   Just ignore it.  */
#endif
/* On VxWorks, <type/vxTypesBase.h> may have defined macros like
   _TYPE_size_t which will typedef size_t.  fixincludes patched the
   vxTypesBase.h so that this macro is only defined if _GCC_SIZE_T is
   not defined, and so that defining this macro defines _GCC_SIZE_T.
   If we find that the macros are still defined at this point, we must
   invoke them so that the type is defined as expected.  */
#endif
#endif
#endif
/* In case nobody has defined these types, but we aren't running under
   GCC 2.00, make sure that __PTRDIFF_TYPE__, __SIZE_TYPE__, and
   __WCHAR_TYPE__ have reasonable values.  This can happen if the
   parts of GCC is compiled by an older compiler, that actually
   include gstddef.h, such as collect2.  */

/* Signed type of difference of two pointers.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
#endif
/* If this symbol has done its job, get rid of it.  */
#endif
/* Unsigned type of `sizeof' something.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
#endif
#endif
/* Wide character type.
   Locale-writers should change this as necessary to
   be big enough to hold unique values not between 0 and 127,
   and not (wchar_t) -1, for each defined multibyte character.  */

/* Define this type if we are doing the whole job,
   or if we want this type in particular.  */
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
#endif
#endif
#endif
/*  In 4.3bsd-net2, leave these undefined to indicate that size_t, etc.
    are already defined.  */
/*  BSD/OS 3.1 and FreeBSD [23].x require the MACHINE_ANSI_H check here.  */
#endif
#endif
/* A null pointer constant.  */

#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
#elif (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
#endif
#endif
#endif
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
/* Offset of member MEMBER in a struct of type TYPE. */
#endif
#endif
/* Paths to the user database files.  */
#if 1
#endif


/* Structure of the password file.  */
struct spwd
  {
    char *sp_namp;		/* Login name.  */
    char *sp_pwdp;		/* Encrypted password.  */
    long int sp_lstchg;		/* Date of last change.  */
    long int sp_min;		/* Minimum number of days between changes.  */
    long int sp_max;		/* Maximum number of days between changes.  */
    long int sp_warn;		/* Number of days to warn user to change
				   the password.  */
    long int sp_inact;		/* Number of days the account may be
				   inactive.  */
    long int sp_expire;		/* Number of days since 1970-01-01 until
				   account expires.  */
    unsigned long int sp_flag;	/* Reserved.  */
  };


/* Open database for reading.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern void setspent (void);

/* Close database.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern void endspent (void);

/* Get next entry from database, perhaps after opening the file.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct spwd *getspent (void);

/* Get shadow entry matching NAME.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct spwd *getspnam (
#if 1
const
#endif
 char *__name);

/* Read shadow entry from STRING.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct spwd *sgetspent (
#if 1
const
#endif
 char *__string);

/* Read next shadow entry from STREAM.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern struct spwd *fgetspent (FILE *__stream);

/* Write line containing shadow password entry to stream.

   This function is not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation it is a cancellation point and
   therefore not marked with __THROW.  */
extern int putspent (
#if 1
const
#endif
 struct spwd *__p, FILE *__stream);


#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && !(defined CONFIG_USE_BB_SHADOW)
/* Reentrant versions of some of the functions above.

   These functions are not part of POSIX and therefore no official
   cancellation point.  But due to similarity with an POSIX interface
   or due to the implementation they are cancellation points and
   therefore not marked with __THROW.  */
extern int getspent_r (struct spwd *__result_buf, char *__buffer,
		       size_t __buflen, struct spwd **__result);

extern int getspnam_r (
#if 1
const
#endif
 char *__name, struct spwd *__result_buf,
		       char *__buffer, size_t __buflen,
		       struct spwd **__result);

extern int sgetspent_r (
#if 1
const
#endif
 char *__string, struct spwd *__result_buf,
			char *__buffer, size_t __buflen,
			struct spwd **__result);

extern int fgetspent_r (FILE *__stream, struct spwd *__result_buf,
			char *__buffer, size_t __buflen,
			struct spwd **__result);
#endif
/* The simple locking functionality provided here is not suitable for
   multi-threaded applications.  */

/* Protect password file against multi writers.  */
extern int lckpwdf (void) 
#if 1
__attribute__((__nothrow__))
#endif
;

/* Unlock password file.  */
extern int ulckpwdf (void) 
#if 1
__attribute__((__nothrow__))
#endif
;

#if 1
#endif


#endif
#endif
#endif
#elif 1
##including arpa/inet.h
/* Copyright (C) 1997, 1999, 2000, 2001, 2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if 1
##including features.h
##including netinet/in.h
/* Type for length arguments in socket calls.  */
#endif


/* Convert Internet host address from numbers-and-dots notation in CP
   into binary data in network byte order.  */
extern in_addr_t inet_addr (const char *__cp) __attribute__((__nothrow__));

/* Return the local host address part of the Internet address in IN.  */
extern in_addr_t inet_lnaof (struct in_addr __in) __attribute__((__nothrow__));

/* Make Internet host address in network byte order by combining the
   network number NET with the local address HOST.  */
extern struct in_addr inet_makeaddr (in_addr_t __net, in_addr_t __host)
     __attribute__((__nothrow__));

/* Return network number part of the Internet address IN.  */
extern in_addr_t inet_netof (struct in_addr __in) __attribute__((__nothrow__));

/* Extract the network number in network byte order from the address
   in numbers-and-dots natation starting at CP.  */
extern in_addr_t inet_network (const char *__cp) __attribute__((__nothrow__));

/* Convert Internet number in IN to ASCII representation.  The return value
   is a pointer to an internal array containing the string.  */
extern char *inet_ntoa (struct in_addr __in) __attribute__((__nothrow__));

/* Convert from presentation format of an Internet number in buffer
   starting at CP to the binary network format and store result for
   interface type AF in buffer starting at BUF.  */
extern int inet_pton (int __af, const char *__restrict __cp,
		      void *__restrict __buf) __attribute__((__nothrow__));

/* Convert a Internet address in binary network format for interface
   type AF in buffer starting at CP to presentation form and place
   result in buffer of length LEN astarting at BUF.  */
extern const char *inet_ntop (int __af, const void *__restrict __cp,
				char *__restrict __buf, socklen_t __len)
     __attribute__((__nothrow__));


/* The following functions are not part of XNS 5.2.  */
#if 1
/* Convert Internet host address from numbers-and-dots notation in CP
   into binary data and store the result in the structure INP.  */
extern int inet_aton (const char *__cp, struct in_addr *__inp) __attribute__((__nothrow__));

/* Format a network number NET into presentation format and place result
   in buffer starting at BUF with length of LEN bytes.  */
extern char *inet_neta (in_addr_t __net, char *__buf, size_t __len) __attribute__((__nothrow__));

/* Convert network number for interface type AF in buffer starting at
   CP to presentation format.  The result will specifiy BITS bits of
   the number.  */
extern char *inet_net_ntop (int __af, const void *__cp, int __bits,
			    char *__buf, size_t __len) __attribute__((__nothrow__));

/* Convert network number for interface type AF from presentation in
   buffer starting at CP to network format and store result int
   buffer starting at BUF of size LEN.  */
extern int inet_net_pton (int __af, const char *__cp,
			  void *__buf, size_t __len) __attribute__((__nothrow__));

/* Convert ASCII representation in hexadecimal form of the Internet
   address to binary form and place result in buffer of length LEN
   starting at BUF.  */
extern unsigned int inet_nsap_addr (const char *__cp,
				    unsigned char *__buf, int __len) __attribute__((__nothrow__));

/* Convert internet address in binary form in LEN bytes starting at CP
   a presentation form and place result in BUF.  */
extern char *inet_nsap_ntoa (int __len, const unsigned char *__cp,
			     char *__buf) __attribute__((__nothrow__));
#endif


#endif
#endif
#endif
/* Some libc's forget to declare these, do it ourself */

extern char **environ;
#endif
/* klogctl is in libc's klog.h, but we cheat and not #include that */
int klogctl(int type, char *b, int len);
/* This is declared here rather than #including <libgen.h> in order to avoid
 * confusing the two versions of basename.  See the dirname/basename man page
 * for details. */
#if 1
char *dirname(char *path);
#endif
/* Include our own copy of struct sysinfo to avoid binary compatibility
 * problems with Linux 2.4, which changed things.  Grumble, grumble. */
struct sysinfo {
	long uptime;			/* Seconds since boot */
	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
	unsigned long totalram;		/* Total usable main memory size */
	unsigned long freeram;		/* Available memory size */
	unsigned long sharedram;	/* Amount of shared memory */
	unsigned long bufferram;	/* Memory used by buffers */
	unsigned long totalswap;	/* Total swap space size */
	unsigned long freeswap;		/* swap space still available */
	unsigned short procs;		/* Number of current processes */
	unsigned short pad;			/* Padding needed for m68k */
	unsigned long totalhigh;	/* Total high memory size */
	unsigned long freehigh;		/* Available high memory size */
	unsigned int mem_unit;		/* Memory unit size in bytes */
	char _f[20 - 2 * sizeof(long) - sizeof(int)]; /* Padding: libc5 uses this.. */
};
int sysinfo(struct sysinfo* info);
#endif
#endif
/* Make all declarations hidden (-fvisibility flag only affects definitions) */
/* (don't include system headers after this until corresponding pop!) */
_Pragma("GCC visibility push(hidden)")


#if (defined CONFIG_USE_BB_PWD_GRP)
##including pwd_.h
/* vi: set sw=4 ts=4: */
/* Copyright (C) 1991,92,95,96,97,98,99,2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/*
 * POSIX Standard: 9.2.2 User Database Access	<pwd.h>
 */

#if (defined CONFIG_USE_BB_PWD_GRP)
#if 1
_Pragma("GCC visibility push(hidden)")
#endif


/* This file is #included after #include <pwd.h>
 * We will use libc-defined structures, but will #define function names
 * so that function calls are directed to bb_internal_XXX replacements
 */

/* All function names below should be remapped by #defines above
 * in order to not collide with libc names. */


/* Rewind the password-file stream.  */
extern void bb_internal_setpwent(void);

/* Close the password-file stream.  */
extern void bb_internal_endpwent(void);

#endif
/* Search for an entry with a matching user ID.  */
extern struct passwd *bb_internal_getpwuid(uid_t __uid);

/* Search for an entry with a matching username.  */
extern struct passwd *bb_internal_getpwnam(const char *__name);

/* Reentrant versions of some of the functions above.

   PLEASE NOTE: the `getpwent_r' function is not (yet) standardized.
   The interface may change in later versions of this library.  But
   the interface is designed following the principals used for the
   other reentrant functions so the chances are good this is what the
   POSIX people would choose.  */

extern int bb_internal_getpwent_r(struct passwd *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct passwd **__restrict __result);

extern int bb_internal_getpwuid_r(uid_t __uid,
		       struct passwd *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct passwd **__restrict __result);

extern int bb_internal_getpwnam_r(const char *__restrict __name,
		       struct passwd *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct passwd **__restrict __result);

/* Read an entry from STREAM.  This function is not standardized and
   probably never will.  */
extern int bb_internal_fgetpwent_r(FILE *__restrict __stream,
			struct passwd *__restrict __resultbuf,
			char *__restrict __buffer, size_t __buflen,
			struct passwd **__restrict __result);

#if 1
_Pragma("GCC visibility pop")
#endif


#endif
##including grp_.h
/* vi: set sw=4 ts=4: */
/* Copyright (C) 1991,92,95,96,97,98,99,2000,01 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.
 */
/*
 * POSIX Standard: 9.2.1 Group Database Access	<grp.h>
 */
#if (defined CONFIG_USE_BB_PWD_GRP)
#if 1
_Pragma("GCC visibility push(hidden)")
#endif


/* This file is #included after #include <grp.h>
 * We will use libc-defined structures, but will #define function names
 * so that function calls are directed to bb_internal_XXX replacements
 */

/* All function names below should be remapped by #defines above
 * in order to not collide with libc names. */


/* Rewind the group-file stream.  */
extern void bb_internal_setgrent(void);

/* Close the group-file stream.  */
extern void bb_internal_endgrent(void);

#endif
/* Search for an entry with a matching group ID.  */
extern struct group *bb_internal_getgrgid(gid_t __gid);

/* Search for an entry with a matching group name.  */
extern struct group *bb_internal_getgrnam(const char *__name);

/* Reentrant versions of some of the functions above.

   PLEASE NOTE: the `getgrent_r' function is not (yet) standardized.
   The interface may change in later versions of this library.  But
   the interface is designed following the principals used for the
   other reentrant functions so the chances are good this is what the
   POSIX people would choose.  */

extern int bb_internal_getgrent_r(struct group *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct group **__restrict __result);

/* Search for an entry with a matching group ID.  */
extern int bb_internal_getgrgid_r(gid_t __gid, struct group *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct group **__restrict __result);

/* Search for an entry with a matching group name.  */
extern int bb_internal_getgrnam_r(const char *__restrict __name,
		       struct group *__restrict __resultbuf,
		       char *__restrict __buffer, size_t __buflen,
		       struct group **__restrict __result);

/* Read a group entry from STREAM.  This function is not standardized
   an probably never will.  */
extern int bb_internal_fgetgrent_r(FILE *__restrict __stream,
			struct group *__restrict __resultbuf,
			char *__restrict __buffer, size_t __buflen,
			struct group **__restrict __result);

/* Store at most *NGROUPS members of the group set for USER into
   *GROUPS.  Also include GROUP.  The actual number of groups found is
   returned in *NGROUPS.  Return -1 if the if *NGROUPS is too small.  */
extern int bb_internal_getgrouplist(const char *__user, gid_t __group,
			 gid_t *__groups, int *__ngroups);

/* Initialize the group set for the current user
   by reading the group database and using all groups
   of which USER is a member.  Also include GROUP.  */
extern int bb_internal_initgroups(const char *__user, gid_t __group);

#if 1
_Pragma("GCC visibility pop")
#endif


#endif
#endif
#if (defined CONFIG_FEATURE_SHADOWPASSWDS)
#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && (defined CONFIG_USE_BB_SHADOW)
##including shadow_.h
/* vi: set sw=4 ts=4: */
/* Copyright (C) 1996, 1997, 1998, 1999 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/* Declaration of types and functions for shadow password suite */

#if (defined CONFIG_FEATURE_SHADOWPASSWDS) && (defined CONFIG_USE_BB_SHADOW)
#if 1
_Pragma("GCC visibility push(hidden)")
#endif


/* Structure of the password file */
struct spwd {
	char *sp_namp;          /* Login name */
	char *sp_pwdp;          /* Encrypted password */
	long sp_lstchg;         /* Date of last change */
	long sp_min;            /* Minimum number of days between changes */
	long sp_max;            /* Maximum number of days between changes */
	long sp_warn;           /* Number of days to warn user to change the password */
	long sp_inact;          /* Number of days the account may be inactive */
	long sp_expire;         /* Number of days since 1970-01-01 until account expires */
	unsigned long sp_flag;  /* Reserved */
};

/* Paths to the user database files */
#endif
/* All function names below should be remapped by #defines above
 * in order to not collide with libc names. */

#endif
extern int bb_internal_getspnam_r(const char *__name, struct spwd *__result_buf,
		       char *__buffer, size_t __buflen,
		       struct spwd **__result);

#endif
#if 1
_Pragma("GCC visibility pop")
#endif


#endif
#endif
#endif
/* Tested to work correctly with all int types (IIRC :]) */
/* Large file support */
/* Note that CONFIG_LFS=y forces bbox to be built with all common ops
 * (stat, lseek etc) mapped to "largefile" variants by libc.
 * Practically it means that open() automatically has O_LARGEFILE added
 * and all filesize/file_offset parameters and struct members are "large"
 * (in today's world - signed 64bit). For full support of large files,
 * we need a few helper #defines (below) and careful use of off_t
 * instead of int/ssize_t. No lseek64(), O_LARGEFILE etc necessary */
#if (defined CONFIG_LFS)
/* CONFIG_LFS is on */
#elif (defined CONFIG_LFS)
/* "long" is too short, need "long long" */
typedef unsigned long long uoff_t;
#endif
#elif !(defined CONFIG_LFS)
/* CONFIG_LFS is off */
#elif !(defined CONFIG_LFS)
typedef unsigned long uoff_t;
#endif
#endif
/* scary. better ideas? (but do *test* them first!) */
/* Some useful definitions */
/* for mtab.c */
/* Macros for min/max.  */
#endif
#endif
/* buffer allocation schemes */
#if (defined CONFIG_FEATURE_BUFFERS_GO_ON_STACK)
#elif !(defined CONFIG_FEATURE_BUFFERS_GO_ON_STACK)
#if !(defined CONFIG_FEATURE_BUFFERS_GO_ON_STACK) && (defined CONFIG_FEATURE_BUFFERS_GO_IN_BSS)
#elif !(defined CONFIG_FEATURE_BUFFERS_GO_ON_STACK) && !(defined CONFIG_FEATURE_BUFFERS_GO_IN_BSS)
#endif
#endif
#if 1
/* glibc uses __errno_location() to get a ptr to errno */
/* We can just memorize it once - no multithreading in busybox :) */
extern int *const bb_errno;
#endif
#if 1
/* Only 32-bit CPUs need this, 64-bit ones use inlined version */
uint64_t bb_bswap_64(uint64_t x) ;
#endif
unsigned long long monotonic_ns(void) ;
unsigned long long monotonic_us(void) ;
unsigned long long monotonic_ms(void) ;
unsigned monotonic_sec(void) ;

extern void chomp(char *s) ;
extern void trim(char *s) ;
extern char *skip_whitespace(const char *) ;
extern char *skip_non_whitespace(const char *) ;
extern char *skip_dev_pfx(const char *tty_name) ;

extern char *strrstr(const char *haystack, const char *needle) ;

//TODO: supply a pointer to char[11] buffer (avoid statics)?
extern const char *bb_mode_string(mode_t mode) ;
extern int is_directory(const char *name, int followLinks, struct stat *statBuf) ;
enum {	/* DO NOT CHANGE THESE VALUES!  cp.c, mv.c, install.c depend on them. */
	FILEUTILS_PRESERVE_STATUS = 1 << 0, /* -p */
	FILEUTILS_DEREFERENCE     = 1 << 1, /* !-d */
	FILEUTILS_RECUR           = 1 << 2, /* -R */
	FILEUTILS_FORCE           = 1 << 3, /* -f */
	FILEUTILS_INTERACTIVE     = 1 << 4, /* -i */
	FILEUTILS_MAKE_HARDLINK   = 1 << 5, /* -l */
	FILEUTILS_MAKE_SOFTLINK   = 1 << 6, /* -s */
	FILEUTILS_DEREF_SOFTLINK  = 1 << 7, /* -L */
	FILEUTILS_DEREFERENCE_L0  = 1 << 8, /* -H */
#if (defined CONFIG_SELINUX)
FILEUTILS_PRESERVE_SECURITY_CONTEXT = 1 << 9, /* -c */
	FILEUTILS_SET_SECURITY_CONTEXT = 1 << 10,
#endif
};
extern int remove_file(const char *path, int flags) ;
/* NB: without FILEUTILS_RECUR in flags, it will basically "cat"
 * the source, not copy (unless "source" is a directory).
 * This makes "cp /dev/null file" and "install /dev/null file" (!!!)
 * work coreutils-compatibly. */
extern int copy_file(const char *source, const char *dest, int flags) ;

enum {
	ACTION_RECURSE        = (1 << 0),
	ACTION_FOLLOWLINKS    = (1 << 1),
	ACTION_FOLLOWLINKS_L0 = (1 << 2),
	ACTION_DEPTHFIRST     = (1 << 3),
	/*ACTION_REVERSE      = (1 << 4), - unused */
	ACTION_QUIET          = (1 << 5),
	ACTION_DANGLING_OK    = (1 << 6),
};
typedef uint8_t recurse_flags_t;
extern int recursive_action(const char *fileName, unsigned flags,
	int  (*fileAction)(const char *fileName, struct stat* statbuf, void* userData, int depth),
	int  (*dirAction)(const char *fileName, struct stat* statbuf, void* userData, int depth),
	void* userData, unsigned depth) ;
extern int device_open(const char *device, int mode) ;
enum { GETPTY_BUFSIZE = 16 }; /* more than enough for "/dev/ttyXXX" */
extern int xgetpty(char *line) ;
extern int get_console_fd_or_die(void) ;
extern void console_make_active(int fd, const int vt_num) ;
extern char *find_block_device(const char *path) ;
/* bb_copyfd_XX print read/write errors and return -1 if they occur */
extern off_t bb_copyfd_eof(int fd1, int fd2) ;
extern off_t bb_copyfd_size(int fd1, int fd2, off_t size) ;
extern void bb_copyfd_exact_size(int fd1, int fd2, off_t size) ;
/* "short" copy can be detected by return value < size */
/* this helper yells "short read!" if param is not -1 */
extern void complain_copyfd_and_die(off_t sz) __attribute__((__noreturn__)) ;
extern char bb_process_escape_sequence(const char **ptr) ;
char* strcpy_and_process_escape_sequences(char *dst, const char *src) ;
/* xxxx_strip version can modify its parameter:
 * "/"        -> "/"
 * "abc"      -> "abc"
 * "abc/def"  -> "def"
 * "abc/def/" -> "def" !!
 */
extern char *bb_get_last_path_component_strip(char *path) ;
/* "abc/def/" -> "" and it never modifies 'path' */
extern char *bb_get_last_path_component_nostrip(const char *path) ;

int ndelay_on(int fd) ;
int ndelay_off(int fd) ;
int close_on_exec_on(int fd) ;
void xdup2(int, int) ;
void xmove_fd(int, int) ;


DIR *xopendir(const char *path) ;
DIR *warn_opendir(const char *path) ;

char *xmalloc_realpath(const char *path)  __attribute__((malloc));
char *xmalloc_readlink(const char *path)  __attribute__((malloc));
char *xmalloc_readlink_or_warn(const char *path)  __attribute__((malloc));
/* !RETURNS_MALLOC: it's a realloc-like function */
char *xrealloc_getcwd_or_warn(char *cwd) ;

char *xmalloc_follow_symlinks(const char *path)  __attribute__((malloc));


enum {
	/* bb_signals(BB_FATAL_SIGS, handler) catches all signals which
	 * otherwise would kill us, except for those resulting from bugs:
	 * SIGSEGV, SIGILL, SIGFPE.
	 * Other fatal signals not included (TODO?):
	 * SIGBUS   Bus error (bad memory access)
	 * SIGPOLL  Pollable event. Synonym of SIGIO
	 * SIGPROF  Profiling timer expired
	 * SIGSYS   Bad argument to routine
	 * SIGTRAP  Trace/breakpoint trap
	 *
	 * The only known arch with some of these sigs not fitting
	 * into 32 bits is parisc (SIGXCPU=33, SIGXFSZ=34, SIGSTKFLT=36).
	 * Dance around with long long to guard against that...
	 */
	BB_FATAL_SIGS = (int)(0
		+ (1LL << 1)
		+ (1LL << 2)
		+ (1LL << 15)
		+ (1LL << 13)   // Write to pipe with no readers
		+ (1LL << 3)   // Quit from keyboard
		+ (1LL << 6)   // Abort signal from abort(3)
		+ (1LL << 14)   // Timer signal from alarm(2)
		+ (1LL << 26) // Virtual alarm clock
		+ (1LL << 24)   // CPU time limit exceeded
		+ (1LL << 25)   // File size limit exceeded
		+ (1LL << 10)   // Yes kids, these are also fatal!
		+ (1LL << 12)
		+ 0),
};
void bb_signals(int sigs, void (*f)(int)) ;
/* Unlike signal() and bb_signals, sets handler with sigaction()
 * and in a way that while signal handler is run, no other signals
 * will be blocked; syscalls will not be restarted: */
void bb_signals_recursive_norestart(int sigs, void (*f)(int)) ;
/* syscalls like read() will be interrupted with EINTR: */
void signal_no_SA_RESTART_empty_mask(int sig, void (*handler)(int)) ;
/* syscalls like read() won't be interrupted (though select/poll will be): */
void signal_SA_RESTART_empty_mask(int sig, void (*handler)(int)) ;
void wait_for_any_sig(void) ;
void kill_myself_with_sig(int sig) __attribute__((__noreturn__)) ;
void sig_block(int sig) ;
void sig_unblock(int sig) ;
/* Will do sigaction(signum, act, NULL): */
int sigaction_set(int sig, const struct sigaction *act) ;
/* SIG_BLOCK/SIG_UNBLOCK all signals: */
int sigprocmask_allsigs(int how) ;
/* Standard handler which just records signo */
extern smallint bb_got_signal;
void record_signo(int signo); /* not FAST_FUNC! */


void xsetgid(gid_t gid) ;
void xsetuid(uid_t uid) ;
void xchdir(const char *path) ;
void xchroot(const char *path) ;
void xsetenv(const char *key, const char *value) ;
void bb_unsetenv(const char *key) ;
void bb_unsetenv_and_free(char *key) ;
void xunlink(const char *pathname) ;
void xstat(const char *pathname, struct stat *buf) ;
void xfstat(int fd, struct stat *buf, const char *errmsg) ;
int xopen(const char *pathname, int flags) ;
int xopen_nonblocking(const char *pathname) ;
int xopen3(const char *pathname, int flags, int mode) ;
int open_or_warn(const char *pathname, int flags) ;
int open3_or_warn(const char *pathname, int flags, int mode) ;
int open_or_warn_stdin(const char *pathname) ;
int xopen_stdin(const char *pathname) ;
void xrename(const char *oldpath, const char *newpath) ;
int rename_or_warn(const char *oldpath, const char *newpath) ;
off_t xlseek(int fd, off_t offset, int whence) ;
int xmkstemp(char *template) ;
off_t fdlength(int fd) ;

uoff_t  get_volume_size_in_bytes(int fd,
                const char *override,
                unsigned override_units,
                int extend);

void xpipe(int filedes[2]) ;
/* In this form code with pipes is much more readable */
struct fd_pair { int rd; int wr; };
/* Useful for having small structure members/global variables */
typedef int8_t socktype_t;
typedef int8_t family_t;
struct BUG_too_small {
	char BUG_socktype_t_too_small[(0
			| SOCK_STREAM
			| SOCK_DGRAM
			| SOCK_RDM
			| SOCK_SEQPACKET
			| SOCK_RAW
			) <= 127 ? 1 : -1];
	char BUG_family_t_too_small[(0
			| 0
			| 2
			| 10
			| 1
#if 1
| 17
#endif
#if 1
| 16
#endif
/* | AF_DECnet */
			/* | AF_IPX */
			) <= 127 ? 1 : -1];
};


void parse_datestr(const char *date_str, struct tm *ptm) ;
time_t validate_tm_time(const char *date_str, struct tm *ptm) ;


int xsocket(int domain, int type, int protocol) ;
void xbind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen) ;
void xlisten(int s, int backlog) ;
void xconnect(int s, const struct sockaddr *s_addr, socklen_t addrlen) ;
ssize_t xsendto(int s, const void *buf, size_t len, const struct sockaddr *to,
				socklen_t tolen) ;
/* SO_REUSEADDR allows a server to rebind to an address that is already
 * "in use" by old connections to e.g. previous server instance which is
 * killed or crashed. Without it bind will fail until all such connections
 * time out. Linux does not allow multiple live binds on same ip:port
 * regardless of SO_REUSEADDR (unlike some other flavors of Unix).
 * Turn it on before you call bind(). */
void setsockopt_reuseaddr(int fd) ; /* On Linux this never fails. */
int setsockopt_broadcast(int fd) ;
int setsockopt_bindtodevice(int fd, const char *iface) ;
/* NB: returns port in host byte order */
unsigned bb_lookup_port(const char *port, const char *protocol, unsigned default_port) ;
typedef struct len_and_sockaddr {
	socklen_t len;
	union {
		struct sockaddr sa;
		struct sockaddr_in sin;
#if (defined CONFIG_FEATURE_IPV6)
struct sockaddr_in6 sin6;
#endif
} u;
} len_and_sockaddr;
enum {
	LSA_LEN_SIZE = __builtin_offsetof(len_and_sockaddr, u),
	LSA_SIZEOF_SA = sizeof(
		union {
			struct sockaddr sa;
			struct sockaddr_in sin;
#if (defined CONFIG_FEATURE_IPV6)
struct sockaddr_in6 sin6;
#endif
}
	)
};
/* Create stream socket, and allocate suitable lsa.
 * (lsa of correct size and lsa->sa.sa_family (AF_INET/AF_INET6))
 * af == AF_UNSPEC will result in trying to create IPv6 socket,
 * and if kernel doesn't support it, fall back to IPv4.
 * This is useful if you plan to bind to resulting local lsa.
 */
#if (defined CONFIG_FEATURE_IPV6)
int xsocket_type(len_and_sockaddr **lsap, int af, int sock_type) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_IPV6)
int xsocket_type(len_and_sockaddr **lsap, int sock_type) 
#if 1
#endif
;
#endif
int xsocket_stream(len_and_sockaddr **lsap) ;
/* Create server socket bound to bindaddr:port. bindaddr can be NULL,
 * numeric IP ("N.N.N.N") or numeric IPv6 address,
 * and can have ":PORT" suffix (for IPv6 use "[X:X:...:X]:PORT").
 * Only if there is no suffix, port argument is used */
/* NB: these set SO_REUSEADDR before bind */
int create_and_bind_stream_or_die(const char *bindaddr, int port) ;
int create_and_bind_dgram_or_die(const char *bindaddr, int port) ;
/* Create client TCP socket connected to peer:port. Peer cannot be NULL.
 * Peer can be numeric IP ("N.N.N.N"), numeric IPv6 address or hostname,
 * and can have ":PORT" suffix (for IPv6 use "[X:X:...:X]:PORT").
 * If there is no suffix, port argument is used */
int create_and_connect_stream_or_die(const char *peer, int port) ;
/* Connect to peer identified by lsa */
int xconnect_stream(const len_and_sockaddr *lsa) ;
/* Get local address of bound or accepted socket */
len_and_sockaddr *get_sock_lsa(int fd)  __attribute__((malloc));
/* Get remote address of connected or accepted socket */
len_and_sockaddr *get_peer_lsa(int fd)  __attribute__((malloc));
/* Return malloc'ed len_and_sockaddr with socket address of host:port
 * Currently will return IPv4 or IPv6 sockaddrs only
 * (depending on host), but in theory nothing prevents e.g.
 * UNIX socket address being returned, IPX sockaddr etc...
 * On error does bb_error_msg and returns NULL */
len_and_sockaddr* host2sockaddr(const char *host, int port)  __attribute__((malloc));
/* Version which dies on error */
len_and_sockaddr* xhost2sockaddr(const char *host, int port)  __attribute__((malloc));
len_and_sockaddr* xdotted2sockaddr(const char *host, int port)  __attribute__((malloc));
/* Same, useful if you want to force family (e.g. IPv6) */
#if !(defined CONFIG_FEATURE_IPV6)
#elif (defined CONFIG_FEATURE_IPV6)
len_and_sockaddr* host_and_af2sockaddr(const char *host, int port, sa_family_t af) 
#if 1
#endif
 
#if 1
__attribute__((malloc))
#endif
;
len_and_sockaddr* xhost_and_af2sockaddr(const char *host, int port, sa_family_t af) 
#if 1
#endif
 
#if 1
__attribute__((malloc))
#endif
;
#endif
/* Assign sin[6]_port member if the socket is an AF_INET[6] one,
 * otherwise no-op. Useful for ftp.
 * NB: does NOT do htons() internally, just direct assignment. */
void set_nport(len_and_sockaddr *lsa, unsigned port) ;
/* Retrieve sin[6]_port or return -1 for non-INET[6] lsa's */
int get_nport(const struct sockaddr *sa) ;
/* Reverse DNS. Returns NULL on failure. */
char* xmalloc_sockaddr2host(const struct sockaddr *sa)  __attribute__((malloc));
/* This one doesn't append :PORTNUM */
char* xmalloc_sockaddr2host_noport(const struct sockaddr *sa)  __attribute__((malloc));
/* This one also doesn't fall back to dotted IP (returns NULL) */
char* xmalloc_sockaddr2hostonly_noport(const struct sockaddr *sa)  __attribute__((malloc));
/* inet_[ap]ton on steroids */
char* xmalloc_sockaddr2dotted(const struct sockaddr *sa)  __attribute__((malloc));
char* xmalloc_sockaddr2dotted_noport(const struct sockaddr *sa)  __attribute__((malloc));
// "old" (ipv4 only) API
// users: traceroute.c hostname.c - use _list_ of all IPs
struct hostent *xgethostbyname(const char *name) ;
// Also mount.c and inetd.c are using gethostbyname(),
// + inet_common.c has additional IPv4-only stuff


void socket_want_pktinfo(int fd) ;
ssize_t send_to_from(int fd, void *buf, size_t len, int flags,
		const struct sockaddr *to,
		const struct sockaddr *from,
		socklen_t tolen) ;
ssize_t recv_from_to(int fd, void *buf, size_t len, int flags,
		struct sockaddr *from,
		struct sockaddr *to,
		socklen_t sa_size) ;


char *xstrdup(const char *s)  __attribute__((malloc));
char *xstrndup(const char *s, int n)  __attribute__((malloc));
void overlapping_strcpy(char *dst, const char *src) ;
char *safe_strncpy(char *dst, const char *src, size_t size) ;
char *strncpy_IFNAMSIZ(char *dst, const char *src) ;
/* Guaranteed to NOT be a macro (smallest code). Saves nearly 2k on uclibc.
 * But potentially slow, don't use in one-billion-times loops */
int bb_putchar(int ch) ;
/* Note: does not use stdio, writes to fd 2 directly */
int bb_putchar_stderr(char ch) ;
char *xasprintf(const char *format, ...) __attribute__ ((format(printf, 1, 2)))  __attribute__((malloc));
// gcc-4.1.1 still isn't good enough at optimizing it
// (+200 bytes compared to macro)
//static ALWAYS_INLINE
//int LONE_DASH(const char *s) { return s[0] == '-' && !s[1]; }
//static ALWAYS_INLINE
//int NOT_LONE_DASH(const char *s) { return s[0] != '-' || s[1]; }
typedef struct uni_stat_t {
	unsigned byte_count;
	unsigned unicode_count;
	unsigned unicode_width;
} uni_stat_t;
/* Returns a string with unprintable chars replaced by '?' or
 * SUBST_WCHAR. This function is unicode-aware. */
const char*  printable_string(uni_stat_t *stats, const char *str);
/* Prints unprintable char ch as ^C or M-c to file
 * (M-c is used only if ch is ORed with PRINTABLE_META),
 * else it is printed as-is (except for ch = 0x9b) */
enum { PRINTABLE_META = 0x100 };
void fputc_printable(int ch, FILE *file) ;

/* dmalloc will redefine these to it's own implementation. It is safe
 * to have the prototypes here unconditionally.  */
void *malloc_or_warn(size_t size)  __attribute__((malloc));
void *xmalloc(size_t size)  __attribute__((malloc));
void *xzalloc(size_t size)  __attribute__((malloc));
void *xrealloc(void *old, size_t size) ;
/* After xrealloc_vector(v, 4, idx) it's ok to use
 * at least v[idx] and v[idx+1], for all idx values.
 * shift specifies how many new elements are added (1: 2, 2: 4... 8: 256...)
 * when all elements are used up. New elements are zeroed out. */
void* xrealloc_vector_helper(void *vector, unsigned sizeof_and_shift, int idx) ;


extern ssize_t safe_read(int fd, void *buf, size_t count) ;
extern ssize_t nonblock_safe_read(int fd, void *buf, size_t count) ;
// NB: will return short read on error, not -1,
// if some data was read before error occurred
extern ssize_t full_read(int fd, void *buf, size_t count) ;
extern void xread(int fd, void *buf, size_t count) ;
extern unsigned char xread_char(int fd) ;
extern ssize_t read_close(int fd, void *buf, size_t maxsz) ;
extern ssize_t open_read_close(const char *filename, void *buf, size_t maxsz) ;
// Reads one line a-la fgets (but doesn't save terminating '\n').
// Reads byte-by-byte. Useful when it is important to not read ahead.
// Bytes are appended to pfx (which must be malloced, or NULL).
extern char *xmalloc_reads(int fd, char *pfx, size_t *maxsz_p) ;
/* Reads block up to *maxsz_p (default: INT_MAX - 4095) */
extern void *xmalloc_read(int fd, size_t *maxsz_p)  __attribute__((malloc));
/* Returns NULL if file can't be opened (default max size: INT_MAX - 4095) */
extern void *xmalloc_open_read_close(const char *filename, size_t *maxsz_p)  __attribute__((malloc));
/* Autodetects gzip/bzip2 formats. fd may be in the middle of the file! */
#if !(defined CONFIG_FEATURE_SEAMLESS_LZMA) && !(defined CONFIG_FEATURE_SEAMLESS_BZ2) && (defined CONFIG_FEATURE_SEAMLESS_GZ) || !(defined CONFIG_FEATURE_SEAMLESS_LZMA) && (defined CONFIG_FEATURE_SEAMLESS_BZ2) || (defined CONFIG_FEATURE_SEAMLESS_LZMA)
extern void setup_unzip_on_fd(int fd /*, int fail_if_not_detected*/) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_SEAMLESS_LZMA) && !(defined CONFIG_FEATURE_SEAMLESS_BZ2) && !(defined CONFIG_FEATURE_SEAMLESS_GZ)
#endif
/* Autodetects .gz etc */
extern int open_zipped(const char *fname) ;
extern void *xmalloc_open_zipped_read_close(const char *fname, size_t *maxsz_p)  __attribute__((malloc));
/* Never returns NULL */
extern void *xmalloc_xopen_read_close(const char *filename, size_t *maxsz_p)  __attribute__((malloc));

extern ssize_t safe_write(int fd, const void *buf, size_t count) ;
// NB: will return short write on error, not -1,
// if some data was written before error occurred
extern ssize_t full_write(int fd, const void *buf, size_t count) ;
extern void xwrite(int fd, const void *buf, size_t count) ;
extern void xwrite_str(int fd, const char *str) ;
extern ssize_t full_write1_str(const char *str) ;
extern ssize_t full_write2_str(const char *str) ;
extern void xopen_xwrite_close(const char* file, const char *str) ;

/* Close fd, but check for failures (some types of write errors) */
extern void xclose(int fd) ;

/* Reads and prints to stdout till eof, then closes FILE. Exits on error: */
extern void xprint_and_close_file(FILE *file) ;

extern char *bb_get_chunk_from_file(FILE *file, int *end) ;
extern char *bb_get_chunk_with_continuation(FILE *file, int *end, int *lineno) ;
/* Reads up to (and including) TERMINATING_STRING: */
extern char *xmalloc_fgets_str(FILE *file, const char *terminating_string)  __attribute__((malloc));
/* Same, with limited max size, and returns the length (excluding NUL): */
extern char *xmalloc_fgets_str_len(FILE *file, const char *terminating_string, size_t *maxsz_p)  __attribute__((malloc));
/* Chops off TERMINATING_STRING from the end: */
extern char *xmalloc_fgetline_str(FILE *file, const char *terminating_string)  __attribute__((malloc));
/* Reads up to (and including) "\n" or NUL byte: */
extern char *xmalloc_fgets(FILE *file)  __attribute__((malloc));
/* Chops off '\n' from the end, unlike fgets: */
extern char *xmalloc_fgetline(FILE *file)  __attribute__((malloc));
/* Same, but doesn't try to conserve space (may have some slack after the end) */
/* extern char *xmalloc_fgetline_fast(FILE *file) FAST_FUNC RETURNS_MALLOC; */

void die_if_ferror(FILE *file, const char *msg) ;
void die_if_ferror_stdout(void) ;
int fflush_all(void) ;
void fflush_stdout_and_exit(int retval) __attribute__((__noreturn__)) ;
int fclose_if_not_stdin(FILE *file) ;
FILE* xfopen(const char *filename, const char *mode) ;
/* Prints warning to stderr and returns NULL on failure: */
FILE* fopen_or_warn(const char *filename, const char *mode) ;
/* "Opens" stdin if filename is special, else just opens file: */
FILE* xfopen_stdin(const char *filename) ;
FILE* fopen_or_warn_stdin(const char *filename) ;
FILE* fopen_for_read(const char *path) ;
FILE* xfopen_for_read(const char *path) ;
FILE* fopen_for_write(const char *path) ;
FILE* xfopen_for_write(const char *path) ;
FILE* xfdopen_for_read(int fd) ;
FILE* xfdopen_for_write(int fd) ;

int bb_pstrcmp(const void *a, const void *b) /* not FAST_FUNC! */;
void qsort_string_vector(char **sv, unsigned count) ;

/* Wrapper which restarts poll on EINTR or ENOMEM.
 * On other errors complains [perror("poll")] and returns.
 * Warning! May take (much) longer than timeout_ms to return!
 * If this is a problem, use bare poll and open-code EINTR/ENOMEM handling */
int safe_poll(struct pollfd *ufds, nfds_t nfds, int timeout_ms) ;

char *safe_gethostname(void) ;
char *safe_getdomainname(void) ;

/* Convert each alpha char in str to lower-case */
char* str_tolower(char *str) ;

char *utoa(unsigned n) ;
char *itoa(int n) ;
/* Returns a pointer past the formatted number, does NOT null-terminate */
char *utoa_to_buf(unsigned n, char *buf, unsigned buflen) ;
char *itoa_to_buf(int n, char *buf, unsigned buflen) ;
/* Intelligent formatters of bignums */
void smart_ulltoa4(unsigned long long ul, char buf[4], const char *scale) ;
void smart_ulltoa5(unsigned long long ul, char buf[5], const char *scale) ;
/* If block_size == 0, display size without fractional part,
 * else display (size * block_size) with one decimal digit.
 * If display_unit == 0, show value no bigger than 1024 with suffix (K,M,G...),
 * else divide by display_unit and do not use suffix. */
const char *make_human_readable_str(unsigned long long size,
		unsigned long block_size, unsigned long display_unit) ;
/* Put a string of hex bytes ("1b2e66fe"...), return advanced pointer */
char *bin2hex(char *buf, const char *cp, int count) ;
/* Reverse */
char* hex2bin(char *dst, const char *str, int count) ;

/* Generate a UUID */
void generate_uuid(uint8_t *buf) ;

/* Last element is marked by mult == 0 */
struct suffix_mult {
	char suffix[4];
	unsigned mult;
};
##including xatonum.h
/* vi: set sw=4 ts=4: */
/*
 * ascii-to-numbers implementations for busybox
 *
 * Copyright (C) 2003  Manuel Novoa III  <mjn3@codepoet.org>
 *
 * Licensed under GPLv2, see file LICENSE in this source tree.
 */

_Pragma("GCC visibility push(hidden)")

/* Provides extern declarations of functions */
/* Unsigned long long functions always exist */
unsigned long longxstrtoull_range_sfx(constchar*str,intb,unsigned long longl,unsigned long longu,conststructsuffix_mult*sfx) ;unsigned long longxstrtoull_range(constchar*str,intb,unsigned long longl,unsigned long longu) ;unsigned long longxstrtoull_sfx(constchar*str,intb,conststructsuffix_mult*sfx) ;unsigned long longxstrtoull(constchar*str,intb) ;unsigned long longxatoull_range_sfx(constchar*str,unsigned long longl,unsigned long longu,conststructsuffix_mult*sfx) ;unsigned long longxatoull_range(constchar*str,unsigned long longl,unsigned long longu) ;unsigned long longxatoull_sfx(constchar*str,conststructsuffix_mult*sfx) ;unsigned long longxatoull(constchar*str) ; long longxstrtoll_range_sfx(constchar*str,intb, long longl, long longu,conststructsuffix_mult*sfx) ; long longxstrtoll_range(constchar*str,intb, long longl, long longu) ; long longxstrtoll(constchar*str,intb) ; long longxatoll_range_sfx(constchar*str, long longl, long longu,conststructsuffix_mult*sfx) ; long longxatoll_range(constchar*str, long longl, long longu) ; long longxatoll_sfx(constchar*str,conststructsuffix_mult*sfx) ; long longxatoll(constchar*str) ;


/* Provides inline definitions of functions */
/* (useful for mapping them to the type of the same width) */
/* If long == long long, then just map them one-to-one */
#if 1
static __inline__unsigned longxstrtoul_range_sfx(constchar*str,intb,unsigned longl,unsigned longu,conststructsuffix_mult*sfx){returnxstrtoull_range_sfx(str,b,l,u,sfx);}static __inline__unsigned longxstrtoul_range(constchar*str,intb,unsigned longl,unsigned longu){returnxstrtoull_range(str,b,l,u);}static __inline__unsigned longxstrtoul_sfx(constchar*str,intb,conststructsuffix_mult*sfx){returnxstrtoull_sfx(str,b,sfx);}static __inline__unsigned longxstrtoul(constchar*str,intb){returnxstrtoull(str,b);}static __inline__unsigned longxatoul_range_sfx(constchar*str,unsigned longl,unsigned longu,conststructsuffix_mult*sfx){returnxatoull_range_sfx(str,l,u,sfx);}static __inline__unsigned longxatoul_range(constchar*str,unsigned longl,unsigned longu){returnxatoull_range(str,l,u);}static __inline__unsigned longxatoul_sfx(constchar*str,conststructsuffix_mult*sfx){returnxatoull_sfx(str,sfx);}static __inline__unsigned longxatoul(constchar*str){returnxatoull(str);}static __inline__ longxstrtol_range_sfx(constchar*str,intb, longl, longu,conststructsuffix_mult*sfx){returnxstrtoll_range_sfx(str,b,l,u,sfx);}static __inline__ longxstrtol_range(constchar*str,intb, longl, longu){returnxstrtoll_range(str,b,l,u);}static __inline__ longxstrtol(constchar*str,intb){returnxstrtoll(str,b);}static __inline__ longxatol_range_sfx(constchar*str, longl, longu,conststructsuffix_mult*sfx){returnxatoll_range_sfx(str,l,u,sfx);}static __inline__ longxatol_range(constchar*str, longl, longu){returnxatoll_range(str,l,u);}static __inline__ longxatol_sfx(constchar*str,conststructsuffix_mult*sfx){returnxatoll_sfx(str,sfx);}static __inline__ longxatol(constchar*str){returnxatoll(str);}
#endif
/* Same for int -> [long] long */
#elif 1
unsigned intxstrtou_range_sfx(constchar*str,intb,unsigned intl,unsigned intu,conststructsuffix_mult*sfx) ;unsigned intxstrtou_range(constchar*str,intb,unsigned intl,unsigned intu) ;unsigned intxstrtou_sfx(constchar*str,intb,conststructsuffix_mult*sfx) ;unsigned intxstrtou(constchar*str,intb) ;unsigned intxatou_range_sfx(constchar*str,unsigned intl,unsigned intu,conststructsuffix_mult*sfx) ;unsigned intxatou_range(constchar*str,unsigned intl,unsigned intu) ;unsigned intxatou_sfx(constchar*str,conststructsuffix_mult*sfx) ;unsigned intxatou(constchar*str) ; intxstrtoi_range_sfx(constchar*str,intb, intl, intu,conststructsuffix_mult*sfx) ; intxstrtoi_range(constchar*str,intb, intl, intu) ; intxstrtoi(constchar*str,intb) ; intxatoi_range_sfx(constchar*str, intl, intu,conststructsuffix_mult*sfx) ; intxatoi_range(constchar*str, intl, intu) ; intxatoi_sfx(constchar*str,conststructsuffix_mult*sfx) ; intxatoi(constchar*str) ;
#endif
/* Specialized */

uint32_t BUG_xatou32_unimplemented(void);
static __inline__ uint32_t xatou32(const char *numstr)
{
	if ((2147483647*2U+1U) == 0xffffffff)
		return xatou(numstr);
	if ((9223372036854775807L*2UL+1UL) == 0xffffffff)
		return xatoul(numstr);
	return BUG_xatou32_unimplemented();
}

/* Non-aborting kind of convertors: bb_strto[u][l]l */

/* On exit: errno = 0 only if there was non-empty, '\0' terminated value
 * errno = EINVAL if value was not '\0' terminated, but otherwise ok
 *    Return value is still valid, caller should just check whether end[0]
 *    is a valid terminating char for particular case. OTOH, if caller
 *    requires '\0' terminated input, [s]he can just check errno == 0.
 * errno = ERANGE if value had alphanumeric terminating char ("1234abcg").
 * errno = ERANGE if value is out of range, missing, etc.
 * errno = ERANGE if value had minus sign for strtouXX (even "-0" is not ok )
 *    return value is all-ones in this case.
 */

unsigned long long bb_strtoull(const char *arg, char **endp, int base) ;
long long bb_strtoll(const char *arg, char **endp, int base) ;

#if 1
static __inline__
unsigned long bb_strtoul(const char *arg, char **endp, int base)
{ return bb_strtoull(arg, endp, base); }
static __inline__
long bb_strtol(const char *arg, char **endp, int base)
{ return bb_strtoll(arg, endp, base); }
#endif
#elif 1
unsigned bb_strtou(const char *arg, char **endp, int base) ;
int bb_strtoi(const char *arg, char **endp, int base) ;
#endif
uint32_t BUG_bb_strtou32_unimplemented(void);
static __inline__
uint32_t bb_strtou32(const char *arg, char **endp, int base)
{
	if (sizeof(uint32_t) == sizeof(unsigned))
		return bb_strtou(arg, endp, base);
	if (sizeof(uint32_t) == sizeof(unsigned long))
		return bb_strtoul(arg, endp, base);
	return BUG_bb_strtou32_unimplemented();
}

/* Floating point */

double bb_strtod(const char *arg, char **endp) ;

_Pragma("GCC visibility pop")
/* Specialized: */

/* Using xatoi() instead of naive atoi() is not always convenient -
 * in many places people want *non-negative* values, but store them
 * in signed int. Therefore we need this one:
 * dies if input is not in [0, INT_MAX] range. Also will reject '-0' etc.
 * It should really be named xatoi_nonnegative (since it allows 0),
 * but that would be too long.
 */
int xatoi_positive(const char *numstr) ;

/* Useful for reading port numbers */
uint16_t xatou16(const char *numstr) ;


/* These parse entries in /etc/passwd and /etc/group.  This is desirable
 * for BusyBox since we want to avoid using the glibc NSS stuff, which
 * increases target size and is often not needed on embedded systems.  */
long xuname2uid(const char *name) ;
long xgroup2gid(const char *name) ;
/* wrapper: allows string to contain numeric uid or gid */
unsigned long get_ug_id(const char *s, long  (*xname2id)(const char *)) ;
/* from chpst. Does not die, returns 0 on failure */
struct bb_uidgid_t {
	uid_t uid;
	gid_t gid;
};
/* always sets uid and gid */
int get_uidgid(struct bb_uidgid_t*, const char*, int numeric_ok) ;
/* always sets uid and gid, allows numeric; exits on failure */
void xget_uidgid(struct bb_uidgid_t*, const char*) ;
/* chown-like handling of "user[:[group]" */
void parse_chown_usergroup_or_die(struct bb_uidgid_t *u, char *user_group) ;
struct passwd* xgetpwnam(const char *name) ;
struct group* xgetgrnam(const char *name) ;
struct passwd* xgetpwuid(uid_t uid) ;
struct group* xgetgrgid(gid_t gid) ;
char* xuid2uname(uid_t uid) ;
char* xgid2group(gid_t gid) ;
char* uid2uname(uid_t uid) ;
char* gid2group(gid_t gid) ;
char* uid2uname_utoa(long uid) ;
char* gid2group_utoa(long gid) ;
/* versions which cache results (useful for ps, ls etc) */
const char* get_cached_username(uid_t uid) ;
const char* get_cached_groupname(gid_t gid) ;
void clear_username_cache(void) ;
/* internally usernames are saved in fixed-sized char[] buffers */
enum { USERNAME_MAX_SIZE = 16 - sizeof(int) };
#if (defined CONFIG_FEATURE_CHECK_NAMES)
void die_if_bad_username(const char* name) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_CHECK_NAMES)
#endif
#if (defined CONFIG_FEATURE_UTMP)
void 
#if 1
#endif
 write_new_utmp(pid_t pid, int new_type, const char *tty_name, const char *username, const char *hostname);
void 
#if 1
#endif
 update_utmp(pid_t pid, int new_type, const char *tty_name, const char *username, const char *hostname);
#elif !(defined CONFIG_FEATURE_UTMP)
#endif
int execable_file(const char *name) ;
char *find_execable(const char *filename, char **PATHp) ;
int exists_execable(const char *filename) ;

/* BB_EXECxx always execs (it's not doing NOFORK/NOEXEC stuff),
 * but it may exec busybox and call applet instead of searching PATH.
 */
#if (defined CONFIG_FEATURE_PREFER_APPLETS)
int bb_execvp(const char *file, char *const argv[]) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_PREFER_APPLETS)
#endif
int BB_EXECVP_or_die(char **argv) __attribute__((__noreturn__)) ;

/* xvfork() can't be a _function_, return after vfork mangles stack
 * in the parent. It must be a macro. */
#if !(defined CONFIG_NOMMU)
pid_t xfork(void) 
#if 1
#endif
;
#endif
/* NOMMU friendy fork+exec: */
pid_t spawn(char **argv) ;
pid_t xspawn(char **argv) ;

pid_t safe_waitpid(pid_t pid, int *wstat, int options) ;
pid_t wait_any_nohang(int *wstat) ;
/* wait4pid: unlike waitpid, waits ONLY for one process.
 * Returns sig + 0x180 if child is killed by signal.
 * It's safe to pass negative 'pids' from failed [v]fork -
 * wait4pid will return -1 (and will not clobber [v]fork's errno).
 * IOW: rc = wait4pid(spawn(argv));
 *      if (rc < 0) bb_perror_msg("%s", argv[0]);
 *      if (rc > 0) bb_error_msg("exit code: %d", rc & 0xff);
 */
int wait4pid(pid_t pid) ;
/* Same as wait4pid(spawn(argv)), but with NOFORK/NOEXEC if configured: */
int spawn_and_wait(char **argv) ;
struct nofork_save_area {
	jmp_buf die_jmp;
	const char *applet_name;
	uint32_t option_mask32;
	int die_sleep;
	uint8_t xfunc_error_retval;
	smallint saved;
};
void save_nofork_data(struct nofork_save_area *save) ;
void restore_nofork_data(struct nofork_save_area *save) ;
/* Does NOT check that applet is NOFORK, just blindly runs it */
int run_nofork_applet(int applet_no, char **argv) ;
int run_nofork_applet_prime(struct nofork_save_area *old, int applet_no, char **argv) ;

/* Helpers for daemonization.
 *
 * bb_daemonize(flags) = daemonize, does not compile on NOMMU
 *
 * bb_daemonize_or_rexec(flags, argv) = daemonizes on MMU (and ignores argv),
 *      rexec's itself on NOMMU with argv passed as command line.
 * Thus bb_daemonize_or_rexec may cause your <applet>_main() to be re-executed
 * from the start. (It will detect it and not reexec again second time).
 * You have to audit carefully that you don't do something twice as a result
 * (opening files/sockets, parsing config files etc...)!
 *
 * Both of the above will redirect fd 0,1,2 to /dev/null and drop ctty
 * (will do setsid()).
 *
 * fork_or_rexec(argv) = bare-bones fork on MMU,
 *      "vfork + re-exec ourself" on NOMMU. No fd redirection, no setsid().
 *      On MMU ignores argv.
 *
 * Helper for network daemons in foreground mode:
 *
 * bb_sanitize_stdio() = make sure that fd 0,1,2 are opened by opening them
 * to /dev/null if they are not.
 */
enum {
	DAEMON_CHDIR_ROOT = 1,
	DAEMON_DEVNULL_STDIO = 2,
	DAEMON_CLOSE_EXTRA_FDS = 4,
	DAEMON_ONLY_SANITIZE = 8, /* internal use */
};
#if !(defined CONFIG_NOMMU)
enum { re_execed = 0 };
#elif (defined CONFIG_NOMMU)
extern 
#if 1
_Bool
#endif
 re_execed;
  void re_exec(char **argv) 
#if 1
__attribute__((__noreturn__))
#endif
 
#if 1
#endif
;
  pid_t fork_or_rexec(char **argv) 
#if 1
#endif
;
  int  BUG_fork_is_unavailable_on_nommu(void) 
#if 1
#endif
;
  int  BUG_daemon_is_unavailable_on_nommu(void) 
#if 1
#endif
;
  void BUG_bb_daemonize_is_unavailable_on_nommu(void) 
#if 1
#endif
;
#endif
void 
#if (defined CONFIG_NOMMU)
bb_daemonize_or_rexec(int flags, char **argv)
#elif !(defined CONFIG_NOMMU)
bb_daemonize_or_rexec(int flags)
#endif
 ;
void bb_sanitize_stdio(void) ;
/* Clear dangerous stuff, set PATH. Return 1 if was run by different user. */
int sanitize_env_if_suid(void) ;


char* single_argv(char **argv) ;
extern const char *const bb_argv_dash[]; /* "-", NULL */
extern const char *opt_complementary;
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
extern const char *applet_long_options;
#endif
extern uint32_t option_mask32;
extern uint32_t getopt32(char **argv, const char *applet_opts, ...) ;


typedef struct llist_t {
	char *data;
	struct llist_t *link;
} llist_t;
void llist_add_to(llist_t **old_head, void *data) ;
void llist_add_to_end(llist_t **list_head, void *data) ;
void *llist_pop(llist_t **elm) ;
void llist_unlink(llist_t **head, llist_t *elm) ;
void llist_free(llist_t *elm, void (*freeit)(void *data)) ;
llist_t *llist_rev(llist_t *list) ;
llist_t *llist_find_str(llist_t *first, const char *str) ;
/* BTW, surprisingly, changing API to
 *   llist_t *llist_add_to(llist_t *old_head, void *data)
 * etc does not result in smaller code... */

/* start_stop_daemon and udhcpc are special - they want
 * to create pidfiles regardless of FEATURE_PIDFILE */
#if (defined CONFIG_FEATURE_PIDFILE)
/* True only if we created pidfile which is *file*, not /dev/null etc */
extern smallint wrote_pidfile;
void write_pidfile(const char *path) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_PIDFILE)
enum { wrote_pidfile = 0 };
#endif
enum {
	LOGMODE_NONE = 0,
	LOGMODE_STDIO = (1 << 0),
	LOGMODE_SYSLOG = (1 << 1) * 
#if (defined CONFIG_FEATURE_SYSLOG)
1
#elif !(defined CONFIG_FEATURE_SYSLOG)
0
#endif
,
	LOGMODE_BOTH = LOGMODE_SYSLOG + LOGMODE_STDIO,
};
extern const char *msg_eol;
extern smallint logmode;
extern int die_sleep;
extern uint8_t xfunc_error_retval;
extern jmp_buf die_jmp;
extern void xfunc_die(void) __attribute__((__noreturn__)) ;
extern void bb_show_usage(void) __attribute__((__noreturn__)) ;
extern void bb_error_msg(const char *s, ...) __attribute__ ((format (printf, 1, 2))) ;
extern void bb_error_msg_and_die(const char *s, ...) __attribute__ ((noreturn, format (printf, 1, 2))) ;
extern void bb_perror_msg(const char *s, ...) __attribute__ ((format (printf, 1, 2))) ;
extern void bb_simple_perror_msg(const char *s) ;
extern void bb_perror_msg_and_die(const char *s, ...) __attribute__ ((noreturn, format (printf, 1, 2))) ;
extern void bb_simple_perror_msg_and_die(const char *s) __attribute__((__noreturn__)) ;
extern void bb_herror_msg(const char *s, ...) __attribute__ ((format (printf, 1, 2))) ;
extern void bb_herror_msg_and_die(const char *s, ...) __attribute__ ((noreturn, format (printf, 1, 2))) ;
extern void bb_perror_nomsg_and_die(void) __attribute__((__noreturn__)) ;
extern void bb_perror_nomsg(void) ;
extern void bb_info_msg(const char *s, ...) __attribute__ ((format (printf, 1, 2))) ;
extern void bb_verror_msg(const char *s, va_list p, const char *strerr) ;

/* We need to export XXX_main from libbusybox
 * only if we build "individual" binaries
 */
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
/* Applets which are useful from another applets */
int bb_cat(char** argv);
/* If shell needs them, they exist even if not enabled as applets */
int echo_main(int argc, char** argv) 
#if (defined CONFIG_ECHO)
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
#elif !(defined CONFIG_ECHO)
#endif
;
int printf_main(int argc, char **argv) 
#if (defined CONFIG_PRINTF)
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
#elif !(defined CONFIG_PRINTF)
#endif
;
int test_main(int argc, char **argv) 
#if (defined CONFIG_TEST)
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
#elif !(defined CONFIG_TEST)
#endif
;
int kill_main(int argc, char **argv) 
#if (defined CONFIG_KILL)
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
#elif !(defined CONFIG_KILL)
#endif
;
/* Similar, but used by chgrp, not shell */
int chown_main(int argc, char **argv) 
#if (defined CONFIG_CHOWN)
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
#elif !(defined CONFIG_CHOWN)
#endif
;
/* Used by ftpd */
int ls_main(int argc, char **argv) 
#if (defined CONFIG_LS)
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
#elif !(defined CONFIG_LS)
#endif
;
/* Don't need IF_xxx() guard for these */
int gunzip_main(int argc, char **argv) 
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
;
int bunzip2_main(int argc, char **argv) 
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
;

#if (defined CONFIG_ROUTE)
void bb_displayroutes(int noresolve, int netstatfmt) 
#if 1
#endif
;
#endif
/* Networking */
int create_icmp_socket(void) ;
int create_icmp6_socket(void) ;
/* interface.c */
/* This structure defines protocol families and their handlers. */
struct aftype {
	const char *name;
	const char *title;
	int af;
	int alen;
	char*        (*print)(unsigned char *);
	const char*  (*sprint)(struct sockaddr *, int numeric);
	int          (*input)(/*int type,*/ const char *bufp, struct sockaddr *);
	void         (*herror)(char *text);
	int          (*rprint)(int options);
	int          (*rinput)(int typ, int ext, char **argv);
	/* may modify src */
	int          (*getmask)(char *src, struct sockaddr *mask, char *name);
};
/* This structure defines hardware protocols and their handlers. */
struct hwtype {
	const char *name;
	const char *title;
	int type;
	int alen;
	char*  (*print)(unsigned char *);
	int    (*input)(const char *, struct sockaddr *);
	int    (*activate)(int fd);
	int suppress_null_addr;
};
extern smallint interface_opt_a;
int display_interfaces(char *ifname) ;
#if (defined CONFIG_FEATURE_HWIB)
int in_ib(const char *bufp, struct sockaddr *sap) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_HWIB)
#endif
const struct aftype *get_aftype(const char *name) ;
const struct hwtype *get_hwtype(const char *name) ;
const struct hwtype *get_hwntype(int type) ;


#if 1
extern int find_applet_by_name(const char *name) ;
/* Returns only if applet is not found. */
extern void run_applet_and_exit(const char *name, char **argv) ;
extern void run_applet_no_and_exit(int a, char **argv) __attribute__((__noreturn__)) ;
#endif
#if 1
extern int match_fstype(const struct mntent *mt, const char *fstypes) ;
extern struct mntent *find_mount_point(const char *name, int subdir_too) ;
#endif
extern void erase_mtab(const char * name) ;
extern unsigned int tty_baud_to_value(speed_t speed) ;
extern speed_t tty_value_to_baud(unsigned int value) ;
#if (defined CONFIG_DESKTOP)
extern void bb_warn_ignoring_args(char *arg) 
#if 1
#endif
;
#elif !(defined CONFIG_DESKTOP)
#endif
extern int get_linux_version_code(void) ;

extern char *query_loop(const char *device) ;
extern int del_loop(const char *device) ;
/* If *devname is not NULL, use that name, otherwise try to find free one,
 * malloc and return it in *devname.
 * return value: 1: read-only loopdev was setup, 0: rw, < 0: error */
extern int set_loop(char **devname, const char *file, unsigned long long offset) ;

/* Like bb_ask below, but asks on stdin with no timeout.  */
char *bb_ask_stdin(const char * prompt) ;
//TODO: pass buf pointer or return allocated buf (avoid statics)?
char *bb_ask(const int fd, int timeout, const char * prompt) ;
int bb_ask_confirmation(void) ;

int bb_parse_mode(const char* s, mode_t* theMode) ;

/*
 * Config file parser
 */
enum {
	PARSE_COLLAPSE  = 0x00010000, // treat consecutive delimiters as one
	PARSE_TRIM      = 0x00020000, // trim leading and trailing delimiters
// TODO: COLLAPSE and TRIM seem to always go in pair
	PARSE_GREEDY    = 0x00040000, // last token takes entire remainder of the line
	PARSE_MIN_DIE   = 0x00100000, // die if < min tokens found
	// keep a copy of current line
	PARSE_KEEP_COPY = 0x00200000 * 
#if (defined CONFIG_FEATURE_CROND_D)
1
#elif !(defined CONFIG_FEATURE_CROND_D)
0
#endif
,
//	PARSE_ESCAPE    = 0x00400000, // process escape sequences in tokens
	// NORMAL is:
	// * remove leading and trailing delimiters and collapse
	//   multiple delimiters into one
	// * warn and continue if less than mintokens delimiters found
	// * grab everything into last token
	PARSE_NORMAL    = PARSE_COLLAPSE | PARSE_TRIM | PARSE_GREEDY,
};
typedef struct parser_t {
	FILE *fp;
	char *line;
	char *data;
	int lineno;
} parser_t;
parser_t* config_open(const char *filename) ;
parser_t* config_open2(const char *filename, FILE*  (*fopen_func)(const char *path)) ;
/* delims[0] is a comment char (use '\0' to disable), the rest are token delimiters */
int config_read(parser_t *parser, char **tokens, unsigned flags, const char *delims) ;
void config_close(parser_t *parser) ;

/* Concatenate path and filename to new allocated buffer.
 * Add "/" only as needed (no duplicate "//" are produced).
 * If path is NULL, it is assumed to be "/".
 * filename should not be NULL. */
char *concat_path_file(const char *path, const char *filename) ;
char *concat_subpath_file(const char *path, const char *filename) ;
const char *bb_basename(const char *name) ;
/* NB: can violate const-ness (similarly to strchr) */
char *last_char_is(const char *s, int c) ;


int bb_make_directory(char *path, long mode, int flags) ;

int get_signum(const char *name) ;
const char *get_signame(int number) ;
void print_signames(void) ;

char *bb_simplify_path(const char *path) ;
/* Returns ptr to NUL */
char *bb_simplify_abs_path_inplace(char *path) ;

extern void bb_do_delay(int seconds) ;
extern void change_identity(const struct passwd *pw) ;
extern void run_shell(const char *shell, int loginshell, const char *command, const char **additional_args) __attribute__((__noreturn__)) ;
#if (defined CONFIG_SELINUX)
extern void renew_current_security_context(void) 
#if 1
#endif
;
extern void set_current_security_context(security_context_t sid) 
#if 1
#endif
;
extern context_t set_security_context_component(security_context_t cur_context,
						char *user, char *role, char *type, char *range) 
#if 1
#endif
;
extern void setfscreatecon_or_die(security_context_t scontext) 
#if 1
#endif
;
extern void selinux_preserve_fcontext(int fdesc) 
#if 1
#endif
;
#elif !(defined CONFIG_SELINUX)
#endif
extern void selinux_or_die(void) ;

/* setup_environment:
 * if chdir pw->pw_dir: ok: else if to_tmp == 1: goto /tmp else: goto / or die
 * if clear_env = 1: cd(pw->pw_dir), clear environment, then set
 *   TERM=(old value)
 *   USER=pw->pw_name, LOGNAME=pw->pw_name
 *   PATH=bb_default_[root_]path
 *   HOME=pw->pw_dir
 *   SHELL=shell
 * else if change_env = 1:
 *   if not root (if pw->pw_uid != 0):
 *     USER=pw->pw_name, LOGNAME=pw->pw_name
 *   HOME=pw->pw_dir
 *   SHELL=shell
 * else does nothing
 */
extern void setup_environment(const char *shell, int flags, const struct passwd *pw) ;
extern int correct_password(const struct passwd *pw) ;
/* Returns a malloced string */
#if !(defined CONFIG_USE_BB_CRYPT)
#endif
extern char *
#if (defined CONFIG_USE_BB_CRYPT)
pw_encrypt(const char *clear, const char *salt, int cleanup)
#elif !(defined CONFIG_USE_BB_CRYPT)
pw_encrypt(const char *clear, const char *salt)
#endif
 ;
extern int obscure(const char *old, const char *newval, const struct passwd *pwdp) ;
/* rnd is additional random input. New one is returned.
 * Useful if you call crypt_make_salt many times in a row:
 * rnd = crypt_make_salt(buf1, 4, 0);
 * rnd = crypt_make_salt(buf2, 4, rnd);
 * rnd = crypt_make_salt(buf3, 4, rnd);
 * (otherwise we risk having same salt generated)
 */
extern int crypt_make_salt(char *p, int cnt, int rnd) ;

/* Returns number of lines changed, or -1 on error */
#if !(defined CONFIG_FEATURE_ADDUSER_TO_GROUP) && !(defined CONFIG_FEATURE_DEL_USER_FROM_GROUP)
#endif
extern int 
#if !(defined CONFIG_FEATURE_ADDUSER_TO_GROUP) && (defined CONFIG_FEATURE_DEL_USER_FROM_GROUP) || (defined CONFIG_FEATURE_ADDUSER_TO_GROUP)
update_passwd(const char *filename,
		const char *username,
		const char *data,
		const char *member)
#elif !(defined CONFIG_FEATURE_ADDUSER_TO_GROUP) && !(defined CONFIG_FEATURE_DEL_USER_FROM_GROUP)
update_passwd(const char *filename, const char *username, const char *data)
#endif
 ;

int index_in_str_array(const char *const string_array[], const char *key) ;
int index_in_strings(const char *strings, const char *key) ;
int index_in_substr_array(const char *const string_array[], const char *key) ;
int index_in_substrings(const char *strings, const char *key) ;
const char *nth_string(const char *strings, int n) ;

extern void print_login_issue(const char *issue_file, const char *tty) ;
extern void print_login_prompt(void) ;

char *xmalloc_ttyname(int fd)  __attribute__((malloc));
/* NB: typically you want to pass fd 0, not 1. Think 'applet | grep something' */
int get_terminal_width_height(int fd, unsigned *width, unsigned *height) ;

int tcsetattr_stdin_TCSANOW(const struct termios *tp) ;

/* NB: "unsigned request" is crucial! "int request" will break some arches! */
int ioctl_or_perror(int fd, unsigned request, void *argp, const char *fmt,...) __attribute__ ((format (printf, 4, 5))) ;
int ioctl_or_perror_and_die(int fd, unsigned request, void *argp, const char *fmt,...) __attribute__ ((format (printf, 4, 5))) ;
#if (defined CONFIG_IOCTL_HEX2STR_ERROR)
int bb_ioctl_or_warn(int fd, unsigned request, void *argp, const char *ioctl_name) 
#if 1
#endif
;
int bb_xioctl(int fd, unsigned request, void *argp, const char *ioctl_name) 
#if 1
#endif
;
#elif !(defined CONFIG_IOCTL_HEX2STR_ERROR)
int bb_ioctl_or_warn(int fd, unsigned request, void *argp) 
#if 1
#endif
;
int bb_xioctl(int fd, unsigned request, void *argp) 
#if 1
#endif
;
#endif
char *is_in_ino_dev_hashtable(const struct stat *statbuf) ;
void add_to_ino_dev_hashtable(const struct stat *statbuf, const char *name) ;
void reset_ino_dev_hashtable(void) ;
#if 1
/* At least glibc has horrendously large inline for this, so wrap it */
unsigned long long bb_makedev(unsigned int major, unsigned int minor) ;
#endif
/* "Keycodes" that report an escape sequence.
 * We use something which fits into signed char,
 * yet doesn't represent any valid Unicode character.
 * Also, -1 is reserved for error indication and we don't use it. */
enum {
	KEYCODE_UP       =  -2,
	KEYCODE_DOWN     =  -3,
	KEYCODE_RIGHT    =  -4,
	KEYCODE_LEFT     =  -5,
	KEYCODE_HOME     =  -6,
	KEYCODE_END      =  -7,
	KEYCODE_INSERT   =  -8,
	KEYCODE_DELETE   =  -9,
	KEYCODE_PAGEUP   = -10,
	KEYCODE_PAGEDOWN = -11,

	KEYCODE_CTRL_UP    = KEYCODE_UP    & ~0x40,
	KEYCODE_CTRL_DOWN  = KEYCODE_DOWN  & ~0x40,
	KEYCODE_CTRL_RIGHT = KEYCODE_RIGHT & ~0x40,
	KEYCODE_CTRL_LEFT  = KEYCODE_LEFT  & ~0x40,
#endif
KEYCODE_CURSOR_POS = -0x100, /* 0xfff..fff00 */
	/* How long is the longest ESC sequence we know?
	 * We want it big enough to be able to contain
	 * cursor position sequence "ESC [ 9999 ; 9999 R"
	 */
	KEYCODE_BUFFER_SIZE = 16
};
/* Note: fd may be in blocking or non-blocking mode, both make sense.
 * For one, less uses non-blocking mode.
 * Only the first read syscall inside read_key may block indefinitely
 * (unless fd is in non-blocking mode),
 * subsequent reads will time out after a few milliseconds.
 * Return of -1 means EOF or error (errno == 0 on EOF).
 * buffer[0] is used as a counter of buffered chars and must be 0
 * on first call.
 * timeout:
 * -2: do not poll for input;
 * -1: poll(-1) (i.e. block);
 * >=0: poll for TIMEOUT milliseconds, return -1/EAGAIN on timeout
 */
int64_t read_key(int fd, char *buffer, int timeout) ;
void read_key_ungets(char *buffer, const char *str, unsigned len) ;


#if (defined CONFIG_FEATURE_EDITING)
/* It's NOT just ENABLEd or disabled. It's a number: */
#if (defined CONFIG_FEATURE_EDITING)
#endif
typedef struct line_input_t {
	int flags;
	const char *path_lookup;
#if (defined CONFIG_FEATURE_EDITING)
int cnt_history;
	int cur_history;
#if (defined CONFIG_FEATURE_EDITING) && (defined CONFIG_FEATURE_EDITING_SAVEHISTORY)
unsigned cnt_history_in_file;
	const char *hist_file;
#endif
char *history[(
#if 1
255
#endif
+0) + 1];
#endif
} line_input_t;
enum {
	DO_HISTORY = 1 * ((
#if 1
255
#endif
+0) > 0),
	SAVE_HISTORY = 2 * ((
#if 1
255
#endif
+0) > 0) * 
#if (defined CONFIG_FEATURE_EDITING_SAVEHISTORY)
1
#elif !(defined CONFIG_FEATURE_EDITING_SAVEHISTORY)
0
#endif
,
	TAB_COMPLETION = 4 * 
#if (defined CONFIG_FEATURE_TAB_COMPLETION)
1
#elif !(defined CONFIG_FEATURE_TAB_COMPLETION)
0
#endif
,
	USERNAME_COMPLETION = 8 * 
#if (defined CONFIG_FEATURE_USERNAME_COMPLETION)
1
#elif !(defined CONFIG_FEATURE_USERNAME_COMPLETION)
0
#endif
,
	VI_MODE = 0x10 * 
#if (defined CONFIG_FEATURE_EDITING_VI)
1
#elif !(defined CONFIG_FEATURE_EDITING_VI)
0
#endif
,
	WITH_PATH_LOOKUP = 0x20,
	FOR_SHELL = DO_HISTORY | SAVE_HISTORY | TAB_COMPLETION | USERNAME_COMPLETION,
};
line_input_t *new_line_input_t(int flags) 
#if 1
#endif
;
/* So far static: void free_line_input_t(line_input_t *n) FAST_FUNC; */
/* maxsize must be >= 2.
 * Returns:
 * -1 on read errors or EOF, or on bare Ctrl-D,
 * 0  on ctrl-C (the line entered is still returned in 'command'),
 * >0 length of input string, including terminating '\n'
 */
int read_line_input(const char* prompt, char* command, int maxsize, line_input_t *state) 
#if 1
#endif
;
#elif !(defined CONFIG_FEATURE_EDITING)
int read_line_input(const char* prompt, char* command, int maxsize) 
#if 1
#endif
;
#endif
#if 1
#elif 1
/* synchronize with sizeof(task_struct.comm) in /usr/include/linux/sched.h */
enum { COMM_LEN = 16 };
#endif
#endif
struct smaprec {
	unsigned long mapped_rw;
	unsigned long mapped_ro;
	unsigned long shared_clean;
	unsigned long shared_dirty;
	unsigned long private_clean;
	unsigned long private_dirty;
	unsigned long stack;
	unsigned long smap_pss, smap_swap;
	unsigned long smap_size;
	unsigned long smap_start;
	char smap_mode[5];
	char *smap_name;
};

#if !(defined CONFIG_PMAP)
#endif
int  
#if (defined CONFIG_PMAP)
procps_read_smaps(pid_t pid, struct smaprec *total,
		      void (*cb)(struct smaprec *, void *), void *data)
#elif !(defined CONFIG_PMAP)
procps_read_smaps(pid_t pid, struct smaprec *total)
#endif
;

typedef struct procps_status_t {
	DIR *dir;
	
#if (defined CONFIG_FEATURE_SHOW_THREADS)
DIR *task_dir;
#elif !(defined CONFIG_FEATURE_SHOW_THREADS)
#endif

	uint8_t shift_pages_to_bytes;
	uint8_t shift_pages_to_kb;
/* Fields are set to 0/NULL if failed to determine (or not requested) */
	uint16_t argv_len;
	char *argv0;
	char *exe;
	
#if (defined CONFIG_SELINUX)
char *context;
#elif !(defined CONFIG_SELINUX)
#endif

	/* Everything below must contain no ptrs to malloc'ed data:
	 * it is memset(0) for each process in procps_scan() */
	unsigned long vsz, rss; /* we round it to kbytes */
	unsigned long stime, utime;
	unsigned long start_time;
	unsigned pid;
	unsigned ppid;
	unsigned pgid;
	unsigned sid;
	unsigned uid;
	unsigned gid;
#if (defined CONFIG_FEATURE_PS_ADDITIONAL_COLUMNS)
unsigned ruid;
	unsigned rgid;
	int niceness;
#endif
unsigned tty_major,tty_minor;
#if (defined CONFIG_FEATURE_TOPMEM)
struct smaprec smaps;
#endif
char state[4];
	/* basename of executable in exec(2), read from /proc/N/stat
	 * (if executable is symlink or script, it is NOT replaced
	 * by link target or interpreter name) */
	char comm[COMM_LEN];
	/* user/group? - use passwd/group parsing functions */
#if (defined CONFIG_FEATURE_TOP_SMP_PROCESS)
int last_seen_on_cpu;
#endif
} procps_status_t;
/* flag bits for procps_scan(xx, flags) calls */
enum {
	PSSCAN_PID      = 1 << 0,
	PSSCAN_PPID     = 1 << 1,
	PSSCAN_PGID     = 1 << 2,
	PSSCAN_SID      = 1 << 3,
	PSSCAN_UIDGID   = 1 << 4,
	PSSCAN_COMM     = 1 << 5,
	/* PSSCAN_CMD      = 1 << 6, - use read_cmdline instead */
	PSSCAN_ARGV0    = 1 << 7,
	PSSCAN_EXE      = 1 << 8,
	PSSCAN_STATE    = 1 << 9,
	PSSCAN_VSZ      = 1 << 10,
	PSSCAN_RSS      = 1 << 11,
	PSSCAN_STIME    = 1 << 12,
	PSSCAN_UTIME    = 1 << 13,
	PSSCAN_TTY      = 1 << 14,
	PSSCAN_SMAPS	= (1 << 15) * 
#if (defined CONFIG_FEATURE_TOPMEM)
1
#elif !(defined CONFIG_FEATURE_TOPMEM)
0
#endif
,
	/* NB: used by find_pid_by_name(). Any applet using it
	 * needs to be mentioned here. */
	PSSCAN_ARGVN    = (1 << 16) * (
#if (defined CONFIG_KILLALL)
1
#elif !(defined CONFIG_KILLALL)
0
#endif

				|| 
#if (defined CONFIG_PGREP)
1
#elif !(defined CONFIG_PGREP)
0
#endif
 || 
#if (defined CONFIG_PKILL)
1
#elif !(defined CONFIG_PKILL)
0
#endif

				|| 
#if (defined CONFIG_PIDOF)
1
#elif !(defined CONFIG_PIDOF)
0
#endif

				|| 
#if (defined CONFIG_SESTATUS)
1
#elif !(defined CONFIG_SESTATUS)
0
#endif

				),
	PSSCAN_CONTEXT  = (1 << 17) * 
#if (defined CONFIG_SELINUX)
1
#elif !(defined CONFIG_SELINUX)
0
#endif
,
	PSSCAN_START_TIME = 1 << 18,
	PSSCAN_CPU      = (1 << 19) * 
#if (defined CONFIG_FEATURE_TOP_SMP_PROCESS)
1
#elif !(defined CONFIG_FEATURE_TOP_SMP_PROCESS)
0
#endif
,
	PSSCAN_NICE     = (1 << 20) * 
#if (defined CONFIG_FEATURE_PS_ADDITIONAL_COLUMNS)
1
#elif !(defined CONFIG_FEATURE_PS_ADDITIONAL_COLUMNS)
0
#endif
,
	PSSCAN_RUIDGID  = (1 << 21) * 
#if (defined CONFIG_FEATURE_PS_ADDITIONAL_COLUMNS)
1
#elif !(defined CONFIG_FEATURE_PS_ADDITIONAL_COLUMNS)
0
#endif
,
	PSSCAN_TASKS	= (1 << 22) * 
#if (defined CONFIG_FEATURE_SHOW_THREADS)
1
#elif !(defined CONFIG_FEATURE_SHOW_THREADS)
0
#endif
,
	/* These are all retrieved from proc/NN/stat in one go: */
	PSSCAN_STAT     = PSSCAN_PPID | PSSCAN_PGID | PSSCAN_SID
	/**/            | PSSCAN_COMM | PSSCAN_STATE
	/**/            | PSSCAN_VSZ | PSSCAN_RSS
	/**/            | PSSCAN_STIME | PSSCAN_UTIME | PSSCAN_START_TIME
	/**/            | PSSCAN_TTY | PSSCAN_NICE
	/**/            | PSSCAN_CPU
};
//procps_status_t* alloc_procps_scan(void) FAST_FUNC;
void free_procps_scan(procps_status_t* sp) ;
procps_status_t* procps_scan(procps_status_t* sp, int flags) ;
/* Format cmdline (up to col chars) into char buf[size] */
/* Puts [comm] if cmdline is empty (-> process is a kernel thread) */
void read_cmdline(char *buf, int size, unsigned pid, const char *comm) ;
pid_t *find_pid_by_name(const char* procName) ;
pid_t *pidlist_reverse(pid_t *pidList) ;
int starts_with_cpu(const char *str) ;
unsigned get_cpu_count(void) ;


extern const char bb_uuenc_tbl_base64[];
extern const char bb_uuenc_tbl_std[];
void bb_uuencode(char *store, const void *s, int length, const char *tbl) ;
enum {
	BASE64_FLAG_UU_STOP = 0x100,
	/* Sign-extends to a value which never matches fgetc result: */
	BASE64_FLAG_NO_STOP_CHAR = 0x80,
};
void  read_base64(FILE *src_stream, FILE *dst_stream, int flags);

typedef struct md5_ctx_t {
	uint8_t wbuffer[64]; /* always correctly aligned for uint64_t */
	void (*process_block)(struct md5_ctx_t*) ;
	uint64_t total64;    /* must be directly before hash[] */
	uint32_t hash[8];    /* 4 elements for md5, 5 for sha1, 8 for sha256 */
} md5_ctx_t;
typedef struct md5_ctx_t sha1_ctx_t;
typedef struct md5_ctx_t sha256_ctx_t;
typedef struct sha512_ctx_t {
	uint64_t total64[2];  /* must be directly before hash[] */
	uint64_t hash[8];
	uint8_t wbuffer[128]; /* always correctly aligned for uint64_t */
} sha512_ctx_t;
void md5_begin(md5_ctx_t *ctx) ;
void md5_hash(md5_ctx_t *ctx, const void *data, size_t length) ;
void md5_end(md5_ctx_t *ctx, void *resbuf) ;
void sha1_begin(sha1_ctx_t *ctx) ;
void sha1_end(sha1_ctx_t *ctx, void *resbuf) ;
void sha256_begin(sha256_ctx_t *ctx) ;
void sha512_begin(sha512_ctx_t *ctx) ;
void sha512_hash(sha512_ctx_t *ctx, const void *buffer, size_t len) ;
void sha512_end(sha512_ctx_t *ctx, void *resbuf) ;

extern uint32_t *global_crc32_table;
uint32_t *crc32_filltable(uint32_t *tbl256, int endian) ;
uint32_t crc32_block_endian1(uint32_t val, const void *buf, unsigned len, uint32_t *crc_table) ;
uint32_t crc32_block_endian0(uint32_t val, const void *buf, unsigned len, uint32_t *crc_table) ;

typedef struct masks_labels_t {
	const char *labels;
	const int masks[];
} masks_labels_t;
int print_flags_separated(const int *masks, const char *labels,
		int flags, const char *separator) ;
int print_flags(const masks_labels_t *ml, int flags) ;

typedef struct bb_progress_t {
	off_t lastsize;
	unsigned lastupdate_sec;
	unsigned start_sec;
	smallint inited;
} bb_progress_t;

void bb_progress_init(bb_progress_t *p) ;
void bb_progress_update(bb_progress_t *p, const char *curfile,
			off_t beg_range, off_t transferred,
			off_t totalsize) ;

extern const char *applet_name;

/* Some older linkers don't perform string merging, we used to have common strings
 * as global arrays to do it by hand. But:
 * (1) newer linkers do it themselves,
 * (2) however, they DONT merge string constants with global arrays,
 * even if the value is the same (!). Thus global arrays actually
 * increased size a bit: for example, "/etc/passwd" string from libc
 * wasn't merged with bb_path_passwd_file[] array!
 * Therefore now we use #defines.
 */
/* "BusyBox vN.N.N (timestamp or extra_version)" */
extern const char bb_banner[];
extern const char bb_msg_memory_exhausted[];
extern const char bb_msg_invalid_date[];
extern const char bb_msg_unknown[];
extern const char bb_msg_can_not_create_raw_socket[];
extern const char bb_msg_perm_denied_are_you_root[];
extern const char bb_msg_you_must_be_root[];
extern const char bb_msg_requires_arg[];
extern const char bb_msg_invalid_arg[];
extern const char bb_msg_standard_input[];
extern const char bb_msg_standard_output[];

/* NB: (bb_hexdigits_upcase[i] | 0x20) -> lowercase hex digit */
extern const char bb_hexdigits_upcase[];

extern const char bb_path_wtmp_file[];

/* Busybox mount uses either /proc/mounts or /etc/mtab to
 * get the list of currently mounted filesystems */
extern const char bb_busybox_exec_path[];
/* util-linux manpage says /sbin:/bin:/usr/sbin:/usr/bin,
 * but I want to save a few bytes here */
extern const char bb_PATH_root_path[]; /* "PATH=/sbin:/usr/sbin:/bin:/usr/bin" */
extern const int const_int_0;
extern const int const_int_1;


/* Providing hard guarantee on minimum size (think of BUFSIZ == 128) */
enum { COMMON_BUFSIZE = (8192 >= 256*sizeof(void*) ? 8192+1 : 256*sizeof(void*)) };
extern char bb_common_bufsiz1[COMMON_BUFSIZE];
/* This struct is deliberately not defined. */
/* See docs/keep_data_small.txt */
struct globals;
/* '*const' ptr makes gcc optimize code much better.
 * Magic prevents ptr_to_globals from going into rodata.
 * If you want to assign a value, use SET_PTR_TO_GLOBALS(x) */
extern struct globals *const ptr_to_globals;
/* At least gcc 3.4.6 on mipsel system needs optimization barrier */
/* You can change LIBBB_DEFAULT_LOGIN_SHELL, but don't use it,
 * use bb_default_login_shell and following defines.
 * If you change LIBBB_DEFAULT_LOGIN_SHELL,
 * don't forget to change increment constant. */
extern const char bb_default_login_shell[];
/* "/bin/sh" */
/* "sh" */
/* The following devices are the same on all systems.  */
#elif (defined CONFIG_FEATURE_DEVFS)
/*Linux, obsolete devfs names */
#elif !(defined CONFIG_FEATURE_DEVFS)
/*Linux, normal names */
#endif
/* We redefine ctype macros. Unicode-correct handling of char types
 * can't be done with such byte-oriented operations anyway,
 * we don't lose anything.
 */
/* We save ~500 bytes on isdigit alone.
 * BTW, x86 likes (unsigned char) cast more than (unsigned). */

/* These work the same for ASCII and Unicode,
 * assuming no one asks "is this a *Unicode* letter?" using isalpha(letter) */
/* In POSIX/C locale isspace is only these chars: "\t\n\v\f\r" and space.
 * "\t\n\v\f\r" happen to have ASCII codes 9,10,11,12,13.
 */
static __inline__ int bb_ascii_isalnum(unsigned char a)
{
	unsigned char b = a - '0';
	if (b <= 9)
		return (b <= 9);
	b = (a|0x20) - 'a';
	return b <= 'z' - 'a';
}
static __inline__ int bb_ascii_isxdigit(unsigned char a)
{
	unsigned char b = a - '0';
	if (b <= 9)
		return (b <= 9);
	b = (a|0x20) - 'a';
	return b <= 'f' - 'a';
}
static __inline__ unsigned char bb_ascii_toupper(unsigned char a)
{
	unsigned char b = a - 'a';
	if (b <= ('z' - 'a'))
		a -= 'a' - 'A';
	return a;
}
static __inline__ unsigned char bb_ascii_tolower(unsigned char a)
{
	unsigned char b = a - 'A';
	if (b <= ('Z' - 'A'))
		a += 'a' - 'A';
	return a;
}

/* In ASCII and Unicode, these are likely to be very different.
 * Let's prevent ambiguous usage from the start */
/* NB: must not treat EOF as isgraph or isprint */
_Pragma("GCC visibility pop")

#endif
#if (defined CONFIG_FEATURE_DATE_NANO)
##including sys/syscall.h
/* Copyright (C) 1995, 1996, 1997 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#if (defined CONFIG_FEATURE_DATE_NANO)
/* This file should list the numbers of the system the system knows.
   But instead of duplicating this we use the information available
   from the kernel sources.  */
##including asm/unistd.h
#elif (defined CONFIG_FEATURE_DATE_NANO)
##including unistd_64.h
#if (defined CONFIG_FEATURE_DATE_NANO)
#if (defined CONFIG_FEATURE_DATE_NANO)
#endif
/*
 * This file contains the system call numbers.
 *
 * Note: holes are not allowed.
 */

/* at least 8 syscall per cacheline */





















































































































/* at the very end the stuff that never runs during the benchmarks */


































/* Only needed for a.out */






































































/* reserved for LiS/STREAMS */



/* reserved for AFS */


/* reserved for tux */
























	/* use arch_prctl */





	/* use arch_prctl */

























































































#if (defined CONFIG_FEATURE_DATE_NANO)
#endif
#endif
#endif
#if (defined CONFIG_FEATURE_DATE_NANO)
/* The Linux kernel header file defines macros `__NR_<name>', but some
   programs expect the traditional form `SYS_<name>'.  So in building libc
   we scan the kernel's list and produce <bits/syscall.h> with macros for
   all the `SYS_' names.  */
##including bits/syscall.h
/* Generated at libc build time from kernel syscall list.  */

#endif
##including bits/wordsize.h
/* Determine the wordsize from the preprocessor defines.  */

#if (defined CONFIG_FEATURE_DATE_NANO)
#endif
#if (defined CONFIG_FEATURE_DATE_NANO)
#endif
#endif
#endif
#endif
enum {
	OPT_RFC2822   = (1 << 0), /* R */
	OPT_SET       = (1 << 1), /* s */
	OPT_UTC       = (1 << 2), /* u */
	OPT_DATE      = (1 << 3), /* d */
	OPT_REFERENCE = (1 << 4), /* r */
	OPT_TIMESPEC  = (1 << 5) * 
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
1
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
0
#endif
, /* I */
	OPT_HINT      = (1 << 6) * 
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
1
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
0
#endif
, /* D */
};

static void maybe_set_utc(int opt)
{
	if (opt & OPT_UTC)
		putenv((char*)"TZ=UTC0");
}

#if (defined CONFIG_LONG_OPTS)
static const char date_longopts[] 
#if 1
__attribute__((aligned(1)))
#endif
 =
		"rfc-822\0"   
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
"\0"
#endif
       "R"
		"rfc-2822\0"  
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
"\0"
#endif
       "R"
		"set\0"       
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
"\001"
#endif
 "s"
		"utc\0"       
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
"\0"
#endif
       "u"
	/*	"universal\0" No_argument       "u" */
		"date\0"      
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
"\001"
#endif
 "d"
		"reference\0" 
#if !(defined CONFIG_LONG_OPTS) && (defined CONFIG_FEATURE_GETOPT_LONG) || (defined CONFIG_LONG_OPTS)
"\001"
#endif
 "r"
		;
#endif
int date_main(int argc, char **argv) 
#if (defined CONFIG_FEATURE_INDIVIDUAL)
#if 1
__attribute__((visibility("default")))
#endif
#elif !(defined CONFIG_FEATURE_INDIVIDUAL)
#endif
;
int date_main(int argc __attribute__((__unused__)), char **argv)
{
	struct timespec ts;
	struct tm tm_time;
	char buf_fmt_dt2str[64];
	unsigned opt;
	int ifmt = -1;
	char *date_str;
	char *fmt_dt2str;
	char *fmt_str2dt;
	char *filename;
	char *isofmt_arg = ((void*)0);

	opt_complementary = "d--s:s--d"
		
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
":R--I:I--R"
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
#endif
;
	
#if (defined CONFIG_LONG_OPTS)
applet_long_options = date_longopts;
#elif !(defined CONFIG_LONG_OPTS)
#endif

	opt = getopt32(argv, "Rs:ud:r:"
			
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
"I::D:"
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
#endif
,
			&date_str, &date_str, &filename
			
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
, &isofmt_arg, &fmt_str2dt
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
#endif
);
	argv += optind;
	maybe_set_utc(opt);

	if (
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
1
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
0
#endif
 && (opt & OPT_TIMESPEC)) {
		ifmt = 0; /* default is date */
		if (isofmt_arg) {
			static const char isoformats[] __attribute__((aligned(1))) =
				"date\0""hours\0""minutes\0""seconds\0"; /* ns? */
			ifmt = index_in_substrings(isoformats, isofmt_arg);
			if (ifmt < 0)
				bb_show_usage();
		}
	}

	fmt_dt2str = ((void*)0);
	if (argv[0] && argv[0][0] == '+') {
		fmt_dt2str = &argv[0][1]; /* skip over the '+' */
		argv++;
	}
	if (!(opt & (OPT_SET | OPT_DATE))) {
		opt |= OPT_SET;
		date_str = argv[0]; /* can be NULL */
		if (date_str) {
#if (defined CONFIG_FEATURE_DATE_COMPAT)
int len = strspn(date_str, "0123456789");
			if (date_str[len] == '\0'
			 || (date_str[len] == '.'
			    && ((unsignedchar)((date_str[len+1])-'0')<=9)
			    && ((unsignedchar)((date_str[len+2])-'0')<=9)
			    && date_str[len+3] == '\0'
			    )
			) {
				/* Dreaded MMDDhhmm[[CC]YY][.ss] format!
				 * It does not match -d or -s format.
				 * Some users actually do use it.
				 */
				len -= 8;
				if (len < 0 || len > 4 || (len & 1))
					bb_error_msg_and_die(bb_msg_invalid_date, date_str);
				if (len != 0) { /* move YY or CCYY to front */
					char buf[4];
					memcpy(buf, date_str + 8, len);
					memmove(date_str + len, date_str, 8);
					memcpy(date_str, buf, len);
				}
			}
#endif
argv++;
		}
	}
	if (*argv)
		bb_show_usage();

	/* Now we have parsed all the information except the date format
	 * which depends on whether the clock is being set or read */

	if (opt & OPT_REFERENCE) {
		struct stat statbuf;
		xstat(filename, &statbuf);
		ts.tv_sec = statbuf.st_mtim.tv_sec;
#if (defined CONFIG_FEATURE_DATE_NANO)
ts.tv_nsec = statbuf.st_mtim.tv_nsec;
		/* some toolchains use .st_mtimensec instead of st_mtim.tv_nsec */
#endif
} else {
#if (defined CONFIG_FEATURE_DATE_NANO)
/* libc has incredibly messy way of doing this,
		 * typically requiring -lrt. We just skip all this mess */
		syscall(228, 
#if 1
0
#endif
, &ts);
#elif !(defined CONFIG_FEATURE_DATE_NANO)
time(&ts.tv_sec);
#endif
}
	localtime_r(&ts.tv_sec, &tm_time);

	/* If date string is given, update tm_time, and maybe set date */
	if (date_str != ((void*)0)) {
		/* Zero out fields - take her back to midnight! */
		tm_time.tm_sec = 0;
		tm_time.tm_min = 0;
		tm_time.tm_hour = 0;

		/* Process any date input to UNIX time since 1 Jan 1970 */
		if (
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
1
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
0
#endif
 && (opt & OPT_HINT)) {
			if (strptime(date_str, fmt_str2dt, &tm_time) == ((void*)0))
				bb_error_msg_and_die(bb_msg_invalid_date, date_str);
		} else {
			parse_datestr(date_str, &tm_time);
		}

		/* Correct any day of week and day of year etc. fields */
		tm_time.tm_isdst = -1;  /* Be sure to recheck dst */
		ts.tv_sec = validate_tm_time(date_str, &tm_time);

		maybe_set_utc(opt);

		/* if setting time, set it */
		if ((opt & OPT_SET) && stime(&ts.tv_sec) < 0) {
			bb_perror_msg("can't set date");
		}
	}

	/* Display output */

	/* Deal with format string */
	if (fmt_dt2str == ((void*)0)) {
		int i;
		fmt_dt2str = buf_fmt_dt2str;
		if (
#if (defined CONFIG_FEATURE_DATE_ISOFMT)
1
#elif !(defined CONFIG_FEATURE_DATE_ISOFMT)
0
#endif
 && ifmt >= 0) {
			/* -I[SPEC]: 0:date 1:hours 2:minutes 3:seconds */
			strcpy(fmt_dt2str, "%Y-%m-%dT%H:%M:%S");
			i = 8 + 3 * ifmt;
			if (ifmt != 0) {
				/* TODO: if (ifmt==4) i += sprintf(&fmt_dt2str[i], ",%09u", nanoseconds); */
 format_utc:
				fmt_dt2str[i++] = '%';
				fmt_dt2str[i++] = (opt & OPT_UTC) ? 'Z' : 'z';
			}
			fmt_dt2str[i] = '\0';
		} else if (opt & OPT_RFC2822) {
			/* -R. undo busybox.c setlocale */
			if (
#if (defined CONFIG_LOCALE_SUPPORT)
1
#elif !(defined CONFIG_LOCALE_SUPPORT)
0
#endif
)
				
#if (defined CONFIG_LOCALE_SUPPORT)
setlocale(__LC_TIME, "C")
#elif !(defined CONFIG_LOCALE_SUPPORT)
((void)0)
#endif
;
			strcpy(fmt_dt2str, "%a, %d %b %Y %H:%M:%S ");
			i = sizeof("%a, %d %b %Y %H:%M:%S ")-1;
			goto format_utc;
		} else { /* default case */
			fmt_dt2str = (char*)"%a %b %e %H:%M:%S %Z %Y";
		}
	}
#if (defined CONFIG_FEATURE_DATE_NANO)
else {
		/* User-specified fmt_dt2str */
		/* Search for and process "%N" */
		char *p = fmt_dt2str;
		while ((p = strchr(p, '%')) != 
#if 1
((void*)0)
#endif
) {
			int n, m;
			unsigned pres, scale;

			p++;
			if (*p == '%') {
				p++;
				continue;
			}
			n = strspn(p, "0123456789");
			if (p[n] != 'N') {
				p += n;
				continue;
			}
			/* We have "%[nnn]N" */
			p[-1] = '\0';
			p[n] = '\0';
			scale = 1;
			pres = 9;
			if (n) {
				pres = xatoi_positive(p);
				if (pres == 0)
					pres = 9;
				m = 9 - pres;
				while (--m >= 0)
					scale *= 10;
			}

			m = p - fmt_dt2str;
			p += n + 1;
			fmt_dt2str = xasprintf("%s%0*u%s", fmt_dt2str, pres, (unsigned)ts.tv_nsec / scale, p);
			p = fmt_dt2str + m;
		}
	}
#endif
if (*fmt_dt2str == '\0') {
		/* With no format string, just print a blank line */
		bb_common_bufsiz1[0] = '\0';
	} else {
		/* Handle special conversions */
		if (strncmp(fmt_dt2str, "%f", 2) == 0) {
			fmt_dt2str = (char*)"%Y.%m.%d-%H:%M:%S";
		}
		/* Generate output string */
		strftime(bb_common_bufsiz1, sizeof(bb_common_bufsiz1), fmt_dt2str, &tm_time);
	}
	puts(bb_common_bufsiz1);

	return 0;
}