/* The FEManager module is for setting up application specific information
	 and startup activity.
	 */

#ifndef FEMANAGE
#define FEMANAGE

class FEManager {
public:
<<<<<<< femanage.h
	/* Shut down the frontend by closing all the open Drafts.  This function is not
  	yet implemented because of unresolved destruction-order issues. */
	static XuBooleanVar shutdown();
=======
	/* Shut down the frontend by closing all the open Drafts.  This function
		must be called after all windows are closed--i.e. there must be no
		remaining UI components which need their Drafts. */
	static void shutdown();
>>>>>>> 1.8

	/* Return to the start of the application.  This generally brings up
		 homeDocuments, etc. but it might also do application specific things. */
	static void returnHome ();

<<<<<<< femanage.h
private:
	/* This gets called after the connection gets established, and the document
     and link types have all been set up. */
	static void startup();
=======
	/* This gets called after the connection gets established, and the document
     and link types have all been set up. */
	static void startup();
>>>>>>> 1.8

	/* make the edition for the home docs of the appropriate clubs */
	static XuEditionP appHomeEdition();

};

#endif FEMANAGE
