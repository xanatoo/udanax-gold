
#ifndef HOMEFCT
#define HOMEFCT

#include "absui.h"
#include "formct.h"

class FEManager;
class FEFormDialog;

class FEHomeFormContentType : public FEFormContentType {

public: /* create */

	FEHomeFormContentType ();

	static FEHomeFormContentType const TheOne;

protected: /* subclass should implement these constructors */

	virtual PTWindowsObject makeWindow (FEContent *);
	 
public: /* subclass should implement these to define form structure */

	virtual const XuStringVar name ();

	virtual int fieldCount ();

	virtual XuStringVar fieldKey (int field);

	virtual FieldType fieldType (int field);

	virtual char* defaultText (int field);

	virtual int defaultCheck (int field);

	virtual int selectedField (TWindowsObject *);

	virtual PTWindowsObject getControl (TWindowsObject *, int field);

	virtual int resourceID (int field);

public: /* special */

	/* bring up a window named by a ref in the home document */
	static void show (XuStringVar);

	/* set the home doc for this session
	This should never be called with two different home docs */
	static void setInstance (FEFormContent *);

private:

	/* Keeps track of the one existing home document so that we can look
	things up in it */
	static FEFormContent * TheHomeContent; 
};

#endif HomeFCT
