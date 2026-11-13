/* Initialize the application.  Connect and log in to the server, backfollow on
	 the public and login clubs to find homedocs, and executethe appropriate hook
	 for each home doc. */

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

// just to initialize them properly
#include "title.h"

#include "xstuff.hxx"
#include "xconn.hxx"

class MTDisplayHook :  public XuExportHook {
public:
	virtual void fulfilled(XuBufferVar buf, XuIntVar size) {
		cerr << (char*) buf << "\n";
	}
};    	

int test1 () {
	XuTextP text = XuText::make(" Bundle 6");
	text = text->insert(0, XuText::make(" Bundle 5"));
	text = text->insert(0, XuText::make(" Bundle 4"));
	text = text->insert(0, XuText::make(" Bundle 3"));
	text = text->insert(0, XuText::make(" Bundle 2"));
	text = text->insert(0, XuText::make(" Bundle 1"));
	text = text->insert(0, XuText::make("Bundles:"));
	FEStuff::getText(text->contents(), new MTDisplayHook());
  return 1;
}

#include <time.h>
#define FE_TEXTLEN 50
int main() {
	char loginBuf[FE_TEXTLEN];
	char hostBuf[FE_TEXTLEN];
	GetProfileString ("PCAIDE", "Host", "<connection> <host> <port>",
		hostBuf, FE_TEXTLEN);
	GetProfileString ("PCAIDE", "User", "<user>",
		loginBuf, FE_TEXTLEN);
	// split the host string into transport and everything else.
	for (char *rest = hostBuf; *rest != ' '; rest++) {}
  *rest++ = '\0';
	cerr << "Connecting to server: " << hostBuf << " with: " << rest << "\n";
	XuIntVar error = XuServer::connect(hostBuf, rest);
	if (error) {
		cerr << "Couldn't connect: error number " << error;
		exit(-1);
	}
	FEConn::make(loginBuf, "" /* password */);
	test1();
	XuPromise::forceAll();
	XuPromise::forceAll();
	XuPromise::forceAll();
	time_t then = time(NULL);
	then += 30;
	time_t now;
	do {
		now = time(NULL);
	} while (now < then);
	return 0;
}

