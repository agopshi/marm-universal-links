/*
 * WARNING: this is an autogenerated file and will be overwritten by
 * the extension interface script.
 */
/**
 * Definitions for functions types passed to/from s3eExt interface
 */
typedef  s3eResult(*s3eUniversalLinksHook_t)();
typedef  s3eResult(*s3eUniversalLinksRegister_t)(s3eUniversalLinksCallback cid, s3eCallback fn, void* userData);
typedef  s3eResult(*s3eUniversalLinksUnRegister_t)(s3eUniversalLinksCallback cbid, s3eCallback fn);

/**
 * struct that gets filled in by s3eUniversalLinksRegister
 */
typedef struct s3eUniversalLinksFuncs
{
    s3eUniversalLinksHook_t m_s3eUniversalLinksHook;
    s3eUniversalLinksRegister_t m_s3eUniversalLinksRegister;
    s3eUniversalLinksUnRegister_t m_s3eUniversalLinksUnRegister;
} s3eUniversalLinksFuncs;
