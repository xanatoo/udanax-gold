
/* select the region in the Content's window, if any */		// UI
void FEFormContent::selectRegion (XuRegionP reg) {
	// TODO: parse sequence region and highlight appropriate fields
}

/* select the reference, which eventually may be a MultiRef */		// UI
void FEFormContent::selectReference (XuHyperRefP reference) {
	// TODO: extend to handle MultiRefs
	this->selectRegion(FEStuff::regionOf(XuSingleRef::cast(reference), myEdition));
}

/* create a reference from the current selection, using the Draft's Work */
XuHyperRefP FEFormContent::selectionReference () {
	return FEStuff::makeSingleRef(myDraft->work(), myEdition,
		XuSequence::string(this->formType()->fieldKey(
			this->formType()->selectedField(myWindow)))->asRegion());
}

// TODO: move these next three, _soon_, if this is not the right place for them */
/* show the Content window */
void FEFormContent::showWindow () {
	if (myWindow) {
		ShowWindow(myWindow->HWindow, SW_SHOW);
		BringWindowToTop(myWindow->HWindow);
	}
}

/* hide the Content window */
void FEFormContent::hideWindow () {
	if (myWindow) {
		ShowWindow(myWindow->HWindow, SW_HIDE);
  }
}
 
XuBooleanVar FEManager::shutdown() {
	for (int i = 0; i < DraftMax; i++) {
		if (TheDrafts[i] != NULL) {
			if (!FEManager::close(TheDrafts[i], FALSE)) {
				return FALSE;
			}
		}
  }
	XuSession::current()->endSession();
  return TRUE;
}

XuBooleanVar FEManager::close (FEDraft* doc, int windowClose) {
	if (doc->close(windowClose)) {
		for (int i = 0; i < DraftMax; i++) {
			if (TheDrafts[i] == doc) {
				// TODO: figure this out.  It seems that removing doc->work()
				// from the table eventually causes a xuFatalError, when a promise
				// with the work's name on it comes back from the server.  Now,
				// the question is, why does that happen?
				TheWorks->remove(doc->work());
				delete doc;
				TheDrafts[i] = NULL;
				break;
			}
		}
    return TRUE;
	} else {
		return FALSE;
  }
}

/* Access the title Work of this Draft. */
XuWorkP FEDraft::title () {
	return myTitleWork;
}

/* Access the title string of this Draft.  Note this may be different
	from the title of the Draft's Content's window, if (say) the Draft
	is grabbed. */
XuStringVar FEDraft::titleStr () {
	return myTitleStr;
}

class DocTitleHook : public XuExportHook {
	FEDraft* myDraft;
  XuWorkP myTitleWork;
public:
	DocTitleHook(FEDraft* doc, XuWorkP titleWork) :
		myDraft(doc), myTitleWork(titleWork) {};
	virtual void fulfilled(XuBufferVar buf, XuIntVar size) {
		myDraft->setTitle(myTitleWork, (XuStringVar)buf);
	}
};

/* Set the title.  If newTitleStr is NULL, will begin a fetch of the title. */
// UI
void FEDraft::setTitle (XuWorkP newTitle, XuStringVar newTitleStr) {
	myTitleWork = newTitle;
	if (newTitleStr == NULL) {
		FEStuff::getText(FETitleManager::titleEdition(myTitleWork),
										 new DocTitleHook(this, myTitleWork));
	} else {
		if (myTitleStr != NULL) {
			delete (char*)myTitleStr;
		}
		myTitleStr = _fstrdup(newTitleStr);
		if (myContent != NULL) {
			myContent->setTitle(myTitleStr);
  	}
	}
}


