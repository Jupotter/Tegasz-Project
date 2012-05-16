/* Standard error check for FMOD */

#include <stdio.h>
#include <stdlib.h>
#include "FMOD_Err_Check.h"
#include "fmod.h"
#include "fmod_errors.h"

void FMOD_Err_Check(FMOD_RESULT result)
{
	if (result != FMOD_OK)
	{
		if (result != FMOD_ERR_INVALID_HANDLE)
		{
		printf("FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
			exit(-1);
		}
	}
}

