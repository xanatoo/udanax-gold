#ifndef CONTENT
#define CONTENT

<<<<<<< content.h
class FEDraft;
class FEContent;

class FEContent {
	XU_PROLOGUE(FEContent)
=======
#include "content.oxx"
#include "draft.oxx"
#include "sheet.oxx"

#include "absui.h"

class FEContent : public XuCounted {
	XU_PROLOGUE(FEContent)
>>>>>>> 1.8

<<<<<<< content.h
public: /* instance functions */

	/* the object defining this type of content */
	virtual const FEContentType* type () =0;
=======
public: /* instance functions */

	/* the object defining this type of content */
	virtual const FEContentTypeP type () =0;
>>>>>>> 1.8

	/* the edition of this Content */
	XuEditionP edition ();

<<<<<<< content.h
private: /* instance variables */
=======
protected:
	FEContent(XuEditionP);

private: /* instance variables */
>>>>>>> 1.8

<<<<<<< content.h
	friend class FEContentType;
=======
	friend class FEContentType;
	XuEditionP myEdition;
>>>>>>> 1.8

};

class FEContentType {

public:  /* accessing */

	/* Some name identifying this type */
	virtual const XuStringVar name () =0;

<<<<<<< content.h
	/* The endorsement region to declare an edition to be of this type. */
	virtual XuCrossRegionP endorsements ();

public: /* creating */
=======
	/* The endorsement region to declare an edition to be of this type. */
	virtual XuCrossRegionP endorsements ();

	virtual FEUI::Alignment vertical ();
	virtual FEUI::Alignment horizontal ();

public: /* creating */
>>>>>>> 1.8

<<<<<<< content.h
	/* Make a content on the edition already of this type. */
	virtual FEContent* makeContent (XuEditionP edition = XU_NULL) =0
=======
	/* Make a content on the edition already of this type. */
	virtual FEContentP makeContent (XuEditionP edition = XU_NULL) =0;
>>>>>>> 1.8

protected:

	FEContentType ();

<<<<<<< content.h
	friend class FESheet;
	/* Make the right kind of window, informed of its draft */
	virtual PTWindowsObject makeWindow (FEDraftP) =0;
	/* Make the right kind of sheet. */
	virtual FESheetP makeSheet(FEDraftP draft) =0;
	 
public: /* content type management */

	/* Construct an edition associating ContentType names with
		 the works describing them.  Make one entry for each registered
		 ContentType. */
	static XuEditionP contentTypeEdition ();
=======
	friend class FESheet;
	friend class FEFormSheet;
	friend class FEDocumentSheet;
	/* Make the right kind of window, informed of its draft */
	virtual PTWindowsObject makeWindow (FEDraftP) =0;
	/* Make the right kind of sheet. */
	virtual FESheetP makeSheet(FEDraftP draft) =0;
	 
public: /* content type management */

	/* Construct an edition associating ContentType names with
		 the works describing them.  Make one entry for each registered
		 ContentType. */
	static XuEditionP contentTypeEdition ();
>>>>>>> 1.8

	/* Set up the associations between ContentTypes and their type IDs. */
  static void setContentTypeEdition (XuEditionP typesEdn);

private: /* variables */

	/* Create the engine structures for the document type.  The ID of
		 the returned work is the endorsementID for the ContentType.  */
	virtual XuWorkP initializeType();

	/* Connect the application ContentType with the engine endorsement. */
	virtual void registerType ();

	friend class FEContent;
	XuIDP myTypeID;        // The ID identifying this type of Edition

<<<<<<< content.h
	friend class FEContentTypeHandle;
	XuIntVar myTypeNumber; // The number for quick lookup of this type.
=======
	friend class FEContentHandle;
	XuIntVar myTypeNum; // The number for quick lookup of this type.
>>>>>>> 1.8

	XuCrossRegionP myEndorsements; /* The endorsements used to certify this type */

<<<<<<< content.h
	FEContentType * myNext; /* A linked list set up at init time */
	static FEContentType * TheFirst; /* The head of the linked list */
=======
	FEContentTypeP myNext; /* A linked list set up at init time */
	static FEContentTypeP TheFirst; /* The head of the linked list */
>>>>>>> 1.8

};

<<<<<<< content.h
/* Start getting the contentType for the supplied edition, without forcing. 
	 Force when the type or content is actually asked for. */
class FEContentHandle {
	XU_PROLOGUE(FEContent)
public:
	FEContentP fetchContent();
	FEContentType* fetchType();
	static make(XuEditionP edition);
private:
	XuIntValueP myTypeNum;
=======
/* Start getting the contentType for the supplied edition, without forcing. 
	 Force when the type or content is actually asked for. */
class FEContentHandle : public XuCounted {
	XU_PROLOGUE(FEContentHandle)
public:
	FEContentP fetchContent();
	FEContentTypeP fetchType();
	static FEContentHandleP make(XuEditionP edition);
private:
	XuIntValueP myTypeNum;
>>>>>>> 1.8
	XuEditionP myEdition;
<<<<<<< content.h
;
=======
  FEContentHandle() {};
};
>>>>>>> 1.8

#endif CONTENT

