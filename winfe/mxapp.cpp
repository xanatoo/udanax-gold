#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "formct.h"
#include "xmdi.h"
#include "absui.h"
#include "pcaidcls.h"
#include "startup.h"
#include "draft.h"

/* Keeps track of the one existing home document so that we can look
	 things up in it */
static FEFormDraftP TheHomeDraft;

void FEApplication::
show (XuStringVar name) {
	if (TheHomeDraft == XU_NULL) {
		XuWorkP loginHomeDoc = FEStartupManager::fetchAppHome();
		if ( loginHomeDoc != XU_NULL ) {
			TheHomeDraft = FEDraft::fetchDraft(loginHomeDoc);
		}
	}
	if (TheHomeDraft != XU_NULL) {
		((FEFormContent*)TheHomeDraft->content())->followFieldRef(name);
	}
}


/*********** Akord Form Type ************/
class FEAkordFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "Akord"; }
	virtual FEUI::Alignment vertical () { return FEUI::Max; }
	virtual FEUI::Alignment horizontal () { return FEUI::Min; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVAKORDDlg(TheApp->MainWindow, "AKORD");
		((PVAKORDDlg *) result)->setDraft(draft);
    return result;
	}
};

static FEAkordFormContentType const akordTypeObject;
FEFormContentTypeP FEApplication::AkordFormType = &akordTypeObject;

/*********** Attn Form Type ************/
class FEAttnFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "Attn"; }
	virtual FEUI::Alignment vertical () { return FEUI::Min; }
	virtual FEUI::Alignment horizontal () { return FEUI::Min; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVATTNDlg(TheApp->MainWindow, "ATTN");
		((PVATTNDlg *) result)->setDraft(draft);
    return result;
	}
};

static FEAttnFormContentType const attnTypeObject;
FEFormContentTypeP FEApplication::AttnFormType = &attnTypeObject;

/*********** CProf Form Type ************/
class FECProfFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "CProf"; }
	virtual FEUI::Alignment vertical () { return FEUI::Max; }
	virtual FEUI::Alignment horizontal () { return FEUI::Max; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVCPROFDlg(TheApp->MainWindow, "CPROF");
		((PVCPROFDlg *) result)->setDraft(draft);
    return result;
	}
};

static FECProfFormContentType const cprofTypeObject;
FEFormContentTypeP FEApplication::CProfFormType = &cprofTypeObject;

/*********** Home Form Type ************/
class FEHomeFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "Home"; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP)  {
    return NULL;
	}
};

static FEHomeFormContentType const homeTypeObject;
FEFormContentTypeP FEApplication::HomeFormType = &homeTypeObject;

/*********** Memo Form Type ************/
class FEMemoFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "Memo"; }
	virtual FEUI::Alignment vertical () { return FEUI::Max; }
	virtual FEUI::Alignment horizontal () { return FEUI::Min; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVMEMODlg(TheApp->MainWindow, "Memo");
		((PVMEMODlg *) result)->setDraft(draft);
    return result;
	}
};

static FEMemoFormContentType const memoTypeObject;
FEFormContentTypeP FEApplication::MemoFormType = &memoTypeObject;

/*********** Rate Form Type ************/
class FERateFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "Rate"; }
	virtual FEUI::Alignment vertical () { return FEUI::Max; }
	virtual FEUI::Alignment horizontal () { return FEUI::Max; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVRATEDlg(TheApp->MainWindow, "RATE");
		((PVRATEDlg *) result)->setDraft(draft);
    return result;
	}
};

static FERateFormContentType const rateTypeObject;
FEFormContentTypeP FEApplication::RateFormType = &rateTypeObject;

/*********** Tabs Form Type ************/
class FETabsFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "Tabs"; }
	virtual FEUI::Alignment vertical () { return FEUI::Min; }
	virtual FEUI::Alignment horizontal () { return FEUI::Max; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVTABSDlg(TheApp->MainWindow, "TABS");
		((PVTABSDlg *) result)->setDraft(draft);
    return result;
	}
};

static FETabsFormContentType const tabsTypeObject;
FEFormContentTypeP FEApplication::TabsFormType = &tabsTypeObject;

/*********** UM Form Type ************/
class FEUMFormContentType : public FEFormContentType {
public: 
	virtual const XuStringVar name () { return "UM"; }
	virtual FEUI::Alignment vertical () { return FEUI::Max; }
	virtual FEUI::Alignment horizontal () { return FEUI::Max; }
protected: 
	virtual PTWindowsObject makeWindow (FEDraftP draft)  {
		PTWindowsObject result = new PVUMDlg(TheApp->MainWindow, "UM");
		((PVUMDlg *) result)->setDraft(draft);
    return result;
	}
};

static FEUMFormContentType const UMTypeObject;
FEFormContentTypeP FEApplication::UMFormType = &UMTypeObject;

