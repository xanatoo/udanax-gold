 //  The manager for a list of links and its trail

#ifndef FELINKS
#define FELINKS

class FEContent;
class FELinkRecord;
class FEListWindow;
class FEEachLink;

#include "bucket.h"
#include "content.oxx"
#include "draft.oxx"

#ifdef NO_PROPAGATE
class FELinkEditionHook;
#endif


class FELinkManager : public FEBucketManager {
public:
	static FELinkManager* make
		(FEContent* content, XuEditionP edition, XuIDRegionP linkTypeIDs);

	FEContent* content ();

  /* Show what's at this end or what's at the other end, respectively */
	virtual void show (int index);
	virtual void follow (int index);

  /* Delete the link at index */
	virtual int deleteItem (int index);

	/* Get info on the link at index */
	virtual void info (int index);

	/* Get the number of links */
  virtual int count ();

	/* The descriptor of the given link (for setting up the linkWindow) */
	virtual char* description (int index);

	/* The work at the given index */
	virtual XuWorkP work (int index);

	/* Set the descriptor to be something else */
	virtual void setDescription (int index, char* newDesc);

	/* The window of this link manager (NULL if none) */
  virtual FEListWindow* window ();

	/* Show the link window (creating it if it's not up at present) */
	virtual void showWindow ();

	/* Close the link window */
	virtual void closeWindow ();

	/* Start a link. */
	static void startLink (XuHyperRefP linkEnd);

	/* End a link.  Put up link creation dialog if applicable. */
	static void endLink (XuHyperRefP linkEnd);

	/* Attach the link to a new document. */
	static void attachLink (XuHyperRefP linkEnd);

protected:
	friend class FEEachLink;

	FELinkRecord* myItems[FEBUCKETMANAGER_MAX_ITEMS];
	FEContentP myContent;

	XuEditionP myEditionTrail;
#ifdef NO_PROPAGATE
	friend class FELinkEditionHook;
	XuFillRangeHookP myEditionHook;
#endif
	XuEditionP myWorkTrail;
	XuFillRangeHookP myWorkHook;
	XuEachHookP myEachHook;

  FEListWindow* myWindow;
};

#endif // FELINKS

