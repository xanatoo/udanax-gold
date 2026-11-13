#ifndef FEEDIT
#define FEEDIT

#include <editwnd.h>
class FETextContent;

class FEEditWindow : public TEditWindow {
public:
	static FEEditWindow* make(PTWindowsObject aParent, LPSTR aTitle,
															FETextContent* content);

	/* for the benefit of FETextContent::close() */
	void flushChanges ();

	// creating links
	virtual void CMStartLink(RTMessage Msg) 		= [CM_FIRST + CM_STARTLINK];
	virtual void CMEndLink(RTMessage Msg) 			= [CM_FIRST + CM_ENDLINK];
	virtual void CMAttach(RTMessage Msg) 				= [CM_FIRST + CM_ATTACHMENT];

	virtual void CMGrab(RTMessage Msg) 					= [CM_FIRST + CM_GRAB];
	virtual void CMRelease(RTMessage Msg) 			= [CM_FIRST + CM_RELEASE];
	virtual void CMNewVariant(RTMessage Msg) 		= [CM_FIRST + CM_NEWVARIANT];
	virtual void CMInfo(RTMessage Msg) 					= [CM_FIRST + CM_INFO];
  /* Delete this document altogether */
	virtual void CMDelete (RTMessage) 					= [CM_FIRST + CM_DELETE];

	/* user is closing window */
	virtual void WMClose (RTMessage Msg)				= [WM_FIRST + WM_CLOSE];

	// manage the other panes
	virtual void ShowLinkWindow() 							= [CM_FIRST + CM_LINKS];
#ifdef PANES
	virtual void ShowVariantWindow()						= [CM_FIRST + CM_VARIANTS];
	virtual void ShowHistoryWindow()						= [CM_FIRST + CM_HISTORY];
#endif
protected:
	virtual void WMCtlColor(RTMessage Msg) = [WM_FIRST + WM_CTLCOLOR];
	FEEditWindow(PTWindowsObject aParent, LPSTR aTitle, FETextContent* content);
private:
	FETextContent* myContent;
};

class FEEdit : public TEdit {
public:
	FEEdit(FETextContent* content, PTWindowsObject AParent, int AnId, LPSTR AText,
					int X, int Y, int W, int H, WORD ATextLen, BOOL Multiline,
   		PTModule AModule = NULL);
	virtual void flushChanges();

  FEContent* content () { return myContent; }
protected:

	// special handlers for reporting edits properly
	virtual void WMChar(RTMessage Msg) 					= [WM_FIRST + WM_CHAR];
	virtual void WMKeydown(RTMessage Msg) 			= [WM_FIRST + WM_KEYDOWN];
	virtual void WMLButtonDown(RTMessage Msg) 	= [WM_FIRST + WM_LBUTTONDOWN];
	virtual void WMCommand(RTMessage Msg) 			= [WM_FIRST + WM_COMMAND];
	virtual void WMKillFocus(RTMessage Msg) 		= [WM_FIRST + WM_KILLFOCUS];
	virtual void CMEditCut(RTMessage Msg) 			= [CM_FIRST + CM_EDITCUT];
	virtual void CMEditCopy(RTMessage Msg) 			= [CM_FIRST + CM_EDITCOPY];
	virtual void CMEditPaste(RTMessage Msg) 		= [CM_FIRST + CM_EDITPASTE];
	virtual void CMEditDelete(RTMessage Msg) 		= [CM_FIRST + CM_EDITDELETE];
	virtual void CMEditUndo(RTMessage Msg) 			= [CM_FIRST + CM_EDITUNDO];
	virtual void CMInsertFile(RTMessage Mgs) 		= [CM_FIRST + CM_INSERTFILE];
	virtual void CMCopyToFile(RTMessage Mgs) 		= [CM_FIRST + CM_COPYTOFILE];
	virtual void SetupWindow();
	int prepareEdit();
	void deleteRange(int start, int stop);
	void reportDelete(int start, int stop);
	void reportInsert(int start, int stop);

private:
	~FEEdit();
	FETextContent* myContent;
	int myStart;
};
#endif // FEEDIT
