/*
Generic implementation of the s3eUniversalLinks extension.
This file should perform any platform-indepedentent functionality
(e.g. error checking) before calling platform-dependent implementations.
*/

/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */


#include "s3eUniversalLinks_internal.h"
s3eResult s3eUniversalLinksInit()
{
    //Add any generic initialisation code here
    return s3eUniversalLinksInit_platform();
}

void s3eUniversalLinksTerminate()
{
    //Add any generic termination code here
    s3eUniversalLinksTerminate_platform();
}

s3eResult s3eUniversalLinksHook()
{
	return s3eUniversalLinksHook_platform();
}

s3eResult s3eUniversalLinksRegister(s3eUniversalLinksCallback cid, s3eCallback fn, void* userData)
{
	return s3eUniversalLinksRegister_platform(cid, fn, userData);
}

s3eResult s3eUniversalLinksUnRegister(s3eUniversalLinksCallback cbid, s3eCallback fn)
{
	return s3eUniversalLinksUnRegister_platform(cbid, fn);
}
