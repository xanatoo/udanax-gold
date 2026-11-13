/* The FEManager class consists only of static member functions and static state.
	FEManager is responsible for registering the document types (i.e. concrete
	subclasses of FEContent) that the frontend supports.  FEManager maintains the
	list of Works currently being viewed by the user, and the corresponding Draft
	objects for each Work.
*/

#ifndef FEMANAGE
#define FEMANAGE

class FEConn;

class FEManager {
public:
	/* Start the FEManager.  This function is called in two cases:  either the user
		has connected and initialized the backend (i.e. FEManager::initializeClub has
		been called), or the user has connected and the	public home document (with its
		document type and link type IDs) has been successfully opened (by the FEInitHook
		in feinit.cpp). */
	static void startup();

	/* Shut down the frontend by closing all the open Drafts.  This function is not
  	yet implemented because of unresolved destruction-order issues. */
	static XuBooleanVar shutdown();

	/* Fetch any existing Draft on this Work.  If there is no existing Draft
		(i.e. the user is not currently viewing this Work), create a new Draft on the
		Work, and a new Content for that Draft, on the Work's edition.  If docClass
		and contClass are not NULL, then use them as the classes of the new Draft and
		new Content; otherwise examine the endorsements on the Edition to determine what
		class of Draft and Content to create.  Return NULL if the Work is unreadable
		or if the document type cannot be determined. */
	static FEDraft* draftOn (XuWorkP work, FEContentType* type = NULL);

	/* Create a new Work on the Edition of the provided Content, make a new Draft
		on the new Work, and return the new Draft.  This is used by the new-variant
		code. */
	static FEDraft* makeNewDraft (FEContent* content);

	/* Attempt to close the provided Draft; if draft->close(...) returns FALSE,
		the Draft will not be closed, and this will also return FALSE; otherwise
		the draft will be wholly deleted from the FEManager.
		Passes the windowClose flag downwards to draft->close(...). */
  static XuBooleanVar close (FEDraft* draft, int windowClose);

	/* Put all appropriate home drafts up on the screen--i.e. the public and the
		login home docs. */
	static void returnHome ();

	/* Initialize the login club */
	static void initializeClub ();

	/* Anyone that uses doc or link types needs the conn */
	static FEConn* TheFEConn;

	/* This gets called by the InitManager when the homedoc edition's opened */
  static void setDocTypeEdition (XuEditionP docTypesEdn);

protected:
	/* make a new home document for the specified club */
  /* if the club is the public club, make the hacked public home doc */
	/* this method is used only by initialize */
	/* makes an FEText home doc if homeEdn is XU_NULL */
	static XuWorkP connectHomeDoc (XuIDP iD, XuStringVar clubName, XuEditionP homeEdn);

	// make the edition for the home docs of the appropriate clubs
	static XuEditionP publicHomeEdition();
	static XuEditionP appHomeEdition();

	/* find the doc type ID of the given Edition, and return that ID's number
		in myDocTypesEdition, without waiting */
	static XuIntValueP docTypeNumber (XuEditionP edition);

	/* The ContentType object at the specified index */
	static FEContentType* contentType (int index);

	/* return a 3D Edition of [docTypeNum, docTypeStr, docTypeID] positions, based
		on the currently-registered set of classes */
	static XuEditionP docTypeEdition ();

private:
	static int DraftCount;
};

#endif FEMANAGE
