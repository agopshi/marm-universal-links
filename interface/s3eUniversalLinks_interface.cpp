/*
 * WARNING: this is an autogenerated file and will be overwritten by
 * the extension interface script.
 */

#include "s3eExt.h"
#include "IwDebug.h"
#include "s3eDevice.h"


#include "s3eUniversalLinks.h"


// Define S3E_EXT_SKIP_LOADER_CALL_LOCK on the user-side to skip LoaderCallStart/LoaderCallDone()-entry.
// e.g. in s3eNUI this is used for generic user-side IwUI-based implementation.
#ifndef S3E_EXT_SKIP_LOADER_CALL_LOCK
#if (defined(WINAPI_FAMILY) && (WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP)) || defined I3D_ARCH_NACLX86_64
// For platforms missing stack-switching (WP8, NaCl, etc.) make loader-entry via LoaderCallStart/LoaderCallDone() on the user-side.
#define LOADER_CALL_LOCK
#endif
#endif


#include "s3eUniversalLinks_interface.h"

static s3eUniversalLinksFuncs g_Ext;
static bool g_GotExt = false;
static bool g_TriedExt = false;
static bool g_TriedNoMsgExt = false;

static bool _extLoad()
{
    if (!g_GotExt && !g_TriedExt)
    {
        s3eResult res = s3eExtGetHash(0xcc622eca, &g_Ext, sizeof(g_Ext));
        if (res == S3E_RESULT_SUCCESS)
            g_GotExt = true;
        else
            s3eDebugAssertShow(S3E_MESSAGE_CONTINUE_STOP_IGNORE,                 "error loading extension: s3eUniversalLinks");

        g_TriedExt = true;
        g_TriedNoMsgExt = true;
    }

    return g_GotExt;
}

static bool _extLoadNoMsg()
{
    if (!g_GotExt && !g_TriedNoMsgExt)
    {
        s3eResult res = s3eExtGetHash(0xcc622eca, &g_Ext, sizeof(g_Ext));
        if (res == S3E_RESULT_SUCCESS)
            g_GotExt = true;
        g_TriedNoMsgExt = true;
        if (g_TriedExt)
            g_TriedExt = true;
    }

    return g_GotExt;
}

s3eBool s3eUniversalLinksAvailable()
{
    _extLoadNoMsg();
    return g_GotExt ? S3E_TRUE : S3E_FALSE;
}

s3eResult s3eUniversalLinksRegister(s3eUniversalLinksCallback cbid, s3eCallback fn, void* userData)
{
    IwTrace(UNIVERSALLINKS_VERBOSE, ("calling s3eUniversalLinks[0] func: s3eUniversalLinksRegister"));

    if (!_extLoad())
        return S3E_RESULT_ERROR;

#ifdef LOADER_CALL_LOCK
    s3eDeviceLoaderCallStart(S3E_TRUE, (void*)g_Ext.m_s3eUniversalLinksRegister);
#endif

    s3eResult ret = g_Ext.m_s3eUniversalLinksRegister(cbid, fn, userData);

#ifdef LOADER_CALL_LOCK
    s3eDeviceLoaderCallDone(S3E_TRUE, (void*)g_Ext.m_s3eUniversalLinksRegister);
#endif

    return ret;
}

s3eResult s3eUniversalLinksUnRegister(s3eUniversalLinksCallback cbid, s3eCallback fn)
{
    IwTrace(UNIVERSALLINKS_VERBOSE, ("calling s3eUniversalLinks[1] func: s3eUniversalLinksUnRegister"));

    if (!_extLoad())
        return S3E_RESULT_ERROR;

#ifdef LOADER_CALL_LOCK
    s3eDeviceLoaderCallStart(S3E_TRUE, (void*)g_Ext.m_s3eUniversalLinksUnRegister);
#endif

    s3eResult ret = g_Ext.m_s3eUniversalLinksUnRegister(cbid, fn);

#ifdef LOADER_CALL_LOCK
    s3eDeviceLoaderCallDone(S3E_TRUE, (void*)g_Ext.m_s3eUniversalLinksUnRegister);
#endif

    return ret;
}

s3eResult s3eUniversalLinksHook()
{
    IwTrace(UNIVERSALLINKS_VERBOSE, ("calling s3eUniversalLinks[2] func: s3eUniversalLinksHook"));

    if (!_extLoad())
        return S3E_RESULT_ERROR;

#ifdef LOADER_CALL_LOCK
    s3eDeviceLoaderCallStart(S3E_TRUE, (void*)g_Ext.m_s3eUniversalLinksHook);
#endif

    s3eResult ret = g_Ext.m_s3eUniversalLinksHook();

#ifdef LOADER_CALL_LOCK
    s3eDeviceLoaderCallDone(S3E_TRUE, (void*)g_Ext.m_s3eUniversalLinksHook);
#endif

    return ret;
}
