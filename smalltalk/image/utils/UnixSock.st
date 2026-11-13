UnixIOAccessor subclass: #UnixSocketAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OS-Unix-Sockets'!
UnixSocketAccessor comment:
'UnixSocketAccessor instances correspond to the Unix BSD concept
of a "socket", that is, an Inter-Process Communications (IPC) mechanism
endpoint.

BSD sockets are a protocol-independent *service interface* to multiple
IPC/Network implementations.  As such, they only refer to abstract
facilities which such implementations make concrete.  BSD documentation
sometimes refers to network implementations as "communications domains"
or "protocol families".

Every socket is associated with a communications domain and is of
some "type" which is one of:
	stream:		provides sequenced, reliable, two-way byte-stream connections
				with support for out-of-band (OOB) transmission.
	datagram:	provides connectionless, unreliable, fixed-maximum-length messages.
	raw:		provides direct access to network interfaces (for the super-user).
	sequenced-packet:	provides sequenced, reliable, record-oriented
				connections -- not implemented in most systems.
	reliably-delivered-message (RDM):	reliable datagrams -- not implemented
				in most systems.
A given domain may implement a type with one or more protocols, or not at all.

A socket has a "socket address" (which BSD documentation sporadically refers to
as "name") the interpretation of which is controlled by the socket''s domain; see
the comments in class SocketAddress and its subclasses.

Using sockets properly usually involves synchronizing the action of four agents:
	The server (some user process which provides a service).
	The client (some user process which requires the service).
	The server''s network implementation (usually performed by the OS kernel).
	The client''s network implementation (usually performed by the OS kernel).
As such, it usually requires special care by the programmer of the client or server
to get things right (can we say that the control flow of the system is four times
as complex as it is usually?)  Look on the class-side for more documentation and
examples.

Also see the "Inter-Process Communications Primer" supplied with BSD
documentation.
'!


!UnixSocketAccessor methodsFor: 'instance creation'!

accept
	"Accept a connection (receiver must be stream-based, have already 
	been bound to an address and listening)."
	"Accept extracts the first connection on the queue of pending 
	connections, and returns a new socketAccessor instance with the
	same properties as the receiver. It also returns the SocketAddress
	of the peer (which this code throws away). 
	If there are no outstanding connections, the calling process will 
	block indefinitely!!"

	| a u |
	"Wait for pending connection."
	self readWait.
	a _ self primAccept.
	u _ self class handle: (a at: 1).
	"(a at: 2) contains peer's socket-address --
		SocketAddress canonicalize: (a at: 2)."
	^u!

acceptNonBlock
	"Accept a connection (receiver must be stream-based, have already 
	been bound to an address and listening)."
	"Accept extracts the first connection on the queue of pending 
	connections, and returns a new socketAccessor instance with the
	same properties as the receiver. It also returns the SocketAddress
	of the peer (which this code throws away). 
	If there are no outstanding connections, returns nil."

	| a u |
	a _ self errorReporter notReadySignal
		handle: [:ex | ex returnDoing: [^nil]]
		do: [self primAccept].
	u _ self class handle: (a at: 1).
	"(a at: 2) contains peer's socket-address --
		SocketAddress canonicalize: (a at: 2)."
	^u! !

!UnixSocketAccessor methodsFor: 'accessing'!

bufferSize
	"Answer the recommended buffer size for this accessor."
	"sockets are special."
	^4096!

getName
	"Return the socket's socket-address, properly canonicalized."
	^SocketAddress canonicalize: (self primGetName)!

getOptionsLevel: l name: n
	"Returns a ByteArray containing socket's specified option's value."
	<primitive: 631>
	^self reportError!

getPeer
	"Return the socket peer's socket-address, properly canonicalized."
	^SocketAddress canonicalize: (self primGetPeer)!

setOptionsLevel: l name: n value: v
	"Set the socket's option at level l named n to value v."
	"v can be a ByteArray, a SmallInteger, or nil."
	<primitive: 630>
	^self reportError! !

!UnixSocketAccessor methodsFor: 'testing'!

atMark
	"Returns true if socket is at OOB data mark."
	<primitive: 634>
	^self reportError! !

!UnixSocketAccessor methodsFor: 'specialized IO'!

receiveFrom: sa buffer: b
	"Receive data on a SocketAccessor.  Put it into the buffer b (a ByteArray or String)
	Side-effects SocketAddress sa to contain the peer's address.
	This is a low-level message which requires external synchronization (e.g. readWait)."
	^self receiveFrom: sa buffer: b start: 1 for: b basicSize flags: 0!

receiveFrom: sa buffer: b start: s for: c 
	"Receive data on a SocketAccessor. Put it into the buffer b (a 
	ByteArray or String) starting at index s for c bytes. Side-effects 
	SocketAddress sa to contain the peer's address. This is a low-level 
	message which requires external synchronization (e.g. readWait)."

	^self
		receiveFrom: sa
		buffer: b
		start: s
		for: c
		flags: 0!

receiveFrom: sa buffer: b start: s for: c flags: f 
	"Receive data on a SocketAccessor. Put it into the buffer b (a 
	ByteArray or String) starting at index s for c bytes. Flags are the 
	union of the ``msg'' socket options. Side-effects SocketAddress sa to 
	contain the peer's address. This is a low-level message which 
	requires external synchronization (e.g. readWait)."

	| cnt |
	cnt _ self
				primReceiveFrom: sa
				buffer: b
				start: s
				for: c
				flags: f.
	sa canonicalize.
	^cnt!

sendTo: sa buffer: b 
	"Transmits the message in buffer b (a ByteArray or String) through 
	the SocketAccessor destined for the peer at SocketAddress sa. This 
	is a low-level message which requires external synchronization (e.g. 
	writeWait)."

	^self
		sendTo: sa
		buffer: b
		start: 1
		for: b basicSize
		flags: 0!

sendTo: sa buffer: b start: s for: c 
	"Transmits the message in buffer b (a ByteArray or String) starting 
	at index s for c bytes through the SocketAccessor destined for the 
	peer at SocketAddress sa. This is a low-level message which 
	requires external synchronization (e.g. writeWait)."

	^self
		sendTo: sa
		buffer: b
		start: s
		for: c
		flags: 0!

