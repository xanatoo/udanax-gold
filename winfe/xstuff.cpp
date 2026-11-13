#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "xstuff.hxx"

#define FE_LINK_LEFTEND_KEY "Link:LeftEnd"
#define FE_LINK_RIGHTEND_KEY "Link:RightEnd"
#define FE_MAX_BUNDLES 50

/* Draft code for the backend of the Xanadu demo frontend. */

/* Comment tags of importance:
   TODO: something to be done
   NYI: not yet implemented
   HUH: a kludge that shouldn't be necessary
   ERROR: an error message that will need to appear in a dialog
   !!!: something I don't understand

   Ifdefs of importance:
   DELAY_BUG:  comments out code relevant to the XuDelay bug that's been
      reported to bugs
   NEW_CLUB_LOCK_BUG:  comments out code for the new-club-WallLock bug
   */

/* This class implements most of the getText operation.  It allocates
	 a single buffer and maintains moving pointers so that the exports of
	 all the bundles int he edition end up in the same buffer.  It
	 allocates that buffer by calling a user-supplied ExportHook.  It also
	 calls the user-supplied export hook when the final bundle comes in (or
	 something gets broken).  */

class FEGetTextHook : public XuExportHook {
	XuBooleanValueP myAtEnd;        // whether the stepMany got all the bundles
	XuIntValueP myBundleCount;      // the number of bundles in the edition
	XuIntValueP myByteCount;        // the number of bytes in the edition
	XuArrayP myBundles;             // the array of bundles
	XuExportHookP myHook;            // the user supplied exportHook for the whole thing
	XuBufferVar myBuffer;           // the buffer into which the exports happen
	XuIntVar mySize;                // the byteCount of the buffer
	XuIntVar myBundlesExported;     // the number of bundles exported so far
	XuIntVar myBundlesFulfilled;    // the number of whose export has completed
	XuIntVar myBytesDone;           // the number of bytes exported so far
public: 
	
	// start the export of a guessed number of bundles.
	FEGetTextHook(XuExportHookP hook, XuStepperP stepper, 
										XuArrayP bundles, XuIntValueP count) :
		myAtEnd(stepper->atEnd()), myBundleCount(bundles->count()),
		myByteCount(count), myHook(hook), myBundles(bundles), 
		myBuffer(NULL), mySize(0), 
		myBundlesExported(0), myBundlesFulfilled(0), myBytesDone(0)
	{
#define FE_BUNDLECOUNT_GUESS 4
		this->exportMany(FE_BUNDLECOUNT_GUESS);
	}

	// hook messages
	virtual XuIntVar getBuffer(XuIntVar, XuBufferVar *bufP)  {
		if (myBuffer == NULL) {
			// is this is the first incoming bundle, set things up
			this->firstExport();
		}
		*bufP = (char*)myBuffer + myBytesDone;
		return mySize - myBytesDone;
	}
	virtual void fulfilled(XuBufferVar, XuIntVar size) {
		myBytesDone += size;
		myBundlesFulfilled++;
		if (myBundlesFulfilled >= myBundleCount->asInt()) {
			myHook->fulfilled(myBuffer,myBytesDone);
		}
	}
 private:
	// set up the buffer and all that.
	void firstExport () {
		if (myBundleCount->isBroken() || !myAtEnd->asBoolean()) {
			cerr << "Can't handle huge editions yet.";
			myHook->broken(XuVoid::cast(myBundleCount));
			myBuffer = new char[1];
			mySize = 0;
		} else {
			// as the client exportHook for a buffer (with extra space for a \0)
			mySize = myHook->getBuffer(myByteCount->asInt()+1, &myBuffer)-1;
			// export any outstanding bundles.
			if (myBundlesExported < myBundleCount->asInt()) {
				this->exportMany(myBundleCount->asInt() - myBundlesExported);
			}
		}
		((char*)myBuffer)[mySize] = '\0';
	}
	// helper routine to export bundles (without relying on existing setup)
	void exportMany(XuIntVar num) {
		int max = myBundlesExported + num;
		for (; myBundlesExported < max; myBundlesExported++) {
			XuArrayP array = XuArrayBundle::cast(myBundles->get(myBundlesExported))->array();
			array->export(this);
		}
	}
};

