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
	virtual PTWindowsObject makeWindow (FEDraftP);
	virtual FEContent* makeContent (XuEditionP, FEDraftP = NULL);
	virtual XuEditionP makeEdition ();
	virtual FEContent * emptyContent ();

public:
	static FETextContentType const TheOne;
};

class FETextContent : public FEContent {

public: /* XuText protocol for Contents */

	XuIntValueP count ();
	
	FETextContentP extract (XuIntegerRegionP region);
	
	FETextContentP insert (XuIntValueP location, XuTextP text);
	
	FETextContentP move (XuIntValueP to, XuIntegerRegionP from);
	
	FETextContentP replace (XuIntegerRegionP region, XuTextP text);


public: /* instance functions */

	virtual FEContentTypeP type ();

	/* set the edition of this Content to newEdition; update content window, if
		any, using version compare if appropriate */ 
	virtual void setEdition (XuEditionP newEdition);

	/* select the region in the Content's window, if any */ 
	virtual void selectRegion (XuRegionP region);

	/* select the reference, which eventually may be a MultiRef */
	virtual void selectReference (XuHyperRefP reference);

	/* create a reference from the current selection, using the Document's Work */
	virtual XuHyperRefP selectionReference ();

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
