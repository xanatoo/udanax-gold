Object subclass: #AnimationSequence
	instanceVariableNames: 'pictures deltas names '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Animation'!
AnimationSequence comment:
'An instance of AnimationSequence is a data structure for a collection for display objects (forms) and an offset used in displaying each display object.  It also has a name for each display object that can be used, for example, in an animation editor.
 
Instance Variables:
	pictures	<SequenceableCollection of: DisplayObjects> usually Forms
	deltas		<SequenceableCollection of: Points>
	names		<SequenceableCollection of: Symbols>'!


!AnimationSequence methodsFor: 'accessing'!

deltas
	"Answer the receiver's deltas."

	^deltas!

names
	"Answer the receiver's collection of names that name
	each picture."

	^names!

names: anArray
	"Set the receiver's collection of names that name
	each picture to be anArray."

	deltas := anArray!

pictures
	"Answer the receiver's collection of pictures."

	^pictures!

pictures: anArray
	"Set the receiver's collection of pictures to be anArray."

	pictures := anArray!

size
	"Answer the size of the receiver's picture collection."

	^pictures size! !

SelectiveMonitor subclass: #PictureSequenceMonitor
	instanceVariableNames: 'state seqDictionary currentSeq '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Animation'!
PictureSequenceMonitor comment:
'An instance of PictureSequenceMonitor represents the possible ways in which an object can be viewed dynamically as an animated sequence.  The choice of sequence is dependent on the state of the object. The outputMedium is an object that knows a visual presentation function, and that basically has a relative display area and a form.

Different subclasses would specify the state of the monitored object that it wishes to animate. In that sense, a subclass is rarely general.

Instance Variables:
	state 			<Symbol>	denoting the current state of the object, used to select an image or sequence of images
	seqDictionary 	<Dictionary>	of possible AnimationSequences to be keyed by the state of the object
	currentSeq 		<AnimationSequence>	the current images used to display the object'!


!PictureSequenceMonitor methodsFor: 'accessing'!

outputMedium: aDisplayItem
	"Set the display item for the receiver to be aDisplayItem."

	super outputMedium: aDisplayItem.
	self setCurrentState!

runCurrentSeq
	"Animation is accomplished by showing each picture in the currently 
	chosen sequence, delaying a short time between displays."
	
	1 to: currentSeq pictures size do: 
		[:i | 
		outputMedium display: (currentSeq pictures at: i).
		(Delay forMilliseconds: 150) wait]! !

!PictureSequenceMonitor methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"Receive a change notice from an object, denoted by anObject, of 
	whom the receiver is a dependent. The argument anAspect is 
	typically a Symbol that indicates what change has occurred; 
	anArgument is additional information."

	anAspect == #currentState
		ifTrue: 
			[state := anObject currentState.
			self perform: (state , ':') asSymbol with: anArgument]! !

!PictureSequenceMonitor methodsFor: 'private'!

setCurrentState
	"Set the state of the receiver to be the same as the current state 
	of the object it is monitoring."

	state := object currentState! !