/*
 @what - bsd err.h replacement for IRIX

 @author - John Hartley - Graphica Software/Dokmai Pty Ltd

 (C)opyright 2023 - All rights reserved
*/

#ifndef __IRIX_ERR_H__
#define __IRIX_ERR_H__

#include <stdarg.h>

#define err verr
#define warn vwarn

void verr(int eval, const char *fmt, ...);
void vwarn(int eval, const char *fmt, ...);

#endif
