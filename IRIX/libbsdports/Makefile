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

prefix?=/usr/local2

SRCS=	err.c stringlist.c strsep.c

INCS=	err.h stringlist.h strsep.h namespace.h un-namespace.h

.MAIN: build

# .PHONY = install

CLEANFILES=

SHLIB_MAJOR=	1

LLIB = lib${LIB}.a

ILIB = ${prefix}/lib/${LLIB}
IINCDIR = ${prefix}/include/

IHEADERS = ${INCS:M*.h:S/^/${IINCDIR}/g}

IINC = ${prefix}/include
OBJS=${SRCS:M*.c:R:S/$/.o/g}

.c.o:
	c99 ${CFLAGS} -c -o $@ $<

${LLIB}: ${OBJS}
	ar -cr $@ ${.ALLSRC}

${IHEADERS}: ${INCS}
	cp ${.ALLSRC} ${IINCDIR}

${ILIB}: ${LLIB}
	cp ${LLIB} ${ILIB}

build: ${LLIB}

install: ${IHEADERS} ${ILIB}

