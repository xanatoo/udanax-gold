Controller subclass: #DisplayListController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-DisplayList'!
DisplayListController comment:
'An instance of DisplayListController is a kind of Controller for DisplayLists that provides support for selecting all of the DisplayListItems.  Subclasses add information about what to do with a selection.'!


!DisplayListController methodsFor: 'control defaults'!

controlActivity
	"Send redButtonActivity if the red button is pressed.
	Send yellowButtonActivity if the yellow button is pressed.
	Otherwise do nothing."

	sensor redButtonPressed
		ifTrue: [^self redButtonActivity].
	sensor yellowButtonPressed
		ifTrue: [^self yellowButtonActivity]!

isControlActive
    	"Keep control active as long as the blue button is not pressed."

    ^super isControlActive & sensor blueButtonPressed not!

redButtonActivity
	"Select an object in a DisplayList relative to the displayed origin of the view."

	| pt |
	pt := sensor cursorPoint.
	self select: pt - view insetDisplayBox origin.
	sensor waitNoButton!

yellowButtonActivity
	"Do nothing for yellow button activity. This provides a framework for 
	subclasses to provide a menu of operations on the objects in the 
	DisplayList."! !

!DisplayListController methodsFor: 'selecting'!

select: aPoint 
	"Figure out which of the models collection of objects might be 
	selected at aPoint.  Notify the view of the selection."

	| selection |
	selection := model objects detect: [:p | p containsPoint: aPoint]
							   ifNone: [nil].
	view hideSelection.
	view selection: selection.
	view showSelection! !

DisplayListController subclass: #SelectListController
	instanceVariableNames: 'buttons messageReceiver '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-DisplayList'!
SelectListController comment:
'An instance of SelectListController adds selection behavior to a DisplayListController.  The instance knows a particular model and a dictionary of buttons with associated message selectors.  If a button is selected in the DisplayList that is the controller''s model, then its corresponding message is sent to the controller to be executed.  Typically, the controller will send the message to its receiverModel.

Instance Variables:

	messageReceiver <Object> that receives the message selected
	buttons	<Dictionary> of associations between DisplayListItems and message selectors'!


!SelectListController methodsFor: 'accessing'!

receiver: anObject buttons: aDictionary
	"Initialize the instance variables of the receiver."

	messageReceiver := anObject.
	buttons := aDictionary.! !

!SelectListController methodsFor: 'selecting'!

processSelector: aSymbol
	"If the user has selected an executable message, evaluate it.  Otherwise
	do nothing."

	aSymbol == nil ifTrue: [^self].
	messageReceiver perform: aSymbol!

select: aPoint 
    "Figure out which item might be selected because the selection
	button has been pressed and the cursor is positioned at aPoint.
	Answer the selection, if any.  Flash some highlighting if the user
	selects nothing.  Carry out the command if a message is selected."

	| selection |
	selection := model objects detect: [:p | p containsPoint: aPoint] ifNone: [nil].
	(buttons includesKey: selection) 
		ifTrue: [selection beIn.
				self processSelector: (buttons at: selection).
				^selection beOut].
	selection isNil
		ifFalse: [(selection isKindOf: DisplayLabel)
					ifTrue: [view hideSelection.
							view selection: selection.
							^view showSelection]].
	view hideSelection.
	view selection: nil.! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SelectListController class
	instanceVariableNames: ''!


!SelectListController class methodsFor: 'instance creation'!

receiver: anObject buttons: aDictionary 
	"Create an instance of the receiver with instance variables 
	initialized."

	^super new receiver: anObject buttons: aDictionary! !