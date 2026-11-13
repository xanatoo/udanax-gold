// The manager for all documents, windows, and managers.

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "absui.h"
#include "draft.h"
#include "content.h"
#include "textct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "xint2set.hxx"
#include "startup.h"
#include "clip.h"
#include "title.h"

#include "formct.h"
#include "ratefct.h"
#include "memofct.h"
#include "akordfct.h"
#include "homefct.h"
#include "tabsfct.h"
#include "attnfct.h"
#include "umfct.h"
#include "cproffct.h"

/* This will only really work if iD is loginClubID or publicClubID. */
XuWorkP FEManager::
connectHomeDoc (XuIDP iD, XuStringVar clubName, XuEditionP homeEdition)
{
	XuWorkP homeWork;
	XuBind (XuInitialReadClub, XuServer::publicClubID()) {
		XuBind (XuInitialEditClub, iD) {
			// Note we must make the doc types before calling makeEdition, as
      // otherwise TextContent's endorsement won't be set up.
			XuEditionP docTypeEdn = FEManager::docTypeEdition();
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
}

#include <sys/stat.h>
static XuStringVar fileContents (char * filename) {
	FILE * f = fopen (filename, "rb");

	// get the length of the file.
	struct stat statbuf;
	fstat(fileno(f), &statbuf);
	int len = statbuf.st_size;
	
	char * buf = new char [len + 1];
	int n = fread (buf, 1, len, f);
	buf[n] = 0;
	cerr << "read " << n << " characters from " << filename << '\n';
	fclose (f);
	return buf;
}
		
/* This gets used to set up the home documents and such. */
void FEManager::initializeClub () {
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
      	// make a new text doc as the public doc
				newDoc = FEManager::connectHomeDoc(XuServer::publicClubID(),
														"Public", FEManager::publicHomeEdition());
			} XuEndBind
      // finish the startup, with the newly made public home doc
			FEStartupManager::completeStartup(newDoc);
		} else {
			FEUI::beep();
			return;
		}
	}
	// if no login doc, or if user wants new one anyway, then make one
	if (FEStartupManager::fetchAppHome() == XU_NULL
			|| FEUI::ask("Make another Home Document?", "Backend Initialization")) {
		XuWorkP homeWork = connectHomeDoc(TheFEConn->loginClubID(), TheFEConn->loginName(),
																			FEManager::appHomeEdition());
		homeWork->release ();
	}
	FEUI::tell("Initialization complete", "Done");
}


XuEditionP FEManager::
publicHomeEdition()
{
	XuEditionP topEdition;
	XuBind (XuInitialReadClub, XuServer::publicClubID()) {
		XuBind (XuInitialEditClub, XuServer::publicClubID()) {
			XuEditionP homeEdition;
			XuWorkP homeDoc;
			// Note we must make the doc types before calling makeEdition, as
      // otherwise TextContent's endorsement won't be set up.
			XuEditionP docTypeEdn = FEManager::docTypeEdition();
			homeEdition = FETextContentType::makeEdition("This is your home document.");
			homeDoc = XuWork::make(homeEdition);
			homeDoc->release();
			/* make the place for the
				 doc and link types, and put homeDoc there */
			topEdition = XuEdition::empty(XuSequenceSpace::make())
				->with(FE_MYLINKTYPESKEY, XuEdition::fromArray(TheFEConn->typeIDs()))
				->with(FE_MYHOMEDOCWORKKEY, homeDoc)
				->with(FE_MYDOCTYPESKEY, docTypeEdn);
		} XuEndBind
	} XuEndBind
	return topEdition;
}

