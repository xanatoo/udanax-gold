'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!


!TextController methodsFor: 'menu messages'!

localMenuItem: selector
	^ #(cut paste copySelection again undo cancel accept changeTextStyle changeFont hardcopy) includes: selector! !

!Browser methodsFor: 'category functions'!

printOutCategory
		"Print the category."
	
	| stream |
	stream _ TextStream on: (String new: 1000).
	organization printOutCategory: category on: stream.
	self hardcopyStream: stream! !

!Browser methodsFor: 'class functions'!

printOutClass
	"Print the class."
	
	| stream |
	stream _ TextStream on: (String new: 1000).
	self nonMetaClass printOutOn: stream.
	self hardcopyStream: stream! !

!Browser methodsFor: 'protocol functions'!

printOutProtocol
	"Print out protocol."

	| stream |
	stream _ TextStream on: (String new: 1000).
	self selectedClass printOutCategory: protocol on: stream.
	self hardcopyStream: stream! !

!Browser methodsFor: 'selector functions'!

printOutMessage
	"Print the method."
	
	| stream |
	stream _ TextStream on: (String new: 1000).
	self selectedClass printMethod: selector on: stream.
	self hardcopyStream: stream! !

!Browser methodsFor: 'private'!

hardcopyStream: aStream

	| document |
	Cursor wait
		showWhile: 
			[document _ Document new.
			document startParagraph.
			document addText: aStream contents asText.
			document close.
			document toPrinter]! !



!ParagraphEditor methodsFor: 'menu messages'!

hardcopy
	"Print out my text"

	| document |
	self controlTerminate.
	Cursor wait
		showWhile: 
			[document _ Document new.
			document startParagraph.
			document addText: self text under: paragraph textStyle.
			document close.
			document toPrinter].
	self controlInitialize.! !


!Behavior methodsFor: 'fileIn/Out'!

printMethod: selector on: aStream
	"Print the source code for the method associated with the argument selector onto
	the stream."

	| source emphasis parser length |
	aStream cr; cr.
	source _ (self sourceMethodAt: selector) asString.
	emphasis _ aStream emphasis.
	aStream emphasis: 2.
	(parser _ self parserClass new) parseSelector: source.
	length _ parser endOfLastToken min: source size.
	aStream nextPutAll: (source copyFrom: 1 to: length).
	aStream emphasis: emphasis.
	aStream nextPutAll: (source copyFrom: length + 1  to: source size)! !


!ClassDescription methodsFor: 'fileIn/Out'!

printOutCategory: aSymbol on: aStream 
	"File a description of the receiver's category, aSymbol, onto aStream."
	|saved|
	saved _ aStream emphasis.
	aStream emphasis: 2.
	aStream cr.
	aStream nextPutAll: self name , ' methodsFor: ' , aSymbol.
	aStream emphasis: saved.
	(self organization listAtCategoryNamed: aSymbol)
		do: [:sel | self printMethod: sel on: aStream].
	aStream cr!

printOutOn: aStream
	"Print me out on a textStream"
	|saved|
	saved _ aStream emphasis.
	aStream emphasis: 11.		"Meant to be 12 point bold font."
	aStream nextPutAll: self definition.
	aStream cr.
	aStream emphasis: 3.		"meant to be 10 point italic font"
	aStream cr.
	aStream nextPutAll: self comment.
	aStream emphasis: saved.
	aStream cr.
	self organization categories do: 
		[:heading | self printOutCategory: heading on: aStream].
	aStream cr.
	aStream cr! !


!SystemOrganizer methodsFor: 'fileIn/Out'!

printOutCategory: category on: aStream
	| first |
	first _ true.
	(self superclassOrder: category) do: 
		[:class | 
		first
			ifTrue: [first _ false]
			ifFalse: [aStream cr; nextPut: Character newPage; cr].
		class
			printOutOn: aStream]! !


!Class methodsFor: 'fileIn/Out'!

printOutOn: aStream
	"Print me out on aStream"

	super printOutOn: aStream.
	self class nonTrivial
		ifTrue:[self class printOutOn: aStream]! !
