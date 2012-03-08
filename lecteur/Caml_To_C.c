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


value call_play(value v)
{
	FMOD_SYSTEM 	*system;
	FMOD_SOUND		*sound1;
	FMOD_CHANNEL	*channel = 0;
	FMOD_RESULT		result;

	FMOD_Initialize(&system, 32, FMOD_INIT_NORMAL, NULL);

	result = FMOD_System_CreateSound(system, "AudioTest.mp3", FMOD_SOFTWARE, 0, &sound1);
	FMOD_Err_Check(result);
	result = FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound1, 0, &channel);
	FMOD_Err_Check(result);

  return (v);
}

/* End main.c */
