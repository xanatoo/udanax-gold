#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

// Support for the clipboard

#include "clip.h"
#include "xmdi.h"
#include "felist.h"
#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "xstuff.hxx"
#include <strstream.h>

static UINT theCFXuText;
static XuSingleRefP theClip;
static HWND theWindow;

void FEClipManager::
startup () {
	theClip = XU_NULL;
  theCFXuText = RegisterClipboardFormat("XuText");
  theWindow = TheApp->MainWindow->HWindow;
}
	
XuSingleRefP FEClipManager::
clipboard () {
	return theClip;
}

void FEClipManager::
copy (XuSingleRefP newClip) {
	theClip = newClip;
  OpenClipboard(theWindow);
  EmptyClipboard();
  SetClipboardData(CF_TEXT, NULL);
  SetClipboardData(theCFXuText, NULL);
	CloseClipboard();
}

/* HACK to set the buffer size to hold an exported streamed ID */
#define FE_MYIDSIZE 300
/* HACK for how much text to stuff on the clipboard */
#define FE_MYTEXTSIZE 1000

void FEClipManager::
renderFormat (UINT format) {
	if (format == theCFXuText) {
    XuBind (XuInitialReadClub, XuServer::publicClubID()) {
    	/* TODO: This may not be able to afford to make a Work.  Works seem
      	to be very expensive.  One per render is a lot. */
    	XuWorkP newClipWork = XuWork::make(theClip->edition());
      XuIDP newClipID = XuServer::assignID(newClipWork);
      char buf[FE_MYIDSIZE];
			ostrstream oo(buf, FE_MYIDSIZE);
			FEStuff::exportToStream(newClipID->export(), oo);
			HANDLE hGlobalMem = GlobalAlloc(GHND, FE_MYIDSIZE);
			LPSTR lpGlobalMem = (LPSTR)GlobalLock(hGlobalMem);
      memcpy(lpGlobalMem, buf, FE_MYIDSIZE);
			GlobalUnlock(hGlobalMem);

			SetClipboardData(theCFXuText, hGlobalMem);
		  CloseClipboard();
    } XuEndBind
  } else if (format == CF_TEXT) {
  	/* TODO: is theClip->excerpt() guaranteed the right thing here? */
		char* buf = (char*)FEStuff::excerpt
			(theClip, theClip->originalContext()->edition(), FE_MYTEXTSIZE-1);
		HANDLE hGlobalMem = GlobalAlloc(GHND, FE_MYTEXTSIZE);
		LPSTR lpGlobalMem = (LPSTR)GlobalLock(hGlobalMem);
    memcpy(lpGlobalMem, buf, FE_MYTEXTSIZE);
		GlobalUnlock(hGlobalMem);

		SetClipboardData(CF_TEXT, hGlobalMem);
	}
}

/* Render all formats. */
void FEClipManager::
renderAllFormats () {
	OpenClipboard(theWindow);
	EmptyClipboard();
  FEClipManager::renderFormat(CF_TEXT);
  FEClipManager::renderFormat(theCFXuText);
  CloseClipboard();
}

/* Return a XuSingleRef of the clipboard fetched from Windows. */
void FEClipManager::
paste () {
	OpenClipboard(theWindow);
	HANDLE hClipMem = GetClipboardData(theCFXuText);
  LPSTR lpClipMem;
  if (hClipMem != NULL) {
  	lpClipMem = GlobalLock(hClipMem);
  	char buf[FE_MYIDSIZE];
    memcpy(buf, lpClipMem, FE_MYIDSIZE);
    GlobalUnlock(hClipMem);
    CloseClipboard();

    istrstream ii(buf, FE_MYIDSIZE);
    XuIntArrayP iDArray = FEStuff::importFromStream(ii);
		XuIDP iD = XuID::import(iDArray);
		XuWorkP work = XuWork::cast(XuServer::get(iD));
		theClip = XuSingleRef::wrap(work->edition());
  } else if ((hClipMem = GetClipboardData(CF_TEXT)) != NULL) {
  	lpClipMem = GlobalLock(hClipMem);
  	char buf[FE_MYTEXTSIZE];
    memcpy(buf, lpClipMem, FE_MYTEXTSIZE);
    GlobalUnlock(hClipMem);
    CloseClipboard();

    /* TODO: Check whether a null workContext will break anything. */
    XuEditionP edn = XuText::make(buf)->edition();
    theClip = FEStuff::makeSingleRef(XU_NULL, edn, XU_NULL);
  } else {
  	CloseClipboard();
  }
}

int FEClipManager::
canPaste () {
	return IsClipboardFormatAvailable(CF_TEXT)
		|| IsClipboardFormatAvailable(theCFXuText);
}

