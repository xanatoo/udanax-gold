#ifndef FETITLE
#define FETITLE

class FEBrowser;
class FETitleHook;

/* undefine this once trails propagate */
#define NO_PROPAGATE

#ifdef NO_PROPAGATE
class FETitleEditionHook;
#endif

class FETitleManager {
public:
	/* these can be called before title startup */
	static XuWorkP makeTitle (XuWorkP titledWork, XuEditionP titleEdn);
	static void reviseTitle (XuWorkP titleWork, XuEditionP titleEdn);
	static XuWorkP titledWork (XuWorkP titleWork);
	static XuEditionP titleEdition (XuWorkP titleWork);
	static XuFilterP titleFilter ();

	static void startup ();

  /* these must be called after startup */
	static void add (XuWorkP work);
	static void remove (XuWorkP work);

private:
	XuEditionP myEditionTrail;
	XuEditionP myWorkTrail;
#ifdef NO_PROPAGATE
	friend class FETitleEditionHook;
	XuFillRangeHookP myEditionHook;
#endif
	XuFillRangeHookP myHook;
};

#endif // FE_TITLE
