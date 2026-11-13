/* Initialize the application.  Connect and log in to the server, backfollow on
	 the public and login clubs to find homedocs, and executethe appropriate hook
	 for each home doc. */

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop
                                                          	
#include "absui.h"
#include "startup.h"

// just to initialize them properly
//#include "title.h"
//#include "clip.h"

#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"

<<<<<<< startup.cpp
#define FE_LINKTYPESKEY "HomeDoc:linkTypes"
#define FE_HOMEDOCWORKKEY "HomeDoc:homeDocWork"
#define FE_CONTENTTYPESKEY "HomeDoc::contentTypes"

=======
#define FE_LINKTYPESKEY "HomeDoc:linkTypes"
#define FE_HOMEDOCWORKKEY "HomeDoc:homeDocWork"
#define FE_CONTENTTYPESKEY "HomeDoc::contentTypes"

#define FE_TEXTLEN 100

>>>>>>> 1.7
static XuWorkP ThePublicHome;
static XuWorkP TheApplicationHome;

XuWorkP FEStartupManager::
fetchPublicHome () {
	return ThePublicHome;
}

XuWorkP FEStartupManager::
fetchAppHome () {
	return TheApplicationHome;
}

<<<<<<< startup.cpp
/******************* System Startup ********************/

static XuFillRangeHookP ThePublicStartupHook;
static XuFillRangeHookP TheApplicationStartupHook;

/* Finish setting up the pieces of the mid-end library. */
static void 
libraryStartup(XuWorkP publicDoc) {
	ThePublicHome = publicDoc;
	FEDraft::startup();
	FEContent::startup();
	FETitleManager::startup();
	FEClipManager::startup();
}

/* Start the application after the library is completely setup. */
/* As soon as both hooks have fired (we have both a public doc and a
	 login doc) then call returnHome to start the application. */
static void 
applicationStartup() {
	if (TheApplicationHome != XU_NULL && ThePublicHome!= XU_NULL) {
		FEManager::startup();
		FEManager::returnHome();
	}
}

=======
/******************* System Startup ********************/

static XuFillRangeHookP ThePublicStartupHook;
static XuFillRangeHookP TheApplicationStartupHook;

/* Finish setting up the pieces of the mid-end library. */
// This gets called with the structured public document with the doc types
// and such.
static void 
libraryStartup(XuWorkP topPublicDoc) {
	XuEditionP topEdn = topPublicDoc->edition();
	ThePublicHome = XuWork::cast(topEdn->get(FE_HOMEDOCWORKKEY));
	XuEditionP typeEdition = XuEdition::cast(topEdn->get(FE_LINKTYPESKEY));
	FEConn::TheOne->setTypeIDs
		(XuPtrArray::cast(typeEdition->stepper()->stepMany(FE_NUMTYPEIDS)));
	FEContentType::setContentTypeEdition
		(XuEdition::cast(topEdn->get(FE_CONTENTTYPESKEY)));
	FEDraft::startup();
//	FETitleManager::startup();
//	FEClipManager::startup();
}

/* Start the application after the library is completely setup. */
/* As soon as both hooks have fired (we have both a public doc and a
	 login doc) then call returnHome to start the application. */
static void 
applicationStartup() {
	if (TheApplicationHome != XU_NULL && ThePublicHome!= XU_NULL) {
		FEManager::startup();
		FEManager::returnHome();
	}
}

>>>>>>> 1.7
// executed for each edition that the startup detector finds
class FEPublicStartup : public XuEachHook {
	int startup (XuWorkP startupWork) {
		/* the public club's home doc is actually a compound edition storing
			an integer edition of link types, a sequence edition of content types,
			and a Work which is the real editable home document */
		XuEditionP startupEdition = startupWork->edition();
<<<<<<< startup.cpp
		/* load link types */
		XuEditionP typeEdition = XuEdition::cast(startupEdition->get(FE_LINKTYPESKEY));
		TheFEConn->setTypeIDs(
				XuPtrArray::cast(typeEdition->stepper()->stepMany(FE_NUMTYPEIDS)));
		FEContentType::setContentTypeEdition(XuEdition::cast(startupEdition->get(FE_CONTENTTYPESKEY)));
=======
    // check that there is something at the proper key
		XuPromiseP typeEdition = startupEdition->get(FE_LINKTYPESKEY);
>>>>>>> 1.7
		typeEdition->force();
		if (typeEdition->isFulfilled()) {
			return TRUE;
		} else {
     	return FALSE;
		}
	}
public:
	virtual void execute (XuPromiseP promise) {
		XuHyperLinkP link = XuHyperLink::wrap(XuEdition::cast(promise));
		if ( this->startup(FEStuff::endAt(link, 1)->workContext()) ) {
<<<<<<< startup.cpp
			ThePublicStartupHook = XU_NULL;
			libraryStartup(XuWork::cast
					(FEStuff::endAt(link, 1)->workContext()
						->edition()->get(FE_HOMEDOCWORKKEY)));
			applicationStartup();
=======
			ThePublicStartupHook = XU_NULL;
			libraryStartup(FEStuff::endAt(link, 1)->workContext());
			applicationStartup();
>>>>>>> 1.7
		}
	}
};