sendTo: sa buffer: b start: s for: c flags: f 
	"Transmits the message in buffer b (a ByteArray or String) starting 
	at index s for c bytes through the SocketAccessor destined for the 
	peer at SocketAddress sa. The flags f is a SmallInteger which is the 
	union of the socket ``msg'' options. This is a low-level message 
	which requires external synchronization (e.g. writeWait)."

	<primitive: 676>
	^self reportError!

shutdown: num
	"Inform the socket accessor that no more IO will be performed:
	0 -- read only, 1 -- write only, 2 -- both"
	"shutdown: 2 is more dramatic (and faster) than close since it
	discards any pending data."
	<primitive: 677>
	^self reportError! !

!UnixSocketAccessor methodsFor: 'state transitions'!

bindTo: aSocketAddress
	"Bind an address to an unaddressed socket."
	"Note -- bindTo: specifies the address which identifies the local address
	of the connection, connectTo: specifies the address which identifies
	the remote address of the connection."
	"returns self"
	<primitive: 672>
	^self reportError!

connectTo: aSocketAddress 
	"If this is a datagram-type socket, permanently specify the peer to which 
	datagrams will be sent.  If this is a stream-type socket, 
	attempts to make the connection.  Waits until the connection is established."
	"Note -- connectTo: specifies the address which identifies 
	the remote address of the connection, bindTo: specifies the 
	address which identifies the local address of the connection."

	"We must catch both operationStartedSignal and notReadySignal
	because Unixes differ in what error code they return
	for a pending socket connection."
	(SignalCollection
		with: self errorReporter operationStartedSignal
		with: self errorReporter notReadySignal)
			handle: [:ex | ex returnDoing: [self waitForConnection]]
			do: [self primConnectTo: aSocketAddress]!

listenFor: aSmallInteger
	"Permit the acception of connections, argument specifies maximum
	connection queue backlog."
	"returns self"
	<primitive: 673>
	^self reportError! !

!UnixSocketAccessor methodsFor: 'private'!

primAccept
	"Accept a connection (receiver must be stream-based, have already been
	 bound to an address and listening).
	 Accept extracts the first connection on the queue of pending connections,
	 and returns a new socket with the same properties as
	 the receiver. If there are no outstanding connections, the socket will get
	 a wouldBlock error."

	"returns an Array with: sockSmallInteger with: aSocketAddress"
	<primitive: 671>
	^self reportError!

primConnectTo: aSocketAddress
	"If this is a datagram-type socket,
		permanently specify the peer to which
		datagrams will be sent.
	If this is a stream-type socket,
		attempts to make the connection."
	"Note -- connectTo: specifies the address which identifies
	the remote address of the connection, bindTo: specifies the
	address which identifies the local address of the connection.
	You're very likely to get an inProgress or wouldBlock error, which
	 means you should (write) wait before doing anything else."
	"Returns self."

	<primitive: 674>
	^self reportError!

primGetName
	"returns SocketAddress"
	<primitive: 632>
	^self reportError!

primGetPeer
	"returns SocketAddress"
	<primitive: 633>
	^self reportError!

primReceiveFrom: sa buffer: b start: s for: c flags: f 
	"Receive data on a SocketAccessor. Put it into the buffer b (a 
	ByteArray or String) starting at index s for c bytes. Flags are the 
	union of the ``msg'' socket options. Side-effects SocketAddress sa to 
	contain the peer's address, which is not canonicalized. This is a 
	low-level message which requires external synchronization (e.g. 
	readWait)."

	<primitive: 675>
	^self reportError!

waitForConnection
	"Wait until I have been connected to my peer; answer the peer's 
	address."
	"Because of subtle OS differences w.r.t. how to wait on a pending 
	connection, we wait until the peer address is available; the polling 
	heuristic is to wait for any activity (or a timeout)."

	| sem dly readReady writeReady rSigError wSigError peer errorSignal |
	errorSignal _ self errorReporter errorSignal.
	dly _ Delay forMilliseconds: self readPauseInterval.
	sem _ dly delaySemaphore.
	readReady _ writeReady _ false.
	rSigError _ wSigError _ false.
	[(peer _ errorSignal handle: [:ex | ex returnWith: nil] do: [self getPeer]) isNil]
		whileTrue: 
			[sem initSignals.
			readReady _ errorSignal
						handle: [:ex | rSigError _ true. ex returnWith: false]
						do: [self setSem: sem forWrite: false. rSigError _ false].
			writeReady _ errorSignal
						handle: [:ex | wSigError _ true. ex returnWith: false]
						do: [self setSem: sem forWrite: true. wSigError _ false].
			readReady | writeReady
				ifFalse: 
					["Wait for data arrival or timeout expiry."
					dly disable.
					dly startup.
					sem wait]].
	 "remove all the semaphores"
	dly disable.
	errorSignal handle: [:ex | ex return]
		do: [readReady not & rSigError not ifTrue: [self setSem: nil forWrite: false].
			writeReady not & wSigError not ifTrue: [self setSem: nil forWrite: true]].
	^peer! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

UnixSocketAccessor class
	instanceVariableNames: ''!


!UnixSocketAccessor class methodsFor: 'class initialize/release'!

initialize
	"UnixSocketAccessor initialize"

	self install!

install
	"Tell the VM to do any needed initialization."

	self primInit: (Array with: SocketAddress)! !

!UnixSocketAccessor class methodsFor: 'instance creation'!

family: fSmInt type: tSmInt
	"Return a new SocketAccessor in the specified domain (family) and type,
	using the default protocol."
	| fd u |
	fd _ self primFamily: fSmInt type: tSmInt protocol: self pfUnspec errInto: self errorReporter new.
	u _ self handle: fd.
	^u!

family: fSmInt type: tSmInt protocol: pSmInt
	"Return a new SocketAccessor in the specified domain (family) type and protocol."
	| fd u |
	fd _ self primFamily: fSmInt type: tSmInt protocol: pSmInt errInto: self errorReporter new.
	u _ self handle: fd.
	^u!

newTCP
	"Appropriate for clients, or for servers with no assigned ports."

	| skt sa |
	skt _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockStream.
	[sa _ IPSocketAddress thisHostAnyPort.
	skt bindTo: sa]
		valueOnUnwindDo: [skt close].
	^skt!

