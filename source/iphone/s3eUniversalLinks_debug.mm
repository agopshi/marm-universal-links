#include "s3eUniversalLinks_internal.h"
#include "s3eUniversalLinks_debug.h"

#include "IwDebug.h"

void _s3eUniversalLinksInspectClass(Class cls)
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

void _s3eUniversalLinksInspectAppDelegate()
{
	Class appDelegateClass = objc_getClass("s3eAppDelegate");
	
	if (appDelegateClass != nil)
	{
		_s3eUniversalLinksInspectClass(appDelegateClass);
	}
	else
	{
		IwTrace(UNIVERSALLINKS_VERBOSE, ("Could not get s3eAppDelegate"));
	}
}
