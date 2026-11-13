#ifndef FORMCT
#define FORMCT
<<<<<<< formct.h

#include "content.h"
#include "formct.oxx"
#include "draft.oxx"
=======

#include "formct.oxx"
#include "draft.oxx"
>>>>>>> 1.7

<<<<<<< formct.h
class FEFormContentType;
=======
#include "content.h"
<<<<<<< formct.h
>>>>>>> 1.7
=======

class FEString : public XuCounted {
	XU_PROLOGUE(FEString)

public:
	/* make a string with the provided char* (copy it) */
	static FEStringP make (XuStringVar string) {
		return new FEString(string);
	}

	/* access */
	XuStringVar string () {
		return (XuStringVar)myString;
	}

	/* equality */
	int isEqual (FEStringP other) {
		return this->isEqual(other->myString);
	}
	int isEqual (XuStringVar str) {
		return !strcmp(myString, str);
  }

private:
	FEString (XuStringVar string) {
  	if (string != NULL) {
			myString = new char[strlen(string)+1];
			strcpy(myString, string);
		} else {
			myString = NULL;
    }
	}

	~FEString () {
  	if (myString) {
			delete[] myString;
    }
	}

	char* myString;
};


class FEStringArray XU_ROOTCLASS {
public:
	FEStringArray (int size) {
		mySize = size;
		myBuf = new FEStringP[size];
	}

	FEStringArray* copy () {
		FEStringArray* ret = new FEStringArray(mySize);
		// this is where counted pointers win... we don't need to
    // worry about deleting or reclaiming any of the string values here.
		for (int i = 0; i < mySize; i++) {
			ret->myBuf[i] = myBuf[i];
		}
		return ret;
	}

	~FEStringArray () {
		delete[] myBuf;
	}

	void store (int i, FEStringP str) {
		myBuf[i] = str;
	}

	XuStringVar fetchString (int i) {
		return myBuf[i]->string();
	}

	FEStringP fetch (int i) {
		return myBuf[i];
  }

private:
	FEStringP* myBuf;
  int mySize;
};


class FEStringAssoc XU_ROOTCLASS {
public:
	FEStringAssoc (int size) {
		myKeys = new FEStringArray(size);
		myValues = new FEStringArray(size);
    mySize = size;
	}

	~FEStringAssoc () {
		delete myKeys;
		delete myValues;
  }

	FEStringAssoc* copy () {
		FEStringAssoc* ret = new FEStringAssoc(0);
		delete ret->myKeys; delete ret->myValues;
		ret->myKeys = myKeys->copy();
		ret->myValues = myValues->copy();
    ret->mySize = mySize;
		return ret;
	}

	XuStringVar fetch (XuStringVar key) {
		for (int i = 0; i < mySize; i++) {
			FEStringP str = myKeys->fetch(i);
			if (str != XU_NULL && str->isEqual(key)) {
				if (myValues->fetch(i) == XU_NULL) {
					return NULL;
				} else {
					return myValues->fetch(i)->string();
				}
			}
		}
		return NULL;
  }

	void store (XuStringVar key, XuStringVar value) {
  	int stored = 0;
		for (int i = 0; i < mySize; i++) {
			FEStringP str = myKeys->fetch(i);
			if (str != XU_NULL && str->isEqual(key)) {
				myValues->store(i, FEString::make(value));
        stored = 1;
				break;
			}
		}
		if (!stored) {
			for (int i = 0; i < mySize; i++) {
				if (myKeys->fetch(i) == XU_NULL) {
					myKeys->store(i, FEString::make(key));
					myValues->store(i, FEString::make(value));
					break;
				}
			}
		}
	}
>>>>>>> 1.8

private:
	FEStringArray* myKeys;
	FEStringArray* myValues;
	int mySize;
};


class FEFormContent : public FEContent {
	XU_PROLOGUE(FEFormContent)

public: /* form-specific accessing */

	/* replace the rangeElement at the supplied key */
	virtual FEFormContentP with (XuStringVar key, XuRangeElementP value);

	/* replace the string at the supplied key; cache if implemented */
	virtual FEFormContentP with (XuStringVar key, XuStringVar value);

	/* follow a reference */
	virtual void followFieldRef (XuStringVar key);

	/* return the string if it's cached */
	// TODO: make this interact sensibly with hooks
	XuStringVar fetchString (XuStringVar key);

	/* update the cache with this string just retrieved */
	// TODO: this is utterly bogus; all the getText stuff should go HERE
	void updateCache (XuStringVar key, XuStringVar value);

public: /* type */

	virtual const FEContentTypeP type ();
	// for convenience, we also have...
	const FEFormContentTypeP formType ();

<<<<<<< formct.h
private:
=======
protected:
	// Make a new FormContent with the provided caches
	FEFormContent (XuEditionP edition, FEFormContentTypeP, FEStringAssoc* = NULL);

	FEStringAssoc* cache () { return myCache; }

	~FEFormContent () {
		delete myCache;
  }

private:
>>>>>>> 1.7

	/* The object defining what kind of form I am */
	FEFormContentTypeP myType;

<<<<<<< formct.h
	friend class FEFormContentType;
	FEFormContent (XuEditionP edition, FEFormContentTypeP);
};
=======
	friend class FEFormContentType;

/* TODO: remodularize this sensibly */
// caching functionality
private:

	static const int numFormFields;

  // this is neither sufficiently general nor sufficiently modular
	FEStringAssoc* myCache;
};
<<<<<<< formct.h
>>>>>>> 1.7
=======

>>>>>>> 1.8

class FEFormContentType : public FEContentType {

public: /* creation */

	virtual FEContentP makeContent (XuEditionP edition = XU_NULL);

protected: /* subclass should implement these constructors */

	/* A window of the right kind, which has been informed of its content object */
	friend class FEFormContent;
	virtual PTWindowsObject makeWindow (FEDraftP) =0;
	virtual FESheetP makeSheet (FEDraftP draft);

	FEFormContentType() {}

};

#endif FORMCT