/* TODO: pBuf should only point to something if the original edition was
	enumerable and if each and every bundle contained the right bitCount
	and so forth.  For now, we just don't return anything. */
void FEStuff::
getText (XuEditionP edition, XuExportHookP hookI)
{
	// retrieve all the bundles
	XuStepperP step = edition->retrieve();
	XuArrayP bundles = step->stepMany(FE_MAX_BUNDLES);
	XuIntValueP countP = edition->count();

	XuExportHookP hook = new FEGetTextHook(hookI, step, bundles, countP);
}

void FEStuff::
getText (XuSequenceP sequence, XuExportHookP hookI) {
	XuArrayP array = sequence->integers();
	array->export(hookI);
}


/* export an 8-bit IntArray to an ostream */
/* TODO: this seems to break Borland badly, which is WRONG-O. */
void FEStuff::
exportToStream (XuIntArrayP array, ostream& oo) {
	XuIntVar count, bits;
	XuIntValueP countP, bitsP;
    
	countP = array->count();
	bitsP = array->bitCount();
	count = countP->asInt(); bits = bitsP->asInt();
	
	XuBufferVar buf;
  int len;
	if (bits == 8) {
		buf = (XuBufferVar) new XuByteVar[len = count+1];
	} else if (bits == 32) {
		buf = (XuBufferVar) new XuIntVar[len = (count+1)*4];
	} else {
		cerr << "ERROR: Can't handle non-byte arrays\n";
		exit(1);
	}

	array->export(buf, count)->force();
	oo << count << " " << bits << " ";
	oo.write((char*)buf, len);
	delete buf;
}

/* import an IntArray from an istream */
XuIntArrayP FEStuff::
importFromStream (istream& ii) {
	cerr << "importing file...\n";
	XuIntVar count, bits;
	ii >> count >> bits;
	cerr << "count: " << count << " bits: " << bits << '\n';
	char c; ii.get(c); /* swallow the space */
	XuBufferVar buf;
  int len;
	if (bits == 8) {
		buf = new char[(len = count)+1];
	} else {
		buf = new char[(len = count*4)+4];
	}
	ii.read((char*)buf, len);
	XuIntArrayP ret = XuIntArray::import(count, bits, (XuBufferVar)buf);
	delete buf;
	return ret;
}

#ifdef TEST_CLUB_BUG
#define NEW_CLUB_LOCK_BUG
#endif

XuClubP FEStuff::
makeUserClub (XuStringVar clubName, XuStringVar clubPassWord) {
	XuAdminerP admin = XuAdminer::make();
	admin->force();
	if (admin->isBroken()) {
		cerr << "ERROR: Can't make club without admin authority\n";
		return XU_NULL;
	}

	XuIDP newClubID;
	XuClubP newClub;
	XuLockSmithP lockSmith;
	XuWorkP clubDir = XuWork::cast(XuServer::get(XuServer::clubDirectoryID()));

	/*  make a new club */
	if (strlen(clubPassWord) == 0) {
		/* if "" is passWord then assume BooLockSmith */
		lockSmith = XuBooLockSmith::make();
	} else {
		lockSmith = XuMatchLockSmith::make(clubPassWord, "None");
  }

#ifdef NEW_CLUB_LOCK_BUG
	XuPromise::forceAll();
	cerr << "strlen(clubPassWord) == <" << strlen(clubPassWord) << ">\n";
	cerr << "XuBooLockSmith::isTypeOf(lockSmith) == "
    << XuBooLockSmith::isTypeOf(lockSmith) << "\n";
	cerr << "XuMatchLockSmith::isTypeOf(lockSmith) == "
    << XuMatchLockSmith::isTypeOf(lockSmith) << "\n";
#endif

	newClub = XuClub::make
			(XuClubDescription::make
	     (XuSet::make(XuPtrArray::nulls(0)), lockSmith)->edition());
	newClubID = XuServer::iDOf(newClub);
	
	/* add to club dir */
	XuEditionP clubDirEdition = clubDir->edition();
	XuVoidP clubDirReviseWorked = clubDir->revise
		(clubDirEdition->with((XuSequenceP)clubName, newClub));
	/* THIS IS VERY IMPORTANT, or it may never be available again! */
	clubDir->release();

	/* Go get the System Access Club, and update its membership to
	   include this new club */
	XuClubP sysAccess = XuClub::cast(XuServer::get(XuServer::accessClubID()));
	sysAccess->grab();
	XuClubDescriptionP clubDesc = XuClubDescription::wrap(sysAccess->edition());
  XuVoidP sysAccessReviseWorked = sysAccess->revise(clubDesc->withMembership
			  (clubDesc->membership()->with(newClub))->edition());
	sysAccess->release();

#ifdef NEW_CLUB_LOCK_BUG
XuLockP lock = XuServer::login(newClubID);
lock->force();
cerr << "clubDirReviseWorked isFulfilled: " << clubDirReviseWorked->isFulfilled() << "\n";
cerr << "sysAccessReviseWorked isFulfilled: " << sysAccessReviseWorked->isFulfilled() << "\n";
cerr << "XuLock::isTypeOf(lock) == "
    << XuLock::isTypeOf(lock)->asInt() << "\n";
cerr << "XuWallLock::isTypeOf(lock) == "
    << XuWallLock::isTypeOf(lock)->asInt() << "\n";
cerr << "XuBooLock::isTypeOf(lock) == "
    << XuBooLock::isTypeOf(lock)->asInt() << "\n";
cerr << "XuMatchLock::isTypeOf(lock) == "
    << XuMatchLock::isTypeOf(lock)->asInt() << "\n";
#endif

	return newClub;
}

