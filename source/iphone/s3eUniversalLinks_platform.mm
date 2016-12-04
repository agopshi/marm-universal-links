/*
 * iphone-specific implementation of the s3eUniversalLinks extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eUniversalLinks_internal.h"

s3eResult s3eUniversalLinksInit_platform()
{
    // Add any platform-specific initialisation code here
    return S3E_RESULT_SUCCESS;
}

void s3eUniversalLinksTerminate_platform()
{ 
}

s3eResult s3eUniversalLinksHook_platform()
{
    return S3E_RESULT_ERROR;
}

s3eResult s3eUniversalLinksRegister_platform(s3eUniversalLinksCallback cid, s3eCallback fn, void* userData)
{
    return S3E_RESULT_ERROR;
}

s3eResult s3eUniversalLinksUnRegister_platform(s3eUniversalLinksCallback cbid, s3eCallback fn)
{
    return S3E_RESULT_ERROR;
}
