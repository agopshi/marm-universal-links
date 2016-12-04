/*
 * android-specific implementation of the s3eUniversalLinks extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eUniversalLinks_internal.h"

#include "s3eEdk.h"
#include "s3eEdk_android.h"
#include <jni.h>
#include "IwDebug.h"

static jobject g_Obj;
//static jmethodID g_s3eUniversalLinksRegister;
//static jmethodID g_s3eUniversalLinksUnRegister;

s3eResult s3eUniversalLinksInit_platform()
{
    // Get the environment from the pointer
    JNIEnv* env = s3eEdkJNIGetEnv();
    jobject obj = NULL;
    jmethodID cons = NULL;

    // Get the extension class
    jclass cls = s3eEdkAndroidFindClass("s3eUniversalLinks");
    if (!cls)
        goto fail;

    // Get its constructor
    cons = env->GetMethodID(cls, "<init>", "()V");
    if (!cons)
        goto fail;

    // Construct the java class
    obj = env->NewObject(cls, cons);
    if (!obj)
        goto fail;

    // Get all the extension methods
    /*
    g_s3eUniversalLinksRegister = env->GetMethodID(cls, "s3eUniversalLinksRegister", "(LFIXME;LFIXME;LFIXME;)I");
    if (!g_s3eUniversalLinksRegister)
        goto fail;

    g_s3eUniversalLinksUnRegister = env->GetMethodID(cls, "s3eUniversalLinksUnRegister", "(LFIXME;LFIXME;)I");
    if (!g_s3eUniversalLinksUnRegister)
        goto fail;
    */


    IwTrace(UNIVERSALLINKS ("s3eUniversalLinks init success"));
    g_Obj = env->NewGlobalRef(obj);
    env->DeleteLocalRef(obj);
    env->DeleteGlobalRef(cls);

    // Add any platform-specific initialisation code here
    return S3E_RESULT_SUCCESS;

fail:
    jthrowable exc = env->ExceptionOccurred();
    if (exc)
    {
        env->ExceptionDescribe();
        env->ExceptionClear();
        IwTrace(UNIVERSALLINKS, ("One or more java methods could not be found"));
    }

    env->DeleteLocalRef(obj);
    env->DeleteGlobalRef(cls);
    return S3E_RESULT_ERROR;

}

void s3eUniversalLinksTerminate_platform()
{ 
    // Add any platform-specific termination code here
    JNIEnv* env = s3eEdkJNIGetEnv();
    env->DeleteGlobalRef(g_Obj);
    g_Obj = NULL;
}

s3eResult s3eUniversalLinksRegister_platform(s3eUniversalLinksCallback cid, s3eCallback fn, void* userData)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    return (s3eResult)env->CallIntMethod(g_Obj, g_s3eUniversalLinksRegister, cid, fn, userData);
}

s3eResult s3eUniversalLinksUnRegister_platform(s3eUniversalLinksCallback cbid, s3eCallback fn)
{
    JNIEnv* env = s3eEdkJNIGetEnv();
    return (s3eResult)env->CallIntMethod(g_Obj, g_s3eUniversalLinksUnRegister, cbid, fn);
}
