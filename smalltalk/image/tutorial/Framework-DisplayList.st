Model subclass: #DisplayList
	instanceVariableNames: 'objects '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DisplayList'!
DisplayList comment:
'An instance of DisplayList holds on to a collection of objects that can be displayed.  These displayable objects themselves know the relative coordinates used in display positioning.  The instance simply acts as a container.  To understand the obligations of any item in a DisplayList, see the protocol for the abstract class DisplayListItem.

Instance Variable:
	objects			<OrderedCollection> of objects that can be displayed'!


!DisplayList methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	objects := OrderedCollection new.!

release
	"Release each of the receiver's objects as well as clean up any
	dependency involving the receiver."

	objects do: [:each | each release].
	objects do: [:each | each removeDependent: self]! !

!DisplayList methodsFor: 'accessing'!

add: anObject
	"Add anObject to the receiver's collection of objects.
	Make the receiver a dependent of anObject. "

	anObject addDependent: self.
	objects add: anObject!

objects
	"Answer the receiver's collection of objects."

	^objects!

remove: anObject
	"Remove anObject from the receiver's collection of objects.
	Remove the receiver as a dependent of anObject. "

	anObject removeDependent: self.
	objects remove: anObject! !

!DisplayList methodsFor: 'updating'!

update: anAspect with: parameters from: anObject
	"Notify the dependents of the receiver that objects changed."

	self changed: #objects with: parameters! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayList class
	instanceVariableNames: ''!


!DisplayList class methodsFor: 'instance creation'!

new
	"Answer an initialized instance of the receiver."

	^super new initialize! !

Model subclass: #DisplayListItem
	instanceVariableNames: 'rectangle '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DisplayList'!
DisplayListItem comment:
'DisplayListItem is an abstract class, representing the behavior of any object that wishes to be displayed within the context of a DisplayList.  It is expected that these items only deal with display, not with any additional context-sensitive behavior.  Such behavior would typically be handled by the view/controller for the particular DisplayList.

Subclasses must implement
	displaying
		showOn:at:


Instance Variables:
	rectangle	<Rectangle>	the relative area in which the instance is displayed'!


!DisplayListItem methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	rectangle := 0@0 extent: 0@0! !

!DisplayListItem methodsFor: 'accessing'!

boundingBox
	"Answer the receiver's bounding box."

	^rectangle!

extent
	"Answer the extent of the receiver's display area."

	^rectangle extent!

origin
	"Answer the origin of the receiver's display area."

	^rectangle origin!

rectangle
	"Answer the receiver's relative display area."

	^rectangle!

selectionRectangle
	"Answer the receiver's selection rectangle."

	^rectangle!

setRectangle: aRectangle
	"Set the receiver's display area to be aRectangle."

	rectangle := aRectangle! !

!DisplayListItem methodsFor: 'testing'!

containsPoint: aPoint 
	"Answer whether aPoint is inside the receiver's displayable area."

	^self rectangle containsPoint: aPoint! !

!DisplayListItem methodsFor: 'moving'!

moveBy: deltaPoint
	"Move the receiver's display location by deltaPoint."

	self setRectangle: (rectangle moveBy: deltaPoint)!

moveTo: aPoint
	"Move the receiver's display location to aPoint."

	self setRectangle: (rectangle moveTo: aPoint)! !

!DisplayListItem methodsFor: 'displaying'!

showOn: aMedium
	"Display the receiver on aMedium at anOffset
	using combination rule aRule."

	self showOn: aMedium at: 0@0!

showOn: aMedium at: anOffset
	"Display the receiver on aMedium at anOffset
	using combination rule aRule."

	self subclassResponsibility! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayListItem class
	instanceVariableNames: ''!


!DisplayListItem class methodsFor: 'instance creation'!

new
	"Answer an initialized instance of the receiver."

	^super new initialize! !

DisplayListItem subclass: #DisplayItem
	instanceVariableNames: 'item '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DisplayList'!
