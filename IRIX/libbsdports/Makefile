#
# @what - build bsdports compatability library
#

PACKAGE=	bsdports

LIB=	bsdports

COMPILER_TYPE=MIPSpro
COMPILER_VERSION=4.4.4m

MKDEP_CMD="c99 -MDupdate"

CC=c99
CFLAGS+=-mips4 -64 -I.
LDFLAGS+=-mip4 -64

SRCS=	err.c stringlist.c

INCS=	err.h stringlist.h

CLEANFILES=

SHLIB_MAJOR=	1


.include <irix.lib.mk>
.include <sys/IRIX.mk>