newTCPclientToHost: hname port: pnum 
	"Create a client socket connected to host hname/port pnum"

	| skt fa |
	skt _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockStream.
	[fa _ IPSocketAddress hostName: hname port: pnum.
	skt connectTo: fa]
		valueOnUnwindDo: [skt close].
	^skt!

newTCPserverAtPort: pnum 
	"Create an instance prepared to be a TCP server at the specified port."

	| skt sa |
	skt _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockStream.
	[sa _ IPSocketAddress hostAddress: IPSocketAddress thisHost port: pnum.
	skt bindTo: sa]
		valueOnUnwindDo: [skt close].
	^skt!

newUDP
	"Appropriate for clients or for servers with no preassigned ports."

	| skt sa |
	skt _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockDgram.
	[sa _ IPSocketAddress thisHostAnyPort.
	skt bindTo: sa]
		valueOnUnwindDo: [skt close].
	^skt!

newUDPserverAtPort: pnum
	"Create an instance prepared to be a UDP server at the specified port."

	| skt sa |
	skt _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockDgram.
	[sa _ IPSocketAddress hostAddress: IPSocketAddress thisHost port: pnum.
	skt bindTo: sa]
		valueOnUnwindDo: [skt close].
	^skt!

openPair
	"Make a pair of connected sockets. Returns an (Array with: fd1 with: fd2)."

	| fd2 e ur uw |
	"Deal with losing socket implementations which don't implement socketpair(2)."
	self unsupportedOperationSignal
		handle:
			[:ex | ex returnWith: (self phonyPair)]
		do: 
			[fd2 _ self primPairErrorInto: (e _ self errorReporter new).
			e failed ifTrue: [^e reportFor: self].
			ur _ self handle: (fd2 at: 1).
			uw _ self handle: (fd2 at: 2).
			^Array with: ur with: uw]!

