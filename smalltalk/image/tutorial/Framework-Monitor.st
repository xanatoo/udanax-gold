Model subclass: #Monitor
	instanceVariableNames: 'outputMedium '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Monitor'!
Monitor comment:
'Monitor is an abstract superclass the represents the ability to watch changes in the state of an object.

Concrete subclasses must implement
	updating
		update:with:from:

Instance Variables
	outputMedium	<Object>	to place notation onto about state changes'!


!Monitor methodsFor: 'accessing'!

outputMedium: aMedium
	"Initialize the medium onto which notations can be placed."

	outputMedium := aMedium! !

!Monitor methodsFor: 'watching'!

monitor: anObject 
	"Add anObject as another object that the receiver wants to  
	watch."

	anObject addDependent: self! !

!Monitor methodsFor: 'updating'!

update: anAspectSymbol with: aParameter from: aSender
		"Receive a change notice from an object, denoted by aSender, of whom the receiver is a dependent.  The argument anAspectSymbol is typically a Symbol that indicates what change has occurred and aParameter is additional information."

	self subclassResponsibility! !

Monitor subclass: #TranscriptMonitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Monitor'!
TranscriptMonitor comment:
'Any object that the instance of TranscriptMonitor watches must conform to the following:
	1.  respond to the message currentState to return a symbol or string representing its current state.  
	2.  when it changes, broadcast the message 
			self changed: #currentState
	3.  the form of 
			self changed: #currentState with: oldState
		allows additional information to be displayed
	    '!


!TranscriptMonitor methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"Store onto the receiver's output log the current status of 
	the object."

	(anAspect == #currentState)
		ifTrue: [outputMedium cr; cr.
				outputMedium nextPutAll: anObject class name.
				outputMedium crtab; nextPutAll: 'changed '.
				anAspect printOn: outputMedium.
				outputMedium nextPutAll: ' from '.
				anArgument printOn: outputMedium.
				outputMedium nextPutAll: ' to '.
				anObject currentState printOn: outputMedium.
				outputMedium cr.
				outputMedium endEntry]! !

Monitor subclass: #SelectiveMonitor
	instanceVariableNames: 'object '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Monitor'!
SelectiveMonitor comment:
'An instance of SelectiveMonitor is a kind of Monitor that knows a particular object that it cares to watch.

Instance Variables:
	object	<Object>'!


!SelectiveMonitor methodsFor: 'watching'!

monitor: anObject 
	"Add anObject as the object that the receiver wants to  
	watch."

	object == nil ifFalse: [object removeDependent: self].
	object := anObject.
	object addDependent: self! !

SelectiveMonitor subclass: #DisplayMonitor
	instanceVariableNames: 'pictures offset '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Monitor'!
DisplayMonitor comment:
'An instance of DisplayMonitor watches a particular object.  As that object''s state changes, the monitor changes the graphical presentation of the object on its output medium.  The presentation is placed with respect to a relative coordinate.

Instance Variables:
	pictures	<Dictionary> with key the state, Symbol, denoting the monitored object and value a DisplayObject
	offset		<Point>	the relative coordinate of the origin position for displaying the selected picture'!


!DisplayMonitor methodsFor: 'accessing'!

offset: aPoint
	"Set the receiver's relative coordinate to be aPoint."

	offset := aPoint!

pictureAt: aSymbol put: aDisplayObject
	"Set the receiver's full dictionary of pictures to be aDictionary."

	pictures at: aSymbol put: aDisplayObject!

setPictures: aDictionary
	"Set the receiver's full dictionary of pictures to be aDictionary."

	pictures := aDictionary! !

!DisplayMonitor methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"Store onto the receiver's output log the current status of 
	the object."

	(anAspect == #currentState) 
		ifTrue: [outputMedium 
					display: (pictures 
								at: (anObject currentState)
								ifAbsent: [Form extent: 64@64])  
					at: offset.]! !

Monitor subclass: #SoundMonitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Monitor'!
SoundMonitor comment:
'An instance of SoundMonitor responds to changes broadcast from any dependent object by attempting to say something about the object.  It knows nothing about the object because the update message carries all the information needed to make the appropriate sounds.  The Monitor outputMedium is the appropriate SoundPlayer.'!


!SoundMonitor methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"Ask the receiver's soundMedium to speak the string anArgument."

	(anAspect == #spoke) 
		ifTrue: [outputMedium play: anArgument for: anObject]! !