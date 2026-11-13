// dialog class for all forms

#ifndef FORMUI
#define FORMUI

#include "promise.hxx"

#define FE_FORMTEXTLEN 5000

class FEFormEditHook;

class FEFormEdit : public TEdit {
public:
	FEFormEdit (PTWindowsObject aParent, int resID,
			FEFormContent * content, int num)
		: TEdit (aParent, resID, FE_FORMTEXTLEN) {
		myNum = num;
		// TODO: these are gross hacks to keep us from either
		// updating fields unnecessarily or allocating every
    	// time we kill focus.
		myOldBuf = new char[FE_FORMTEXTLEN];
		myBuf = new char[FE_FORMTEXTLEN];

        myContent = content;
	}

	virtual void WMKillFocus(RTMessage Msg) = [WM_FIRST + WM_KILLFOCUS];
	virtual void WMSetFocus(RTMessage Msg) = [WM_FIRST + WM_SETFOCUS];

	// set to the contents of this edition
	void setValue (XuRangeElementP newContents);

	~FEFormEdit () { delete myBuf; delete myOldBuf; }

private:
	friend FEFormEditHook;
	int myNum;
  /* buffer used for getting text upon KillFocus */
	char* myBuf;
	/* buffer used for holding the text as of before the last KillFocus */
	/* we compare against this so we don't revise unless the contents have
		actually changed */
  char* myOldBuf;
	// The contents in the server
    FEFormContent * myContent;

protected: // accessing
	int fieldNum () { return myNum; }
	FEFormContent * content () { return myContent; }

protected: // selection

	// Update the selection to whatever I might want it to be
	virtual void updateSelection ();
};

class FEFormTextCompare : public FEFormEdit {
public:
	FEFormTextCompare (PTWindowsObject aParent, int resID,
			FEFormContent * content, int num, XuStringVar reference)
		: FEFormEdit (aParent, resID, content, num) {
		myReference = reference;
	}

private: /* variables */

	XuStringVar myReference; /* key in Edition where I can find Editio to compare with */

public: /* override from TStatic */

	virtual void WMSetText (RTMessage) = [WM_FIRST + WM_SETTEXT];

protected: // selection (from FEFormEdit)

	virtual void updateSelection ();
};

class FEFormCheckbox : public TCheckBox {
public:
	FEFormCheckbox (PTWindowsObject aParent, int resID, PTGroupBox group,
			FEFormContent * content, int num)
		: TCheckBox (aParent, resID, group) {
		myNum = num;
		myOldState = BF_UNCHECKED;
		myContent = content;
	}

	virtual void WMKillFocus(RTMessage Msg) = [WM_FIRST + WM_KILLFOCUS];

	void setValue (XuRangeElementP newContents);

private:
	int myNum;
	int myOldState;

	// The contents in the server
    FEFormContent * myContent;
};


class FERefButtonHook : public XuReadyHook {

private: /* variables */

	XuIntValueP myFlag; /* The flag that determines whether it is there */
	TButton * myButton; /* The button to be hidden if there is no ref */

public:

	FERefButtonHook (XuIntValueP flag, TButton * button);

	virtual void ready ();
};

class FEFormRefButton : public TButton {
public:
	FEFormRefButton (PTWindowsObject aParent, int resID,
			FEFormContent * content, int num)
		: TButton (aParent, resID) {
		myNum = num;
        myContent = content;
	}

	virtual void BNClicked (RTMessage Msg) = [NF_FIRST + BN_CLICKED];

private:

	// The contents in the server
    FEFormContent * myContent;

	int myNum;
};


class FEFormRefCheckbox : public TCheckBox {
public:
	FEFormRefCheckbox (PTWindowsObject aParent, int resID,
			FEFormContent * content, int num)
		: TCheckBox (aParent, resID, NULL) {
		myNum = num;
        myContent = content;
	}

	virtual void WMLButtonDown (RTMessage Msg) = [WM_FIRST + WM_LBUTTONDOWN];

private:

	// The contents in the server
    FEFormContent * myContent;

	int myNum;
};

class FEFormRefText : public TEdit {
public:
	FEFormRefText (PTWindowsObject aParent, int resID,
			FEFormContent * content, int num)
		: TEdit (aParent, resID, NULL) {
		myNum = num;
        myContent = content;
	}

	virtual void WMLButtonDown (RTMessage Msg) = [WM_FIRST + WM_LBUTTONDOWN];

private:

	// The contents in the server
    FEFormContent * myContent;

	int myNum;
};


#endif
