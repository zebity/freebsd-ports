/*
 @what - test the bsd err compatability function
*/

#include <err.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int errcode = 1;

  printf("%s: printing error\n", argv[0]);
  printf("getenv: %s\n", getenv("_"));

  err(errcode, "%s - calling err for %d", argv[0], errcode);

}
