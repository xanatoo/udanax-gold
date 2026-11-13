Object subclass: #SoundPlayer
	instanceVariableNames: 'list fileName '
	classVariableNames: 'Sound '
	poolDictionaries: ''
	category: 'Framework-Sound'!
SoundPlayer comment:
'A SoundPlayer represents an interface to the hardware platform''s ability to generate sound.

Instance Variables:
	list			<OrderedCollection>	of phrases that the instance can say
	fileName	<String>		name of the file in which the sound resources are found;
								nil if the sound resources are in the platform system resources

Class Variables:
	Sound		<SoundPlayer>a SoundPlayer on the system resource
								caching this instance speeds up some applications'!


!SoundPlayer methodsFor: 'playing'!

play: aString 
	"Say the phrase aString.  Notify the user if the phrase can 
	not be said."

	(self canPlay: aString asString) 
		ifFalse: [Transcript space; show: aString]
		ifTrue: [self play: fileName from: aString asString]!

play: aString for: anObject
	"Say the phrase aString.  Notify the user if the phrase can 
	not be said."

	(self canPlay: aString asString) 
		ifFalse: [Transcript space; show: aString]
		ifTrue: [self play: fileName from: aString asString]! !

!SoundPlayer methodsFor: 'accessing'!

canPlay: aString 
	"Answer whether or not the receiver can say the words in 
	aString."

	^list includes: aString!

fileNamed: aString 
	"Set the name of the file where the sound information is 
	stored to be aString.  Initialize the list of phrases as well."

	(aString isNil or: [aString isEmpty])
		ifTrue:	[fileName := nil]
		ifFalse:	[fileName := aString asFilename.
				fileName exists
					ifFalse: [self error: fileName asString, ' does not exist']].
	list :=  self enumerateSoundFrom: fileName.!

playList
	"Answer the collection of phrases that the receiver can say."

	^list! !

!SoundPlayer methodsFor: 'private'!

enumerateSoundFrom: aString 
	"Call on the system primitive to make the sound denoted by 
	aString. "

	<primitive: 772>
	"If the primitive fails, then there is no sound available, so 
	ignore. "
	^Array new!

play: aString from: bString 
	"Call on the system primitive to make the sound found in the 
	file named aString as denoted by bString."

	<primitive: 773>
	"If the primitive fails, then there is no sound available, so 
	ignore. "
	^nil! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SoundPlayer class
	instanceVariableNames: ''!


!SoundPlayer class methodsFor: 'instance creation'!

initSystem
	"Create a new instance of the receiver that looks for its  
	sounds from the system resources rather than from a file."

	Sound := self new fileNamed: nil!

onFileNamed: aString 
	"Create an instance of the receiver.  Set the file name from 
	which sounds are found to be aString. The file name is nil if 
	the sounds are in the system resource."

	^self new fileNamed: aString!

onSystem
	"Create a new instance of the receiver that looks for its  
	sounds from the system resources rather than from a file."

	^Sound isNil 
		ifTrue: [Sound := self new fileNamed: nil]
		ifFalse: [Sound]! !

!SoundPlayer class methodsFor: 'examples'!

sample
	"This example prompts the user to type a sound or phrase 
	to be played and then attempts to carry out the request."

	"SoundPlayer sample"

	| sound |
	sound := FillInTheBlank request: 'Type the sound or phrase to be played' initialAnswer: 'Simple Beep'.
	sound isNil ifTrue: [^self].
	Sound play: sound! !