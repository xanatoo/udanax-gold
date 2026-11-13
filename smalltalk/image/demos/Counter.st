'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!

MouseMenuController subclass: #CounterController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Demo-Counter'!


!CounterController methodsFor: 'initialize-release'!

initialize
	
	super initialize.
	self yellowButtonMenu: (PopUpMenu
			labels: 
'Increment
Decrement')
		yellowButtonMessages: #(increment decrement)! !

!CounterController methodsFor: 'control defaults'!

isControlActive
	"Inherits control from superclass MouseMenuController.
	As the blue blutton menu is used for reframing views only, counters are to be activated
	by pressing the other two buttons."

	^super isControlActive & sensor blueButtonPressed not! !

!CounterController methodsFor: 'menu messages'!

decrement
	"Subtract 1 from the value of the counter"

	self model decrement!

increment
	"Add 1 to the value of the counter"

	self model increment! !

Object subclass: #CountHolder
	instanceVariableNames: 'value '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Demo-Counter'!


!CountHolder methodsFor: 'operations'!

decrement
	"Subtract 1 from the value of the counter"

	value _ value - 1.
	self changed!

increment
	"Add 1 to the value of the counter"

	value _ value + 1.
	self changed!

initialize: aNumber 
	"Initialize the state of the counter to aNumber"

	value _ aNumber! !

!CountHolder methodsFor: 'accessing'!

value
	"return my current value"

	^ value! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CountHolder class
	instanceVariableNames: ''!


!CountHolder class methodsFor: 'instance creation'!

new: aNumber 
	"Create a new counter and initialize it with aNumber"

	| newCounter |
	newCounter _ super new.
	newCounter initialize: aNumber.
	^newCounter! !

View subclass: #CounterView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Demo-Counter'!


!CounterView methodsFor: 'displaying'!

displayView
	"Display the value of the counter in the counter view."

	| pos |

	"Calculate the absolute display coordinates from the coordinates of the view box."
	pos _ (self insetDisplayBox topLeft x +10) @ (self insetDisplayBox center y).

	"Concatenating the components of the output string and display them."
	('My value is: ', self model value printString) asText allBold asParagraph displayAt: pos.!

update: aParameter
	self display! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CounterView class
	instanceVariableNames: ''!


!CounterView class methodsFor: 'instance creation'!

open
	"Open a view for a new counter"
	"CounterView open."

	| counterView topView counter|

	counter _ CountHolder new: 0.

	counterView _ CounterView new
		model: counter;
		controller: CounterController new;
		borderWidth: 2;
		insideColor: Form white.

	topView _ StandardSystemView new
		label: 'Counter';
		minimumSize: 120@120;
		addSubView: counterView.

	topView controller open

! !
