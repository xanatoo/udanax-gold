// dialog class for all forms

#ifndef FORMUI
#define FORMUI

#include "promise.hxx"
#include "draft.oxx"
#include <edit.h>
#include <checkbox.h>

<<<<<<< formui.h
=======
#define WU_SELECTREF WM_USER + 0xabc
#define WU_REFRESH WM_USER + 0xabd

>>>>>>> 1.10
class FEFormEditHook;

class FEFormEdit : public TEdit {
public:
	FEFormEdit (PTWindowsObject aParent, int resID,
			FEDraftP draft, XuStringVar key);

	virtual void SetupWindow ();

	virtual void WMKillFocus(RTMessage Msg) = [WM_FIRST + WM_KILLFOCUS];
	virtual void WMSetFocus(RTMessage Msg) = [WM_FIRST + WM_SETFOCUS];

	/* set the control based on the server contents */
	void resetValue ();

	/* intercept the user messages for selecting myself and refreshing myself */
	virtual void WUSelectRef (RTMessage msg) = [WM_FIRST + WU_SELECTREF];
  virtual void WURefresh (RTMessage msg) = [WM_FIRST + WU_REFRESH];

	~FEFormEdit () { delete myBuf; delete myOldBuf; }

protected:
  /* buffer used for getting text upon KillFocus */
	char* myBuf;
	/* buffer used for holding the text as of before the last KillFocus */
	/* we compare against this so we don't revise unless the contents have
		actually changed */
	friend class FEFormEditHook;
  char* myOldBuf;

	XuStringVar myKey;
	FEDraftP myDraft;

protected: // selection

	/* Update the selection to whatever I might want it to be */
	virtual void updateSelection ();
};

class FEFormTextCompare : public FEFormEdit {
public:
	FEFormTextCompare (PTWindowsObject aParent, int resID,
			FEDraftP draft, XuStringVar key, XuStringVar reference);

private: /* variables */

	XuStringVar myReference; /* key in Edition where I can find Edition to compare with */

public: /* override from TStatic */

//	virtual void WMSetText (RTMessage) = [WM_FIRST + WM_SETTEXT];

protected: // selection (from FEFormEdit)

	virtual void updateSelection ();
};

class FEFormCheckbox : public TCheckBox {
public:
	FEFormCheckbox (PTWindowsObject aParent, int resID, PTGroupBox group,
			FEDraftP draft, XuStringVar key);

	virtual void SetupWindow ();

	virtual void WMKillFocus(RTMessage Msg) = [WM_FIRST + WM_KILLFOCUS];

	/* set the control based on the server contents */
	void resetValue ();

	/* intercept the user messages for selecting myself and refreshing myself */
	virtual void WURefresh (RTMessage msg) = [WM_FIRST + WU_REFRESH];
// we can't select checkboxes meaningfully yet
//	virtual void WUSelectRef (RTMessage msg) = [WM_FIRST + WU_SELECTREF];

private:
	XuStringVar myKey;
	int myOldState;

	FEDraftP myDraft;
};


class FERefButtonHook : public XuReadyHook {
	XuIntValueP myFlag; /* The flag that determines whether it is there */
	TButton * myButton; /* The button to be hidden if there is no ref */

public:

	FERefButtonHook (XuIntValueP flag, TButton * button);

	virtual void ready ();
};

class FEFormRefButton : public TButton {
public:
	FEFormRefButton (PTWindowsObject aParent, int resID, 
									 FEDraftP draft, XuStringVar key);

	virtual void BNClicked (RTMessage Msg) = [NF_FIRST + BN_CLICKED];

private:

	FEDraftP myDraft;
	XuStringVar myKey;
};


class FEFormRateRefButton : public TButton {
public:
	FEFormRateRefButton (PTWindowsObject aParent, int resID, 
									 FEDraftP draft, XuStringVar key);

	virtual void BNClicked (RTMessage Msg) = [NF_FIRST + BN_CLICKED];

private:

	FEDraftP myDraft;
	XuStringVar myKey;
};


class FEFormRefCheckbox : public TCheckBox {
public:
	FEFormRefCheckbox (PTWindowsObject aParent, int resID,
			FEDraftP draft, XuStringVar key);

	virtual void WMLButtonDown (RTMessage Msg) = [WM_FIRST + WM_LBUTTONDOWN];

private:

	FEDraftP myDraft;
	XuStringVar myKey;
};

class FEFormRefText : public TEdit {
public:
	FEFormRefText (PTWindowsObject aParent, int resID,
			FEDraftP draft, XuStringVar myKey);

	virtual void WMLButtonDown (RTMessage Msg) = [WM_FIRST + WM_LBUTTONDOWN];

private:

	FEDraftP myDraft;
	XuStringVar myKey;
};


class FEFormRefEdit : public FEFormEdit {
public:
	FEFormRefEdit (PTWindowsObject aParent, int resID,
			FEDraftP draft, XuStringVar key, XuStringVar refKey);

  // user clicked; follow the ref
	virtual void WMLButtonDown (RTMessage Msg) = [WM_FIRST + WM_LBUTTONDOWN];

	virtual void WMSetFocus(RTMessage Msg) = [WM_FIRST + WM_SETFOCUS];

	~FEFormRefEdit () { delete myBuf; delete myOldBuf; }

protected:
  // inherits all of FEFormEdit's instvars
	
	XuStringVar myRefKey;
	FEDraftP myDraft;
};
#endif
