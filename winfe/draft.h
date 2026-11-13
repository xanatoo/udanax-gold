// The superclass of all Drafts.  Specific subclasses handle particular
// revise policies (for example, simple drafts versus buckets).

#ifndef DRAFT
#define DRAFT

#include "draft.oxx"
#include "content.oxx"
#include "sheet.oxx"

<<<<<<< draft.h
class FEDraftP {
=======
class FEDraft : public XuCounted {
	XU_PROLOGUE(FEDraft)
>>>>>>> 1.4
public: /* creation */
	
	/* Return a draft on the supplied work.  If one already existed, use
		 it.  Otherwise extract the edition, get its contentType, make an
		 appropriate contentType, and create a draft on that. */
	// TODO: Temporarily, if a Content is supplied, use it as the Draft's
	// Content.  This may or may not be keepable; currently it's just for
  // the II demo.
	static FEDraftP fetchDraft (XuWorkP work, FEContentP content = XU_NULL);

	/* Create a new Work on the Edition of the provided Content, make a new Draft
		on the new Work, and return the new Draft.  This is used by the new-variant
		code. */
	static FEDraftP makeNewDraft (FEContentP content);

<<<<<<< draft.h
public: /* accessing */
=======
	/* Close all existing drafts. */
	static void closeAll ();

public: /* accessing */
>>>>>>> 1.4

	/* Access the Content of this Draft. */
	FEContentP content ();

<<<<<<< draft.h
public: /* grab/revise protocol */
=======
	/* Access the Work under this Draft. */
	XuWorkP work ();

	/* Access the Work under this Draft. */
	XuWorkP editWork ();

public: /* grab/revise protocol */
>>>>>>> 1.4

	/* Attempt to grab this draft. */
  virtual void grab ();

	/* revise the virtual Work that this is a Draft on. */
	virtual void revise (FEContentP content);

	/* Release this draft. */ 
  virtual void release ();

<<<<<<< draft.h
	/* TRUE if this draft has a grab on its virtual work. */
	virtual XuBooleanVar canRevise ();
=======
	/* TRUE if this draft has a grab on its virtual work. */
	virtual XuBooleanValueP canRevise ();
>>>>>>> 1.4

public: /* compare and swap protocol */

 	/* Compare and swap the current contents without keeping a grab on the Draft. */
	virtual XuBooleanValueP replace (FEContentP oldContent, FEContentP newContent);

<<<<<<< draft.h
protected:
	
	FEDraft();
=======
protected:
	
	FEDraft(XuWorkP work, FEContentP content, XuIntVar draftNum);
  ~FEDraft();
>>>>>>> 1.4

private: 

<<<<<<< draft.h
	/* initialize draft to work mapping structures. */
	friend class FEStartupManager;
	void startup();

	XuWorkP myWork;
	FEContentP myContent;
	XuVoidP myLastReviseSuccess;
	XuBooleanVar amGrabbing;
=======
	XuWorkP myWork;
	FEContentP myContent;
	XuVoidP myLastReviseSuccess;
	XuBooleanVar amGrabbing;
>>>>>>> 1.4

<<<<<<< draft.h
	/* private hack instance variable to map from drafts to sheets
		 this variable is only accessed by sheets, and may be NULL. */
	friend class FESheet;
	FESheetP mySheet;
=======
	/* private hack instance variable to map from drafts to sheets
		 this variable is only accessed by sheets, and may be NULL. */
	friend class FESheet;
	FESheetP mySheet;

	/* private hack method to return the draft of this sheet.
		 if the mySheet way of pairing sheets with drafts goes away,
		 this will too. */
	static FEDraftP draftFor (FESheetP sheet);

public:
	/* initialize draft to work mapping structures. */
	static void startup();
>>>>>>> 1.4

};

#endif DRAFT

