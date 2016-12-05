/*
 * iphone-specific implementation of the s3eUniversalLinks extension.
 * Add any platform-specific functionality here.
 */
/*
 * NOTE: This file was originally written by the extension builder, but will not
 * be overwritten (unless --force is specified) and is intended to be modified.
 */
#include "s3eUniversalLinks_internal.h"
#include "s3eUniversalLinks_debug.h"

#include "s3eEdk.h"
#include "s3eEdk_iphone.h"

#include "IwDebug.h"

#include <objc/runtime.h>

#import <UIKit/UIKit.h>

/*
	In order to receive URLs, we need our AppDelegate to implement application:continueUserActivity:restorationHandler: and return YES from application:didFinishLaunchingWithOptions:.
	
	Unfortunately, Marmalade doesn't expose its AppDelegate implementation, so we're stuck with whatever has been exposed as an s3eEdkCallback (e.g. S3E_EDK_IPHONE_HANDLEOPENURL for the deprecated direct deep links functionality).
	
	However, we're able to get around that by using the Objective C runtime to add our own implementation at runtime. Continue reading below.
*/

// Anonymous namespace to avoid polluting the global linker space with our helpers.
namespace
{
	// Whether or not the extension has had the chance to initialize yet.
	// We can't enqueue callbacks before the extension is initialized.
	bool isInitialized = false;
	
	// Since we can't enqueue callbacks before the extension is initialized,
	// we keep track of the initial URL manually.
	char* initialUrl = NULL;
	
	void releaseInitialUrl()
	{
		if (initialUrl)
		{
			delete[] initialUrl;
			initialUrl = NULL;
		}
	}
	
	void setInitialUrl(const char* url)
	{
		// Just in case it was set multiple times.
		releaseInitialUrl();
		
		initialUrl = new char[strlen(url) + 1];
		strcpy(initialUrl, url);
	}
	
	/*
	- (BOOL)application:(UIApplication *)application 
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

	BOOL didFinishLaunchingWithOptionsImpl(id self, SEL _cmd, UIApplication* application, NSDictionary* launchOptions)
	{
		// See http://stackoverflow.com/a/33784117/4237824 and http://stackoverflow.com/a/4294832/4237824.
		
		// If we were to implement this method, we would have to exchange its implementation with the
		// Marmalade one, then call the Marmalade one here manually, and return YES no matter what.
		
		// Fortunately, it looks like Marmalade's implementation already does return YES, so we
		// don't need to actually do this. YAY!
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
			
			if (isInitialized)
			{
				s3eEdkCallbacksEnqueue(
					S3E_EXT_UNIVERSALLINKS_HASH,
					S3E_UNIVERSALLINKS_CALLBACK_OPEN,
					(void*)urlCStr,
					strlen(urlCStr) + 1
				);
			}
			else
			{
				setInitialUrl(urlCStr);
			}
		}
		
		return YES;
	}

	s3eResult hookAppDelegateContinueUserActivity()
	{
		//IwTrace(UNIVERSALLINKS_VERBOSE, ("Hooking application:continueUserActivity:restorationHandler: of app delegate"));
		
		Class appDelegateClass = objc_getClass("s3eAppDelegate");
		
		if (appDelegateClass == nil)
		{
			//IwTrace(UNIVERSALLINKS, ("objc_getClass returned nil for s3eAppDelegate"));
			return S3E_RESULT_ERROR;
		}
		
		// We could also fetch the app delegate class like this, but this might not be safe
		// in case the application hasn't been fully initialized yet.
		// UIApplication* app = s3eEdkGetUIApplication();
		// Class appDelegateClass = [app.delegate class];
		
		//IwTrace(UNIVERSALLINKS_VERBOSE, ("App delegate class (should be s3eAppDelegate): %s", class_getName(appDelegateClass)));
		
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
		
		//IwTrace(UNIVERSALLINKS_VERBOSE, ("Hooked? %d", success));
		
		return success ? S3E_RESULT_SUCCESS : S3E_RESULT_ERROR;
	}
}

int g_s3eUniversalLinksHookResult = hookAppDelegateContinueUserActivity();

s3eResult s3eUniversalLinksInit_platform()
{
	// Helpful when debugging.
	//inspectAppDelegate();
	
	return (s3eResult)g_s3eUniversalLinksHookResult;
}

void s3eUniversalLinksTerminate_platform()
{
	releaseInitialUrl();
}

s3eResult s3eUniversalLinksHook_platform()
{
	// This isn't actually used on iOS because we need to hook into the app delegate
	// way before any of the app code gets a chance to run.
	return S3E_RESULT_SUCCESS;
}

const char* s3eUniversalLinksGetInitialUrl_platform()
{
	return initialUrl;
}
