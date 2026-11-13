'From Smalltalk-80, Version 2.4 of 19 September 1988 on 3 October 1988 at 11:09:05 am'!

!FileConnection methodsFor: 'renaming'!

rename: newFileName
	"Rename the receiver to be newFileName.  Inform the OS as well."

	fileName asFilename renameTo: newFileName.
	fileName _ newFileName asString! !


ExternalReadWriteStream subclass: #FileStream
	instanceVariableNames: 'rwmode '
	classVariableNames: 'Read Shorten Write '
	poolDictionaries: ''
	category: 'OS-Streams'!
FileStream comment:
'FileStreams are for backwards compatibility.  They work the same way as an ExternalReadWriteStream. They are opened in readWrite mode from the point of view of the operating system.  They maintain their own flags for file mode as well as implementing some utility messages. 

Instance Variables:

	rwmode			<Integer>			the modes are ReadOnly ReadWrite ReadWriteShorten WriteShorten
	
Class Variables:

	Read			<Integer> mode constant = 1
	Shorten			<Integer> mode constant = 2
	Write 			<Integer> mode constant = 4
'!


!FileStream methodsFor: 'accessing'!

contentsOfEntireFile
	"Answer the contents of the receiver."

	| s |
	self readOnly.
	self reset.
	s _ self next: self size.
	self close.
	^s! !

!FileStream methodsFor: 'editing'!

edit
	"Create and schedule a FileView of the contents of the receiver.
	The label of the view is the name of the receiver. "

	FileModel 
		open: (FileModel fileStream: self)
		named: self name! !

!FileStream methodsFor: 'file accessing'!

file
	"Answer the file that the receiver is streaming over."

	^ioConnection!

fileName
	"Answer the name of the file being streamed over."

	^self name!

fullName
	"Answer the name of the file being streamed over."

	^self name!

rename: newFileName 
	"Change the name of the receiver's file to be newFileName."

	ioConnection rename: newFileName! !

!FileStream methodsFor: 'file status'!

release
	"Close the receiver. Do not shorten the file"


	self closed ifTrue: [^self].
	super closeConnection.
	ioBuffer _ nil.
	collection _ collection species new: 0.
	self removeDependency! !

!FileStream methodsFor: 'file modes'!

readOnly
	"Set the receiver's mode so that pages are not flushed and reading stops at end of file."

	self setMode: Read!

readWrite
	"Set the receiver's mode so that pages are flushed, end of file can be extended by
	writing, and closing does not truncate file." 

	self setMode: Read + Write!

readWriteShorten
	"Same as readWrite except close truncates file at current position."

	self setMode: Read + Write + Shorten!

writeShorten
	"Allow write and shorten the receiver's file upon closing." 

	self setMode: Write + Shorten! !

!FileStream methodsFor: 'fileIn/Out'!

fileIn
	"File in the contents of the receiver."
 
	Transcript refresh; cr; cr; show: 'Filing in from:'; crtab; show: self name; cr.
	self readOnly.
	^super fileIn!

fileOutChanges
	"Append to the receiver a description of all system changes."
 
	Transcript refresh; cr; cr; show: ('Filing out changes on:'); crtab; show: self name.
	super fileOutChanges!

fileOutProjectStatistics
	"Write the current changeSet in the form of a report."

	Cursor write showWhile:
		[Project putStatsOn: self.
		self close]!

printOutChanges
	"Print out a description of all system changes." 

	self fileOutChanges! !

!FileStream methodsFor: 'private'!

closeConnection
	"Close the receiver's io connection."

	self writing 
		ifTrue: [(rwmode bitAnd: Shorten) = Shorten
					ifTrue: [self shorten]
					ifFalse: [self flush]].
	^super closeConnection!

setMode: m 
	"Set the mode and flush if changing from Write to ReadOnly."

	rwmode = m 
		"don't flush if first time or not write mode or continuing write mode"
		ifFalse: [((rwmode bitAnd: Write) = 0 or: [(m bitAnd: Write) = Write])
					ifTrue: [rwmode _ m]
					ifFalse: 
						[self commit.
						rwmode _ m]]!

setupBufferAndLimits
	"Initialize the ioBuffer and limits."

	rwmode _ Read + Write + Shorten.
	super setupBufferAndLimits.!

shorten
	"Shorten the file."
	"Normally called by close and not directly by user."

	self flush.
	readLimit _ position.
	IOAccessor unsupportedOperationSignal
		handle: 
			[:ex | 
			| tmp pos myFile todo buffer |
	
			tmp _ IOAccessor openFileWriteOnly: 'temp.tmp' asFilename.
			todo _ pos _ self position.
			myFile _ ioConnection input.
			myFile seekTo: 0.
			buffer _ ByteArray new: tmp bufferSize.
			[todo = 0]
				whileFalse: 
					[| n |
					n _ myFile
						readInto: buffer
						startingAt: 1
						for: (buffer size min: todo).
					tmp
						writeFrom: buffer
						startingAt: 1
						for: n
						untilFalse: [:cnt | true].
				todo _ todo - n].
			tmp close.
			super closeConnection.
			'temp.tmp' asFilename renameTo: super name asFilename.
			self reopen.
			self position: pos]
		do: [ioConnection input truncateTo: self position]!

writing
	"Answer whether it is possible to write on the receiver." 

	^rwmode anyMask: Write! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

FileStream class
	instanceVariableNames: ''!


!FileStream class methodsFor: 'class initialization'!

initialize
	"Initialize important constants."

	"FileStream initialize"	

	Read _ 1.
	Write _ 2.
	Shorten _ 4! !

!FileStream class methodsFor: 'instance creation'!

fileNamed: aFileName
	"Create an instance of the receivers that streams over aFileName."

	| fileStream filename|
	filename _ aFileName asFilename.
	filename exists
		ifTrue: [filename isWritable
					ifTrue: [fileStream _ self on: (FileConnection
											openFileNamed: aFileName
											mode: #readWrite
											creationRule: #noCreate)]
					ifFalse: [fileStream _ self on: (FileConnection
											openFileNamed: aFileName
											mode: #readOnly
											creationRule: #noCreate).
							fileStream readOnly]]
		ifFalse: [fileStream _ self on: (FileConnection
								openFileNamed: aFileName
								mode: #readWrite
								creationRule: #mayCreate)].
	^fileStream!

newFileNamed: aFileName 
	"Create an instance of the receivers that streams over aFileName.
	The file is created or truncated."

	^self on: (FileConnection
			openFileNamed: aFileName
			mode: #readWrite
			creationRule: #truncateOrCreate)!

oldFileNamed: aFileName 
	"Create an instance of the receivers that streams over aFileName.
	The file must exist."

	| fileStream filename|
	filename _ aFileName asFilename.
	filename exists
		ifTrue: [filename isWritable
					ifTrue: [fileStream _ self on: (FileConnection
											openFileNamed: aFileName
											mode: #readWrite
											creationRule: #noCreate)]
					ifFalse: [fileStream _ self on: (FileConnection
											openFileNamed: aFileName
											mode: #readOnly
											creationRule: #noCreate).
							fileStream readOnly]]
		ifFalse: [self error: 'file does not exist'.
				fileStream _ self on: (FileConnection
								openFileNamed: aFileName
								mode: #readWrite
								creationRule: #mayCreate)].
	^fileStream! !

FileStream initialize!