void FEStuff::
makeAndExportWork (char* filename, char* text) {
    XuWorkP homeDoc = XuWork::make(XuText::make(text)->edition());
    XuIDP newID = XuServer::assignID(homeDoc);
    filebuf fileBuf;
    fileBuf.open(filename, ios::out);
    ostream to(&fileBuf);
    exportToStream(newID->export(), to);
}

XuWorkP FEStuff::
importAndOpenWork (char* filename)
{
    filebuf fileBuf;
    fileBuf.open(filename, ios::in);
    istream from(&fileBuf);
    XuIDP returnID = XuID::import(importFromStream(from));
    return XuWork::cast(XuServer::get(returnID));
}
		

/* All this link making could quite plausibly go in FELinkTypeDescription */
XuHyperLinkP FEStuff::
makeLink(XuIDP linkTypeID, XuHyperRefP left, XuHyperRefP right)
{
	/* link club to home doc */
	 return XuHyperLink::
		make(XuSet::make(XuPtrArray::with(XuServer::get(linkTypeID))), left, right);
}

XuSingleRefP FEStuff::
makeSingleRef(XuWorkP work, XuEditionP edition, XuRegionP region)
{
	/* TODO: originally this bound InitialOwner in order to freeze the Work.
		It may still need to. */
	XuWorkP frozen;
	frozen = XuWork::make(edition);
	frozen->removeEditClub();
	if (region == XU_NULL) {
		return XuSingleRef::make(edition, work, frozen);
	} else {
		/* TODO: this withExcerpt shouldn't be necessary; you should be able
	   	to make a ref with an excerpt, but this seems currently broken */
		return XuSingleRef::make(XU_NULL, work, frozen)
							->withExcerpt(edition->copy(region));
  }
}          

XuSingleRefP FEStuff::
makeSingleRefWithOwner(XuWorkP work, XuEditionP edition, XuRegionP region, XuIDP owner)
{
	XuWorkP frozen;
  frozen = XuWork::make(edition);
  frozen->removeEditClub();
  frozen->setOwner(owner);
	if (region == XU_NULL) {
		return XuSingleRef::make(edition, work, frozen);
  } else {
		/* TODO: this withExcerpt shouldn't be necessary; you should be able
	   	to make a ref with an excerpt, but this seems currently broken */
		return XuSingleRef::make(XU_NULL, work, frozen)
							->withExcerpt(edition->copy(region));
  }
}          

void FEStuff::
deleteWork (XuWorkP work) {
	work->removeReadClub();
	work->removeEditClub();
}

void FEStuff::
deleteClub (XuIDP clubID) {
	XuClubP club = XuClub::cast(XuServer::get(clubID));
	deleteWork(club);
	XuWorkP clubDirWork =
        XuWork::cast(XuServer::get(XuServer::clubDirectoryID()));
	clubDirWork->grab();
	clubDirWork->revise(clubDirWork->edition()
		->without(XuServer::clubName(clubID)));
}
    

