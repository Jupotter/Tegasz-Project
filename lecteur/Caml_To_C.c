/*
 * main.c: contains the program entry point.
 */

/* Standard headers */
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include "Caml_To_C.h"

/* Also include fmod */
#include "fmod.h"

#include "FMOD_Err_Check.h"
#include "FMOD_Wrap.h"


value call_play(value v, value sys)
{
	FMOD_SYSTEM 	*system;
	FMOD_SOUND		*sound1;
	FMOD_CHANNEL	*channel = 0;
	FMOD_RESULT		result;

	system = (void*)sys;
	sound1 = (void*)v;

	/*result = FMOD_System_CreateSound(system, sound1, FMOD_SOFTWARE, 0, &sound1);
	FMOD_Err_Check(result);*/
	result = FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound1, 0, &channel);
	FMOD_Err_Check(result);

  return 0;
}

value call_init()
{
	FMOD_SYSTEM 	*system;
	FMOD_Initialize(&system, 32, FMOD_INIT_NORMAL, NULL);

	printf("init");

	return (value)system;
}

value call_load(value v, value sys)
{
	FMOD_SYSTEM 	*system;
	FMOD_SOUND		*sound1;
	FMOD_RESULT		result;

	char *name;
	name = String_val(v);
	system = (void*)sys;

	result = FMOD_System_CreateSound(system, name ,FMOD_SOFTWARE, 0, &sound1);
	FMOD_Err_Check(result);

	return (value)sound1;
}

/* End main.c */
