FESheetP FESheet::
sheetOn (FEDraftP draft) {
	if (draft->mySheet == NULL) {
		draft->mySheet = draft->content()->type()->makeSheet(draft);
	}
	return draft->mySheet;
}

void FESheet::
showWork (XuWorkP work) {
	FEDraftP draft = FEDraft::fetchDraft(work);
	if (draft != NULL) {
		FESheet::sheetOn(draft)->show();
	}
}

void FESheet::
showRef (XuHyperRefP ref) {
	FEDraftP draft = FEDraft::fetchDraft(ref->workContext());
	if (draft != NULL) {
		FESheet::sheetOn(draft)->show();
	}
}

// default do nothing.
void FEContent::
flush () {}


/******************* FEFormSheet ********************/

void FEFormSheet::
show () {
	myWindow->Show(SW_SHOWNORMAL);
	BringWindowToTop(myWindow->HWindow);
}

void FEFormSheet::
hide () {
	myWindow->Show(SW_HIDE);
}

FEFormSheet::
FEFormSheet (FEDraftP draft) {
	FEContentTypeP type = draft->content->type();
	myWindow = type->makeWindow(draft);
	if (myWindow) {
		if (TheApp->MakeWindow(myWindow)) {
			FEUI::align(myWindow->HWindow, type->horizontal(), type->vertical());
			myWindow->Show (SW_SHOWNORMAL);
		} else {
			cerr << "Panic and confusion--can't make window!\n";
			abort();
		}
  }
}

FEFormSheet::
~FEFormSheet () {
	if (myWindow) {
		this->flush();
		PTWindowObject = myWindow;
		myWindow = NULL;
		window->ShutDownWindow();
	}
}

void FEFormSheet::
flush () {
	if (myWindow && (GetParent(GetFocus()) == myWindow->HWindow)) {
		SetFocus (myWindow->HWindow);
	}
}

/******************* FEDocumentSheet ********************/

void FEDocumentSheet::
show () {
	myWindow->Show(SW_SHOWNORMAL);
	BringWindowToTop(myWindow->HWindow);
}

void FEDocumentSheet::
hide () {
	myWindow->Show(SW_HIDE);
}

FEDocumentSheet::
FEDocumentSheet (FEDraftP draft) {
	FEContentTypeP type = draft->content->type();
	myWindow = type->makeWindow(draft);
	if (myWindow) {
		if (TheApp->MakeWindow(myWindow)) {
			FEUI::align(myWindow->HWindow, type->horizontal(), type->vertical());
			myWindow->Show (SW_SHOWNORMAL);
		} else {
			cerr << "Panic and confusion--can't make window!\n";
			abort();
		}
  }
}

FEDocumentSheet::
~FEDocumentSheet () {
	if (myWindow) {
		this->flush();
		PTWindowObject = myWindow;
		myWindow = NULL;
		window->ShutDownWindow();
	}
}

void FEDocumentSheet::
flush () {
	if (myWindow && (GetParent(GetFocus()) == myWindow->HWindow)) {
		SetFocus (myWindow->HWindow);
	}
}

/* set the Content window's title */
void FETextContent::setTitle (XuStringVar newTitle) {
	myWindow->SetCaption((char*)newTitle);
}

/* close all windows */
void FETextContent::close (int windowClose) {
	if (!windowClose) {
		myWindow->CloseWindow();
		delete myWindow;
	}
	myWindow = NULL;
	myLinkMgr->closeWindow();
}
  

/* this Content's link manager */
FELinkManager* FETextContent::linkManager () {
	return myLinkMgr;
}

