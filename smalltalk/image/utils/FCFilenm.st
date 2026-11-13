'From Smalltalk-80, Version 2.3 of 13 June 1988 on 29 September 1988 at 11:53:05 pm'!

"Only permit file-in in versions < 2.4"
(Smalltalk includesKey: #BlockClosure) ifTrue:
[self error: 'This file-in implements forward-compatible V2.4/2.5
Filename support for V2.3 -- it is intended for use in V2.3 systems only!!']!

!String methodsFor: 'converting'!

asFilename

	^Filename named: self! !


Object subclass: #Filename
	instanceVariableNames: 'nameString '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OS-Support'!
Filename comment:
'I am an abstract class.  Instances of my subclasses encapsulate the
platform-specific syntax of OS file pathnames.  Actually, this class
can almost be used as a concrete class, except name syntax is not
interpreted.

There is standard protocol provided to do most of the things that OS''s
can do with references to files -- deleteing, renaming, etc.

Instance Variables:
	nameString	<String> Platform-specific syntax naming a file.
				Primitives "know" that the nameString is the first instance variable.

Class Variables:
	DefaultDirectory	<Filename>
						Starting point for relative references.
	Separator			<Character>
						OS''s standard lexime used to seperate components of a name.
	DefaultClass		<Metaclass>
						The appropriate concrete subclass for this platform.
'!


!Filename methodsFor: 'instance creation'!

construct: extraFn
	"Make a new instance, treating the receiver as a directory, and
	the string argument as a file within the pathname."

	| ws prefix suffix |
	prefix _ nameString.
	suffix _ (extraFn at: 1) = FileDirectory separator ifTrue: [extraFn copyFrom: 2 to: extraFn size] ifFalse: [extraFn].
	ws _ WriteStream on: (String new: prefix size + suffix size + 1).
	ws nextPutAll: prefix; nextPut: FileDirectory separator; nextPutAll: suffix.
	^self class named: ws contents! !

!Filename methodsFor: 'converting'!

asFilename
	"Answer self"

	^self!

asString
	"Answer the OS-specific name string."

	^nameString! !

!Filename methodsFor: 'file utilities'!

copyTo: destName
	"Copy the file whose name is the receiver to a file named destName."

	FileDirectory copyFileNamed: nameString to: destName asString!

delete
	"Delete the reference to the named file (which is slightly different
	than saying 'deleting the file', but means the same thing in most cases)."

	FileDirectory removeKey: nameString!

directoryContents
	"Returns Array of strings -- the contents of the directory.
	Not Array of Filenames because we'd have to prepend directory names."

	^(FileDirectory named: nameString) contents!

exists
	"Answer true if the named file exists."

	^FileDirectory includesKey: nameString!

fileSize
	"Answer the size (in bytes) of the corresponding file."

	| file size | 
	file _ self readStream.
	size _ file size.
	file close.
	^size!

makeDirectory
	"Create a directory with this name."

	SystemCall makeDirectory: nameString!

moveTo: destName
	"Copy the file whose name is the receiver to a file named destName."

	self copyTo: destName.
	self delete!

renameTo: aFileName
	"Substitute the new name for the old one (a.k.a. 'rename the file')."

	FileDirectory rename: nameString newName: aFileName asString! !

!Filename methodsFor: 'testing'!

isAbsolute
	"Answer true if this name is absolute (e.g. not relative to the
	'current directory')."

	^(nameString at: 1) == FileDirectory separator!

isDirectory
	"Answer true if this name refers to a directory."

	^FileDirectory isDirectory: nameString!

isRelative
	"Answer true if this name must be interpreted relative to some
	directory."
	^self isAbsolute not!

isWritable
	"Answer true if the named file is writable by the current user."

	^FileDirectory canWriteFile: self! !

!Filename methodsFor: 'parsing'!

head
	"Answer the directory prefix as a String."

	| indx |
	indx _ self lastIndexOf: FileDirectory separator.
	^(self isAbsolute or: [indx > 0])
		ifTrue: [indx = 1
					ifTrue: [String with: FileDirectory separator]
					ifFalse: [nameString copyFrom: 1 to: indx - 1]]
		ifFalse: [self class defaultDirectory asString]!

