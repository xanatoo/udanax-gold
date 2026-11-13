MacFilename subclass: #MacOSFilename
	instanceVariableNames: 'volumeReference '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OS-Mac-Support'!
MacOSFilename comment:
'MacOSFilename adds the notion of a VREF to the filename.  Allows the Advanced Macintosh/Smalltalk programmer to use the Macintosh Standard File Utilities to get and put files.  Allows application writers to get a list of the files clicked to run the VM/VI.  Adds the ''getInfo'' capability to determine the file type, creator, data size, res. size, creation date, mod date.'!

!MacOSFilename methodsFor: 'utilities'!

stringFromVRef
	" get the equiv string from vRef"

	^self stringFromVRefErrInto: self errorReporter new!

putFileWithPrompt: aString
	" put file via StdFile manager"

	^self putFileWithPrompt: aString errInto: self errorReporter new! !

!MacOSFilename methodsFor: 'accessing'!

volumeReference
	^volumeReference! !

!MacOSFilename methodsFor: 'private'!

named: aString volumeReference: aNumber

	super named: aString.
	volumeReference _ aNumber!

getFileInfoErrInto: errorHandler
	" put file via StdFile manager"
	<primitive: 758>

	^errorHandler reportError!

stringFromVRefErrInto: errorHandler
	" get the equiv string from vRef"
	<primitive: 759>

	^errorHandler reportError!

getFileInfo
	"get file statistics"
	" (MacOSFilename getFileTypes: #('TEXT' 'HPSF') ) getFileInfo"
	| stat bytes dts |
	stat _ self getFileInfoErrInto: self errorReporter new.
	bytes _ stat at: 6.
	dts _ IdentityDictionary new: 2.
	1 to: 2 do: 
		[:i | 
		| secs start dateAndTime |
		start _ i - 1 * 4 + 1.
		secs _ UninterpretedBytes with: bytes from: start to: start + 3.
		(secs unsignedLongAt: 1) = 0
			ifTrue:	[dateAndTime _ nil]
			ifFalse:	[dateAndTime _ Time aTime: (secs unsignedLongAt: 1)].

		dts at: (#(created modified) at: i)
			put: dateAndTime].
	stat at: 6 put: dts.
	^stat!

putFileWithPrompt: aString errInto: errorHandler
	" put file via StdFile manager"
	<primitive: 757>

	^errorHandler reportError! !

!MacOSFilename class methodsFor: 'instance creation'!

getFileTypes: aArray
	" get file via StdFile manager"
	"MacOSFilename getFileTypes: nil"
	"MacOSFilename getFileTypes: #('TEXT' 'HPS3')"

	^self getFileTypes: aArray errInto: self errorReporter new!

getStarupFiles
	" get statup files via finder"
	"MacOSFilename getStarupFiles"

	^self getStarupFilesErrInto: self errorReporter new! !

!MacOSFilename class methodsFor: 'primitives'!

getFileTypes: aArray errInto: errorHandler
	" get file via StdFile manager"

	<primitive: 756>
	^errorHandler reportError!

getStarupFilesErrInto: errorHandler
	" get statup files via finder"

	<primitive: 761>
	^errorHandler reportError! !


Object subclass: #SoundManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OS-Mac-Support'!

!SoundManager methodsFor: 'primitives'!

enumerateSoundsFrom: aFileOrNil
	" argument is a MacFilename or nil. Returns
	an array of Strings of the names of sounds"
	"SoundManager new enumerateSoundsFrom: nil "

	<primitive: 772>
	^self primitiveFailed!

playSoundFrom: aFileOrNil sound: aString
	" argument aFileOrNil is a MacFilename or nil.
	argument aString is the identifier for a sound.
	 Returns true or false."
	"SoundManager new playSoundFrom: nil sound: 'Simple Beep'"

	<primitive: 773 >
	^self primitiveFailed!

simpleBeep: aNumber
	" argument is a number, Plays the system beep
	associated with the number.  Returns true or false"
	"SoundManager new simpleBeep: 1 "

	<primitive: 774 >
	^self primitiveFailed! !


!Form class methodsFor: 'instance creation'!

fromClipboard
	"Answer an instance of the receiver with bitmap initialized from a
 	 PICT in the Macintosh clipboard."

	^Form new fromClipboard! !

!Form methodsFor: 'fileIn/Out'!

fromClipboard
	"Answer an instance of the receiver with bitmap initialized from a
 	 PICT in the Macintosh clipboard."

	<primitive: 778>! !


!Form methodsFor: 'fileIn/Out'!

toClipboard
	"Store an instance of form to the clipboard in PICT format"

	<primitive: 777>! !

