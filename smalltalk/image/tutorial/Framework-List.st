ListController subclass: #ListSelectionController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-List'!
ListSelectionController comment:
'An Instance of ListSelectionController is a kind of ListController that has special channels for determining change requests and menu operations.'!


!ListSelectionController methodsFor: 'menu messages'!

menuMessageReceiver
	"Answer the object that should be sent a message when a menu item 
	is selected."

	^view menuMessageReceiver!

redButtonActivity
	"Determine which item in the list is selected. Send a message to the 
	model indicating the number of the selected item."

	| selectionMovement oldSelection trialSelection nextSelection |
	selectionMovement := false.
	oldSelection := view selection.
	[sensor redButtonPressed]
		whileTrue: 
			[trialSelection := view findSelection: sensor cursorPoint.
			trialSelection ~~ nil
				ifTrue: 
					[nextSelection := trialSelection.
					view moveSelectionBox: nextSelection.
					nextSelection ~= oldSelection ifTrue: [selectionMovement := true]]].
	nextSelection == nil ifTrue: [^self].
	nextSelection = oldSelection
		ifTrue: 
			[selectionMovement ifTrue: [^self].
			nextSelection := 0.
			view moveSelectionBox: nextSelection].
	view channelChangeRequest
		ifFalse: 
			[view moveSelectionBox: oldSelection.
			^view flash].
	self changeModelSelection: nextSelection!

yellowButtonActivity
	"Determine which item in the yellow button pop-up menu is selected.
	If one is selected, then send the corresponding message to the object
	designated as the menu message receiver."

	| index menu |
	menu := view yellowButtonMenu.
	menu == nil
		ifTrue:
			[view flash.
			super controlActivity]
		ifFalse: 
			[index := menu startUpYellowButton.
			index ~= 0 
				ifTrue:
					[self controlTerminate.
					self menuMessageReceiver perform: (menu selectorAt: index).
					self controlInitialize]]! !

Object subclass: #NameAccessor
	instanceVariableNames: 'nameTranslation '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-List'!
NameAccessor comment:
'An instance of NameAccessor a translator of name access protocol.  The instance knows the message to send to its referenced object in order to obtain the name of that object.

Instance Variables:
	nameTranslation	<Symbol>	a message selector to send to an object to determine its name'!


!NameAccessor methodsFor: 'accessing'!

nameFor: anObject
	"Answer a printable name for anObject."

	^anObject perform: nameTranslation! !

!NameAccessor methodsFor: 'private'!

setName: nameSelector
	"Set the adaptor message for the receiver."

	nameTranslation := nameSelector! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

NameAccessor class
	instanceVariableNames: ''!


!NameAccessor class methodsFor: 'instance creation'!

name: nameSelector 
	"Create a new instance of the receiver with appropriate adaptor 
	message, that is nameSelector is the message selector by which an 
	object finds out another object's name. However, the sending object 
	only has to know the protocol of this class."

	^self new setName: nameSelector! !

ListView subclass: #ListSelectionView
	instanceVariableNames: 'menuChannel changeRequestChannel '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-List'!
ListSelectionView comment:
'An instance of ListSelectionView is a special type of ListView that knows the object from which it receives its menu.  It also knows an object that manages change requests.

Instance Variables:
	menuChannel			<Object>	any object that understands the messages value and receiver, 
										typically a kind of MessageSend
	changeRequestChannel	<Object>	any object that understands the message value, typically a
										BlockClosure
	'!


!ListSelectionView methodsFor: 'accessing'!

changeRequestChannel: anObject 
	"Set the receiver's change request channel to be anObject. Note, 
	anObject must understand the message value."

	changeRequestChannel := anObject!

menuChannel: anObject 
	"Set the receiver`s menu channel to be anObject. Note, anObject 
	must understand the message value and receiver."

	menuChannel := anObject! !

!ListSelectionView methodsFor: 'controller access'!

defaultControllerClass
	"Answer the default controller class for the receiver."

	^ListSelectionController! !

!ListSelectionView methodsFor: 'displaying'!

display
	"Display the list of items after making sure that the list has been 
	obtained from the receiver's model."

	list == nil
		ifTrue: 
			[self list: self getList.
			self moveSelectionBox: self getListIndex].
	super display! !

!ListSelectionView methodsFor: 'adaptor'!