tail
	"Answer the filename suffix as a String."

	| indx |
	indx _ self lastIndexOf: FileDirectory separator.
	^(self isAbsolute or: [indx > 0])
		ifTrue: [nameString copyFrom: indx + 1 to: nameString size]
		ifFalse: [nameString copy]! !

!Filename methodsFor: 'printing'!

printOn: aStream
	"Append to the argument aStream a sequence of characters that identifies the receiver."
	"Amplifies method in superclass to add name string."

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: self asString.
	aStream nextPut: $)! !

!Filename methodsFor: 'defaulting'!

defaultClass
	^self class defaultClass! !

!Filename methodsFor: 'stream creation'!

appendStream
	"Answer a write stream connected to the file represented by
	the receiver."

	^(FileStream fileNamed: nameString) writeShorten; setToEnd!

newReadAppendStream
	"Answer a new readAppend stream connected to the file represented by
	the receiver."

	self notify: 'Not available--proceed for readWrite stream'.
	^(FileStream newFileNamed: nameString) readWrite; setToEnd!

newReadWriteStream
	"Answer a new readWrite stream connected to the file represented by
	the receiver."

	^(FileStream newFileNamed: nameString) readWrite!

readAppendStream
	"Answer a readAppend stream connected to the file represented by
	the receiver."

	self notify: 'Not available--proceed for readWrite stream'.
	^(FileStream fileNamed: nameString) readWrite; setToEnd!

readStream
	"Answer a read stream connected to the file represented by
	the receiver."

	^(FileStream fileNamed: nameString) readOnly!

readWriteStream
	"Answer a readWrite stream connected to the file represented by
	the receiver."

	^(FileStream fileNamed: nameString) readWrite!

writeStream
	"Answer a write stream connected to the file represented by
	the receiver."

	^(FileStream newFileNamed: nameString) writeShorten! !

!Filename methodsFor: 'utilities'!

contentsOfEntireFile
	"Answer the contents of the file represented by
	the receiver."

	^self readStream contentsOfEntireFile!

edit
	"Edit the contents of the file represented by
	the receiver."

	self readStream edit!

fileIn
	"FileIn the contents of the file represented by
	the receiver."

	^self readStream fileIn!

fileOutChanges
	"FileOut changes on the file represented by
	the receiver."


	self writeStream fileOutChanges!

fileOutChangesFor: class
	"FileOut changes for class on the file represented by
	the receiver."

	self writeStream fileOutChangesFor: class! !

!Filename methodsFor: 'private'!

lastIndexOf: aChar 
	"Answer the index of the last character in my nameString which 
	matches aChar, if none, answer 0."
	"Used to split nameStrings into head and tail components."

	nameString size
		to: 1
		by: -1
		do: [:i | (nameString at: i)
				= aChar ifTrue: [^i]].
	^0!

named: n
	"Set the OS-specific pathname."
	"Only appropriate at instance creation."

	nameString _ n.
	(nameString last == FileDirectory separator and: [nameString size > 1])
		ifTrue: [nameString _ nameString copyFrom: 1 to: nameString size -1]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Filename class
	instanceVariableNames: ''!


!Filename class methodsFor: 'class initialization'!

findDefaultDirectory
	"Determine the default directory name and cache it as a Filename.
	Typically done at snapshot-return time."

	^SystemCall currentWorkingDirectory asFilename!

install
	"You are the default class for Filenames, install yourself."
	"Do nothing for abstract classes."! !

!Filename class methodsFor: 'instance creation'!

named: str
	"Answer a new Filename with the supplied name string."
	"Avoid infinite recursion if there is no concrete subclass."

	^self new named: str! !

!Filename class methodsFor: 'defaults'!

defaultClass
	"Answer the appropriate concrete subclass."

	^self!

defaultDirectory
	"Answer the default directory (e.g. interpretation starting point for
	relative names)."

	^self findDefaultDirectory!

defaultDirectoryName
	"Answer the default directory (e.g. interpretation starting point for
	relative names)."

	^self defaultDirectory asString! !

!Filename class methodsFor: 'constants'!

separator
	"Answer the filename separator."

	^FileDirectory separator! !