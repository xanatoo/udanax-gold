// The superclass of all Drafts.  Specific subclasses handle particular
// revise policies (for example, simple drafts versus buckets).

#ifndef DRAFT
#define DRAFT

class FEContent;

class FEDraft {
public: /* creation */
	static FEDraft* make (XuWorkP work, FEContent* content = NULL);

public: /* methods */
	/* The edit work.  If edit works are not supported, the same as work(). */
	XuWorkP editWork ();

	/* The save work.  If edit works are not supported, this gets revised
		on every call to revise(). This may be XU_NULL if the Draft has
		never been saved. */
	XuWorkP work ();

	/* Revise the (edit) work. */		// UI
	/* Note that this assumes that newEdition has been endorsed appropriately
  	with the typeID of its Content. */
	virtual void revise (XuEditionP newEdition);

	/* Revise the save work. */			// UI          	
	/* Note that this assumes that newEdition has been endorsed appropriately
		with the typeID of its Content. */
	virtual void save (XuEditionP newEdition);

	/* Close this Draft, asking the user whether to save, if applicable. */
	/* Note that the Content must still be around in case the user has never
		saved and the Draft hasn't been tracking revisions. */
  /* windowClose is true if the Draft's Content's window is being closed. */
	// UI
	virtual XuBooleanVar close (int windowClose);

	/* Ask the user whether to save, and save if so.  Return TRUE unless the
		user cancels. */
	virtual XuBooleanVar confirmSave ();

	/* Access the Content of this Draft. */
	FEContent* content ();

	/* Set the Content of this Draft.  Do not revise the	Draft's Work
		or set the Draft of the Content. */
	void setContent (FEContent* newContent);

	/* Access the title Work of this Draft. */
	XuWorkP title ();

	/* Access the title string of this Draft.  Note this may be different
		from the title of the Draft's Content's window, if (say) the Draft
		is grabbed. */
	XuStringVar titleStr ();

	/* Set the title.  If newTitleStr is NULL, will begin a fetch of the title. */
	// UI
	void setTitle (XuWorkP newTitle, XuStringVar newTitleStr = NULL);

protected: /* instance variables */
	XuWorkP myWork;
	//	XuWorkP mySaveWork;		// not yet supported (wrong for memex demo!)
	XuRevisionHookP myReviseHook;
	FEContent* myContent;
	XuWorkP myTitleWork;
  XuStringVar myTitleStr;

public: /* grab/revise protocol */

	/* Attempt to grab this draft.  This lets people who would rather not
		type onto a moving draft try to grab in a more direct way. */	// UI
  virtual void grab ();

	/* Release this draft. amGrabbing() must be TRUE. */	// UI
  virtual void release ();

	/* TRUE if myWork is grabbed by someone. */
	XuBooleanVar isGrabbed ();

	/* TRUE if I am grabbing myWork. */
	XuBooleanVar amGrabbing ();

	/* TRUE if I am waiting for a grab of myWork. */
	XuBooleanVar amWaiting ();

	/* The ID of the current grabber (valid only if isGrabbed is TRUE). */
	XuIDP currentGrabber ();

	/* The name of the current grabber (valid only if isGrabbed is TRUE). */
	XuStringVar currentGrabberStr ();

protected: /* instance variables */
	XuStatusHookP myStatusHook;
	XuVoidP myLastReviseSuccess;
	XuBooleanVar myIsGrabbed, myAmGrabbing, myAmWaiting;
	XuIDP myGrabberID;
	XuStringVar myGrabberStr;
};

#endif DRAFT

