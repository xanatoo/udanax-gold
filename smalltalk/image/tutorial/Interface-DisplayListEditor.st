DisplayListView subclass: #DisplayListEditorView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-DisplayList'!
DisplayListEditorView comment:
'Instances of DisplayListEditorView provide a framework for displaying DisplayLists while they are being edited.'!


!DisplayListEditorView methodsFor: 'controller defaults'!

defaultControllerClass
	"Answer the class of the default controller for the receiver."

	^DisplayListEditorController! !

!DisplayListEditorView methodsFor: 'displaying'!

hideSelection
	"Hide the receiver's selection by removing the box around the item."

	selection == nil
		ifFalse: [|box|
				box  := self insetDisplayBox.
				Display border: 
						 ((selection selectionRectangle 
								translateBy: box origin) intersect: box)
						width: 2 
						rule: Form reverse 
						mask: Form black]!

showSelection
	"Display the receiver's selection by drawing a box around the item."

	selection == nil
		ifFalse: [|box|
				box  := self insetDisplayBox.
				Display border: 
							((selection selectionRectangle 
								translateBy: box origin) intersect: box)
						width: 2 
						rule: Form reverse 
						mask: Form black]! !

!DisplayListEditorView methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"The model has changed. Display all of the model's collection of 
	objects."

	anAspect == #value
		ifTrue: [selection _ nil.
				self display]
		ifFalse: [super update: anAspect with: anArgument from: anObject]!

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
		ifTrue: [buffer border: (selection selectionRectangle translateBy: offset)
						width: 2 rule: Form reverse mask: Form black].
	buffer displayOn: Display at: aRectangle origin + box origin clippingBox: box.! !

Model subclass: #DisplayListEditor
	instanceVariableNames: 'picture original modified '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-DisplayList'!
DisplayListEditor comment:
'An instance of DisplayListEditor provides interactive support for editing structured graphics pictures.

Examples show a DisplayListEditor combined with various Browsers for browsing collections of DisplayLists with simple lists or sophisticated hierarchical outlines.

Instance Variables:
	picture			<DisplayList>	the current version of the graphics being edited but possibly not yet saved
	original			<DisplayList> the last version of the graphics that was saved
	modified			<Boolean> a flag to indicate whether the picture is changed from the original or not'!


!DisplayListEditor methodsFor: 'accessing'!

copyOfValue: aDisplayList
	"Answer a copy of aDisplayList."

	| newCopy |
	aDisplayList isNil
		ifTrue: [^nil].
	newCopy := self newValue.
	aDisplayList objects do: 
		[:item |
		newCopy add: item copy].
	^newCopy!

newValue
	"Answer a new value that the receiver can edit."

	^self newValueClass new!

objects
	"Answer the picture's objects that the receiver is editing."

	^picture isNil
		ifTrue: [^Array new]
		ifFalse: [picture objects]!

value
	"Answer the picture that the receiver is editing."

	^picture!

value: aDisplayList
	"Set the receiver's picture to be a copy of a picture aDisplayList."

	original _ aDisplayList.
	picture _ self copyOfValue: original.
	modified _ false.
	self changed: #value! !

!DisplayListEditor methodsFor: 'picture editing'!

addDisplayObject: aDisplayObject
	"Record a change in the receiver's picture by adding aDisplayObject."

	self addDisplayObject: aDisplayObject at: 0@0!

addDisplayObject: aDisplayObject at: aPoint
	"Record a change in the receiver's picture by adding aDisplayObject at aPoint."

	| operationBoundingBox |
	operationBoundingBox _ (aDisplayObject boundingBox translateBy: aPoint).
	picture add: (DisplayItem display: aDisplayObject at: aPoint).
	self damage: operationBoundingBox!

moveObject: aDisplayListItem to: aPoint
	"Move the DisplayListItem to aPoint."

	| rectangle |
	rectangle _ aDisplayListItem rectangle copy.
	aDisplayListItem moveTo: aPoint.
	self damage: (rectangle merge: aDisplayListItem rectangle)!

