/*
 * main.c: contains the program entry point.
 */

/* Standard headers */
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

/* Also include fmod */
#include "fmod.h"

#include "FMOD_Err_Check.h"
#include "FMOD_Wrap.h"


int main(int argc, char *argv[])
{
	if (argc > 1)
	{
	FMOD_SYSTEM 	*system;
	FMOD_SOUND		*sound1;
	FMOD_CHANNEL	*channel = 0;
	FMOD_RESULT		result;

	FMOD_Initialize(&system, 32, FMOD_INIT_NORMAL, NULL);

	result = FMOD_System_CreateSound(system, argv[1], FMOD_SOFTWARE, 0, &sound1);
	FMOD_Err_Check(result);
	result = FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound1, 0, &channel);
	FMOD_Err_Check(result);

	scanf("wait");

	result = FMOD_Sound_Release(sound1);
	FMOD_Err_Check(result);
	FMOD_Cleanup(system);
  return (0);
	}
	else
	{
		printf("You need to pass a filename as parameter.\n");
		return (-1);
	}
}

/* End main.c */
