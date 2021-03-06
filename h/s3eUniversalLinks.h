/*
 * (C) 2001-2012 Marmalade. All Rights Reserved.
 *
 * This document is protected by copyright, and contains information
 * proprietary to Marmalade.
 *
 * This file consists of source code released by Marmalade under
 * the terms of the accompanying End User License Agreement (EULA).
 * Please do not use this program/source code before you have read the
 * EULA and have agreed to be bound by its terms.
 */
/*
 * WARNING: this is an autogenerated file and will be overwritten by
 * the extension interface script.
 */
#ifndef S3E_EXT_UNIVERSALLINKS_H
#define S3E_EXT_UNIVERSALLINKS_H

#include <s3eTypes.h>

/**
 * s3eUniversalLinks callbacks.
 *
 * @see s3eUniversalLinksRegister
 * @see s3eUniversalLinksUnRegister
 * @par Required Header Files
 * s3eUniversalLinks.h
 */
typedef enum s3eUniversalLinksCallback
{
	/**
	 * Called when the application is opened in response to a universal link.
	 * systemData: char* url
	 */
	S3E_UNIVERSALLINKS_CALLBACK_OPEN =  0,

	S3E_UNIVERSALLINKS_CALLBACK_MAX
} s3eUniversalLinksCallback;
// \cond HIDDEN_DEFINES
S3E_BEGIN_C_DECL
// \endcond

/**
 * Report if the UniversalLinks extension is available.
 * @return S3E_TRUE if the UniversalLinks extension is available. S3E_FALSE otherwise.
 */
s3eBool s3eUniversalLinksAvailable();

/**
 * Registers a callback to be called for an operating system event.
 *
 * The available callback types are listed in @ref s3eUniversalLinksCallback.
 * @param cbid ID of the event for which to register.
 * @param fn callback function.
 * @param userData Value to pass to the @e userData parameter of @e NotifyFunc.
 * @return
 *  - @ref S3E_RESULT_SUCCESS if no error occurred.
 *  - @ref S3E_RESULT_ERROR if the operation failed.\n
 *
 * @see s3eUniversalLinksUnRegister
 * @note For more information on the system data passed as a parameter to the callback
 * registered using this function, see the @ref s3eUniversalLinksCallback enum.
 * @note It is not necessary to define a return value for any registered callback.
 */
s3eResult s3eUniversalLinksRegister(s3eUniversalLinksCallback cbid, s3eCallback fn, void* userData);

/**
 * Unregister a callback for a given event.
 * @param cbid ID of the callback to unregister.
 * @param fn Callback Function.
 * @return
 * - @ref S3E_RESULT_SUCCESS if no error occurred.
 * - @ref S3E_RESULT_ERROR if the operation failed.\n
 * @see s3eUniversalLinksRegister
 */
s3eResult s3eUniversalLinksUnRegister(s3eUniversalLinksCallback cbid, s3eCallback fn);

/**
 * Hook whatever is necessary to make universal links work. Call this during app initialization.
 * @return
 * - #S3E_RESULT_SUCCESS if no error occurred.
 * - #S3E_RESULT_ERROR if the operation failed.
 */
s3eResult s3eUniversalLinksHook();

/**
 * Return the initial URL that was used when launching the app. Callbacks aren't called
 * during app launch, so this method allows you to retrieve that information manually.
 * @return The initial URL as a NULL-terminated string, or NULL if there wasn't an initial URL.
 */
const char* s3eUniversalLinksGetInitialUrl();

// \cond HIDDEN_DEFINES
S3E_END_C_DECL
// \endcond

#endif /* !S3E_EXT_UNIVERSALLINKS_H */