removeObject: aDisplayListItem
	"Remove the display item aDisplayListItem from the receiver's picture."
	
	| rectangle |
	rectangle _ aDisplayListItem rectangle.
	picture remove: aDisplayListItem.
	self damage: rectangle! !

!DisplayListEditor methodsFor: 'accept-cancel'!

accept
	"Change the origional to be picture."

	modified := false.
	original become: picture.
	picture := self copyOfValue: original!

cancel
	"Change the picture to be the original."

	self value: original! !

!DisplayListEditor methodsFor: 'update'!

changeRequest
	"Alert the user if losing information is possible."

	self modified
		ifFalse: [^true].
	^self confirm: 'The picture showing has been altered.
Do you wish to discard those changes?'.! !

!DisplayListEditor methodsFor: 'private'!

damage: aRectangle 
	"Note that the receiver has been modified. Notify dependents."

	modified := true.
	self changed: #rectangle with: aRectangle!

modified
	"Answer as to whether the receiver has been modified."

	modified == nil
		ifTrue: [modified := false].
	^modified!

newValueClass
	"Answer the class to be used in creating a new object to edit."

	^DisplayList! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DisplayListEditor class
	instanceVariableNames: ''!


!DisplayListEditor class methodsFor: 'editor creation'!

open
	"Create a view of the receiver on the screen."

	"DisplayListEditor open"

	| topView pictureView pictureEditor |

	pictureEditor := self new.
	pictureEditor value: DisplayList new.

	topView := StandardSystemView new.
	topView borderWidth: 2.
	topView model: pictureEditor.
	topView label: 'DisplayList Editor'.
	topView minimumSize: 200 @ 150.

	pictureView := DisplayListEditorView new model: pictureEditor.
	topView addSubView: pictureView.
	topView controller open! !

!DisplayListEditor class methodsFor: 'browser creation'!

