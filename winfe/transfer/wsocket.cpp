#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>
#include <string.h>

extern "C" {
	#include "\wwattcp\include\tcp.h"
};

#include <windows.h>

#include "xanadup.hxx"
#include "socket.h"

class XuWatSocketPortalSpec : public XuPortalSpec {

	public:
		XuPortalP fetchNewPortal (XuStringVar addr);

		XuWatSocketPortalSpec ();

	private:

		static XuWatSocketPortalSpec TheOne;
};

class XuWatSocketPortal : public XuPortal {
	
	public: /* sending & receiving */

		virtual void sendByte (XuIntVar b);
		virtual XuIntVar receiveByte ();

		virtual void sendBuffer (XuBufferVar buffer, XuIntVar count);
		virtual void receiveBuffer (XuBufferVar buffer, XuIntVar size);
		virtual void flush ();
		virtual XuBooleanVar canReceive ();

		virtual ~ XuWatSocketPortal ();

	private: /* flow */

		void tick ();

	private: /* create */

		friend class XuWatSocketPortalSpec;

	private: /* variables */

		XuWatSocketPortal ();

		tcp_Socket mySocket;
        XuBooleanVar isFlushed;
};

typedef XuWatSocketPortal * XuWatSocketPortalP;

XuWatSocketPortalSpec::XuWatSocketPortalSpec ()
	 : XuPortalSpec ("wsocket", xuTCS) {
}

XuPortalP XuWatSocketPortalSpec::fetchNewPortal (XuStringVar addr) {
	/* copied from SocketPortal::make 6/1/92/ravi */
	

	sock_init ();

	char hostName[50];
	int port;

	if (strlen(addr) > sizeof(hostName)) {
		return NULL; /* hack!!! to avoid string overflow */
	}
	if (sscanf (addr, "%s %d", &hostName, &port) != 2) {
		return NULL;
	}

	longword host = resolve(hostName);
	if (host == 0) {
		return NULL;
	}

	/* connect to destination host port */
	XuWatSocketPortalP result = new XuWatSocketPortal ();
	if (result == NULL) {
		cerr << "wsocket: new failed\n";
		return NULL;
    }
	if (! tcp_open (&result->mySocket, 0, host, port, NULL)) {
		cerr << "wsocket: open failed\n";
		return NULL;
	}

    int status;
	sock_wait_established (&result->mySocket, 10, NULL, &status);
	cerr << "wsocket: connected\n";

	return result;

sock_err:
	cerr << "wsocket: sock_wait_established status " << status << "\n";
	return NULL;
}

XuWatSocketPortalSpec XuWatSocketPortalSpec::TheOne;


void XuWatSocketPortal::sendByte (XuIntVar b) {
	/* hack!!! there must be a more efficient way */
	XuByteVar a[1];
	a[0] = (XuByteVar) b;
	this->sendBuffer (a, 1);
}

XuIntVar XuWatSocketPortal::receiveByte () {
	/* hack!!! there must be a more efficient way */
	XuByteVar a[1];
	this->receiveBuffer (a, 1);
	return a[0];
}

void XuWatSocketPortal::sendBuffer (XuBufferVar buffer, XuIntVar count) {
	sock_write (&mySocket, (unsigned char *) buffer, count);
	isFlushed = FALSE;
//    printf("<%d> ", count);
}

void XuWatSocketPortal::receiveBuffer (XuBufferVar buffer, XuIntVar count) {
//    printf("(%d", count);
	for (;;) {
		if (sock_dataready (&mySocket)) {
        	int n;
			n = sock_fastread (&mySocket, (unsigned char *) buffer, count);
			count -= n;
//            printf("-%d",n);
			if (count == 0) {
//            	printf(") ");
				return;
			}
		}
		Yield ();
		this->tick ();
//        printf("-");
	}
}

void XuWatSocketPortal::flush () {
	this->tick ();
}

XuBooleanVar XuWatSocketPortal::canReceive () {
	this->tick ();
	return sock_dataready (&mySocket) > 0;
}
 

XuWatSocketPortal::XuWatSocketPortal () {
	isFlushed = TRUE;
}

XuWatSocketPortal::~XuWatSocketPortal () {
    this->tick ();
	sock_close (&mySocket);
}

void XuWatSocketPortal::tick () {
	if (! isFlushed) {
		sock_flush (&mySocket);
		isFlushed = TRUE;
//		printf("! ");
    }
	int status;
	sock_tick (&mySocket, &status);
	return;
sock_err:
	xuError(XU_SOCKET_SEND_ERROR, XU_SOURCE);
