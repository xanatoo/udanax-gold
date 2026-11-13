/* The class for handling top-level windows in a particular windowing
   system. */

#ifndef SHEET
#define SHEET

class FESheet {
 public: /* creation */
	/* Fetch any existing Sheet on this Work.  If there is no existing Sheet
		(i.e. the user is not currently viewing this Work), create a new Sheet on the
		Work, and a new Content for that Sheet, on the Work's edition.  If docClass
		and contClass are not NULL, then use them as the classes of the new Sheet and
		new Content; otherwise examine the endorsements on the Edition to determine what
		class of Sheet and Content to create.  Return NULL if the Work is unreadable
		or if the document type cannot be determined. */
	static FESheet* sheetOn (FEDraft* draft);

	/* Get a Sheet on the supplied work, and display it. */
	static showWork (XuWork work);

	/* Get a Sheet on the work that this ref is onto, display it, 
		 and highlight (if possible) the particular contents fo the ref. */
	static showRef (XuHyperRefP ref);

	/* flush outstanding changes */
	void flush ();

	/* show the Content window */
	virtual void show () =0;
	/* hide the Content window */
	virtual void hide () =0;

#ifdef 0
	/* select the region in the Content's window, if any */		
	virtual void selectRegion (XuRegionP region) =0;

	/* select the reference, which eventually may be a MultiRef */ 
	virtual void selectReference (XuHyperRefP reference) =0;

	/* create a reference from the current selection, using the Draft's Work */
	virtual XuHyperRefP selectionReference () =0;
#endif
};

class FEFormSheet : public FESheet {

	/* flush outstanding changes */
	void flush ();

	/* show the Content window */
	virtual void show () =0;
	/* hide the Content window */
	virtual void hide () =0;

private: 
	
	friend class FEFormContent;
	FEFormSheet(FEDraftP draft);
	
	~FEFormSheet();

	PTWindowsObject myWindow;
	
};

#ifdef 0
class FEDocumentSheet {

public: /* inherited */

	/* flush outstanding changes */
	void flush ();

	/* show the Content window */
	virtual void show () =0;
	/* hide the Content window */
	virtual void hide () =0;

public: 

	/* The link manager for this Content */
	virtual FELinkManager* linkManager ();

	/* Access the title Work of this Sheet. */
	XuWorkP title ();

	/* Access the title string of this Sheet.  Note this may be different
		from the window title, if (say) the Sheet's Draft is grabbed. */
	XuStringVar titleStr ();

 private:
	/* set the sheet's title */
	virtual void setTitle (XuStringVar newTitle);

	/* Set the title.  If newTitleStr is NULL, will begin a fetch of the title. */
	void setTitle (XuWorkP newTitle, XuStringVar newTitleStr = NULL);

};
#endif

#endif SHEET

