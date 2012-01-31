/* Contains wrappers for common FMOD functions, check for errors automatically */

#ifndef _FMOD_WRAPPER_
#define _FMOD_WRAPPER_

#include "fmod.h"

FMOD_RESULT FMOD_Initialize(FMOD_SYSTEM **system, 
														int maxchannels, 
														FMOD_INITFLAGS flags, 
														void *extradriverdata);

FMOD_RESULT FMOD_Cleanup(FMOD_SYSTEM *system);


#endif
/* End FMOD_Wrapper.h */
