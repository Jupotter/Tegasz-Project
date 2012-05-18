
#ifndef _CAML_C_H_
#define _CAML_C_H_

#include <caml/mlvalues.h>
#include <caml/alloc.h>

value call_play(value v, value sys);

value call_load(value v, value sys);

value call_stop(value v);

value call_pause(value v);

value call_init();

value set_volume(value v, value c);

value is_paused(value v);

#endif

