#ifndef FAKEBTNS
#define FAKEBTNS

#include <edit.h>
#include <checkbox.h>
// #include <groupbox.h>

// private variant of TEdit that acts like a button.
class FEButtonEdit : public TEdit {
public:
	virtual void WMLButtonDown(RTMessage Msg) = [WM_FIRST + WM_LBUTTONDOWN];
	FEButtonEdit(PTWindowsObject AParent, int AnId, LPSTR AText,
					int X, int Y, int W, int H, WORD ATextLen, BOOL Multiline,
			PTModule AModule = NULL);
	FEButtonEdit(PTWindowsObject AParent, int resourceID,
								WORD ATextLen, PTModule AModule = NULL);
protected:
	virtual void SetupWindow();
};

// variant of TCheckBox that acts like a button
class FEButtonCheckBox : public TCheckBox {
public:
	virtual void BNClicked(RTMessage Msg) = [NF_FIRST + BN_CLICKED];
	FEButtonCheckBox(PTWindowsObject AParent, int AnId, LPSTR AText,
					int X, int Y, int W, int H, PTGroupBox AGroup,
			PTModule AModule = NULL);
	FEButtonCheckBox(PTWindowsObject AParent, int resourceID,
								PTGroupBox AGroup, PTModule AModule = NULL);
};

#endif // FAKEBTNS