XuFilterP FEStuff::
linkFilter (XuRegionP linkTypeIDs) {
	return XuFilter::cast
		(XuHyperLink::spec()->filter()->intersect
			(XuFilterSpace::make(XuCrossSpace::endorsements())
			 ->anyFilter
				(XuCrossRegion::endorsements
				 (XuIDRegion::cast(XuIDSpace::global()->fullRegion()),
					XuIDRegion::cast(linkTypeIDs)))));
}

XuFilterP FEStuff::
openEndorsementFilter () {
	return XuFilterSpace::make(XuCrossSpace::endorsements())->anyFilter
		(XuCrossRegion::endorsements
 		 (XuIDRegion::cast(XuIDSpace::global()->fullRegion()),
			XuIDRegion::cast(XuIDSpace::global()->fullRegion())));
}
	    
XuFilterP FEStuff::
variantFilter (XuStringVar docTypeName) {
	return XuWrapperSpec::get(docTypeName)->filter();
}

/* return promise for TRUE if end is at left side of link */
XuIntValueP FEStuff::
atRight (XuHyperLinkP link, XuWorkP end) {
	return end->isIdentical(link->endAt(FE_LINK_RIGHTEND_KEY)->workContext());
}

/* return left end if atRight is FALSE (i.e. 0) */
XuHyperRefP FEStuff::
endAt (XuHyperLinkP link, XuIntValueP atRight) {
	atRight->force();
	if (atRight->asInt()) {
		return link->endAt(FE_LINK_RIGHTEND_KEY);
  } else {
		return link->endAt(FE_LINK_LEFTEND_KEY);
  }
}

static XuPtrArrayP linkKeys = XU_NULL;

/* return key for right end if atRight is TRUE, else key for left end */
XuSequenceP FEStuff::
linkKey (XuIntValueP atRight) {
	if (linkKeys == XU_NULL) {
		linkKeys = XuPtrArray::with
			(XuSequence::string(FE_LINK_LEFTEND_KEY),
			 XuSequence::string(FE_LINK_RIGHTEND_KEY));
	}
	return XuSequence::cast(linkKeys->get(atRight));
} 


/* You must be the owner to do this. What happens if you're not? Blast?
   Return an error? Assume return TRUE if OK, FALSE if not, for now. */
XuIntVar FEStuff::
setPermissions(XuWorkP work, XuIDP readID, XuIDP editID) {
	/* Check ownership by catching blasts from the change attempt.
		This is the right thing with respect to race conditions. */
    // dean eliminated waiting for results.  No one currently uses this.
	work->setReadClub(readID);
	work->setEditClub(editID);
	return TRUE;
}

/* Return the first ten characters of the ref (no ellipsis yet) */
/* if regionOf is XU_NULL, then it's the whole thing */
/* should check to make sure currentContext is text */
XuStringVar FEStuff::
excerpt(XuSingleRefP ref, XuEditionP currentContext, int len) {
	XuRegionP region = regionOf(ref, currentContext);
  region->force();
	cerr << "This is too obsolete to live.";
	abort();

/*	if (region->isBroken()) {
		XuBufferVar buf = new char[len+1];
		XuArrayBundle::cast(edition->stepper()->get())->export(buf, len);
		XuPromise::forceAll();
		return (XuStringVar)buf;
  } else {
		XuDataP data = XuData::make(NULL, len);
		getText(currentContext->copy(region), data);
		XuPromise::forceAll();
		XuStringVar text = (XuStringVar)data->buffer();
		if (strlen(text) < len) {
			return text;
 		} else {
			XuStringVar first = (XuStringVar) new char[len+1];
			((char*)text)[len] = '\0';
			strcpy((char*) first, text);
			delete (void*) text;
			return first;
		}
  }
*/
	return "Obsolete exceprt fetching.";
}

// Return the region in currentContext to which ref refers.
// should this use the original context if the excerpt doesn't exist?
XuRegionP FEStuff::
regionOf (XuSingleRefP ref, XuEditionP currentContext) {
	return currentContext->sharedRegion(ref->excerpt());
}


