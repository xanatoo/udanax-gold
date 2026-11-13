// The superclass of all Content classes.

#ifndef CONTENT
#define CONTENT
#include "xanadu.oxx"
#include "absui.h"

class FEDraft;

class FEContent;

class FEContentType {

public: /* creation */

	/* make a XuEditionP initialized as this type of content */
	virtual XuEditionP makeEdition () =0;

	/* set the type ID we use; this should actually only be called from initialization */
	virtual void setTypeID (XuIDP);

	virtual XuCrossRegionP endorsements ();

public: /* accessing */

	/* Some name identifying this type */
	virtual const XuStringVar name () =0;

	/* For iterating over all types */
  static FEContentType* fetchFirst (); // first type, or NULL if none 
	FEContentType* fetchNext (); // next type, or NULL if last


protected: /* setup */

	FEContentType ();

	/* Make a new content object of this type */
  /* Virtual so subclasses can add behaviour */
	virtual FEContent * emptyContent () =0;

protected: /* subclass should implement these constructors */

	friend class FEContent;

	/* A window of the right kind, which has been informed of its content object */
	virtual PTWindowsObject makeWindow (FEContent *) =0;
	 
	/* Where to place the window when it first comes up */
	virtual FEUI::Alignment vertical () { return FEUI::Default; }
	virtual FEUI::Alignment horizontal () { return FEUI::Default; }

private: /* variables */

	XuIDP myTypeID; /* The ID identifying this type of Edition */

	XuCrossRegionP myEndorsements; /* The endorsements used to certify this type */

	FEContentType * myNext; /* A linked list set up at init time */

	static FEContentType * TheFirst; /* The head of the linked list */

public: /* creating */

	/* Make a content and open a window on it */
	virtual FEContent* makeContent (XuEditionP, FEDraft* = NULL);
};

class FEContent {

public: /* instance functions */

	/* the object defining this type of content */
	virtual const FEContentType* type () =0;

	/* the edition of this Content */
	XuEditionP edition ();

	/* set the edition of this Content to newEdition; update content window, if
		any, using version compare if appropriate */		// UI
	virtual void setEdition (XuEditionP newEdition) =0;

	/* select the region in the Content's window, if any */		// UI
	virtual void selectRegion (XuRegionP region) =0;

	/* select the reference, which eventually may be a MultiRef */		// UI
	virtual void selectReference (XuHyperRefP reference) =0;

	/* create a reference from the current selection, using the Draft's Work */
  // UI
	virtual XuHyperRefP selectionReference () =0;

	// TODO: move these next three, _soon_, if this is not the right place for them */
	/* show the Content window */
	virtual void showWindow () =0;
	/* hide the Content window */
	virtual void hideWindow () =0;
	/* set the Content window's title */
	virtual void setTitle (XuStringVar newTitle) =0;

	/* the Draft of this Content, if any */
	FEDraft* draft ();

	/* set the Draft of this Content; do not revise the Draft's Work, or
		set the Content of the Draft */
	void setDraft (FEDraft* draft);

	/* flush all outstanding changes */
	virtual void flush () =0;

	/* close all windows--it's assumed all changes have already been flushed */
	virtual void close (int windowClose) =0;

	/* revise the Edition to newEdition */
	virtual void revise (XuEditionP newEdition);

protected: /* instance variables */

	friend class FEContentType;

	XuEditionP myEdition;
	FEDraft* myDraft;

	TWindowsObject * myWindow;	/* The window or dialog I am attached to */

};

#endif CONTENT

