
#ifndef _CAML_C_H_
#define _CAML_C_H_

#include <caml/mlvalues.h>

value call_play(value v, value sys);

value call_load(value v, value sys);

value call_stop(value v);

value call_pause(value v, value sys);

value call_init();

#endif

