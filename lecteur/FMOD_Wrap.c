/* Wrapper for common FMOD functions */

#include "fmod.h"
#include "FMOD_Wrap.h"
#include "FMOD_Err_Check.h" 

FMOD_RESULT FMOD_Initialize(FMOD_SYSTEM **system,
														int maxchasnnels,
														FMOD_INITFLAGS flags,
														void *extradriverdata)
{
	FMOD_RESULT result;
	result = FMOD_System_Create(system);
	FMOD_Err_Check(result);
	result = FMOD_System_Init(*system, maxchasnnels, flags, extradriverdata);
	FMOD_Err_Check(result);
	return result;
}

FMOD_RESULT FMOD_Cleanup(FMOD_SYSTEM *system)
{
	FMOD_RESULT result;
	result = FMOD_System_Close(system);
	FMOD_Err_Check(result);
	result = FMOD_System_Release(system);
	FMOD_Err_Check(result);
	return result;
}


/* End FMOD_Wrap.c */
