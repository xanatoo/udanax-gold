 //  The manager for a list of links and its trail

#ifndef FEVARIANTS
#define FEVARIANTS

class FEVariantRecord;
class FEBrowser;
class FEEachVariant;

#ifdef NO_PROPAGATE
class FEVariantWorkHook;
#endif

/* TODO in FELinkManager and FEVariantManager: common protocol
for maintaining list pane; separate method for generating list
string from description; etc. */

class FEVariantManager : public FEBucketManager {
public:
	/* TODO: this should filter for all variants which can be browsed by this
  	frontend, not just for one wrapper type */

	static FEVariantManager* make (FEBrowser* browser, XuEditionP edition);

    /* Show the shared material in this one or go to other, respectively */
	virtual void show (int index);
	virtual void follow (int index);

	/* The descriptor of the given variant (for setting up the variantWindow) */
	virtual char* description (int index);
protected:
	friend class FEEachVariant;

	FEVariantRecord* myItems[FEBUCKETMANAGER_MAX_ITEMS];
	FEBrowser* myBrowser;

	XuEditionP myWorkTrail;
#ifdef NO_PROPAGATE
	friend class FEVariantWorkHook;
	XuFillRangeHookP myWorkHook;
#endif
	XuEditionP myTitleTrail;
  XuFillRangeHookP myTitleHook;
	XuEachHookP myEachHook;
};

#endif // FEVARIANTS

