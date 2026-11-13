// The superclass of all Content classes.

#ifndef TEXTCT
#define TEXTCT

#include "textct.oxx"
#include "content.h"

class FEEditWindow;
class FELinkManager;

class FETextContentType : public FEContentType {

public: /* from FEContentType */
	virtual const XuStringVar name ();
	virtual FEContentP makeContent (XuEditionP edition = XU_NULL);

public:
	static FEContentTypeP TheOne;

private:
	/* Make the right kind of window, informed of its draft */
	virtual PTWindowsObject makeWindow (FEDraftP) =0;
	/* Make the right kind of sheet. */
	virtual FESheetP makeSheet(FEDraftP draft) =0;
};

class FETextContent : public FEContent {
	XU_PROLOGUE(FETextContent)

public: /* XuText protocol for Contents */

	XuIntValueP count ();
	
	FETextContentP extract (XuIntegerRegionP region);
	
	FETextContentP insert (XuIntValueP location, XuTextP text);
	
	FETextContentP move (XuIntValueP to, XuIntegerRegionP from);
	
	FETextContentP replace (XuIntegerRegionP region, XuTextP text);

public: /* instance functions */

	virtual FEContentTypeP type ();

#ifdef REF_SELECTION

	/* select the region in the Content's window, if any */ 
	virtual void selectRegion (XuRegionP region);

	/* select the reference, which eventually may be a MultiRef */
	virtual void selectReference (XuHyperRefP reference);

	/* create a reference from the current selection, using the Document's Work */
	virtual XuHyperRefP selectionReference ();

#endif // REF_SELECTION

	/* length of the Content's text */
	virtual XuIntVar length ();

private:
	friend class FETextContentType;
	FEEditWindow* myWindow;
	FELinkManager* myLinkMgr;
};

#endif TEXTCT
