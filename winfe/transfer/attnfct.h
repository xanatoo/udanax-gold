
#ifndef ATTNFCT
#define ATTNFCT

#include "absui.h"

class FEManager;
class FEFormDialog;

class FEAttnFormContentType : public FEFormContentType {

public: /* create */

	FEAttnFormContentType ();

	static FEAttnFormContentType const TheOne;

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

	virtual FEUI::Alignment vertical ();

	virtual FEUI::Alignment horizontal ();
};

#endif ATTNFCT
