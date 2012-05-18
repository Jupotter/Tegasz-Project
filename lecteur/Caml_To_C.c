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
  FMOD_SOUND	*sound1;
  FMOD_CHANNEL	*channel = 0;
  FMOD_RESULT	result;
  
  system = (void*)sys;
  sound1 = (void*)v;
  
  /*result = FMOD_System_CreateSound(system, sound1, FMOD_SOFTWARE, 0, &sound1);
    FMOD_Err_Check(result);*/
  result = FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound1, 0, &channel);
  FMOD_Err_Check(result);
  result = FMOD_Channel_SetPaused(channel, 0);
  FMOD_Err_Check(result);
  
  
  return (value)channel;
}

value call_init()
{
  FMOD_SYSTEM 	*system;
  FMOD_Initialize(&system, 32, FMOD_INIT_NORMAL, NULL);
  
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

value call_pause(value v)
{
  FMOD_CHANNEL	*channel = 0;
  FMOD_RESULT		result;
  
  channel = (void*)v;
  
  result = FMOD_Channel_SetPaused(channel, 0);
  FMOD_Err_Check(result);
  
  return 0;
}

value call_stop(value v)
{
  FMOD_CHANNEL	*channel = 0;
  FMOD_RESULT		result;
  
  channel = (void*)v;
  
  result = FMOD_Channel_SetPaused(channel, 1);
  FMOD_Err_Check(result);
  
  return 0;
}

value set_volume(value v, value c)
{
  FMOD_CHANNEL	*channel = 0;
  FMOD_RESULT		result;
  float volume;
  double tmp;
  
  channel = (void*)c;
  tmp = Double_val(v);
  volume = tmp/100;
  
  result = FMOD_Channel_SetVolume(channel, volume);
  FMOD_Err_Check(result);
  
  return 0;
}

value is_paused(value v)
{
  FMOD_CHANNEL	*channel = 0;
  FMOD_RESULT		result;
  int 	      		paused = 0;

  channel = (void*)v;

	result = FMOD_Channel_IsPlaying(channel, &paused);
	FMOD_Err_Check(result);

	return (value)paused;
}

value timer (value v)
{
   FMOD_CHANNEL     *channel = 0;
   FMOD_RESULT       result;
   unsigned int time;

   channel = (void*)v;
   result = FMOD_Channel_GetPosition(channel, &time, FMOD_TIMEUNIT_MS);
   FMOD_Err_Check(result);

   /*printf("%i\n", time);*/
   return (value)time;
}


value getAlbum(value v)
{
  FMOD_TAG *tag = malloc(sizeof(FMOD_TAG));
  FMOD_SOUND *sound = 0;
  FMOD_RESULT result;
  char* name_album;

  sound = (void*)v;

  result = FMOD_Sound_GetTag(sound, "ALBUM", 0, tag);
  FMOD_Err_Check(result);

  name_album = tag -> data;

  return (value)name_album;
}

/* End main.c */
