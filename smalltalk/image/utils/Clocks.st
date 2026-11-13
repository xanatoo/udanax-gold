View subclass: #AClockView
	instanceVariableNames: 'myProject date '
	classVariableNames: 'NumberForms '
	poolDictionaries: ''
	category: 'Tools-Clocks'!
AClockView comment:
'I am the view of the ASCII clock - I display the date in my top view''s label tab and display the time in my insides.

My instance variables are:
	<myProject> 		<Project> the project I''m open in and,
	<date> 				<Date> the date i have in my label'!


!AClockView methodsFor: 'initialize-release'!

initialize
	"set up the view's constants"

	super initialize.
	myProject _ Project current.
	date _ Date today! !

!AClockView methodsFor: 'displaying'!

display
	"sent on update, check if my project is the current one."

	myProject == Project current
		ifTrue:
			[super display]!

displayTimeAt: aPoint
	"update the time in the view with now's string"

	| str |
	str _ Time now printString.
	str _ str copyFrom: 1 to: (str size - 6). 	"remove seconds and am/pm"
	str asParagraph
		displayOn: Display
		at: aPoint
		clippingBox: self insetDisplayBox	"put up the string"!

displayView
	"called from the outside, check the date and update the time."

	| today |
	today _ Date today.
	date = today
		ifFalse: [date _ today. self topView newLabel: today printString].
	super displayView.
	self topView isCollapsed 
		ifFalse: [self displayTimeAt: ((self insetDisplayBox origin) + (16 @ 1))] "Magic numbers"! !

!AClockView methodsFor: 'controller access'!

defaultControllerClass
	^ClockController! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

AClockView class
	instanceVariableNames: ''!


!AClockView class methodsFor: 'instance creation'!

open
	"open an ASCII clock view and start the controller."
	"AClockView open"

	| topView insideView |
	topView _ StandardSystemView new.
	topView label: Date today printString.
	topView borderWidth: 2.
	topView insideColor: Form white.
	topView minimumSize: 
		('XX:XX' asParagraph boundingBox corner + 
			(32@8)).		"Magic Numbers... (system and font dependent)"
	insideView _ self new.
	topView addSubView: insideView.
	topView controller open! !

MouseMenuController subclass: #ClockController
	instanceVariableNames: 'clockProcess '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools-Clocks'!
ClockController comment:
'I am the controller for clock views.  I set up the process that updates the clock every minute.'!


!ClockController methodsFor: 'initialize-release'!

initialize
	"start the process to update the clock every minute.
	One might want to make this less frequent (like every 3 minutes)."

	super initialize.
	clockProcess _ 
		[[(Delay forSeconds: 60) wait.
			view displaySafe: [view topView display]. 
			true] whileTrue] 
		newProcess.
	clockProcess resume!

release
	"stop the update process."

	clockProcess terminate! !

!ClockController methodsFor: 'control activity'!

isControlActive
	"am i awake?"

	^super isControlActive & sensor blueButtonPressed not! !

View subclass: #GClockView
	instanceVariableNames: 'cacheForm cacheBox myProject date '
	classVariableNames: 'NumberForms '
	poolDictionaries: ''
	category: 'Tools-Clocks'!
GClockView comment:
'I am the view of the graphical clock - I display the date in my top view''s
label tab and display the time in my insides like a graphical clock.

My instance variables are:
	cacheForm 			<Form> the bitmap of the numbers for the face of the clock,
	cacheBox 			<rectangle> the box (i.e., self insetDisplayBox) that the face lives in,
	myProject 			<project> the project I''m open in and,
	date 				<date> the date i have in my label'!


!GClockView methodsFor: 'initialize-release'!

initialize
	"set up the view's constants"

	super initialize.
	myProject _ Project current.
	date _ Date today! !

!GClockView methodsFor: 'displaying'!

display
	"sent on update, check if my project is the current one."

	myProject == Project current 
		ifTrue:
			[super  display]!

displayFace
	"update my face if the time has changes, write out the cached form if not (i.e., if i was moved)"

	(cacheBox == nil or: [cacheBox ~= self insetDisplayBox])
		ifTrue:
			[self reallyDisplayFace.
			cacheForm _ Form fromDisplay: (cacheBox _ self insetDisplayBox)]
		ifFalse:
			[cacheForm displayAt: self insetDisplayBox topLeft]!

displayHands
	"display the hands of the clock.  This is where the fancy stuff is..."

	| x y radius center extent time hour minute hand |
	extent _ self insetDisplayBox extent.
	center _ self insetDisplayBox center.
	radius _ extent // 2 - 20.
	time _ Time now.
	minute _ time minutes.
	hour _ time hours * 5 + (minute / 12) asFloat.
	hand _ Pen new.
	hand defaultNib: 4.
	x _ (hour * 6 - 90) degreesToRadians cos.
	y _ (hour * 6 - 90) degreesToRadians sin.
	hand up; goto: center + (x@y * radius // 2); down.
	hand goto: center.
	hand defaultNib: 2.
	x _ (minute * 6 - 90) degreesToRadians cos.
	y _ (minute * 6 - 90) degreesToRadians sin.
	hand goto: center + (x@y * (radius-8))!

displayView
	"do the updating of the view"

	| today |
	today _ Date today.
	date = today
		ifFalse: [date _ today. self topView newLabel: today printString].
	self topView isCollapsed
		ifFalse: [self displayFace.
				self displayHands]!

reallyDisplayFace
	"generate the background face form"

	| degree radius center direction form extent |
	center _ self insetDisplayBox center.
	extent _ self insetDisplayBox extent.
	radius _ extent // 2 - 12.
	1 to: 12 do:
		[:number |
		degree _ number-3 * 30.
		direction _ (degree degreesToRadians cos @ degree degreesToRadians sin).
		form _ NumberForms at: number.
		form displayAt: center+1 + (direction*radius) - (form extent // 2).
		Display black: (center + (direction*(radius-11)) extent: 2@2)]! !

!GClockView methodsFor: 'controller access'!

defaultControllerClass
	"answer my controller class"

	^ClockController! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

GClockView class
	instanceVariableNames: ''!


!GClockView class methodsFor: 'instance creation'!

open
	"open a new GClockView by executing the following comment"
	"GClockView open"

	| topView insideView |
	topView _ StandardSystemView new.
	topView label: Date today printString.
	topView borderWidth: 2.
	topView insideColor: Form white.
	topView minimumSize: 100@100.
	insideView _ self new.
	topView addSubView: insideView.
	topView controller open! !

!GClockView class methodsFor: 'class initialization'!

initialize
	"initialize the class constants"
	"GClockView initialize"

	| text |
	NumberForms _ Array new: 12.
	1 to: 12 do:
		[:number |
		text _ number printString asText.
		text emphasizeFrom: 1 to: text size with: 11.
		NumberForms at: number put: text asParagraph asForm]! !

GClockView initialize!