DisplayItem comment:
'An instance of DisplayItem is a kind of DisplayListItem that knows an object that can be displayed in a rectangular area.  

Instance Variables:
	item	<DisplayObject>	the object that can be displayed'!


!DisplayItem methodsFor: 'accessing'!

item
	"Answer the receiver's display object."

	^item!

setItem: anItem
	"Set the receiver's display item.
	Do not notify dependents."

	item := anItem.
	self sizeIt!

sizeIt
	"Make the receiver's displayable area reflect the extent of the 
	receiver's display item."

	self setRectangle: (Rectangle origin: self origin extent: item extent)! !

!DisplayItem methodsFor: 'displaying'!

display: aDisplayObject
	"The receiver places the argument aDisplayObject on itself at its relative origin."

	| oldrect |
	oldrect := self rectangle.
	item := aDisplayObject.
	self sizeIt.
	self changed: #item with: (oldrect merge: self rectangle)!

display: aDisplayObject at: aPoint
	"The receiver places the argument aDisplayObject on itself at its relative origin."

	self display: aDisplayObject!

showOn: aMedium at: anOffset
	"Display the receiver's display object on aMedium at anOffset
	using combination rule aRule."

	item displayOn: aMedium at: (anOffset + self origin) rule: Form under! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayItem class
	instanceVariableNames: ''!


!DisplayItem class methodsFor: 'instance creation'!

display: anItem at: aPoint
	"Answer an instance of the receiver with display item anItem
	displaying at aPoint."

	| di |
	di := self new.
	di display: anItem.
	di moveTo: aPoint.
	^di! !

DisplayItem subclass: #DisplayButton
	instanceVariableNames: 'up down '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DisplayList'!
DisplayButton comment:
'An instance of DisplayButton displays one of two DisplayObjects that represent button state changes.  DisplayButtons also hold on to a selector that can be used by clients to determine what the DisplayButton means.

Instance Variable:
	up			<Form | OpaqueForm>	image to be displayed when the state is up
	down		<Form | OpaqueForm>	image to be displayed when the state is down'!


!DisplayButton methodsFor: 'accessing'!

beIn
	"Change the receiver's display item to the down display object."

	self display: down.!

beOut
	"Change the receiver's display item to the up display object."

	self display: up.!

pushFor: aDelay 
	"Change the receiver's display item to the down display object. 
	wait for aDelay milliseconds and then change the receiver's display 
	item to the up display object."

	self display: down.
	(Delay forMilliseconds: aDelay) wait.
	self display: up! !

!DisplayButton methodsFor: 'private'!

setUp: upForm down: downForm 
	"Set the receiver's up and down display objects."

	up := upForm.
	down := downForm.
	self setItem: up! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayButton class
	instanceVariableNames: ''!


!DisplayButton class methodsFor: 'instance creation'!

up: up down: down at: aPoint 
	"Answer an instance of the receiver with the given up and down display objects."

	| di | 
	di := self new.
	di setUp: up down: down.
	di moveTo: aPoint.
	^di! !

DisplayItem subclass: #DisplayLabel
	instanceVariableNames: 'label '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DisplayList'!
DisplayLabel comment:
'An instance of DisplayLabel is a kind of DisplayItem that displays a string within the item, with a possible border around it.

Instance Variable:
	label	<String | Text>	the image shown by the receiver is this sequence of characters'!


!DisplayLabel methodsFor: 'accessing'!

label
	"Answer the receiver's display label."

	^label!

selectionRectangle
	"Answer the receiver's selection rectangle."

	^self rectangle insetBy: 2! !

!DisplayLabel methodsFor: 'private'!

border: anInteger 
	"Set the receiver's border width to be anInteger."

	| new |
	new := Form extent: self rectangle extent + ((anInteger*2+2) @ (anInteger*2+2)).
	item displayOn: new at: (anInteger + 2) @ (anInteger + 2).
	new border: new boundingBox width: anInteger.
	item := new.
	self sizeIt!

