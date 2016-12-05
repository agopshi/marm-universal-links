/*
 * iphone-specific implementation of the s3eUniversalLinks extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eUniversalLinks_internal.h"

#include "s3eEdk.h"
#include "s3eEdk_iphone.h"

#include "IwDebug.h"

#include <objc/runtime.h>

#import <UIKit/UIKit.h>

/*
	In order to receive URLs, we need our AppDelegate to implement application:continueUserActivity:restorationHandler: and return YES from application:didFinishLaunchingWithOptions:.
	
	Unfortunately, Marmalade doesn't expose its AppDelegate implementation, so we're stuck with whatever has been exposed as an s3eEdkCallback (e.g. S3E_EDK_IPHONE_HANDLEOPENURL for the deprecated direct deep links functionality).
	
	However, we may be able to get around that using the Objective C runtime to add our own implementation at runtime. Continue reading below.
*/

// For debugging.
void inspectClass(Class cls)
{
	const char* clsName = class_getName(cls);
	
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Inspecting class %s", clsName));
	
	uint32 numMethods = 0;
	Method* methods = class_copyMethodList(cls, &numMethods);
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Class %s has %u methods", clsName, numMethods));
	
	if (methods)
	{
		for (uint32 i = 0; i < numMethods; ++i)
		{
			Method method = methods[i];
			SEL sel = method_getName(method);
			const char* name = sel_getName(sel);
			
			IwTrace(UNIVERSALLINKS_VERBOSE, ("%s method: %s", clsName, name));
		}
		free(methods);
	}
	
	uint32 numProperties = 0;
	objc_property_t* properties = class_copyPropertyList(cls, &numProperties);
	IwTrace(UNIVERSALLINKS_VERBOSE, ("%s has %u properties", clsName, numProperties));
	
	if (properties)
	{
		for (uint32 i = 0; i < numProperties; ++i)
		{
			objc_property_t property = properties[i];
			const char* name = property_getName(property);
			
			IwTrace(UNIVERSALLINKS_VERBOSE, ("%s property: %s", clsName, name));
		}
		free(properties);
	}
	
	uint32 numIVars = 0;
	Ivar* iVars = class_copyIvarList(cls, &numIVars);
	IwTrace(UNIVERSALLINKS_VERBOSE, ("%s has %u ivars", clsName, numIVars));
	
	if (iVars)
	{
		for (uint32 i = 0; i < numIVars; ++i)
		{
			Ivar ivar = iVars[i];
			const char* name = ivar_getName(ivar);
			
			IwTrace(UNIVERSALLINKS_VERBOSE, ("%s ivar: %s", clsName, name));
		}
		free(iVars);
	}
}

void inspectAppDelegate()
{
	Class appDelegateClass = objc_getClass("s3eAppDelegate");
	
	if (appDelegateClass != nil)
	{
		inspectClass(appDelegateClass);
	}
	else
	{
		IwTrace(UNIVERSALLINKS_VERBOSE, ("Could not get s3eAppDelegate"));
	}
}

/*
See http://stackoverflow.com/a/33784117/4237824.

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

BOOL didFinishLaunchingWithOptionsImpl(id self, SEL _cmd, UIApplication* application, NSDictionary* launchOptions)
{
	// See http://stackoverflow.com/a/4294832/4237824. If we were to implement this method,
	// we would have to exchange its implementation with the original one, then call
	// the original one here, and, lastly, return YES no matter what.
}
*/

/*
- (BOOL)application:(UIApplication *)application 
continueUserActivity:(NSUserActivity *)userActivity 
 restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler;
 */
BOOL continueUserActivityImp(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, void (^restorationHandler)(NSArray* restorableObjects))
{
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Called application:continueUserActivity:restorationHandler:"));
	
	if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb])
	{
		NSString* url = [userActivity.webpageURL absoluteString];
		
		const char* urlCStr = [url UTF8String];
		
		IwTrace(UNIVERSALLINKS_VERBOSE, ("Got URL: %s", urlCStr));
		
		s3eEdkCallbacksEnqueue(
			S3E_EXT_UNIVERSALLINKS_HASH,
			S3E_UNIVERSALLINKS_CALLBACK_OPEN,
			(void*)urlCStr,
			strlen(urlCStr) + 1
		);
	}
	
	return YES;
}

s3eResult hookAppDelegateContinueUserActivity()
{
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Hooking application:continueUserActivity:restorationHandler: of app delegate"));
	
	Class appDelegateClass = objc_getClass("s3eAppDelegate");
	
	if (appDelegateClass == nil)
	{
		IwTrace(UNIVERSALLINKS, ("objc_getClass returned nil for s3eAppDelegate"));
		return S3E_RESULT_ERROR;
	}
	
	// We could also fetch the app delegate class like this, but this might not be safe
	// in case the application hasn't been fully initialized yet.
	// UIApplication* app = s3eEdkGetUIApplication();
	// Class appDelegateClass = [app.delegate class];
	
	IwTrace(UNIVERSALLINKS_VERBOSE, ("App delegate class (should be s3eAppDelegate): %s", class_getName(appDelegateClass)));
	
	SEL continueUserActivitySel = @selector(application:continueUserActivity:restorationHandler:);
	//sel_registerName("application:continueUserActivity:restorationHandler:");
	
	// Types of continueUserActivityImp, starting with the return type.
	NSString* types =[
		NSString stringWithFormat:@"%s%s%s%s%s%s",
		@encode(BOOL),
		@encode(id),
		@encode(SEL),
		@encode(UIApplication*),
		@encode(NSUserActivity*),
		@encode(void (^)(NSArray*))
	];
	
	const char* typesCStr = [types UTF8String];
	
	BOOL success = class_addMethod(
		appDelegateClass,
		continueUserActivitySel,
		(IMP)continueUserActivityImp,
		typesCStr
	);
	
	IwTrace(UNIVERSALLINKS_VERBOSE, ("Hooked? %d", success));
	
	return success ? S3E_RESULT_SUCCESS : S3E_RESULT_ERROR;
}

s3eResult s3eUniversalLinksInit_platform()
{
	// Helpful when debugging.
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