openListBrowserOn: anAssociationList label: aString 
	"Create a browser that provides a simple list of names for accessing 
	DisplayLists."

	"DisplayListEditor
				openListBrowserOn: OrderedCollection new
				label: 'DisplayLists'"

	| topView pictureView listBrowser listView pictureEditor |
	pictureEditor := self new.
	listBrowser := ListBrowser new.
	listBrowser editor: pictureEditor.
	listBrowser list: anAssociationList accessor: (NameAccessor name: #key).
	topView := StandardSystemView new.
	topView borderWidth: 1.
	topView model: listBrowser.
	topView label: aString.
	topView minimumSize: 200 @ 150.
	listView := ListSelectionView
				on: listBrowser selectionHolder
				menuChannel: (MessageSend receiver: listBrowser selector: #selectionListMenu)
				changeRequestChannel: 
					[pictureEditor changeRequest].
	topView
		addSubView: listView
		in: (0 @ 0 extent: 1.0 @ 0.3)
		borderWidth: 1.
	pictureView := DisplayListEditorView new model: pictureEditor.
	topView
		addSubView: pictureView
		in: (0 @ 0.3 extent: 1.0 @ 0.7)
		borderWidth: 1.
	topView controller open! !

DisplayListController subclass: #DisplayListEditorController
	instanceVariableNames: ''
	classVariableNames: 'Scrap '
	poolDictionaries: ''
	category: 'Interface-DisplayList'!
DisplayListEditorController comment:
'Class DisplayListEditorController supports editing structured pictures.  This is intended to be an easy to use general-purpose framework for graphics editing.	


	Class Variables
		Scrap 	<aDisplayListItem | nil>	the place to hold objects in support of cut/copy/paste'!


!DisplayListEditorController methodsFor: 'control defaults'!

yellowButtonActivity
	"Process the receiver's yellow button menu."

	| menu index |
	menu := ActionMenu
			labels: 'cut\copy\paste\line\curve\image\accept\cancel' withCRs
			lines: #(3 6)
			selectors: #(cut copySelected paste line curve image accept cancel).
	index := menu startUp.
	index = 0 ifTrue: [^self].
	self perform: (menu selectorAt: index)! !

!DisplayListEditorController methodsFor: 'user interface support'!

displayReversed: aDisplayObject
	"Display aDisplayObject on the display relative to the receiver's view."

	self displayReversed: aDisplayObject at: 0@0!

displayReversed: aDisplayObject at: aPoint
	"Display aDisplayObject on the display relative to the receiver's view."

	aDisplayObject
		displayOn: Display
		at: aPoint
		clippingBox: view insetDisplayBox
		rule: Form reverse
		mask: nil!

dragObject: anObject
	"Drag the displaylist item anObject on the display.  Answer the new origin point in in display coordinates."

	| pt oldPt rect displayObject |
	rect := anObject rectangle copy.
	rect := (self reverseMapPoint: rect origin) extent: rect extent.
	pt := oldPt := self cursorPoint.
	rect := rect align: rect center with: pt. 
	displayObject := anObject item.
	"Display border: rect width: 1 rule: Form reverse mask: Form black."
	self displayReversed: displayObject at: rect origin.
	[sensor anyButtonPressed] whileTrue:
		[pt := self cursorPoint.
		oldPt = pt
			ifFalse: ["Display border: rect width: 1 rule: Form reverse mask: Form black."
					self displayReversed: displayObject at: rect origin.
					oldPt := pt.
					rect := rect align: rect center with: pt. 	
					"Display border: rect width: 1 rule: Form reverse mask: Form black."
					self displayReversed: displayObject at: rect origin]].
	"Display border: rect width: 1 rule: Form reverse mask: Form black."
	self displayReversed: displayObject at: rect origin.
	^rect origin.!

rubberBandCurve: startPoint to: endPoint until: aBlock
	"RubberBand a curve and answer the middle point for a curve with given start and end points
	when aBlock answers true."

	| curve previousApex apex |
	curve := Curve new.
	curve firstPoint: startPoint.
	curve secondPoint: (previousApex := self cursorPoint).
	curve thirdPoint: endPoint.
	curve form: self displayBrush.
	self displayReversed: curve.
	Cursor crossHair showWhile: [
		[aBlock value] whileFalse:
			[(apex := self cursorPoint) = previousApex 
				ifFalse:
					[self displayReversed: curve.
					curve secondPoint: apex.
					self displayReversed: curve.
				previousApex  := apex]]].
	self displayReversed: curve.
	^ curve secondPoint!

rubberBandLineFrom: startPoint until: aBlock
	"RubberBand a line and answer the end point of a line with given start point
	when aBlock answers true."

	| line endPoint |
	line := Line from: startPoint to: startPoint withForm: self displayBrush.
	self displayReversed: line.
	[aBlock value] whileFalse:
		[(endPoint := self cursorPoint) = line endPoint
			ifFalse: [self displayReversed: line.
					line endPoint: endPoint.
					self displayReversed: line]].
	self displayReversed: line.
	^line endPoint!

track: aDisplayObject until: aBlock
	"Move the display object aDisplayObject on the display until aBlocks answers true.
	Answer the last point in display coordinates."

	| previousPoint cursorPoint  |
	previousPoint  := self cursorPoint.
	self displayReversed: aDisplayObject at: previousPoint.
	[aBlock value] whileFalse:
		[cursorPoint := self cursorPoint.
		cursorPoint ~= previousPoint
			ifTrue:	[self displayReversed: aDisplayObject at: previousPoint.
					previousPoint := cursorPoint.
					self displayReversed: aDisplayObject at: previousPoint]].
	self displayReversed: aDisplayObject at: previousPoint.
	^previousPoint! !

!DisplayListEditorController methodsFor: 'menu messages'!

accept
	"The edited information should now be accepted by the view."

	model accept!

cancel
	"The edited information should be forgotten by the view."

	model cancel!

copySelected
	"Copy the selected item to the Scrap."

	| selected |
	selected := view selection.
	selected isNil
		ifTrue: [^self].
	Scrap := selected copy!

curve
	"Add a conic-section to the model's picture."

	| firstPoint secondPoint thirdPoint curve |
	Cursor crossHair showWhile: [firstPoint := sensor waitButton].
	self displayReversed: self displayBrush at: firstPoint.
	thirdPoint := self track: self displayBrush until: [sensor anyButtonPressed not].
	secondPoint := self rubberBandCurve: firstPoint to: thirdPoint until: [sensor redButtonPressed].
	curve := Curve new.
	curve firstPoint: (self mapPoint: firstPoint).
	curve secondPoint: (self mapPoint: secondPoint).
	curve thirdPoint: (self mapPoint: thirdPoint).
	curve form: self currentBrush.
	self processDisplayObject: curve.
	sensor waitNoButton!

cut
	"Cut the selected item into the Scrap."

	| selected |
	selected := view selection.
	selected isNil
		ifTrue: [^self].
	view hideSelection.
	view selection: nil.
	model removeObject: selected.
	Scrap := selected!

image
	"Add a image to the model's picture."

	| form rectangle pt|
	rectangle := Rectangle fromUser.
	form := Form fromDisplay: rectangle.
	pt := self track: form until: [sensor anyButtonPressed].
	sensor waitNoButton.
	self processDisplayObject: form at: (self mapPoint: pt)!

line
	"Add a line to the model's picture."

	| firstPoint endPoint |
	Cursor crossHair showWhile:
		[firstPoint  := sensor waitButton].
	endPoint := self rubberBandLineFrom: firstPoint until: [sensor anyButtonPressed not].
	self processDisplayObject:
			(Line from: (self mapPoint: firstPoint)
				to: (self mapPoint: endPoint)
				withForm: self currentBrush).!

paste
	"Add the item in the Scrap into the model."

	Scrap isNil
		ifTrue: [^self].
	model addDisplayObject: Scrap item at: Scrap rectangle origin! !

!DisplayListEditorController methodsFor: 'private'!

currentBrush
	"Answer a drawing brush."

	^(Form extent: 1@1) black!

cursorPoint
	"Answer the sensors cursor point."

	^sensor cursorPoint!

displayBrush
	"Answer a drawing brush for the display."

	^self currentBrush!

hitDetect: aPoint 
	"Answer the object of the models collection of objects might be at aPoint."

	model objects reverseDo:
		[:object |
		(object containsPoint: aPoint)
			ifTrue: [^object]].
	^nil!

mapPoint: aPoint
	"Answer the user coordinate for the display point aPoint."

	^aPoint - view insetDisplayBox origin!

processDisplayObject: aDisplayObject
	"Put the display object aDisplayObject into the model relative the boundingBox origin of the display object."
 
	| boundingBox |
	boundingBox := aDisplayObject boundingBox. 
	model addDisplayObject: (aDisplayObject translateBy: boundingBox origin negated) at: boundingBox origin!

processDisplayObject: aDisplayObject at: aPoint
	"Add the display object aDisplayObject to the model at: aPoint."

	model addDisplayObject: aDisplayObject at: aPoint!

reverseMapPoint: aPoint
	"Answer the display coordinate for the user point aPoint."

	^aPoint translateBy: view insetDisplayBox origin!

select: aPoint 
	"Figure out which of the models collection of objects might be 
	selected at aPoint.  If the user moves the cursor drag the object if not,
	notify the view of the selection."

	| selection oldPt  startPt pt |
	selection := self hitDetect: aPoint.
	selection == nil
		ifTrue: [^self selected: nil].
	startPt := oldPt := pt := aPoint.
	[sensor redButtonPressed] whileTrue: 
		[pt := self mapPoint: sensor cursorPoint.
		pt = oldPt
			ifFalse: [(startPt dist: pt) > 5
						ifTrue: [pt := self dragObject: selection.
								^model moveObject: selection to: (self mapPoint: pt).].
					oldPt := pt]].
	self selected: selection!

selected: anObject 
	"Notify the view of the selection."

	view hideSelection.
	view selection: anObject.
	view showSelection! !