setLabel: aLabel 
	"Set the receiver's display label to be aLabel."

	label := aLabel.
	item := (DisplayText text: (Text string: aLabel emphasis: 5)
						 textStyle: (TextStyle styleNamed: #large)) form.
	self sizeIt! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayLabel class
	instanceVariableNames: ''!


!DisplayLabel class methodsFor: 'instance creation'!

label: aString at: aPoint 
	"Answer an instance of the receiver with display label aString 
	displaying at the relative position aPoint."

	| lab |
	lab := self new.
	lab setLabel: aString.
	lab moveTo: aPoint.
	^lab!

label: aString at: aPoint border: anInteger 
	"Answer an instance of the receiver with display label aString and 
	border width anInteger displayed at relative position aPoint."

	| lab |
	lab := self new.
	lab setLabel: aString.
	lab moveTo: aPoint.
	lab border: anInteger.
	^lab! !

View subclass: #DisplayListView
	instanceVariableNames: 'selection '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DisplayList'!
DisplayListView comment:
'An instance of DisplayListView is a kind of View that renders the objects in a DisplayList.  They can also hold and display a selection of one of the items from the DisplayList.

Instance Variable:
	selection	<DisplayListItem> the current selection'!


!DisplayListView methodsFor: 'controller defaults'!

defaultControllerClass
	"Answer the class of the default controller for the receiver."

	^Controller! !

!DisplayListView methodsFor: 'accessing'!

objects
	"Answer the model's collection of objects."

	^model objects!

selection
	"Answer the receiver's selection."

	^selection!

selection: aDisplayListItem
	"Set the receiver's selection to be aDisplayListItem."

	selection := aDisplayListItem! !

!DisplayListView methodsFor: 'displaying'!

displayObjects
	"Display the model's collection of objects."

	| buffer box|
	box := self insetDisplayBox.
	buffer := Form extent: box extent.
	self objects do: [:each | each showOn: buffer at: 0@0].
	buffer displayOn: Display at: box origin!

displayView
	"Display the model's collection of objects. Display the receiver's 
	selection."

	self displayObjects.
	self showSelection!

hideSelection
	"Hide the receiver's selection by reversing the Display."

	selection == nil
		ifFalse: [ | box |
				box := self insetDisplayBox.
				Display reverse: 
							((selection selectionRectangle 
								translateBy: box origin) intersect: box)]!

showSelection
	"Display the receiver's selection by reversing the Display."

	selection == nil 
		ifFalse: [ | box |
				box := self insetDisplayBox.
				Display reverse: 
						   ((selection selectionRectangle 
								translateBy: box origin) intersect: box)]! !

!DisplayListView methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"The model has changed. Display all of the model's collection of objects, preferably within an area specified by anArgument."

	(anArgument isKindOf: Rectangle)
		ifTrue: [^self updateDisplayObjectsIn: anArgument].
	self displayObjects.
	self showSelection!

updateDisplayObjectsIn: aRectangle 
	"Display only those objects in the model's collection of object that 
	fall within aRectangle."

	| buffer box offset |
	box := self insetDisplayBox.
	buffer := Form extent: aRectangle extent.
	offset := 0 @ 0 - aRectangle origin.
	self objects do: [:each | (each rectangle intersects: aRectangle)
								ifTrue: [each showOn: buffer
											at: offset]].
	(selection notNil and: [selection selectionRectangle intersects: aRectangle])
		ifTrue: [buffer reverse: (selection selectionRectangle translateBy: offset)].
	buffer displayOn: Display at: aRectangle origin + box origin clippingBox: box.! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayListView class
	instanceVariableNames: ''!


!DisplayListView class methodsFor: 'instance creation'!

open: aDisplayList
	"Open an instance of the receiver with aDisplayList as the model."

	"DisplayListView open: DisplayList new"

	| sv dlv |
	sv := StandardSystemView new.
	sv borderWidth: 2.
	dlv := self new model: aDisplayList.
	sv addSubView: dlv.
	sv cacheRefresh: false.
	sv controller open! !