#ifndef FESTARTUP
#define FESTARTUP

#define FE_MYLINKTYPESKEY "HomeDoc:linkTypes"
#define FE_MYHOMEDOCWORKKEY "HomeDoc:homeDocWork"
#define FE_MYDOCTYPESKEY "HomeDoc::docTypes"

class FEStartupManager {
public:
	static void startup ();
	static void completeStartup (XuWorkP publicDoc);

	// return the home docs for the clubs.
	static XuWorkP fetchPublicHome ();
	static XuWorkP fetchAppHome();
};

#endif // FESTARTUP
