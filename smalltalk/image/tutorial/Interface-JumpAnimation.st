PictureSequenceMonitor subclass: #JumperSequenceMonitor
	instanceVariableNames: ''
	classVariableNames: 'Man Woman '
	poolDictionaries: ''
	category: 'Interface-JumpAnimation'!
JumperSequenceMonitor comment:
'An instance of JumperSequenceMonitor represents an element of a jumper animation, and therefore expects to animate sitting, standing, whirling, jumping, pointing, and pouting behavior.

Class Variables:
	Man		<Dictionary>	whose keys are the names of an animation, and 
								whose values are instances of AnimationSequence
	Woman		<Dictionary>	whose keys are the names of an animation, and 
								whose values are instances of AnimationSequence'!


!JumperSequenceMonitor methodsFor: 'initialize-release'!

man
	"Set the receiver to represent the image of a Man."

	seqDictionary := Man!

woman
	"Set the receiver to represent the image of a Woman."

	seqDictionary := Woman! !

!JumperSequenceMonitor methodsFor: 'updating'!

pointing: anArgument 
	"anArgument is the state of the object to be animated.   
	If the animation is of an object that is not sitting, then have 
	the object sitdown.  Then animate a pointing action."

	anArgument == #sitting ifFalse: [self runSitDown].
	^self runPoint!

pouting: anArgument 
	"anArgument is the state of the object to be animated.   
	If the animation is of an object that is not sitting, then have 
	the object sitdown.  Then animate a pouting action."

	anArgument == #sitting ifFalse: [self runSitDown].
	^self runPout!

sitting: anArgument
	"anArgument is the state of the object to be animated.   
	If the animation is of an object that is standing or whirling,
	then have the object sit down.  Otherwise, if the object is
	pouting or pointing, then set the object to its current image
	of sitting or standing."

		(anArgument == #standing or: [anArgument == #whirling])
					ifTrue: [^self runSitDown].
		(anArgument == #pouting or: [anArgument == #pointing])
					ifTrue: [^self setCurrentState].!

standing: anArgument 
	"anArgument is the state of the object to be animated.   
	If the animation is of an object that is sitting, then have
	the object stand up."

		anArgument == #sitting ifTrue: [^self runStandUp].!

whirling: anArgument
	"anArgument is the state of the object to be animated.   
	If the animation is of an object that is standing, then have
	the object whirl around.  If the object is sitting, have it
	stand up before it whirls around."

			anArgument == #standing
				ifTrue: [^self runWhirlAround].

			anArgument == #sitting
				ifTrue: [self runStandUp.
						^self runWhirlAround]! !

!JumperSequenceMonitor methodsFor: 'movies'!

runPoint
	"Display the movie of the animated object pointing to another 
	object. "

	currentSeq := seqDictionary at: #pointing.
	self runCurrentSeq!

runPout
	"Display the movie of the animated object pouting."

	currentSeq := seqDictionary at: #pout.
	self runCurrentSeq!

runSitDown
	"Display the movie of the animated object sitting down."

	currentSeq := seqDictionary at: #down.
	self runCurrentSeq!

runStandUp
	"Display the movie of the animated object standing up."

	currentSeq := seqDictionary at: #up.
	self runCurrentSeq!

runWhirlAround
	"Display the movie of the animated object whirling around."

	currentSeq := seqDictionary at: #whirl.
	2 timesRepeat: [self runCurrentSeq]! !

!JumperSequenceMonitor methodsFor: 'private'!

setCurrentState
	"Based on the state of the animated object, set the item's form to 
	be of a sitting or standing person."

	super setCurrentState.
	state == #sitting
		ifTrue: [^outputMedium display: (seqDictionary at: #down) pictures last].
	state == #standing
		ifTrue: [^outputMedium display: (seqDictionary at: #up) pictures last]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

JumperSequenceMonitor class
	instanceVariableNames: ''!


!JumperSequenceMonitor class methodsFor: 'constants'!

manSitting
	"Answer the image of a man sitting down."

	^(Man at: #down) pictures last!

womanSitting
	"Answer the image of a woman sitting down."

	^(Woman at: #down) pictures last! !

!JumperSequenceMonitor class methodsFor: 'class initialization'!

getPictures
	"Retrieve all of the pictures needed to animate images of a woman 
	and a man in sitting, standing, whirling, pouting, and pointing, 
	positions. The user is asked to specify the directory or file folder in 
	which the pictures can be found."

	"JumperSequenceMonitor getPictures"

	| dirName |
	dirName := FillInTheBlank request: 'Name of Directory for Jumper Pictures'.
	Man := BinaryStorage fromFileNamed: dirName , 'Man-Animations'.
	Woman := BinaryStorage fromFileNamed: dirName , 'Woman-Animations'!

getPictures: dirName
	"Retrieve all of the pictures needed to animate images of a woman 
	and a man in sitting, standing, whirling, pouting, and pointing, 
	positions."

	Man := BinaryStorage fromFileNamed: dirName , 'Man-Animations'.
	Woman := BinaryStorage fromFileNamed: dirName , 'Woman-Animations'! !

!JumperSequenceMonitor class methodsFor: 'instance creation'!

man: anObject 
	"Save the parameter anObject as the model or object 
	animated by a new instance of the receiver.  This new
	instance represents a man."

	| body |
	body := self new.
	body man.
	body monitor: anObject.
	^body!

woman: anObject
	"Save the parameter anObject as the model or object 
	animated by a new instance of the receiver.  This new
	instance represents a woman."

	| body |
	body := self new.
	body woman.
	body monitor: anObject.
	^body! !