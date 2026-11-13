#ifndef FESTARTUP
#define FESTARTUP

class FEStartupManager {
public:
	static void startup ();

	// return the home docs for the clubs.
	static XuWorkP fetchPublicHome ();
	static XuWorkP fetchAppHome();
<<<<<<< startup.h

	// initialize the homeDoc of the current club
	// and the public club if the logged in as System Admin
	static void setupHomeDoc();

private:
	// the complex edition for the public home doc
	XuEditionP publicHomeEdition();

=======

	// initialize the homeDoc of the current club
	// and the public club if the logged in as System Admin
	static void setupHomeDoc();

private:
	// the complex edition for the public home doc
	static XuEditionP publicHomeEdition();

>>>>>>> 1.3
};

#endif // FESTARTUP
