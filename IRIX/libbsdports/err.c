/*
 @what - bsd err, warn replacement for IRIX

 @author - John Hartley - Graphics Software/Dokmai Pty Ltd

 (C)opyright 2023 - All rights reserved
*/

#include <err.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* extern const char *__progname; */

char unknown[] = "unknown";

const char *get_progname() {
  const char *prog = getenv("_");
  if (prog != NULL) {
    char *p = strrchr(prog, '/');
    if (p != NULL) {
      prog = p+1;
    }
  } else {
    prog = unknown;
  }
  return prog;
}
 
void verr(int eval, const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);

    fprintf(stderr, "%s: ", get_progname());
    fprintf(stderr, "%s: ", strerror(errno));
    vfprintf(stderr, fmt, args);
    fputc('\n', stderr);

  va_end(args);
  exit(eval);
}

void verrx(int eval, const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);

    fprintf(stderr, "%s: ", get_progname());
    vfprintf(stderr, fmt, args);
    fputc('\n', stderr);

  va_end(args);
  exit(eval);
}

void vwarn(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);

    fprintf(stderr, "%s: ", get_progname());
    fprintf(stderr, "%s: ", strerror(errno));
    vfprintf(stderr, fmt, args);
    fputc('\n', stderr);

  va_end(args);
}

void vwarnx(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);

    fprintf(stderr, "%s: ", get_progname());
    vfprintf(stderr, fmt, args);
    fputc('\n', stderr);

  va_end(args);
}