XuEditionP FEManager::
appHomeEdition ()
{
	XuIDP loginID = TheFEConn->loginClubID();

	// Here is where all the initial documents are created and connected.

	// First make the rate form.
	XuEditionP rateEdn = FERateFormContentType::TheOne.makeEdition ();
	XuWorkP rateWork = XuWork::make(rateEdn);
  rateWork->release ();

	// Then make the Contractual Profile form
	XuEditionP cprofEdn = FECProfFormContentType::TheOne.makeEdition ();
	XuWorkP cprofWork = XuWork::make(cprofEdn);
  cprofWork->release ();

	// Then make the UM CLC form pointing to it
	XuStringVar buf = fileContents ("umclc.txt");
	XuEditionP umclcEdn = FEUMFormContentType::TheOne.makeEdition ()
		->with ("Manual", XuText::make ("AB14")->edition ())
		->with ("Procedure", XuText::make ("3220")->edition ())
		->with ("Page", XuText::make ("12")->edition ())
		->with ("Date", XuText::make ("7/12/92")->edition ())
		->with ("Rev", XuText::make ("00")->edition ())
		->with ("Title", XuText::make (
"GENERAL LIABILITY AND COVERAGE EXTENSIONS\r\n\
CONTRACTUAL LIABILITY COVERAGE\r\n\
COVERAGE SUPPLEMENT")->edition ())
		->with ("Contents", XuText::make (buf)->edition ())
		->with ("Exhibit",
			FEStuff::makeSingleRef(cprofWork, cprofEdn, XU_NULL)->edition ());
	umclcEdn->endorse (FEUMFormContentType::TheOne.endorsements ());
	XuWorkP umclcWork = XuWork::make (umclcEdn);
	umclcWork->release ();
	delete (void*) buf;

	// Then make the UM CCC form
 	buf = fileContents ("umccc.txt");
	XuTextP umcccText = XuText::make (buf); // for revised version later
	delete (void*) buf;
	XuEditionP umcccEdn = FEUMFormContentType::TheOne.makeEdition ()
		->with ("Manual", XuText::make ("AB14")->edition ())
		->with ("Procedure", XuText::make ("3220")->edition ())
		->with ("Page", XuText::make ("05")->edition ())
		->with ("Date", XuText::make ("7/12/92")->edition ())
		->with ("Rev", XuText::make ("00")->edition ())
		->with ("Title", XuText::make (
"GENERAL LIABILITY AND COVERAGE EXTENSIONS\r\n\
AMENDED CARE, CUSTODY, AND CONTROL EXCLUSION\r\n\
COVERAGE SUPPLEMENT")->edition ())
		->with ("Contents", umcccText->edition ());
	umcccEdn->endorse (FEUMFormContentType::TheOne.endorsements ());
	XuWorkP umcccWork = XuWork::make (umcccEdn);
  umcccWork->release ();

	// Now make the akord form pointing to both UM pages
	XuEditionP akordEdn = FEAkordFormContentType::TheOne.makeEdition ()
		->with ("CGL", FEStuff::makeSingleRef(umclcWork, umclcEdn, XU_NULL)->edition ())
		->with ("CCC", FEStuff::makeSingleRef(umcccWork, umclcEdn, XU_NULL)->edition ());
	akordEdn->endorse (FEAkordFormContentType::TheOne.endorsements ());
	XuWorkP akordWork = XuWork::make(akordEdn);
  akordWork->release ();

	// Then make the Tabs form pointing to the other forms
	XuEditionP tabsEdn = FETabsFormContentType::TheOne.makeEdition ()
		->with ("Rate Instructions",
			FEStuff::makeSingleRef(rateWork, rateEdn, XU_NULL)->edition ())
		->with ("Akord",
			FEStuff::makeSingleRef(akordWork, akordEdn, XU_NULL)->edition ())
		->with ("Contractual Profile",
			FEStuff::makeSingleRef(cprofWork, cprofEdn, XU_NULL)->edition ());
	tabsEdn->endorse (FETabsFormContentType::TheOne.endorsements ());
	XuWorkP tabsWork = XuWork::make (tabsEdn);
  tabsWork->release ();

	// Next make the UM hazard form
	buf = fileContents ("umhaz.txt");
	XuEditionP umhazEdn = FEUMFormContentType::TheOne.makeEdition ()
		->with ("Manual", XuText::make ("AB14")->edition ())
		->with ("Procedure", XuText::make ("3220")->edition ())
		->with ("Page", XuText::make ("22")->edition ())
		->with ("Date", XuText::make ("7/12/92")->edition ())
		->with ("Rev", XuText::make ("00")->edition ())
		->with ("Title", XuText::make (
"GENERAL LIABILITY AND COVERAGE EXTENSIONS\r\n\
NEARBY HAZARDS\r\n\
COVERAGE SUPPLEMENT")->edition ())
		->with ("Contents", XuText::make (buf)->edition ());
	umhazEdn->endorse (FEUMFormContentType::TheOne.endorsements ());
	XuWorkP umhazWork = XuWork::make (umhazEdn);
  umhazWork->release ();
	delete (void*) buf;

	// Then make the LCR memo pointing to it
	XuEditionP lcrmemoEdn = FEMemoFormContentType::TheOne.makeEdition ()
		->with ("Date", XuText::make ("2/10/93")->edition ())
		->with ("File", XuText::make ("Unlucky Markets")->edition ())
		->with ("From", XuText::make ("Karen Albertson, Loss Control Representative")->edition ())
		->with ("To", XuText::make ("Blake Patterson, Underwriter")->edition ())
		->with ("Memorandum", XuText::make ("The new market has a vacant wood frame building next door.")->edition ())
		->with ("References", FEStuff::makeSingleRef(umhazWork, umhazEdn, XU_NULL)->edition ());
	lcrmemoEdn->endorse (FEMemoFormContentType::TheOne.endorsements ());
	XuWorkP lcrmemoWork = XuWork::make (lcrmemoEdn);
  lcrmemoWork->release ();

	// And then make the LCR attention window pointing to it
	XuEditionP lcrattnEdn = FEAttnFormContentType::TheOne.makeEdition ()
		->with ("Message", XuText::make ("MEMO\r\nFrom: Karen Albertson, Loss Control Representative")->edition ())
		->with ("Read", FEStuff::makeSingleRef(lcrmemoWork, lcrmemoEdn, XU_NULL)->edition ());
	lcrattnEdn->endorse (FEAttnFormContentType::TheOne.endorsements ());
	XuWorkP lcrattnWork = XuWork::make (lcrattnEdn);
  lcrattnWork->release ();

	// Next make the revised UM CCC form
	XuEditionP umccc2Edn = umcccEdn
		->with ("Date", XuText::make ("2/12/93")->edition ())
		->with ("Rev", XuText::make ("01")->edition ())
		->with ("Contents", umcccText->replace (
				XuIntegerSpace::make()->interval (529,534), XuText::make ("10-20%"))->edition ())
		->with ("Original", umcccText->edition ());
	umccc2Edn->endorse (FEUMFormContentType::TheOne.endorsements ());
	XuWorkP umccc2Work = XuWork::make (umccc2Edn);
	umccc2Work->release ();

	// And then make the UM Change attention window pointing to it
	XuEditionP umattnEdn = FEAttnFormContentType::TheOne.makeEdition ()
		->with ("Message", XuText::make ("UM CHANGE\r\nCare, Custody, and Control Exclusions")->edition ())
		->with ("Read", FEStuff::makeSingleRef(umccc2Work, umccc2Edn, XU_NULL)->edition ());
	umattnEdn->endorse (FEAttnFormContentType::TheOne.endorsements ());
	XuWorkP umattnWork = XuWork::make (umattnEdn);
  umattnWork->release ();

	// Next make the HOUO memo
	XuEditionP houomemoEdn = FEMemoFormContentType::TheOne.makeEdition ()
		->with ("Date", XuText::make ("2/15/93")->edition ())
		->with ("File", XuText::make ("Unlucky Markets")->edition ())
		->with ("From", XuText::make ("George Smithers, Branch Manager")->edition ())
		->with ("To", XuText::make ("Blake Patterson, Underwriter")->edition ())
		->with ("Memorandum", XuText::make ("The Home Office Underwriting Officer says we should try to reduce the rate since they write $5M premiums per year with us")->edition ());
	houomemoEdn->endorse (FEMemoFormContentType::TheOne.endorsements ());
	XuWorkP houomemoWork = XuWork::make (houomemoEdn);
	houomemoWork->release ();

	// And then make the HOUO attention window pointing to it
	XuEditionP houoattnEdn = FEAttnFormContentType::TheOne.makeEdition ()
		->with ("Message", XuText::make ("MEMO\r\nFrom: George Smithers, Branch Manager")->edition ())
		->with ("Read", FEStuff::makeSingleRef(houomemoWork, houomemoEdn, XU_NULL)->edition ());
	houoattnEdn->endorse (FEAttnFormContentType::TheOne.endorsements ());
	XuWorkP houoattnWork = XuWork::make (houoattnEdn);
  houoattnWork->release ();

	// Now make the home doc and connect it to the akord, tabs, and attention
	XuEditionP homeEdn = FEHomeFormContentType::TheOne.makeEdition()
		->with ("Akord", FEStuff::makeSingleRef(akordWork, akordEdn, XU_NULL)->edition ())
		->with ("Papers", FEStuff::makeSingleRef(tabsWork, tabsEdn, XU_NULL)->edition ())
		->with ("Attention 1B", FEStuff::makeSingleRef(lcrattnWork, lcrattnEdn, XU_NULL)->edition ())
		->with ("Attention 2B", FEStuff::makeSingleRef(umattnWork, umattnEdn, XU_NULL)->edition ())
		->with ("Attention 1C", FEStuff::makeSingleRef(houoattnWork, houoattnEdn, XU_NULL)->edition ());
	homeEdn->endorse (FEHomeFormContentType::TheOne.endorsements ());
  return homeEdn;
}