class FEApplicationStartup : public XuEachHook {
protected:
	virtual void execute (XuPromiseP promise) {
		TheApplicationStartupHook = XU_NULL;
		XuHyperLinkP link = XuHyperLink::wrap(XuEdition::cast(promise));
		TheApplicationHome = FEStuff::endAt(link, 1)->workContext();
		applicationStartup();
	}
};

<<<<<<< startup.cpp
void FEStartupManager::
startup() {
	char loginBuf[FE_TEXTLEN];
	char hostBuf[FE_TEXTLEN];
=======
void FEStartupManager::startup() {
	char loginBuf[FE_TEXTLEN];
	char hostBuf[FE_TEXTLEN];
	char demonBuf[FE_MYTEXTLEN];

	// If there is a pointer to a server startup demon, invoke it
  do {
		GetProfileString ("PCAIDE", "Startup", "", demonBuf, FE_MYTEXTLEN);
		if (strlen (demonBuf) == 0)
    	break;
		char * rest = strchr (demonBuf, ' ');
		if (! rest)
    	break;
		*rest++ = 0;
		// Just connect, exchange a byte, and disconnect
		cerr << "Connecting to demon " << demonBuf << " with: " << rest << "\n";
		XuPortal* startup = XuPortal::fetch (demonBuf, rest);
		if (! startup)
			break;
		startup->sendByte ('?');
		startup->flush ();
    cerr << "Waiting for a byte...\n";
		if (startup->receiveByte () != '!') {
			FEUI::tell("Server Startup", "Could not start server");
			exit (-1);
    }
		delete startup;
	} while (FALSE);
			  	

>>>>>>> 1.7
	FEUI::loginParams(hostBuf, loginBuf);
	// split the host string into transport and everything else.
	for (char *rest = hostBuf; *rest != ' '; rest++) {}
  *rest++ = '\0';
	cerr << "Connecting to server: " << hostBuf << " with: " << rest << "\n";
	XuIntVar error = XuServer::connect(hostBuf, rest);
	if (error) {
		cerr << "Couldn't connect: error number " << error;
		exit(-1);
	}
<<<<<<< startup.cpp
	TheFEConn = FEConn::make(loginBuf, "" /* password */);

	/* Start backfollows to find the public and login homeDocs. */
=======
	FEConn::make(loginBuf, "" /* password */);

	/* Start backfollows to find the public and login homeDocs. */
>>>>>>> 1.7
	ThePublicStartupHook = new FEPublicStartup()->asFillRangeHook();
	XuServer::get(XuServer::publicClubID())
		->transcluders(XuHyperLink::spec()->filter())
		->addFillRangeDetector(ThePublicStartupHook);
<<<<<<< startup.cpp
	TheApplicationStartupHook = new FEApplicationStartup()->asFillRangeHook();
	XuServer::get(TheFEConn->loginClubID())
		->transcluders(XuHyperLink::spec()->filter())
		->addFillRangeDetector(TheApplicationStartupHook);
}

/******************* Home Documents ********************/

/* Connect the homeEdition to the club as its homeDoc. */
static XuWorkP 
connectHomeDoc (XuIDP iD, XuStringVar clubName, XuEditionP homeEdition)
{
	XuWorkP homeWork;
	XuBind (XuInitialReadClub, XuServer::publicClubID()) {
		XuBind (XuInitialEditClub, iD) {
			// Note we must make the doc types before calling makeEdition, as
      // otherwise TextContent's endorsement won't be set up.
			XuEditionP contentTypeEdn = FEContentType::contentTypeEdition();
			homeWork = XuWork::make(homeEdition);
			homeWork->release();
		} XuEndBind

		// make the link from the club to the home doc
		XuBind (XuInitialEditClub, XuServer::emptyClubID()) {
			XuClubP club = XuClub::cast(XuServer::get(iD));
			XuWorkP homeLinkWork = XuWork::make(FEStuff::makeLink
   			(TheFEConn->homeDocLinkTypeID(),
   			 FEStuff::makeSingleRef(club, club->edition(), XU_NULL),
  	 		 FEStuff::makeSingleRef(homeWork, homeEdition, XU_NULL))
				->edition());
			homeLinkWork->release();
		} XuEndBind
	} XuEndBind

/*	if (homeEdition == XU_NULL) {
		// make the title
		char docName[50];
		wsprintf(docName, "%s Home Document", clubName);
		XuEditionP titleEdition;
		titleEdition = XuText::make(docName)->edition();
		XuBind (XuInitialReadClub, XuServer::publicClubID()) {
			XuBind (XuInitialEditClub, iD) {
				FETitleManager::makeTitle(homeWork, titleEdition);
			} XuEndBind
		} XuEndBind
	}  */
	return homeWork;
=======
	TheApplicationStartupHook = new FEApplicationStartup()->asFillRangeHook();
	XuServer::get(FEConn::TheOne->loginClubID())
		->transcluders(XuHyperLink::spec()->filter())
		->addFillRangeDetector(TheApplicationStartupHook);

	// TODO: add modeless dialog here "Logging in..."
	if (GetProfileInt ("PCAIDE", "Initialize", 0)) {
		FEStartupManager::setupHomeDoc();
	}
}

/******************* Home Documents ********************/

/* Connect the homeEdition to the club as its homeDoc. */
static XuWorkP 
connectHomeDoc (XuIDP iD, XuStringVar clubName, XuEditionP homeEdition)
{
	XuWorkP homeWork;
	XuBind (XuInitialReadClub, XuServer::publicClubID()) {
		XuBind (XuInitialEditClub, iD) {
			// Note we must make the doc types before calling makeEdition, as
      // otherwise TextContent's endorsement won't be set up.
			XuEditionP contentTypeEdn = FEContentType::contentTypeEdition();
			homeWork = XuWork::make(homeEdition);
			homeWork->release();
		} XuEndBind

		// make the link from the club to the home doc
		XuBind (XuInitialEditClub, XuServer::emptyClubID()) {
			XuClubP club = XuClub::cast(XuServer::get(iD));
			XuWorkP homeLinkWork = XuWork::make(FEStuff::makeLink
				(FEConn::TheOne->homeDocLinkTypeID(),
   			 FEStuff::makeSingleRef(club, club->edition(), XU_NULL),
  	 		 FEStuff::makeSingleRef(homeWork, homeEdition, XU_NULL))
				->edition());
			homeLinkWork->release();
		} XuEndBind
	} XuEndBind

/*	if (homeEdition == XU_NULL) {
		// make the title
		char docName[50];
		wsprintf(docName, "%s Home Document", clubName);
		XuEditionP titleEdition;
		titleEdition = XuText::make(docName)->edition();
		XuBind (XuInitialReadClub, XuServer::publicClubID()) {
			XuBind (XuInitialEditClub, iD) {
				FETitleManager::makeTitle(homeWork, titleEdition);
			} XuEndBind
		} XuEndBind
	}  */
	return homeWork;
>>>>>>> 1.7
}

<<<<<<< startup.cpp
/* Set up the home documents and such. */
void FEStartupManager::
setupHomeDoc () {
	// are we sysadmin?
	XuAdminerP admin = XuAdminer::make();
	admin->force();
	if (TheFEConn->titleTypeID() == XU_NULL) {
  	// The world isn't initialized.  Make the link types.
		if (admin->isFulfilled()
				&& FEUI::ask("Initialize document and link types?",
										"Backend Initialization")) {
    	// we are sysadmin, and we have permission to init the world
			TheFEConn->makeTypeIDs();
      XuWorkP newDoc;
			XuBind (XuInitialReadClub,XuServer::publicClubID()) {
				newDoc = connectHomeDoc(XuServer::publicClubID(),
														"Public", FEStartupManager::publicHomeEdition());
			} XuEndBind
      // finish the startup, with the newly made public home doc
			libraryStartup(newDoc);
		} else {
			FEUI::beep();
			return;
=======
/* Set up the home documents and such. */
void FEStartupManager::
setupHomeDoc () {
	// are we sysadmin?
	XuAdminerP admin = XuAdminer::make();
	admin->force();
	if (FEConn::TheOne->titleTypeID() == XU_NULL) {
  	// The world isn't initialized.  Make the link types.
		if (admin->isFulfilled()
				&& (FEUI::ask("Initialize document and link types?",
										"Backend Initialization")
						|| GetProfileInt ("PCAIDE", "Initialize", 0))) {
			// we are sysadmin, and we have permission to init the world
			// kill the public hook
			ThePublicStartupHook = XU_NULL;
			FEConn::TheOne->makeTypeIDs();
      XuWorkP newDoc;
			XuBind (XuInitialReadClub,XuServer::publicClubID()) {
				newDoc = connectHomeDoc(XuServer::publicClubID(),
														"Public", FEStartupManager::publicHomeEdition());
			} XuEndBind
      // finish the startup, with the newly made public home doc
			libraryStartup(newDoc);
		} else {
			FEUI::beep();
			return;
>>>>>>> 1.7
		}
	}
<<<<<<< startup.cpp
	// if no login doc, or if user wants new one anyway, then make one
	if (FEStartupManager::fetchAppHome() == XU_NULL
			|| FEUI::ask("Make another Home Document?", "Backend Initialization")) {
		TheApplicationHome = connectHomeDoc(TheFEConn->loginClubID(), TheFEConn->loginName(),
																			FEManager::appHomeEdition());
		TheApplicationHome->release ();
		applicationStartup();
	}
	FEUI::tell("Initialization complete", "Done");
}
=======
	// if no login doc, or if user wants new one anyway, then make one
	if (FEStartupManager::fetchAppHome() == XU_NULL
			|| FEUI::ask("Make another Home Document?", "Backend Initialization")) {
		// kill the app hook
		TheApplicationStartupHook = XU_NULL;
		TheApplicationHome = connectHomeDoc(FEConn::TheOne->loginClubID(), FEConn::TheOne->loginName(),
																			FEManager::appHomeEdition());
		TheApplicationHome->release ();
		applicationStartup();
	}
// No need for this anymore--it just comes up!
//	FEUI::tell("Initialization complete", "Done");
}
>>>>>>> 1.7

<<<<<<< startup.cpp
XuEditionP FEStartupManager::
publicHomeEdition()
{
	XuEditionP topEdition;
	XuBind (XuInitialReadClub, XuServer::publicClubID()) {
		XuBind (XuInitialEditClub, XuServer::publicClubID()) {
			XuEditionP homeEdition;
			XuWorkP homeDoc;
			// Note we must make the doc types before calling makeEdition, as
      // otherwise TextContent's endorsement won't be set up.
			XuEditionP contentTypeEdn = FEContentType::contentTypeEdition();
			homeEdition = XuText::make("This is your home document.")->contents();
			homeDoc = XuWork::make(homeEdition);
			homeDoc->release();
			/* make the place for the
				 doc and link types, and put homeDoc there */
			topEdition = XuEdition::empty(XuSequenceSpace::make())
				->with(FE_LINKTYPESKEY, XuEdition::fromArray(TheFEConn->typeIDs()))
				->with(FE_HOMEDOCWORKKEY, homeDoc)
				->with(FE_CONTENTTYPESKEY, contentTypeEdn);
		} XuEndBind
	} XuEndBind
	return topEdition;
=======
XuEditionP FEStartupManager::
publicHomeEdition()
{
	XuEditionP topEdition;
	XuBind (XuInitialReadClub, XuServer::publicClubID()) {
		XuBind (XuInitialEditClub, XuServer::publicClubID()) {
			XuEditionP homeEdition;
			XuWorkP homeDoc;
			// Note we must make the doc types before calling makeEdition, as
      // otherwise TextContent's endorsement won't be set up.
			XuEditionP contentTypeEdn = FEContentType::contentTypeEdition();
			homeEdition = XuText::make("This is your home document.")->contents();
			homeDoc = XuWork::make(homeEdition);
			homeDoc->release();
			/* make the place for the
				 doc and link types, and put homeDoc there */
			topEdition = XuEdition::empty(XuSequenceSpace::make())
				->with(FE_LINKTYPESKEY, XuEdition::fromArray(FEConn::TheOne->typeIDs()))
				->with(FE_HOMEDOCWORKKEY, homeDoc)
				->with(FE_CONTENTTYPESKEY, contentTypeEdn);
		} XuEndBind
	} XuEndBind
	return topEdition;
>>>>>>> 1.7
}

