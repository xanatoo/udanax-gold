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
#include "title.h"
#include "clip.h"

#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"

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

// executed for each edition that the startup detector finds
class FEPublicStartup : public XuEachHook {
	int startup (XuWorkP startupWork) {
		/* the public club's home doc is actually a compound edition storing
			an integer edition of link types and a Work which is the real
			editable home document */
		XuEditionP startupEdition = startupWork->edition();
		/* load link types */
		XuEditionP typeEdition = XuEdition::cast(startupEdition->get(FE_MYLINKTYPESKEY));
		FEManager::TheFEConn->setTypeIDs(
				XuPtrArray::cast(typeEdition->stepper()->stepMany(FE_NUMTYPEIDS)));
		FEManager::setDocTypeEdition(XuEdition::cast(startupEdition->get(FE_MYDOCTYPESKEY)));
		typeEdition->force();
		return typeEdition->isFulfilled();
	}
public:
	virtual void execute (XuPromiseP promise) {
		XuHyperLinkP link = XuHyperLink::wrap(XuEdition::cast(promise));
		if ( this->startup(FEStuff::endAt(link, 1)->workContext()) ) {
			FEStartupManager::completeStartup
				(XuWork::cast
					(FEStuff::endAt(link, 1)->workContext()
						->edition()->get(FE_MYHOMEDOCWORKKEY)));
			return;
		}
	}
};

static XuFillRangeHookP ThePublicStartupHook;

void FEStartupManager::
startup() {
	char loginBuf[FE_MYTEXTLEN];
	char hostBuf[FE_MYTEXTLEN];
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
	FEManager::TheFEConn = FEConn::make(loginBuf, "" /* password */);
	ThePublicStartupHook = new FEPublicStartup()->asFillRangeHook();
	XuServer::get(XuServer::publicClubID())
		->transcluders(XuHyperLink::spec()->filter())
		->addFillRangeDetector(ThePublicStartupHook);
	// TODO: add modeless dialog here "Logging in..."
}

#include "homefct.h"
class FEApplicationStartup : public XuEachHook {
protected:
	virtual void execute (XuPromiseP promise) {
		XuHyperLinkP link = XuHyperLink::wrap(XuEdition::cast(promise));
		XuWorkP homeWork = FEStuff::endAt(link, 1)->workContext();
		TheApplicationHome = homeWork;
		FEDraft * home = FEManager::draftOn (homeWork);
		if (home) {
			FEHomeFormContentType::setInstance ((FEFormContent*)home->content ());
			FEHomeFormContentType::show ("Akord");
			FEHomeFormContentType::show ("Papers");
		}
	}
};

static XuFillRangeHookP TheApplicationStartupHook;

void FEStartupManager::
completeStartup(XuWorkP publicDoc) {
	ThePublicStartupHook = XU_NULL;
	FEManager::startup();
	FETitleManager::startup();
	FEClipManager::startup();
	ThePublicHome = publicDoc;
	TheApplicationStartupHook = new FEApplicationStartup()->asFillRangeHook();
	XuServer::get(FEManager::TheFEConn->loginClubID())
		->transcluders(XuHyperLink::spec()->filter())
		->addFillRangeDetector(TheApplicationStartupHook);
}