channelChangeRequest
	"Answer true or false as to whether the change channel wishes to 
	changed."

	^changeRequestChannel == nil
		ifTrue: [false]
		ifFalse: [changeRequestChannel value]!

getList
	"Answer the list to be displayed."

	^model list!

getListIndex
	"Answer the list index to be selected."

	^model listIndex!

menuMessageReceiver
	"Answer the object that is to receive a menu message.

	This makes the assumption that the receiver of the selection is the 
	same as the object holding the menu."

	^menuChannel receiver!

yellowButtonMenu
	"Answer a PopUpMenu or nil."

	menuChannel == nil ifTrue: [^nil].
	^ menuChannel value! !

!ListSelectionView methodsFor: 'updating'!

update: aSymbol with: aParameter from: anObject 
	"Some aspect of the receiver's model has changed. Update lists or 
	selections."

	aSymbol == #list
		ifTrue: [self repairAfterListChange].
	aSymbol == #listIndex
		ifTrue: [self repairAfterSelection]! !

!ListSelectionView methodsFor: 'private'!

repairAfterListChange
	"The receiver's list is no longer valid,  redisplay it."

	| sel |
	self list: self getList	.
	sel := self getListIndex.
	0 = sel
		ifTrue: [^self displayView].
	selection := sel.
	self selectionVisible
		ifFalse: [list repositionAt: self computeCompositionOrigin
					clippingBox: self clippingBox].
	self displayView!

repairAfterSelection
	"The receiver's selection is no longer valid,  redisplay it."

	| sel |
	sel := self getListIndex.
	selection = sel
		ifTrue: [self selectionVisible ifTrue: [^self]]
		ifFalse: [self deselect].
	selection := sel.
	self selectionVisible
		ifFalse: [list repositionAt: self computeCompositionOrigin clippingBox: self clippingBox.
				self displayView]
		ifTrue: [self displaySelectionBox]!

selectionVisible
	"Answer true if the receiver's selection is visible otherwise answer false."

	^selection > 0 and: [self selectionBox intersects: self clippingBox]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ListSelectionView class
	instanceVariableNames: ''!


!ListSelectionView class methodsFor: 'instance creation'!

on: aModel menuChannel: menuChannel changeRequestChannel: changeRequestChannel 
	"Create an instance of the receiver for the object aModel. Get the 
	translation for the menu messages from menuChannel. Broadcasting 
	changes comes via changeRequestChannel. aModel has to 
	understand the message list."

	| lv |
	lv := self new model: aModel.
	lv menuChannel: menuChannel.
	lv changeRequestChannel: changeRequestChannel.
	^lv! !

CollectionBrowser subclass: #ListBrowser
	instanceVariableNames: 'list listSelection '
	classVariableNames: 'PasteBuffer '
	poolDictionaries: ''
	category: 'Framework-List'!
ListBrowser comment:
'An instance of a ListBrowser is a CollectionBrowser for browsing and editing the structure of SequencableCollections.
A ListBrowser represents an application that consists of a simple linear list (like a rolodex).

Instance Variables:
	list				<OrderedCollection>
	listSelection	<SequenceSelection>

Class Variables:
	PasteBuffer		<Array>		collection element, index indicating whether to paste identity or a copy
	'!


!ListBrowser methodsFor: 'accessing'!

collection
	"Answer the list that the receiver is browsing."

	^list!

list: aList 
	"Set the receiver's list to be aList."

	list := aList.
	listSelection sequence: aList.
	self setValueEditorsValue: nil!

list: aList accessor: aNameAccessor
	"Set the receiver's list to be aList. Access the list with 
	aNameAccessor."

	listSelection := SequenceSelection new.
	listSelection nameAccessor: aNameAccessor.
	listSelection addDependent: self.
	self list: aList!

selectionHolder
	"Answer receiver's listSelection."

	^listSelection! !

!ListBrowser methodsFor: 'menu messages'!

addAfter
	"Prompt the user for adding a new item to the list. The item will 
	be added after the currently selected item."

	| newCategory |
	self changeRequest ifFalse: [^self].
	newCategory := FillInTheBlank request: 'New Item' initialAnswer: ''.
	newCategory = '' ifTrue: [^self].
	self insertAfter: (self newFor: newCategory)!