phonyPair
	"Simulates the action of openPair, but using the IP domain.
	Returns Array with: IOAccessor with: IOAccessor"
	"This is just here in order to deal with losing socket implementations
	which don't implement socketpair and who don't do Unix-domain
	rendesvous correctly."
	| s1 s2 s3 sa sb |
	s1 _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockStream.
	s2 _ self family: (SocketAddress domainCodeFromName: #afInet)
				type: self sockStream.
	
	[sa _ IPSocketAddress thisHostAnyPort.
	s1 bindTo: sa.
	"Use loopback interface."
	sb _ (s1 getName) hostName: 'localhost'.
	s1 listenFor: 1.
	s2 primConnectTo: sb.
	s3 _ s1 accept]
		valueOnUnwindDo: 
			[s1 close.
			s2 close].
	s1 close.
	^Array with: s3 with: s2! !

!UnixSocketAccessor class methodsFor: 'accessing'!

getHostname
	"Answer a string with the current platform's host name."

	<primitive: 649>
	^self primitiveFailed! !

!UnixSocketAccessor class methodsFor: 'constants-socket options'!

msgDontroute
	"Socket send option flag to send without using routing tables."
	^4!

msgOob
	"Socket send/recieve option flag to process out-of-band data."
	^1!

msgPeek
	"Socket receive option flag to peek at incoming message."
	^2!

soAcceptconn
	"Socket option for expressing willingness to accept connections."

	^2!

soDebug
	"Socket option constant for turning on debug info recording."
	^1!

soDontlinger
	"Socket option constant to not linger on close (even if data present)."
	^self soLinger bitInvert!

soDontroute
	"Socket option constant for direct use of interface addresses."
	^16r10!

soLinger
	"Socket option constant to linger on close if data present."
	^16r80!

solSocket
	"Level number for get/setOptions to apply to socket itself."
	^16rFFFF!

soReuseaddr
	"Socket option constant allowing local address reuse."
	^16r8!

soUseloopback
	"Socket option constant to bypass hardware when possible."
	^16r40! !

!UnixSocketAccessor class methodsFor: 'constants-socket types'!

sockDgram
	"Constant for socket type providing connectionless, unreliable,
	fixed-maximum-length messages."
	^2!

sockRaw
	"Constant for socket type indicating direct access to network
	interfaces.  Only accessable to privileged users."
	^3!

sockRdm
	"Constant for socket type providing reliable datagrams -- not
	implemented in most systems."
	^4!

sockSeqpacket
	"Constant for socket type providing sequenced, reliable, record-oriented
	connections -- not implemented in most systems."
	^5!

sockStream
	"Constant for socket type providing sequenced, reliable, two-way
	byte-stream connections with support for out-of-band (OOB) transmission."
	^1! !

!UnixSocketAccessor class methodsFor: 'constants-protocol families'!

pfInet
	"Answer protocol family code for Internet protocols."

	^2!

pfUnix
	"Answer protocol family code for Unix-domain ``protocols''."

	^1!

pfUnspec
	"Answer protocol family code for unspecified protocols."

	^0! !

!UnixSocketAccessor class methodsFor: 'documentation'!

howToImplementAClient
	"If you want to implement a client for some (connection-based) service
	which already exists, you may want to read this.  We'll assume the service
	is IP/TCP based.

	First you need to create the socket and connect it to the server.  Let's assume
	you know the host name, 'servicehost' and you know the port number is 175.
	In that case:
			skt _ UnixSocketAccessor newTCPclientToHost: 'servicehost' port: 175.

	At this point, the UnixSocketAccessor can be read and written to just like a
	UnixDiskFileDescriptor (e.g. you can use readInto:starting... and writeFrom:starting...
	and readWait and writeWait, etc).

	For streaming, you can create a connection, and then ask the connection for a stream:
			conn _ ExternalStream new
						input: skt;
						output: skt.
			stream _ conn readStream.

	When you're done communicating with the service, just:
		skt close.
	finishes the job.

			stream close
	will close the socket as well, so both are not necessary"

	^self error: 'comment only'!

howToImplementAServer
	"If you want to implement a server for some (connection-based) service
	you may want to read this.  We'll assume the service is to be IP/TCP based.

	First, you create a socket and bind the socket to an address.  A more complicated
	issue is what port number you should assign your service.  This issue is discussed in the
	documentation for class IPSocketAddress -- for this example, we'll assume you've already
	arranged for your service to be at port 175.  So:
		skt _ UnixSocketAccessor	newTCPserverAtPort: 175.
	...now you've published a socket for your host at port 175, but you need to accept
	the connections which will be arriving.  First, you inform the OS to construct a connection
	queue of some maximum length (5 is the longest queue most implementations will allow).  Let's
	say that you're only willing to handle two clients at a time:
		skt listenFor: 2.
	...now you can accept arriving connections:
		newskt _ skt accept.
	...newskt is a new UnixSocketAccessor of an ''equivalent'' domain, type and protocol to the
	original socket.  The port number is (I think) an arbitrary one assigned by the system.  If you
	wish, you can send getPeer to the newskt first, to validate that your client is originating
	on a system you are willing to provide services to (if not, you should send close to newskt
	and start over).

	At this point you probably want to fork off a process to provide the service, while the original
	process waits for the next connection with accept.  The forked process which actually provides
	the service will have newskt, a UnixSocketAccessor which can be read and written to just like a
	UnixDiskFileDescriptor (e.g. you can use readInto:starting... and writeFrom:starting...
	and readWait and writeWait, etc).

	When you're done providing the service to a given client, your forked process should
	just send:
		newskt close.
	and terminate itself. When you are no longer willing to accept new connections from clients
	you just send:
		skt close

	Streams can be used on newskt in the same fashion as for client sockets"

	^self error: 'comment only'!

howToUseDatagramSockets
	"Connectionless IPC (using datagram sockets) is quite different from
	connection-oriented IPC.  Typically, each transaction is of a known
	length, and each transation may be associated with a different peer.

	Datagrams are supported for both the Unix and Internet domains.  We'll
	use Unix-domain for this example, one where both peers are symmetric.
	First, you construct a socket of the appropriate type:
		skt _ UnixSocketAccessor	family: (SocketAddress domainCodeFromName: #afUnix)
									type: (UnixSocketAccessor sockDgram)
									protocol: (UnixSocketAccessor pfUnspec).
	...and then one side would bind to an address:
		mySa _ UDSocketAddress name: '/tmp/foo'.
		skt bindTo: mySa.
	...and perhaps set-up to home to a particular peer:
		hisSa _ UDSocketAddress name: '/tmp/bar'.
		skt connectTo: hisSa.
	...the peer would swap the addresses but execute similar code.

	At this point, both sides could use their sockets for normal reading and writing, if the transaction
	sizes were known in advance.

	If the application were more client/server style, the server would forgo the connectTo: (since
	he wouldn't know who the client was in advance.  The client would skip the bindTo:, and
	let the system assign a socket address for him.

	The server would communicate to his client(s) by reading with receiveFrom:buffer..., and using
	the socket address returned, reply to a given client using sendTo:buffer:...
	The clients could use normal read/write protocol."

	^self error: 'comment only'! !

!UnixSocketAccessor class methodsFor: 'examples'!

exampleIPClient
	"Simple TCP client (see exampleIPServer) which sends a 
	single message and waits for a reply."
	"UnixSocketAccessor exampleIPClient"
	"Be sure to start the server first."

	|  pnum hname proc cmd reply skt |
	hname _ FillInTheBlank
				request: 'What is the name of the server''s host?'
				initialAnswer: 'localhost'.
	pnum _ (FillInTheBlank
				request: 'What is the server''s port number?'
				initialAnswer: '') asNumber.
	skt _ self newTCPclientToHost: hname port: pnum.
	proc _ ExternalConnection new input: skt; output: skt; yourself.
	cmd _ proc readAppendStream.
	reply _ cmd through: Character cr.
	cmd nextPutAll: 'Hello dere, Kingfish!!'; cr; commit.
	cmd close.
	^reply!

exampleIPServer
	"Simple TCP server (see exampleIPClient) which waits for a
	single message and sends a reply."
	"[UnixSocketAccessor exampleIPServer] forkAt: Processor userInterruptPriority"

	| skt ns d tc |
	skt _ self newTCP.
	Transcript beginEntry; cr; nextPutAll: 'Bound server socket to: '.
	Transcript cr; print: skt getName; cr; endEntry.

	skt listenFor: 1.
	d _ Delay forSeconds: 5.
	ns _ nil.
	tc _ 50.
	[ns isNil and: [tc > 0]]
		whileTrue: [
			Transcript nextPutAll: 'Waiting for connection...'.
			tc _ tc - 1.
			d wait.
			ns _ skt acceptNonBlock.
			Transcript cr; endEntry].
	ns isNil
		ifTrue: [Transcript nextPutAll: 'Giving up!!';
							cr;
							endEntry.
				skt close.
				^self].

	ns _ (ExternalConnection new input: ns; output: ns; yourself) readAppendStream.
	ns nextPutAll: 'What Smalltalk hath wrought'; cr.
	Transcript beginEntry; nextPutAll: 'client sez: "'.
	Transcript nextPutAll: (ns through: Character cr); nextPut: $"; cr; endEntry.
	ns close.
	skt close!

exampleTalkClient
	"Simple UDP client which just fires off single packets to a talk
	server and waits for an acknowledgement. Could be used as
	basis for a ``talk'' client.  Be sure a server is started first."
	"UnixSocketAccessor exampleTalkClient"

	| skt fa buffer hname msg |
	hname _ FillInTheBlank
		request: 'What is the name of the server''s host?'
		initialAnswer: ''.
	skt _ self newUDP.
	fa _ IPSocketAddress
			hostName: hname
			port: 6666.
	buffer _ String new: 1000.
	[[(msg _ FillInTheBlank request: 'Say something') isEmpty] whileFalse:
		[| count |
		skt writeWait.
		skt sendTo: fa buffer: msg.
		skt readWait.
		count _ skt receiveFrom: fa buffer: buffer.
		count > 0
			ifTrue:	[Transcript cr; nextPutAll: 'Server said: '.
					Transcript show: (buffer copyFrom: 1 to: count)]]]
	valueNowOrOnUnwindDo: [skt close].
	Transcript cr.!

exampleTalkServer
	"Simple UDP server which just accepts single packets from anybody
	and broadcasts them to all clients that have connected so far.
	Could be used as basis for a ``talk'' server.
	Press the blue button down to abort the server."
	"[UnixSocketAccessor exampleTalkServer]
			forkAt: Processor userInterruptPriority"

	| skt fa buffer count clients |
	skt _ self newUDPserverAtPort: 6666.
	clients _ Set new.	"All known clients so far"
	fa _ IPSocketAddress new.
	buffer _ String new: 1024.
	Transcript cr; show: 'talk server starting'.
	[[Sensor blueButtonPressed] whileFalse:
		["Wait for data arrival or timeout."
		(skt readWaitWithTimeoutMs: 200)
			ifFalse: [
				count _ skt receiveFrom: fa buffer: buffer start: 1 for: buffer size.
				clients add: fa copy.
				clients do: [:sa | skt sendTo: sa buffer: buffer start: 1 for: count]]]]
	valueNowOrOnUnwindDo:
		[Transcript cr; show: 'talk server shutting down'.
		skt close]!

requestTimeService
	"UnixSocketAccessor requestTimeService"
	"Uses the IP/UDP time service, which returns the time in seconds
	since Jan 1, 1900 UT as a 4-byte integer.  Prints the result in the
	transcript.  Prompts for a host name (be sure it runs a time server).

	This is an example of accessing sockets in raw access instead of
	using external streams"

	| skt fa buffer count hname msg cvtblk |
	"Create a block that converts the time to a date"
	cvtblk _
		[:timeBuffer |
		| seconds |
		seconds _ (UninterpretedBytes from: timeBuffer)
						unsignedLongAt: 1 bigEndian: true.
		"Adjust by one year's worth of seconds (1900 in IP vs. 1901 in Smalltalk)."
		Time aTimeString: seconds  - (60 * 60 * 24 * 365)].
	hname _ FillInTheBlank
		request: 'What host shall we try?'
		initialAnswer: 'localhost'.
	skt _ self newUDP.
	"The following is kept in an unwind block in case an exception is raised"
	[fa _ IPSocketAddress
			hostName: hname
			port: (IPSocketAddress servicePortByName: 'time').
	skt connectTo: fa.
	buffer _ ByteArray new: 4.
	"Any message will do to trigger time server."
	msg _ 'What time is it?'.
	skt writeAll: msg.
	Transcript cr.
	(skt readWaitWithTimeoutMs: 10000)
		ifFalse:
			[count _ skt readInto: buffer.
			count = 4
				ifTrue:	[Transcript nextPutAll: 'Timeserver(', hname, ') returned: ', (cvtblk value: buffer)]
				ifFalse:	[count = 0
							ifTrue:	[Transcript nextPutAll: 'no response']
							ifFalse:	[Transcript nextPutAll: 'Invalid reply format']]]
		ifTrue: [Transcript nextPutAll: 'No reply'].
	Transcript endEntry] valueNowOrOnUnwindDo: [skt close]! !

!UnixSocketAccessor class methodsFor: 'private-primitives'!

primFamily: fSmallInteger type: tSmallInteger protocol: pSmallInteger errInto: anErrorHolder
	"returns a SmallInteger for the socket fd."
	<primitive: 670>
	^anErrorHolder reportFor: self!

primInit: anArray
	"Tell the VM to set up for sockets, special classes are supplied in arg."

	<primitive: 698>
	^self primitiveFailed!

primPairErrorInto: errorHolder
	"Makes a pair of connected sockets. Returns an (Array with: fd1 with: fd2)."

	<primitive: 654>
	^errorHolder reportFor: self! !

UninterpretedBytes variableByteSubclass: #SocketAddress
	instanceVariableNames: ''
	classVariableNames: 'DomainCodes KnownDomains '
	poolDictionaries: ''
	category: 'OS-Unix-Sockets'!
SocketAddress comment:
'Instances of this class (and it''s subclasses) correspond to the BSD
socket mechanism''s C-struct "sockaddr".

struct sockaddr {
        u_short sa_family;			/* address family */
        char    sa_data[14];		/* up to 14 bytes of direct address */
};

The first two bytes are the "address family" type identifier.
The remaining bytes (maximum of 14) are interpreted by the subclasses.
We simply represent all 16 bytes as byte variable data in each instance.

We "canonicalize" instances of SocketAddress wherever possible
by become-ing them into instances of an appropriate subclass.

Only two subclasses have been defined at this time (the ''''known domains''''):
	IPSocketAddress		for the Internet Protocols (IP) domain
	UDSocketAddress		for the Unix Domain
see the comments for those classes.

Other subclasses can be defined as needed.  To do this, you should define
a subclass which has appropriate protocol for interpreting the remaining
bytes and then add those class names to KnownDomains by editing initKnown;
this way, canonicalization can work for the new subclass.

Class variables:
	BigEndian		<Boolean> indicating the platform''s byte-endianess.
					Initialized at start-up time.  Needed to manipulate the
					family code (which is a C short packed into the ByteArray).
	DomainCodes	<IdentityDictionary> containing the mapping between address-family
					codes and a name (Symbol).
	KnownDomains	<IdentityDictionary> containing the mapping between address-family
					name and the appropriate SocketAddress subclass.


'!


!SocketAddress methodsFor: 'private-accessing'!

domainCode: fc
	"Assign the domain code, canonicalizing if neccessary (may do a become)."
	self unsignedShortAt: 1 put: fc.
	self canonicalize! !

!SocketAddress methodsFor: 'byte order reversal'!

reverseByteOrder
	"Reverse the byte order for dealing with platform switch on snapshot return."
	"Only the domain-code needs reversing, the rest of the bytes
	are in NBO."
	| t |
	t _ self byteAt: 1.
	self byteAt: 1 put: (self byteAt: 2).
	self byteAt: 2 put: t! !

!SocketAddress methodsFor: 'accessing'!

domainCode
	"Answer the domain code."

	^self unsignedShortAt: 1! !

!SocketAddress methodsFor: 'printing'!

printBytesOn: aStream 
	"Output the printable representation of the address to the stream."

	3 to: self sizeInBytes do: 
		[:i | 
		(self byteAt: i)
			printOn: aStream.
		i = self sizeInBytes ifFalse: [aStream nextPut: $.]]!

printOn: aStream 
	"Append to the argument, aStream, the printable representation of the
	domain code and the remaining bytes."

	| fn fc |
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	self class = SocketAddress
		ifTrue: 
			[fc _ self domainCode.
			fn _ DomainCodes at: fc ifAbsent: ['af' , fc printString].
			aStream nextPutAll: fn asString.
			aStream space].
	self printBytesOn: aStream.
	aStream nextPut: $)! !

!SocketAddress methodsFor: 'copying'!

canonicalize
	"Convert this instance to a more appropriate class (if needed) by becoming."

	| newself |
	newself _ self class canonicalize: self.
	"Avoid unneeded becomes."
	self = newself ifFalse: [self become: newself]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SocketAddress class
	instanceVariableNames: ''!


!SocketAddress class methodsFor: 'class accessing'!

domainCodeFromName: sym
	"Answer the domain code corresponding to the name (a Symbol)."

	^DomainCodes keyAtValue: sym!

domainNameFromCode: code
	"Given the domain code, answer the name (a Symbol)."

	^DomainCodes at: code!

knownClassFromCode: code
	"Given a domain code, answer the appropriate concrete class."

	^Smalltalk at: (KnownDomains at: (DomainCodes at: code ifAbsent: [#afUnspec]) ifAbsent: [#SocketAddress])! !

!SocketAddress class methodsFor: 'private-copying'!

from: sktAddr
	"Make a new instance by copying the SocketAddress argument."

	| sz |
	sz _ sktAddr sizeInBytes.
	^(self new: sz)
		replaceBytesFrom: 1
		to: sz
		with: sktAddr
		startingAt: 1! !

!SocketAddress class methodsFor: 'instance creation'!

canonicalize: sa
	"Given a SocketAddress, return an instance which is of the most
	appropriate concrete class."

	| cls |
	cls _ self knownClassFromCode: sa domainCode.
	sa class = cls ifTrue: [^sa].
	^cls from: sa!

new
	"Return a new instance of the default size and of unspecified type."

	^self new: 16! !

!SocketAddress class methodsFor: 'class initialization'!

initCodes
	"Set up the dictionary which maps domain codes to names."
	"This list corresponds to SunOS 4.0Beta2!!"

	DomainCodes _ IdentityDictionary new: 23.
	DomainCodes at: 0 put: #afUnspec.
	DomainCodes at: 1 put: #afUnix.
	DomainCodes at: 2 put: #afInet.
	DomainCodes at: 3 put: #afImplink.
	DomainCodes at: 4 put: #afPup.
	DomainCodes at: 5 put: #afChaos.
	DomainCodes at: 6 put: #afNs.
	DomainCodes at: 7 put: #afNbs.
	DomainCodes at: 8 put: #afEcma.
	DomainCodes at: 9 put: #afDatakit.
	DomainCodes at: 10 put: #afCcitt.
	DomainCodes at: 11 put: #afSna.
	DomainCodes at: 12 put: #afDecnet.
	DomainCodes at: 13 put: #afDli.
	DomainCodes at: 14 put: #afLat.
	DomainCodes at: 15 put: #afHylink.
	DomainCodes at: 16 put: #afAppletalk.
	DomainCodes at: 17 put: #afNit.
	DomainCodes at: 18 put: #af802.
	DomainCodes at: 19 put: #afOsi.
	DomainCodes at: 20 put: #afX25.
	DomainCodes at: 21 put: #afOsinet.
	DomainCodes at: 22 put: #afGosip!

initialize
	"SocketAddress initialize."

	self initCodes.
	self initKnown!

initKnown
	"Build the dictionary of known specializations of socket addresses."
	"We use symbols (rather than classes) as values to avoid file-in problems."

	KnownDomains _ IdentityDictionary new: 3.
	KnownDomains at: #afUnspec put: #SocketAddress.
	KnownDomains at: #afUnix put: #UDSocketAddress.
	KnownDomains at: #afInet put: #IPSocketAddress! !

SocketAddress initialize!


SocketAddress variableByteSubclass: #UDSocketAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OS-Unix-Sockets'!
UDSocketAddress comment:
'Instances of this class represent socket addresses interpreted in the "Unix Domain" address family.

From /usr/include/sys/un.h:
	struct  sockaddr_un {
		short   sun_family;			/* AF_UNIX */
		char    sun_path[109];		/* path name (gag) */
	};

The path-name field represents has syntax like ordinary Unix path names.
That is, ''/tmp/foo'' is a perfectly reasonable one, but even better would be
one which is guaranteed not to collide (maybe use your pid?)

A nasty side effect of using Unix-domain sockets is that you have to unlink
the path name when you''re done (if you don''t want it hanging around).
'!


!UDSocketAddress methodsFor: 'accessing'!

name
	"Anwer the name as a String."

	| len  |
	len _ self nameLength.
	^(String new: len) replaceFrom: 1 to: len withByteArray: self startingAt: 3!

name: str
	"Assign the name."
	"Names that are too long are silently truncated."

	"Avoid unneeded becomes."
	str = self name ifFalse: [self become: (self class name: str)]! !

!UDSocketAddress methodsFor: 'printing'!

printBytesOn: aStream
	"Output the printable representation of the address to the stream."

	self name printOn: aStream! !

!UDSocketAddress methodsFor: 'private-accessing'!

nameLength
	"Answer the length of the name."

	3 to: self sizeInBytes do: [:i | 0 = (self byteAt: i) ifTrue: [^i - 3]].
	^self sizeInBytes - 2! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

UDSocketAddress class
	instanceVariableNames: ''!


!UDSocketAddress class methodsFor: 'instance creation'!

name: str
	"Answer a new instance with the supplied name."
	"Names that are too long are silently truncated."
	| len n |
	len _ (str size + 1) min: self maxNameLength.
	n _ (self new: len + 2) replaceBytesFrom: 3 to: len + 1 with: str asByteArray startingAt: 1.
	n atByte: str size + 3 put: 0. "C-style string null padding"
	^n!

new: cnt
	"Answer a new instance with an uninitialized name."

	^(super new: cnt) domainCode: 1.! !

!UDSocketAddress class methodsFor: 'constants'!

maxNameLength
	"Answer the maximum length of the name field."
	"As the comment in the header file says: (gag)"

	^109! !

SocketAddress variableByteSubclass: #IPSocketAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OS-Unix-Sockets'!
IPSocketAddress comment:
'Instances of this class represent socket addresses interpreted in the ''''Internet (e.g. ARPA) Domain'''' address family.

From /usr/include/netinet/in.h:
	struct in_addr {
		union {
			struct { u_char s_b1,s_b2,s_b3,s_b4; } S_un_b;
			struct { u_short s_w1,s_w2; } S_un_w;
			u_long S_addr;
		} S_un;
	struct sockaddr_in {
		short sin_family;
		u_short sin_port;
		struct in_addr sin_addr;	
		char sin_zero[8];
	};

That is, an Internet address has a 2-byte port number and a 4-byte host address.

Look for more information about structure of and symbolic names for host addresses
and ports in this class'' "documentation" protocol.
'!


!IPSocketAddress methodsFor: 'printing'!

printBytesOn: aStream
	"Output the printable representation of the address to the stream."

	aStream nextPutAll: 'port#'; print: self port; space; nextPutAll: 'at:'.
	aStream nextPutAll: self hostName.! !

!IPSocketAddress methodsFor: 'accessing'!

hostAddress
	"Answer the host address."

	^(ByteArray new: 4) replaceBytesFrom: 1 to: 4 with: self startingAt: 5!

hostAddress: hba
	"Assign the host address."

	self replaceBytesFrom: 5 to: 8 with: hba startingAt: 1!

hostName
	"Answer the host name."

	| hn |
	hn _ self class hostNameByAddress: self hostAddress.
	hn isNil
		ifTrue: 
			[| ws |
			ws _ WriteStream new: 7.
			5 to: 8 do: 
				[:i | 
				(self byteAt: i) printOn: ws.
				i = self sizeInBytes ifFalse: [ws nextPut: $.]].
			hn _ ws contents].
	^hn!

hostName: hn
	"Assign the host name."

	| hba |
	hba _ self class hostAddressByName: hn.
	hba isNil ifTrue: [hn error: 'No such hostname']
			ifFalse: [^self hostAddress: hba]!

port
	"Answer the port number."
	"Network byte order is fixed."

	^self unsignedShortAt: 3 bigEndian: true!

port: p
	"Assign the port number (ByteArray or Integer)."
	"Network byte order is fixed."

	(p isKindOf: ByteArray)
		ifTrue:
			[self byteAt: 3 put: (p at: p size - 1).
			self byteAt: 4 put: (p at: p size)]
		ifFalse:
			["Assume Integer"
			self unsignedShortAt: 3 put: p bigEndian: true]! !

!IPSocketAddress methodsFor: 'network addresses'!

networkAddress
	"Answer the network address."
	"Extract it from the host address."

	0 = ((self byteAt: 5) bitAnd: 16r80) ifTrue: [^ByteArray with: (self byteAt: 5)].
	16r80 = ((self byteAt: 5) bitAnd: 16rC0) ifTrue: [^ByteArray with: (self byteAt: 5) with: (self byteAt: 6)].
	16rC0 = ((self byteAt: 5) bitAnd: 16rC0) ifTrue: [^ByteArray with: (self byteAt: 5) with: (self byteAt: 6) with: (self byteAt: 7)].
	self error: 'unknown network class'!

networkClass
	"Answer the network class as a symbol (one of #classA #classB #classC)."
	"Extract it from the host address."

	0 = ((self byteAt: 5) bitAnd: 16r80) ifTrue: [^#classA].
	16r80 = ((self byteAt: 5) bitAnd: 16rC0) ifTrue: [^#classB].
	16rC0 = ((self byteAt: 5) bitAnd: 16rC0) ifTrue: [^#classC].
	^self error: 'unknown network class'! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

IPSocketAddress class
	instanceVariableNames: ''!


!IPSocketAddress class methodsFor: 'instance creation'!

hostAddress: ha
	"Answer a new instance with the given host address."

	^self new hostAddress: ha!

hostAddress: hn port: p
	"Answer a new instance with the given host address and port."

	^(self new hostAddress: hn) port: p!

hostName: hn
	"Answer a new instance with the given host name."

	^self new hostName: hn!

hostName: hn port: p
	"Answer a new instance with the given host name and port."

	^(self new hostName: hn) port: p!

thisHostAnyPort
	"Answer an instance which addresses this host through a system-assigned port."

	^self hostAddress: self thisHost port: self anyPort! !

!IPSocketAddress class methodsFor: 'private'!

allZeros: aByteArray
	"Answer true if the indexed fields are all 0."

	aByteArray do: [:e | 0 = e ifFalse: [^false]].
	^true!

bytesToName: aByteArray
	"Convert the bytes to the canonical printed representation."

	| ws |
	ws _ WriteStream on: (String new: 7).
	1 to: aByteArray size do: [:i | (aByteArray at: i) printOn: ws. i = aByteArray size ifFalse: [ws nextPut: $.]].
	^ws contents!

new: cnt
	"Create an new instance."

	^(super new: cnt) domainCode: 2.!

primHostAddressByName: aString
	"returns a ByteArray which is the IP address of the named host."

	<primitive: 640>
	((aString isString)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

primHostNameByAddress: aByteArray
	"returns a String which is the host name for the given IP address."

	<primitive: 645>
	((aByteArray isKindOf: ByteArray)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

stringToBytes: aString
	"Convert the string in canonical address format to a byte array."

	| ba rs fpi st i |
	ba _ ByteArray new: 4.
	st _ 1.
	i _ 1.
	[st <= aString size] whileTrue:
		[fpi _ aString indexOfSubCollection: '.' startingAt: st ifAbsent: [aString size + 1].
		rs _ ReadStream on: aString from: st to: fpi - 1.
		ba at: i put: (Integer readFrom: rs).
		i _ i + 1.
		st _ fpi + 1].
	^ba! !

!IPSocketAddress class methodsFor: 'naming utilities'!

hostAddressByName: aString
	"Answer the host address for the named host."

	aString = '-thishost-' ifTrue: [^self thisHost].
	(aString at: 1) isDigit ifTrue: [^self stringToBytes: aString].
	^self primHostAddressByName: aString!

hostNameByAddress: aByteArray
	"returns a String which is the host name for the given IP address, all zeros means thisHost."

	| nm |
	(self allZeros: aByteArray) ifTrue: [^'-thishost-'].
	nm _ self primHostNameByAddress: aByteArray.
	nm isNil ifTrue: [nm _ self bytesToName: aByteArray].
	^nm!

netAddressByName: aString
	"returns a ByteArray which is the IP address of the named network."
	<primitive: 641>
	((aString isString)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

netNameByAddress: aByteArray
	"returns a String which is the network name for the given IP address."
	<primitive: 646>
	((aByteArray isKindOf: ByteArray)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

protocolNameByNumber: aSmallInteger
	"returns a String which is the protocol name for the given IP protocol number."
	<primitive: 647>
	((aSmallInteger isMemberOf: SmallInteger)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

protocolNumberByName: aString
	"returns a SmallInteger which is the IP protocol number of the named protocol."
	<primitive: 642>
	((aString isString)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

serviceNameByPort: aByteArray
	"returns a String which is the service name for the given IP port number."
	<primitive: 648>
	((aByteArray isKindOf: ByteArray)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise!

servicePortByName: aString
	"returns a ByteArray which is the IP port number of the named service."
	<primitive: 643>
	((aString isString)
		ifTrue: [OSErrorHolder inaccessableSignal]
		ifFalse: [OSErrorHolder badArgumentsSignal]) raise! !

!IPSocketAddress class methodsFor: 'addressing'!

anyAddress
	"The IP broadcast address."
	"Someday, the broadcast address value will be 255 instead of 0."
	^ByteArray with: 0 with: 0 with: 0 with: 0!

broadcastAddressForNet: ba
	"Construct an IP broadcast address, given a network address."
	"Someday, the broadcast address value will be 255 instead of 0."
	^(ByteArray new: 4) replaceBytesFrom: 1 to: ba size with: ba startingAt: 1!

thisHost
	"The wildcard 'thisHost' address."
	^ByteArray with: 0 with: 0 with: 0 with: 0! !

!IPSocketAddress class methodsFor: 'constants'!

anyPort
	"Answer the anonymouse port number."

	^0!

firstUnreservedPort
	"Answer the first port number which is not reserved for WKPs."

	^1024!

maxPort
	"Answer the largest legal port number."

	^16rFFFF! !

!IPSocketAddress class methodsFor: 'documentation'!

allAboutHostAddresses
	"IP host addresses are 4 bytes long and are made up of a network
	number and a host-on-network number.  (Normally, though, we treat
	a host address as if it doesn't have any substructure.)  An IP host
	address doesn't really just identify a particular host, it identifies a
	particular network interface on a particular host.  Therefore, one host
	may have several host addresses.

	Host addresses by convention are printed as 4 decimal bytes with periods
	in between, viz: 192.9.200.2
	When we need to deal with host or network addresses as such (rather than
	embedded in a socket address) we just use (4-byte) ByteArrays.

	Just in case you're interested -- there are 3 types of network addresses:
		class A:		1-byte network number, 3-byte host number.
		class B:		2-byte network number, 2-byte host number.
		class C:		3-byte network number, 1-byte host number.
	...that is, there are a few class-A networks (where each can have
	very many hosts), there are a moderate number of class-B networks
	(where each can have a moderate number of hosts) and there are
	many class-C networks (where each can have a small number of hosts).
	Determination of network classes is made by the value of the first byte
	of a host address; small numbers are class-A, big numbers are class-C and
	the ones in-between are class-B.  Most networks are class-C (natch!!).
	This story gets more complicated in the case of subnets, which we won't
	discuss here.

	Broadcast addresses on a given network are formed by using as many
	zero bytes as needed to fill in the host number (someday, we're told,
	bytes with the value 255 will be used instead).  So, to reach all the hosts
	on the Arpanet (which is the class-A network #10) use: 10.0.0.0
	...and to reach all the hosts on a class-B network numbered 192.9.100
	use: 192.9.100.0
	There is no standard way to form multicast addresses in the IP domain.

	Just to make things confusing, an all-zero IP address is used to identify
	the current host to the BSD IP implementation.  That is, 0.0.0.0 means
	this-host through any available network interface.

	When a client wants to reach a server on the current host, the address
	127.0.0.1 ('localhost') is used.
"
	^self error: 'comment only'!

allAboutHostNames
	"People prefer to refer to hosts using a name rather than a
	string of digits.  So IP implementations usually have some sort of
	name-to-address directory in which an address can be looked up
	dynamically.

	To deal with the case where you have a host number but no name, 
	all the routines which deal with host names (which are Strings) can
	accept numeric strings in canonical format (i.e. 192.9.100.4).

	The class protocol ''naming utilities'' has methods to convert to/from
	host-names and host-addresses.
"
	^self error: 'comment only'!

allAboutPortNumbersAndNames
	"Port numbers are necessarily part of socket addresses because more
	than just a host-address is needed to identify a communicating entity
	on a given host.  That is, since each socket on a host needs a unique
	socket address and there will be many sockets with the same
	<address-family, host-address, protocol-number>, we need another field to
	provide uniqueness.

	IP port numbers are 2 bytes long and are normally treated as a 16-bit
	positive number.  Some port numbers are assigned in advance (Well Known Ports)
	and correspond to some standard service's connection-port.  Sockets which are
	not created for these standard purposes are dynamically assigned port numbers.

	As with hosts names, programmers prefer to refer to standard services using a name
	rather than a string of digits.  So IP implementations usually have some sort of
	serviceName-to-portNumber directory. The class protocol ''naming utilities'' has
	methods to convert to/from service-names and port-numbers.

	Assigning a new standard port number is an issue too complicated to be covered here.
	If you want to install a name-to-number correspondence that will have effect
	only on your local network, there will be platform-specific means to configure your
	local name-service.  (On Suns, this is done with the Yellow Pages).

	If your service is transient, or otherwise not appropriate for assigning a Well-Known
	Port-Number, you have 2 alternatives:
		1) Pick a random number between
				IPSocketAddress firstUnreservedPort
		and
				IPSocketAddress maxPort
		inclusive and hard-code this number into your client and server implementation.  Hope
		that no-one on the hosts you will be using has made the same choice.

		2) Let the system assign one for you (each time you start a server) by fire-ing up a
		server which creates a socket using port:
			IPSocketAddress anyPort
		then do a getName on that socket, print the port number and supply it to the client
		when you start it up.
"
	^self error: 'comment only'! !

UnixSocketAccessor initialize!
