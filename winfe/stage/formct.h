
#ifndef FORMCT
#define FORMCT
#include "content.h"

class FEFormContentType;

class FEFormContent : public FEContent {

public:

	virtual void endorse (XuEditionP edition);

public: /* form-specific accessing */

	/* the control with the specified number was changed.  Revise. */
	virtual void fieldChanged (int fieldNum, XuRangeElementP value);

	/* set the contents of the given control (don't change the edition). */
	virtual void setField (int, XuRangeElementP);
	virtual void setTextField (int, XuStringVar);
	virtual void setCheckboxField (int, int);

	/* follow a reference */
	virtual void followFieldRef (int field);

public: /* type */

	virtual const FEContentType * type ();
	// for convenience, we also have...
	const FEFormContentType* formType ()
  	{ return (FEFormContentType*) this->type (); }

protected:

		/* The object defining what kind of form I am */
	FEFormContentType * myType;

private: /* constructors */

	friend class FEFormContentType;

    FEFormContent (FEFormContentType *);
};

class FEFormContentType : public FEContentType {

public: /* creation */

	virtual FEContent * emptyContent ();

	virtual XuEditionP makeEdition ();

	FEFormContentType () : FEContentType () {}

protected: /* subclass should implement these constructors */

	friend class FEFormContent;

	/* A window of the right kind, which has been informed of its content object */
	virtual PTWindowsObject makeWindow (FEContent *) =0;
	 
public: /* subclass should implement these to define form structure */

	/* the number of fields */
	virtual int fieldCount () =0;

	/* the key associated with the specified field */
	virtual XuStringVar fieldKey (int field) =0;

	/* the types of fields */
	enum FieldType { Text, Checkbox, Reference };

	/* the type of the specified field */
	virtual FieldType fieldType (int field) =0;

	/* the currently selected field, or -1 if there is none  */
	virtual int selectedField (TWindowsObject *) =0;

	/* get the control for the specified field */
	virtual PTWindowsObject getControl (TWindowsObject *, int field) =0;

	/* the resource ID of the numbered field */
	virtual int resourceID (int field) =0;

public: /* accessing */

	/* the index associated with the named field */
	virtual int fieldIndex (XuStringVar);
};

#endif FORMCT
