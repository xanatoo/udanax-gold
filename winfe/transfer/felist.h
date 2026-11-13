// The list views for the frontend.  All of them have almost everything in
// common, so they are all placed here.  The modularity of this system is
// something we will need to reexamine once we reach Stage 1.

#ifndef FELIST
#define FELIST

#include "fe.h"
#include <listbox.h>

class FEBrowser;
class FEBucketManager;

typedef enum E_FEWinType { LinkWin, VariantWin, HistoryWin } FEWinType;

class FEListWindow : public TWindow {
public:
	static FEListWindow* make (PTWindowsObject aParent, LPSTR aTitle,
		FEBucketManager* bucketMgr, FEWinType type);

	/* This method may not be strictly necessary.  It's so the BucketMgr
	can update the ListWindow. */
	int addString (LPSTR string);

	/* And these, likewise. */
	void replaceString (int index, char* newString);
	void deleteString (int index);

protected:
	FEListWindow(PTWindowsObject aParent, LPSTR ATitle,
		FEBucketManager* bucketMgr, FEWinType type);
	virtual void SetupWindow();
	virtual void CMInfo(RTMessage Msg) = [CM_FIRST + CM_INFO];
	virtual void CMDelete(RTMessage Msg) = [CM_FIRST + CM_DELETE];
	virtual void WMMDIActivate(RTMessage Msg) = [WM_FIRST + WM_MDIACTIVATE];
	virtual void HandleListBoxMsg(RTMessage Msg) = [ID_FIRST + ID_LISTBOX];
	virtual void WMSetFocus(RTMessage Msg) = [WM_FIRST + WM_SETFOCUS];
	virtual void WMSize(RTMessage Msg) = [WM_FIRST + WM_SIZE];
	virtual void WMCtlColor(RTMessage Msg) = [WM_FIRST + WM_CTLCOLOR];
	virtual void WMClose(RTMessage Msg) = [WM_FIRST + WM_CLOSE];
	PTListBox ListBox;
	FEBucketManager* myBucketMgr;
	FEWinType myType;
};

#endif // FELIST
