/*
 * iphone-specific implementation of the s3eUniversalLinks extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eUniversalLinks_internal.h"

#include "IwDebug.h"

#include <objc/runtime.h>

#import <UIKit/UIKit.h>

/*
	In order to receive URLs, we need our AppDelegate to implement application:continueUserActivity:restorationHandler:.
	
	Unfortunately, Marmalade doesn't expose its AppDelegate implementation, so we're stuck with whatever has been exposed as a s3eEdkCallback (e.g. S3E_EDK_IPHONE_HANDLEOPENURL for the deprecated direct deep links functionality).
	
	However, we may be able to get around that using the Objective C runtime to add our own implementation at runtime.
 */

void inspectAppDelegate()
{
	Class s3eAppDelegate = objc_getClass("s3eAppDelegate");
	
	if (s3eAppDelegate != nil)
	{
		IwTrace(UNIVERSALLINKS, ("Got s3eAppDelegate"));
		
		uint32 numMethods = 0;
		Method* methods = class_copyMethodList(s3eAppDelegate, &numMethods);
		
		IwTrace(UNIVERSALLINKS, ("%u methods", numMethods));
		
		if (methods != NULL)
		{
			for (uint32 i = 0; i < numMethods; ++i)
			{
				Method method = methods[i];
				SEL sel = method_getName(method);
				const char* name = sel_getName(sel);
				
				IwTrace(UNIVERSALLINKS, ("Method: %s", name));
			}
			free(methods);
		}
	}
	else
	{
		IwTrace(UNIVERSALLINKS, ("Could not get s3eAppDelegate"));
	}
}

/*
- (BOOL)application:(UIApplication *)application 
continueUserActivity:(NSUserActivity *)userActivity 
 restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler;
 */
void continueUserActivityImp(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, void (^restorationHandler)(NSArray *restorableObjects))
{
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Called application:continueUserActivity:restorationHandler:"));
}

s3eResult hookAppDelegateContinueUserActivity()
{
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Hooking application:continueUserActivity:restorationHandler: of s3eAppDelegate"));
	
	Class s3eAppDelegate = objc_getClass("s3eAppDelegate");
	
	if (s3eAppDelegate == nil)
	{
		IwTrace(UNIVERSALLINKS, ("objc_getClass returned nil for s3eAppDelegate"));
		return S3E_RESULT_ERROR;
	}
	
	SEL continueUserActivitySel = sel_registerName("application:continueUserActivity:restorationHandler:");
	
	BOOL success = class_addMethod(
		s3eAppDelegate,
		continueUserActivitySel,
		(IMP)continueUserActivityImp,
		"v@:"
	);
	
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Hooked? %s", success ? "yes" : "no"));
	
	return success ? S3E_RESULT_SUCCESS : S3E_RESULT_ERROR;
}

s3eResult s3eUniversalLinksInit_platform()
{
	//inspectAppDelegate();
	
	return hookAppDelegateContinueUserActivity();
}

void s3eUniversalLinksTerminate_platform()
{ 
}

s3eResult s3eUniversalLinksHook_platform()
{
	return S3E_RESULT_SUCCESS;
}
