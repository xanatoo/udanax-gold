!InteractiveCompilerErrorHandler methodsFor: 'private'!

getChoiceMenu

	^ActionMenu
		labels: 'temp\class var\global\undeclared\correct it\abort' withCRs
		lines: #(4)
		selectors: #(declareTemp:from: declareClassVar:from: declareGlobal:from: declareUndeclared:from: declareCorrect:from: declareFailed:from:)! !

!InteractiveCompilerErrorHandler methodsFor: 'interaction'!

undeclared: association at: sourceRange from: codeStream
	| menu index |
	Cursor normal show.
	self selectRange: sourceRange.
	index := (menu := self getChoiceMenu)
				startUp: #anyButton
				withHeading: ' declare ' asText , (association key contractTo: 20) asText allBold , ' as ' asText.
	index = 0 ifTrue: [^self declareFailed: association from: codeStream].
	^self perform: (menu selectorAt: index) with: association with: codeStream! !

!SmalltalkCompiler methodsFor: 'private'!

getInteractiveCompilerErrorHandler

	^InteractiveCompilerErrorHandler new
		class: class;
		editor: requestor!

translate: aStream noPattern: noPattern ifFail: failBlock needSourceMap: mapFlag handlerClass: handlerClass
	"The handler class is used only for non-interactive mode."
	"Do things this way to avoid creating a circularity."
	| startPos endPos |
	startPos := aStream position.
	^requestor == nil
		ifTrue:
			["Non-interactive mode"
			self
				translate: aStream
				noPattern: noPattern
				ifFail: failBlock
				needSourceMap: mapFlag
				handler: 
					((handlerClass new
						class: class;
						source: aStream)
					  failBlock: [^failBlock value])]
		ifFalse:
			["Interactive mode"
			aStream setToEnd.
			endPos := aStream position.
			aStream position: startPos.
			self
				translate: aStream
				noPattern: noPattern
				ifFail: failBlock
				needSourceMap: mapFlag
				handler: 
					((self getInteractiveCompilerErrorHandler)
					  failBlock: [^failBlock value];
					  retryBlock:
						[:lengthChange |
						^self
							translate: (ReadStream on: requestor text asString from: startPos + 1 to: endPos + lengthChange)
							noPattern: noPattern
							ifFail: failBlock
							needSourceMap: mapFlag
							handlerClass: handlerClass])]! !

