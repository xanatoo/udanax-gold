!PostScriptPrinter class methodsFor: 'printing'!

sendToPrinter
	"Send the temp file to the printer via a system call, or   
	print a failure message."

	Transcript show: 'sending to printer... '.
	Filename errorReporter unsupportedOperationSignal
		handle: [:ex |
				Transcript show: ex errorString.
				ex return]
		do: [TempFileName asFilename printFile.
			Transcript show: ' ...done.'; cr]! !

!MacFilename methodsFor: 'utilities'!

printFile
	" print a postScript file via print manager"

	^self printFileErrInto: self errorReporter new! !

!MacFilename methodsFor: 'private'!

printFileErrInto: errorHandler
	" print a postScript file via print manager"
	<primitive: 770>

	^errorHandler reportError! !

!UnixFilename methodsFor: 'utilities'!

printFile
	"print a PostScript file--may be installation specific."

	| cmd proc reply connection |
	connection _ UnixProcess pipeConnectionFor: 'lpr'
			arguments: (Array with: nameString)
			setProcessDescriptor: [:pd | proc _ pd].
	[cmd _ connection readStream.
	reply _ cmd contents.
	proc wait]
		valueNowOrOnUnwindDo:
			[connection close.
			"Process will remove itself, eventually"].
	Transcript show: reply! !

!DosFilename methodsFor: 'utilities'!

printFile
	"print a PostScript file"

	self errorReporter unsupportedOperationSignal raise! !

