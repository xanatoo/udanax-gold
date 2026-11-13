#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "Xstuff.hxx"

class FEGetEditText : public XuExportHook {
	public:
		FEGetEditText(PTEdit edit) : myEdit(edit) {}
	protected:
		virtual void fulfilled(XuBufferVar buf, XuIntVar size) {
			myEdit->SetText ((char*)buf);
			delete buf;
		}
};

void DialogTools::
setEditText(XuEditionP edition, TEditP edit) {
	FEStuff::getText(edition, new FEGetEditText(edit));
}

void DialogTools::
setEditText(XuSequenceP sequence, TEditP edit) {
	FEStuff::getText(sequence, new FEGetEditText(edit));
}

