/*
 @what - bsd err.h replacement for IRIX

 @author - John Hartley - Graphica Software/Dokmai Pty Ltd

 (C)opyright 2023 - All rights reserved
*/

#ifndef __IRIX_ERR_H__
#define __IRIX_ERR_H__

#include <stdarg.h>

#define err verr
#define _err verr
#define errx verrx
#define warn vwarn
#define warnx vwarnx

void verr(int eval, const char *fmt, ...);
void verrx(int eval, const char *fmt, ...);
void vwarn(const char *fmt, ...);
void vwarnx(const char *fmt, ...);

#endif
