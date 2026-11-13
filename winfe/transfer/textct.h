// The superclass of all Content classes.

#ifndef TEXTCT
#define TEXTCT

class FEManager;
class FEEditWindow;
class FELinkManager;

class FETextContentType : public FEContentType {

public: /* creation */
	static XuEditionP makeEdition (XuStringVar str);

public: /* from FEContentType */
	virtual const XuStringVar name ();
	virtual PTWindowsObject makeWindow (FEContent *);
	virtual FEContent* makeContent (XuEditionP, FEDraft* = NULL);
	virtual XuEditionP makeEdition ();
	virtual FEContent * emptyContent ();

public:
	static FETextContentType const TheOne;
};

class FETextContent : public FEContent {

public: /* instance functions */

	virtual const FEContentType* type ();

	/* set the edition of this Content to newEdition; update content window, if
		any, using version compare if appropriate */		// UI
	virtual void setEdition (XuEditionP newEdition);

	/* select the region in the Content's window, if any */		// UI
	virtual void selectRegion (XuRegionP region);

	/* select the reference, which eventually may be a MultiRef */		// UI
	virtual void selectReference (XuHyperRefP reference);

	/* create a reference from the current selection, using the Document's Work */
  // UI
	virtual XuHyperRefP selectionReference ();

	// TODO: move these next three, _soon_, if this is not the right place for them */
	/* show the Content window */
	virtual void showWindow ();
	/* hide the Content window */
	virtual void hideWindow ();
	/* set the Content window's title */
	virtual void setTitle (XuStringVar newTitle);

	/* flush changes to this FEContent */
	virtual void flush ();

	/* Close this FEContent */
	virtual void close (int windowClose);

	/* The link manager for this Content */
	virtual FELinkManager* linkManager ();

	/* length of the Content's text */
	virtual XuIntVar length ();

	/* insert string at pos, in Edition only */
	virtual void insertString (XuIntVar pos, XuStringVar string);

	/* delete len chars at pos, in Edition only */
	virtual void deleteString (XuIntVar pos, XuIntVar len);

	/* insert text at pos, in Edition only */
	virtual void insertText (XuIntVar pos, XuTextP text);	

	/* revise my Document to myEdition, after endorsing it with my type ID */
	virtual void revise (XuEditionP newEdition);

private:
	friend class FETextContentType;
	FEEditWindow* myWindow;
	static FETextContent* theStaticCont;
	FELinkManager* myLinkMgr;
};

#endif TEXTCT
