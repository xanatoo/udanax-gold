#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "xstuff.hxx"
#include "xconn.hxx"

/* Draft code for the login and connection parts of the Xanadu demo frontend.
   Rob Jellinghaus, August-September 1992 */


/* TODO: do something ignominious if loginAndInit returns XU_NULL */
FEConn* FEConn::make
    (const char* loginName, const char* loginPassword)
{
	FEConn* newConn = new FEConn();
  newConn->loginAndInit(loginName, loginPassword);
	for (int i = 0; i < FE_NUMTYPEIDS; i++) {
  	newConn->myTypeIDs[i] = XU_NULL;
  }
  return newConn;
}

XuKeyMasterP FEConn::loginAndInit
    (const char* clubName, const char* clubPassword)
{
	/* try this to finesse System Access */
	XuKeyMasterP pubKM =
		XuBooLock::cast(XuServer::login(XuServer::publicClubID()))->boo();
	XuLockP lock = XuServer::loginByName(clubName);
	XuKeyMasterP myKM;
	XuIf (XuBooLock::isTypeOf(lock)) {
		myKM = XuBooLock::cast(lock)->boo();
	} XuElse {
		XuIf (XuWallLock::isTypeOf(lock)) {
			cerr << "ERROR: can't log into that club\n";
			return XU_NULL;
		} XuElse {
			myKM = XuMatchLock::cast(lock)->encryptedPassword(clubPassword);
			myKM->force();
			if (myKM->isBroken()) {
				cerr << "ERROR: password wrong\n";
				return XU_NULL;
			}
		} XuEndIf
	} XuEndIf

	myKM->incorporate
		(XuBooLock::cast(XuServer::login(XuServer::publicClubID()))->boo());
	XuCurrentKeyMaster.set(myKM);

	myLoginClubID = XuServer::clubID(clubName);
	XuCurrentAuthor.set(myLoginClubID);
	XuInitialOwner.set(myLoginClubID);
	XuInitialSponsor.set(myLoginClubID);
	// TODO this should be the login club
	XuInitialReadClub.set(XuServer::publicClubID());
	XuInitialEditClub.set(myLoginClubID);
	myLoginName = new char[strlen(clubName)+1];
	strcpy(myLoginName, clubName);
	return myKM;
}    

XuPtrArrayP FEConn::
typeIDs () {
	XuPtrArrayP iDs = XuPtrArray::nulls(FE_NUMTYPEIDS);
	for (XuIntVar i = 0; i < FE_NUMTYPEIDS; i++) {
		iDs->store(i, XuServer::get(myTypeIDs[i]));
	}
  return iDs;
}       	

void FEConn::
makeTypeIDs () {
	/* obviously these will one day be proper link type descriptions */
	XuStringVar s[FE_NUMTYPEIDS];
	XuPtrArrayP newIDs = XuPtrArray::nulls(FE_NUMTYPEIDS);

	s[0] = "Demo relationship link type";
	s[1] = "Demo home document link type";
	s[2] = "Demo title document type";

	for (XuIntVar i = 0; i < FE_NUMTYPEIDS; i++) {
		XuWorkP typeDescWork = XuWork::make(XuText::make(s[i])->edition());
		myTypeIDs[i] = XuServer::assignID(typeDescWork);
	}
}       	

void FEConn::
setTypeIDs (XuPtrArrayP iDs) {
	XuIf (iDs->count()->equals(XuIntValue::signedMake(FE_NUMTYPEIDS))) {
  	for (XuIntVar i = 0; i < FE_NUMTYPEIDS; i++) {
				myTypeIDs[i] = XuServer::iDOf(XuRangeElement::cast(iDs->get(i)));
    }
  } XuElse {
    cerr << "Wrong number of link types for setLinkTypeIDs\n";
    exit(-1);
  } XuEndIf
}

XuIDP FEConn::loginClubID ()
{
    return myLoginClubID;
}
XuIDP FEConn::relationshipLinkTypeID ()
{
    return myTypeIDs[0];
}
XuIDP FEConn::homeDocLinkTypeID ()
{
    return myTypeIDs[1];
}
XuIDP FEConn::titleTypeID ()
{
	return myTypeIDs[2];
}

char* FEConn::loginName ()
{
	return myLoginName;
}


void FEConn::linkHomeDocTo(XuClubP newClub)
{
    /* make empty home doc */
    /* HAIR HAIR HAIR!
       The newClub needs to be the owner of the home doc and the link,
       as well as the editor and reader.
       But as part of the link creation, the CurrentKeyMaster needs to
       be able to make a frozen Work for the OriginalContext.
       So what we do is make the SingleRefs in a special way such that
       the Work can be frozen by the CurrentKeyMaster and then give
       ownership back to the newClub. */
	XuHyperLinkP link;
  XuIDP newClubID = XuServer::iDOf(newClub);
  XuEditionP homeEdition;
  XuWorkP homeDoc;
	XuBind(XuInitialReadClub, newClubID) {
    XuBind(XuInitialEditClub, newClubID) {
			XuBind(XuInitialOwner, newClubID) {
	    	homeEdition = XuText::make("Home Document!")->edition();
	    	homeDoc = XuWork::make(homeEdition);
	    	/* note that homeDoc->edition() at this point will blast
	      	 with MustHaveReadPermission! */
			} XuEndBind
			/* link club to home doc */
			link = FEStuff::makeLink
	    	(homeDocLinkTypeID(),
		 		 FEStuff::makeSingleRefWithOwner
	     		(newClub, newClub->edition(), XU_NULL, newClubID),
		 		 FEStuff::makeSingleRefWithOwner
	     		(homeDoc, homeEdition, XU_NULL, newClubID));
			XuBind(XuInitialOwner, newClubID) {
	    	XuWorkP linkWork = XuWork::make(link->edition());
			} XuEndBind
    } XuEndBind
	} XuEndBind
}

XuIDP FEConn::privateClubID()
{
	return loginClubID ();
}



