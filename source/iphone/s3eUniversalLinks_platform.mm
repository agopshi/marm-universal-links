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

s3eResult s3eUniversalLinksTest_platform(const char* str)
{
    return S3E_RESULT_ERROR;
}
