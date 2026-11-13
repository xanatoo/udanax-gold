/* Draft code for the utility functions of the Xanadu demo frontend.
   Rob Jellinghaus, August-September 1992 */

#ifndef XSTUFF
#define XSTUFF

// turn on code to test the new-club-creation bug (in xstuff.cpp and xmdi.cpp)
#define TEST_CLUB_BUG

class FEStuff {
public:
	/* export an IntArray to an ostream */
	static void exportToStream (XuIntArrayP array, ostream& oo);

	/* import an IntArray from an istream */
	static XuIntArrayP importFromStream (istream& ii);

	/* Make a new user club & put it in the club directory */
	/* note: must be logged in as System Admin */
	static XuClubP makeUserClub(XuStringVar clubName, XuStringVar clubPassword);

	/* Make a home document and export its ID */
	static void makeAndExportWork (char* filename, char* text);

	/* Read the ID of a Work and return the Work */
	static XuWorkP importAndOpenWork (char* filename);

	/* Make a new link */
	static XuHyperLinkP makeLink
						(XuIDP linkTypeID, XuHyperRefP left, XuHyperRefP right);

	/* Make a new SingleRef */
	/* region should be defaulted but compiler sez "sorry, NYI" */
	static XuSingleRefP makeSingleRef
							(XuWorkP work, XuEditionP edition, XuRegionP region);

	/* Make a new SingleRef with owner as the originalContext's owner */
	/* region should be defaulted but compiler sez "sorry, NYI" */
	static XuSingleRefP makeSingleRefWithOwner
				(XuWorkP work, XuEditionP edition, XuRegionP region, XuIDP owner);

	/* Delete a work by removing its read and edit clubs */
	static void deleteWork (XuWorkP work);

	/* Delete a club by removing its clubs and its dir entry */
	static void deleteClub (XuIDP clubID);

	/* Make a filter for links of these types */
	static XuFilterP linkFilter (XuRegionP linkTypes);

	/* Make an open filter for all endorsements */
	static XuFilterP openEndorsementFilter ();

	/* Make a filter for documents of this type */
	static XuFilterP variantFilter (XuStringVar docTypeName);

	/* Get text from an edition */
	/* Note the text does _not_ need to be contiguous */
	static void getText (XuEditionP edition, XuExportHookP hookI);

	/* Get the text of a Sequence */
	static void getText (XuSequenceP sequence, XuExportHookP hookI);

	/* return promise for true if end is at left of link */
	static XuIntValueP atRight (XuHyperLinkP link, XuWorkP end);

	/* return right end if atRight is TRUE, right otherwise */
	static XuHyperRefP endAt (XuHyperLinkP link, XuIntValueP atRight);

  /* return key for right end if atRight is TRUE, else key for left end */
  static XuSequenceP linkKey (XuIntValueP atRight);

	/* set the read and edit clubs of work; return TRUE if succeeded, FALSE
		 if failed (can only fail if you're not the owner) */
	static XuIntVar setPermissions(XuWorkP work, XuIDP read, XuIDP edit);

	/* It does seem as though we want some kind of region protocol which
		 minimizes round trips... deferred routines or something... anyway,
		 that will have to wait for later. */
	/* return an appropriate excerpt for this HyperRef */
	static XuStringVar excerpt
			(XuSingleRefP ref, XuEditionP currentContext, int len = 16);

	/* Do the version compare, returning the region of currentContext
		 to which ref refers. If there is no excerpt, assume... what? For
		 now, no excerpt means link is to the whole originalContext, so
		 compare currentContext to originalContext. No originalContext
		 means the whole Work is linked to, so just return XU_NULL. If it
		 turns out that no originalContext means whole Work, then return
		 XU_NULL in that case too. */
	static XuRegionP regionOf (XuSingleRefP ref, XuEditionP currentContext);
};

#endif /* XSTUFF */
