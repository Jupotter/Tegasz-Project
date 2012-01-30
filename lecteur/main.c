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


int main(int argc, char *argv[])
{
	if (argc > 1)
	{
	FMOD_SYSTEM 	*system;
	FMOD_SOUND		*sound1;
	FMOD_CHANNEL	*channel = 0;
	FMOD_RESULT		result;

	result = FMOD_System_Create(&system);
	FMOD_Err_Check(result);

	result = FMOD_System_Init(system, 32, FMOD_INIT_NORMAL, NULL);
	FMOD_Err_Check(result);
	result = FMOD_System_CreateSound(system, argv[1], FMOD_SOFTWARE, 0, &sound1);
	FMOD_Err_Check(result);
	result = FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound1, 0, &channel);
	FMOD_Err_Check(result);

	scanf("wait");

	result = FMOD_Sound_Release(sound1);
	FMOD_Err_Check(result);
	result = FMOD_System_Close(system);
	FMOD_Err_Check(result);
	result = FMOD_System_Release(system);
	FMOD_Err_Check(result);
  return (0);
	}
	else
	{
		printf("You need to pass a filename as parameter.\n");
		return (-1);
	}
}

/* End main.c */
