#ifndef XCONN
#define XCONN

/* Draft code for the connection/login functions of the Xanadu demo frontend.
   Rob Jellinghaus, August-September 1992 */

#define FE_NUMTYPEIDS 3

class FEConn {
public:
	static FEConn* make
		(const char* loginName, const char* loginPassword);
    
	/* Log into the club (break if impossible) and set up fluid vars */
  XuKeyMasterP loginAndInit
		(const char* clubName, const char* clubPassword);

	/* Make the type IDs and works */
  void makeTypeIDs ();

  /* set the type IDs */
  /* this is done by the FEHomeDocManager code in browser.cpp */
	void setTypeIDs (XuPtrArrayP typeIDs);
	// return an array of the type ID works
	XuPtrArrayP typeIDs();

  /* access the ID of the login Club, and the IDs of the link types */
  XuIDP loginClubID ();
  XuIDP relationshipLinkTypeID ();
	XuIDP homeDocLinkTypeID ();
	XuIDP titleTypeID ();

	/* the name of the login club */
	char* loginName ();

  /* Link a home document to this club */
  void linkHomeDocTo (XuClubP newClub);

  /* Return the canonical public club */
  /* Return the canonical private club (loginClub plus whatever?) */
  XuIDP privateClubID ();
    
private:
	FEConn () {};
    
	XuIDP myTypeIDs[FE_NUMTYPEIDS];
	XuIDP myLoginClubID;
  char* myLoginName;

};

#endif // XCONN