addBefore
	"Prompt the user for adding a new item to the outline. The item will 
	be added before the currently selected item at the same indent 
	level."

	| newCategory |
	self changeRequest ifFalse: [^self].
	newCategory := FillInTheBlank request: 'New Outline Item' initialAnswer: ''.
	newCategory = '' ifTrue: [^self].
	self insertBefore: (self newFor: newCategory)!

renameCategory
	"Prompt the user for a new name and rename the selected item."

	| newCategory current |
	self changeRequest ifFalse: [^self].
	current := self selected.
	newCategory := FillInTheBlank request: 'New item name' initialAnswer: current key.
	newCategory = '' ifTrue: [^self].
	newCategory = current key ifTrue: [^self].
	current key: newCategory.
	listSelection resetItem: current.
	self noteModification!

selectionListMenu
	"Answer the menu to use in manipulating the receiver's list."

	self selected == nil
		ifTrue: [^(MenuBuilder parseFrom: (ReadStream on:
					'add[addAfter] load[load] save[save]')) menu].
	^(MenuBuilder parseFrom: (ReadStream on:
		'(add: 	
			(after[addAfter] before[addBefore])
		 paste: 	
			(after[pasteAfter] before[pasteBefore]))
		(copy[copyCurrent] cut[cut] rename [renameCategory])
		(load [load] save[save])')) menu! !

!ListBrowser methodsFor: 'cut-copy-paste'!

copyCurrent
	"Place a copy of the currently selected item into the paste buffer."

	| current |
	current := self selected.
	current == nil ifTrue: [^self].
	PasteBuffer := Array with: current with: 1!

cut
	"Remove the currently selected item and place it in the paste buffer."

	| current |
	current := self selected.
	current == nil ifTrue: [^self].
	self changeRequest ifFalse: [^self].
	PasteBuffer := Array with: current with: 0.
	list removeAtIndex: listSelection listIndex.
	listSelection resetItem: nil.
	self setValueEditorsValue: nil.
	self noteModification!

pasteAfter
	"Add the item in the paste buffer after the currently selected item."

	PasteBuffer == nil ifTrue: [^self].
	self checkPasteBuffer.
	self insertAfter: (PasteBuffer at: 1)!

pasteBefore
	"Add the item in the paste buffer before the currently selected item."

	PasteBuffer == nil ifTrue: [^self].
	self checkPasteBuffer.
	self insertBefore: (PasteBuffer at: 1)! !

!ListBrowser methodsFor: 'storing-loading'!

loadedNewCollection: aCollection
	"Additional structure has been retrieved. Insert it into the existing 
	structure after the current selection."

	list addAll: aCollection.
	listSelection resetItem: self selected.! !

!ListBrowser methodsFor: 'private'!

checkPasteBuffer
	"Sent by the paste operations, this method makes certain that the 
	first time a paste is done, that the actual structure is used. 
	Thereafter, multiple pastes creates copies."

	| tmp |
	PasteBuffer == nil ifTrue: [^self].
	PasteBuffer at: 2 put: (tmp := (PasteBuffer at: 2) + 1).
	tmp = 2 ifTrue: [PasteBuffer at: 1 put: (PasteBuffer at: 1) copy]!

insert: newItem
	"Insert newItem at the end of the receiver's list"

	| selected |
	list addLast: newItem.
	selected := self selected.
	selected == nil
		ifTrue: [listSelection resetList]
		ifFalse: [listSelection resetItem: selected]
	self noteModification!

insertAfter: newItem 
	"Insert newValue in the receiver's list, after the currently selected 
	item."

	| selected selectionIndex |
	selected := self selected.
	selected == nil
		ifTrue: 
			[list addLast: newItem.
			listSelection resetList]
		ifFalse: 
			[selectionIndex := listSelection listIndex.
			selectionIndex = list size
				ifTrue: [list addLast: newItem]
				ifFalse: [list add: newItem beforeIndex: selectionIndex + 1].
			listSelection resetItem: selected].
	listSelection resetItem: selected.
	self noteModification!

insertBefore: newItem 
	"Insert newItem in the receiver's list, before the currently selected 
	item."

	| selected selectionIndex |
	selected := self selected.
	selected == nil
		ifTrue: 
			[list addFirst: newItem.
			listSelection resetList]
		ifFalse: 
			[selectionIndex := listSelection listIndex.
			list add: newItem beforeIndex: selectionIndex.
			listSelection resetItem: selected].
	self noteModification!

newItemWithKey: newCategory value: newValue 
	"Answer an Association with newCategory as the key and newValue 
	as the value."

	^Association key: newCategory value: newValue! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ListBrowser class
	instanceVariableNames: ''!


!ListBrowser class methodsFor: 'examples'!

none
	"See EnvironmentEditor for an example of using the ListBrowser. A 
	ListBrowser without a value editor linked to it is not interesting. 
	EnvironmentEditor supports values that are Environments and 
	provides an appropriate editor."! !

Model subclass: #SequenceSelection
	instanceVariableNames: 'sequence nameAccessor selectionList currentSelectionIndex '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-List'!
SequenceSelection comment:
'An instance of SequenceSelection acts as a data structure for a structure that consists of any kind of objects as its elements.  It knows about
	making selections from a sequence and
	notifying dependents if a selection changes
The only protocol that an element of the sequence has to know is the one pre-stored in the nameAccessor.  In this sense, every element must respond to the same naming protocol.

Instance Variables:
	sequence		<SequenceableCollection>	some structure that is being manipulated or handled
	nameAccessor	<NameAccessor>			pathway for finding out the name of an element of the sequence
	selectionList	<Array>						a constructed view of the sequence
	currentSelectionIndex	<SmallInteger>		the index of the currently selected element of the sequence'!


!SequenceSelection methodsFor: 'accessing'!

currentSelection
	"Answer the currently selected element."

	^(currentSelectionIndex == 0 or: [currentSelectionIndex == nil])
		ifTrue: [nil]
		ifFalse: [sequence at: currentSelectionIndex]!

currentSelection: anObject
	"Set the receivers the currently selected element."

	| old |
	old := self currentSelectionState.
	currentSelectionIndex := self findIndexOf: anObject startingAt: self start.
	self changedCurrentSelectionWithOld: old!

nameAccessor
	"Answer the receivers nameAccessor."

	^nameAccessor!

nameAccessor: aNameAccessor
	"Set the receiver's nameAccessor to be aNameAccessor."

	nameAccessor := aNameAccessor!

resetItem: anObject 
	"Signal that a new list is necessary. Set the receiver's current 
	selection to be aChild."

	self resetList.
	self currentSelection: anObject!

resetList 
	"Signal that a new list is necessary."

	selectionList := nil.
	self changed: #list!

sequence
	"Answer the receiver's sequence."

	^sequence!

sequence: aSequencableCollection
	"Set the receiver's sequence to be aSequencableCollection."

	sequence := aSequencableCollection! !

!SequenceSelection methodsFor: 'list accessor'!

nameFor: anObject
	"Answer the name for anObject."

	^nameAccessor nameFor: anObject!

start
	"Answer the start element in list."

	^1! !

!SequenceSelection methodsFor: 'list messages'!

list
	"Answer the receiver's selection list."

	selectionList == nil ifTrue: [self buildList].
	^selectionList!

listIndex
	"Answer the receiver`s indented list index."

	^currentSelectionIndex == nil
		ifTrue: [0]
		ifFalse: [currentSelectionIndex]!

toggleListIndex: aNumber 
	"Change the receiver`s indented list index to be aNumber."

	| old |
	old := self currentSelectionState.
	currentSelectionIndex := aNumber.
	self changed: #currentSelection with: old! !

!SequenceSelection methodsFor: 'private'!

buildList
	"Build the receiver's selection list."

	selectionList := Array new: sequence size.
	1 to: sequence size do:
		[:index |
		selectionList at: index put: (self nameFor: (sequence at: index))]!

changedCurrentSelectionWithOld: oldSelectionState 
	"The current selection just changed. Do anything to respond including 
	telling dependents."

	self changed: #listIndex with: oldSelectionState.
	self changed: #currentSelection with: oldSelectionState!

currentSelectionState
	"Answer the receiver's current selection index."

	^currentSelectionIndex!

findIndexOf: anObject startingAt: startIndex

	startIndex to: sequence size do:
		[:index |
		(sequence at: index) == anObject
			ifTrue: [^index]].
	^0! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SequenceSelection class
	instanceVariableNames: ''!


!SequenceSelection class methodsFor: 'instance creation'!

on: aSequencableCollection
	"Create a new instance of the receiver on aSequencableCollection."

	^self new sequence: aSequencableCollection! !