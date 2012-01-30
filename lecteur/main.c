/*
 * main.c: contains the program entry point.
 */

/* Standard headers */
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

/* Also include fmod */
#include "fmod.h"


/*int main(int argc, char *argv[])*/
int main(void)
{
	FMOD_SYSTEM 	*system;
	FMOD_SOUND		*sound1;
	FMOD_CHANNEL	*channel = 0;
	/*FMOD_RESULT		result;*/

	FMOD_System_Create(&system);

	FMOD_System_Init(system, 32, FMOD_INIT_NORMAL, NULL);
	FMOD_System_CreateSound(system, "AudioTest.mp3", FMOD_SOFTWARE, 0, &sound1);
	FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound1, 0, &channel);

	scanf("wait");

	FMOD_Sound_Release(sound1);
	FMOD_System_Close(system);
	FMOD_System_Release(system);

  return (0);
}

/* End main.c */
