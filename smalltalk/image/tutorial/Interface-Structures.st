Model subclass: #CollectionBrowser
	instanceVariableNames: 'valueEditor modified filename '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-Structures'!
CollectionBrowser comment:
'A CollectionBrowser is an abstract class description for structure browsing.  It does not know the values of the elements of its structure, but rather knows a kind of editor that has knowledge about the values of the elements.  An instance of a subclass of CollectionBrowser:
	manages the operations for modifying the structure, the browser
	knows whether or not the structure has been changed but not saved
	knows where, if any, the structure has been stored externally
	is able to store and retrieve the structure (using binary storage mechanisms)
	knows the Editor for the elements of the collection and finds out values from the Editor

This means that the CollectionBrowser provides a framework for full pluggability.  Using subclasses, different kinds of structures can be edited.  Using composition with other browsers, lists, trees,  or other structures can provide references to different kinds of values.  See ListBrowser or EnvironmentBrowser as examples.

Subclasses must implement:

	accessing
		collection
		selectionHolder
	storing-loading
		loadedNewCollection:
	private
		newItemWithKey:value:

Instance Variables:
	valueEditor		<Object>	that understands value, value:, and newValue
	modified		<Boolean>
	filename		<String> '!


!CollectionBrowser methodsFor: 'initialize-release'!

initialize
	"Specify the default values for the receiver's instance variables."

	modified := false! !

!CollectionBrowser methodsFor: 'accessing'!

collection
	"Answer the collection that the receiver is browsing."
	
	^self subclassResponsibility!

editor
	"Answer the receiver's value editor."

	^valueEditor!

editor: aValueEditor
	"Set the receiver's value editor to be aValueEditor."

	valueEditor := aValueEditor!

filename
	"Answer the name, if any, of the file from which the last information 
	for the receiver was loaded or saved."

	^filename == nil
		ifTrue: [String new]
		ifFalse: [filename]!

filename: aString 
	"Store aString as the name of the file from which the  
	information for the receiver is to be loaded or saved."

	filename := aString!

selected
	"Answer receiver's current selection or nil if nothing is selected."

	^self selectionHolder currentSelection!

selectedValue
	"Answer the value of the receiver's current selection or nil if nothing 
	is selected."

	| selection |
	selection := self selected.
	^selection == nil
		ifTrue: [nil]
		ifFalse: [selection value]!

selectionHolder
	"Answer the holder of the receiver's selection."

	^self subclassResponsibility! !

!CollectionBrowser methodsFor: 'changing'!

closeRequest
	"Notify the user if the outline has not been saved. The user decides 
	whether to continue and lose the changes."

	^modified
		ifTrue: [self confirm: 'The collection has been altered.
Do you wish to discard those changes?']
		ifFalse: [valueEditor changeRequest]!

newLabel: aString
	"Sent by the user interface.  Do nothing,  subclasses might find meaning here."

	^self! !

!CollectionBrowser methodsFor: 'updating'!

update: anAspect with: aParameter from: anObject 
	"Receive a change notice from an object, denoted by anObject, 
	of whom the receiver is a dependent."

	anObject == self selectionHolder
		ifTrue: [^self
				updateSelection: anAspect
				with: aParameter
				from: anObject]
		ifFalse: [^super
				update: anAspect
				with: aParameter
				from: anObject]!

updateSelection: anAspect with: aParameter from: anObject 
	"Because of the dependency between the receiver and its own 
	selection holder, whenever the selection is changed, the 
	receiver is informed."

	anAspect == #currentSelection ifFalse: [^self].
	self setValueEditorsValue: self selectedValue! !

!CollectionBrowser methodsFor: 'storing-loading'!

load
	"Prompt the user for the name of a file from which a collection is to be 
	loaded. If the user provides no file name, then do nothing. If the file 
	does not exist, then inform the user and ask again. The loaded 
	collection is given to the receiver in the loadedNewCollection: message."

	| aFileName tmp |
	self changeRequest ifFalse: [^self].
	aFileName := nil.
	[aFileName isNil]
		whileTrue: 
			[aFileName := 
				FillInTheBlank request: 'Load information from file name' 
								initialAnswer: self filename.
			aFileName = '' ifTrue: [^nil].
			self filename: aFileName.
			Cursor read showWhile: [tmp := BinaryStorage fromFileNamed: aFileName].
			self loadedNewCollection: tmp.
			self noteModification]!

loadedNewCollection: aCollection
	"Additional structure has been retrieved. Insert it into the existing 
	structure after the current selection."

	^self subclassResponsibility!

save
	"Prompt the user for the name of a file into which to save the 
	receiver's collection. If the user types nothing, then do nothing."

	| aFileName |
	self changeRequest ifFalse: [^self].
	aFileName := FillInTheBlank request: 'File name for saving the outline ' 
							initialAnswer: self filename.
	aFileName = '' ifTrue: [^nil].
	aFileName asFilename exists ifTrue:
		[(self confirm: 'File already exists.  Proceed to overwrite?')
			ifFalse: [^nil]].
	self filename: aFileName.
	Cursor write showWhile: 
		[self inCleanDependencyEnvironmentDo: 
				[BinaryStorage put: self collection onFileNamed: aFileName]].
	modified := false! !

!CollectionBrowser methodsFor: 'dependents access'!

removeDependent: anObject
	"Clean up any dependency relationships when all dependents of the receiver are gone.
	This is usually when the last view on the receiver is closed."

	super removeDependent: anObject.
	dependents == nil
		ifTrue: [valueEditor release]! !

!CollectionBrowser methodsFor: 'private'!

inCleanDependencyEnvironmentDo: aBlock 
	"Execute aBlock with selected dependency relationships of the 
	receiver removed. This is useful with binary storage."

	self setValueEditorsValue: nil.
	aBlock valueNowOrOnUnwindDo: [self setValueEditorsValue: self selectedValue]!

newFor: newCategory 
	"Answer a new list item."

	^self newItemWithKey: newCategory value: self newItemValue!

newItemValue
	"Answer an prototypical value to store in the receivers collection."

	^valueEditor == nil
		ifFalse: [valueEditor newValue]
		ifTrue: [nil]!

newItemWithKey: newCategory value: newValue 
	"Answer an item with newCategory as the key and newValue 
	as the value."

	^self subclassResponsibility!

noteModification
	"Note that receiver's list has changed."

	modified := true!

setValueEditorsValue: aValue
	"Give aValue to the value editor to edit."

	valueEditor == nil
		ifFalse: [valueEditor value == aValue
					ifFalse: [valueEditor value: aValue]]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CollectionBrowser class
	instanceVariableNames: ''!


!CollectionBrowser class methodsFor: 'instance creation'!

new
	"Answer an initialized instance of the receiver."

	^super new initialize!

openOnFile: aFilename with: anEditor 
	"Open a collection browser on a new collection, loading the 
	information from the file whose name is aFilename. Use anEditor as 
	the editor for the values accessed through the collection.  This
	editor must respond to the message openOnFile:.  All examples
	of using a kind of CollectionBrowser are found in an associated
	editor."

	^anEditor openOnFile: aFilename! !

CollectionBrowser subclass: #OutlineBrowser
	instanceVariableNames: 'tree treeSelection '
	classVariableNames: 'PasteBuffer '
	poolDictionaries: ''
	category: 'Interface-Structures'!
OutlineBrowser comment:
'An instance of a OutlineBrowser is a CollectionBrowser for browsing and editing the structure of HierarchialCollections.
An OutlineBrowser represents an application that consists of a sophisticated hierarchical outline (like the table of contents of a book).

Instance Variables:
	tree			<Object>			any object for which a TreeAccessor can provide translation 
	treeSelection	<TreeSelection>		an object that remembers a current selection for the tree-like object

Class Variables:
	PasteBuffer		<Array>				collection element, index indicating whether to paste identity or a copy'!


!OutlineBrowser methodsFor: 'accessing'!

collection
	"Answer the tree that the receiver is browsing."

	^tree!

selectedValue
	"Answer the value of the receiver's current selection or nil if nothing 
	is selected."

	| selection |
	selection := self selected.
	^selection == nil
		ifTrue: [tree value]
		ifFalse: [selection value]!

selectionHolder
	"Answer receiver's treeSelection."

	^treeSelection!

tree: aTree 
	"Set the receiver's tree to be aTree."

	tree := aTree.
	treeSelection tree: aTree!

tree: aTree accessor: aTreeAccessor
	"Set the receiver's tree to be aTree. Access the tree with 
	aTreeAccessor."

	treeSelection := IndentedTreeSelection new.
	treeSelection treeAccessor: aTreeAccessor.
	treeSelection addDependent: self.
	self tree: aTree! !

!OutlineBrowser methodsFor: 'open set accessing'!

closeCurrent
	"Close the receiver's current selection."

	treeSelection closeCurrent!

deepCloseCurrent
	"Close the receivers current selection and all of its children."

	treeSelection deepCloseCurrent!

deepOpenCurrent
	"Open the receiver's current selection and all of its children."

	treeSelection deepOpenCurrent!

openCurrent
	"Open the receiver's current selection."

	treeSelection openCurrent! !

!OutlineBrowser methodsFor: 'changing'!

newLabel: aString
	"Sent by the user interface.  Change the key of the receiver's tree."

	tree key: aString.
	self noteModification! !

!OutlineBrowser methodsFor: 'menu messages'!

addAfter
	"Prompt the user for adding a new item to the outline. The item will 
	be added after the currently selected item at the same indent level."

	| newCategory |
	self changeRequest ifFalse: [^self].
	newCategory := FillInTheBlank request: 'New Outline Item' initialAnswer: ''.
	newCategory = '' ifTrue: [^self].
	self insertChildAfter:
		(self newFor: newCategory )
		withOpenedSet: nil!

addBefore
	"Prompt the user for adding a new item to the outline. The item will 
	be added before the currently selected item at the same indent level."

	|newCategory|
	self changeRequest ifFalse: [^self].
	newCategory := FillInTheBlank request: 'New Outline Item' initialAnswer: (''). 
	newCategory = '' ifTrue: [^self].
	self insertChildBefore:
		(self newFor: newCategory)
		withOpenedSet: nil!

addCategory
	"Prompt the user for adding a new item to the outline. The item will 
	be added at the end of the outline."

	| newCategory |
	self changeRequest ifFalse: [^self].
	newCategory := FillInTheBlank request: 'New Outline Item' initialAnswer: ''.
	newCategory = '' ifTrue: [^self].
	self insertCategory: newCategory!

addIndented
	"Prompt the user for adding a new item to the outline. The item will 
	be added before the currently selected item at the next indent level."

	|newCategory|
	self changeRequest ifFalse: [^self].
	newCategory := FillInTheBlank request: 'New Outline Item' initialAnswer: (''). 
	newCategory = '' ifTrue: [^self].
	self insertChild: (self newFor: newCategory )
		withOpenedSet: nil
.!

downLevel
	"Shift the indention of the currently selected item down one level in 
	the outline. This makes the item a subitem of the preceding item of 
	the outline."

	| current parent newParent index |
	current := self selectedChild.
	parent := self selectedChildParent.
	index := parent findIndexOfChild: current.
	index = 1 ifTrue: [^self].
	newParent := parent at: index - 1.
	parent removeChild: current.
	newParent addChild: current.
	treeSelection addToOpenedSet: (Array with: newParent).
	treeSelection resetChild: current.
	self noteModification!

renameCategory
	"Prompt the user for a new name and rename the selected item."

	| newCategory currentChild |
	self changeRequest ifFalse: [^self].
	currentChild := self selectedChild.
	newCategory := FillInTheBlank request: 'New item name' initialAnswer: currentChild name.
	newCategory = '' ifTrue: [^self].
	newCategory = currentChild name ifTrue: [^self].
	currentChild key: newCategory.
	treeSelection resetChild: currentChild.
	self noteModification!

selectionListMenu
	"Answer the menu to use in manipulating the outline."

	self selected == nil
		ifTrue: [^(MenuBuilder parseFrom: (ReadStream on:
					'add[addAfter] load[load] save[save]')) menu].
	^(MenuBuilder parseFrom: (ReadStream on:
		'(add: 	
			(after[addAfter] before[addBefore] indented[addIndented])
		 paste: 	
			(after[pasteAfter] before[pasteBefore] indented[pasteIndented]))
		(expand [openCurrent] contract[closeCurrent])
		(level: (up [upLevel] down [downLevel]))
		(copy[copyCurrent] cut[cut] rename [renameCategory])
		(load [load] save[save])')) menu!

upLevel
	"Shift the indention of the currently selected item up one level in 
	the outline (unless the item is already at the top). If this item is a 
	subitem, it basically is removed and inserted after the parent item, 
	at the same level as the parent."

	| current parent parentParent |
	current := self selectedChild.
	parent := self selectedChildParent.
	(current == tree or: [parent == tree])
		ifTrue: [^self].
	parentParent := self parentForChild: parent. 
	parent removeChild: current.
	parentParent addChild: current after: parent.
	parent isLeaf ifTrue: [treeSelection removeFromOpenedSet: (Array with: parent)].
	treeSelection resetChild: current.
	self noteModification.! !

!OutlineBrowser methodsFor: 'cut-copy-paste'!

copyCurrent
	"Place a copy of the currently selected item into the paste buffer."

	| current |
	current := self selectedChild.
	PasteBuffer := Array
					with: current
					with: (treeSelection openSetFor: current)
					with: 1!

cut
	"Remove the currently selected item and place it in the paste buffer."

	| current parent |
	self changeRequest ifFalse: [^self].
	current := self selectedChild.
	parent := self selectedChildParent.
	PasteBuffer := Array with: current with: (treeSelection openSetFor: current) with: 0.
	current == tree
		ifTrue: 
			[self tree: (self newFor: 'unnamed')]
		ifFalse: 
			[parent removeChild: self selectedChild.
			treeSelection removedChild: current from: parent.
			self currentChild: tree].
	self setValueEditorsValue: tree value.
	self noteModification!

pasteAfter
	"Add the item in the paste buffer after the currently selected item 
	at the same indent level."

	PasteBuffer == nil ifTrue: [^self].
	self checkPasteBuffer.
	self insertChildAfter: (PasteBuffer at: 1)
		withOpenedSet: (PasteBuffer at: 2)!

pasteBefore
	"Add the item in the paste buffer before the currently selected item 
	at the same indent level."

	PasteBuffer == nil ifTrue: [^self].
	self checkPasteBuffer.
	self insertChildBefore: (PasteBuffer at: 1)
		withOpenedSet: (PasteBuffer at: 2)!

pasteIndented
	"Add the item in the paste buffer after the currently selected item 
	at the next indent level."

	PasteBuffer == nil ifTrue: [^self].
	self checkPasteBuffer.
	self insertChild: (PasteBuffer at: 1)
		withOpenedSet: (PasteBuffer at: 2)! !

!OutlineBrowser methodsFor: 'storing-loading'!

loadedNewCollection: aCollection 
	"Additional structure has been retrieved. Insert it into the existing 
	structure after the current selection."

	self insertChildAfter: aCollection withOpenedSet: nil! !

!OutlineBrowser methodsFor: 'private'!

checkPasteBuffer
	"Sent by the paste operations, this method makes certain that the 
	first time a paste is done, that the actual structure is used. 
	Thereafter, multiple pastes creates copies."

	| tmp |
	PasteBuffer == nil ifTrue: [^self].
	PasteBuffer at: 3 put: (tmp := (PasteBuffer at: 3) + 1).
	tmp = 2 ifTrue: [PasteBuffer at: 1 put: ((PasteBuffer at: 1)
												copyAndReplaceInSet: (PasteBuffer at: 2))]!

currentChild: aChild
	"Set the receiver's currently selected child to be aChild."

	^treeSelection currentSelection: aChild!

insertChild: aChild withOpenedSet: aSet
	"Insert aChild in the receiver's outline."

	| selected |
	aChild == nil ifTrue: [^self].
	selected := self selectedChild.
	selected addChild: aChild.
	aSet isNil
		ifFalse: [treeSelection addToOpenedSet: aSet].
	(treeSelection isOpen: selected)
		ifFalse: [treeSelection openCurrent.
				self currentChild: selected.]
		ifTrue: [treeSelection resetChild: selected].
	self noteModification!

insertChildAfter: aChild withOpenedSet: aSet 
	"Insert aChild in the receiver's outline, after the currently 
	selected item."

	| selected parent|
Sensor leftShiftDown ifTrue: [self halt].
	aChild == nil ifTrue: [^self].
	selected := self selectedChild.
	parent := self selectedChildParent.
	selected == tree
		ifTrue: [selected addChild: aChild]
		ifFalse: [parent addChild: aChild after: selected].
	aSet isNil
		ifFalse: [treeSelection addToOpenedSet: aSet].
	treeSelection resetChild: selected.
	self noteModification!

insertChildBefore: aChild withOpenedSet: aSet
	"Insert aChild in the receiver's outline, before the currently 
	selected item."

	| selected parent |
	aChild == nil ifTrue: [^self].
	selected := self selectedChild.
	parent := self selectedChildParent.
	parent addChild: aChild before: selected.
	aSet isNil
		ifFalse: [treeSelection addToOpenedSet: aSet].
	treeSelection resetChild: selected.
	self noteModification!

newItemWithKey: newCategory value: newValue 
	"Answer an item with newCategory as the key and newValue 
	as the value."
	
	^AssociationTreeWithParent key: newCategory value: newValue!

parentForChild: aChild
	"Answer the parent of aChild."

	^aChild parent!

selectedChild
	"Answer the currently selected outline item--a subtree. If no item is 
	selected, answer the root of the outline."

	| aChild |
	aChild := self selected.
	^aChild == nil
		ifTrue: [tree]
		ifFalse: [aChild]!

selectedChildParent
	"Answer the currently selected outline item's parent--a subtree."

	^self selectedChild parent! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

OutlineBrowser class
	instanceVariableNames: ''!


!OutlineBrowser class methodsFor: 'examples'!

none
	"See EnvironmentEditor for an example of using the ListBrowser. A 
	OutlineBrowser without a value editor linked to it is not interesting. 
	EnvironmentEditor supports values that are Environments and 
	provides an appropriate editor."! !

StandardSystemController subclass: #CollectionBrowserController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-Structures'!
CollectionBrowserController comment:
'An CollectionBrowserController represents a kind of StandardSystemsController that requires confirmation from the user before the view on the display screen can be closed.'!


!CollectionBrowserController methodsFor: 'menu messages'!

close
	"Remove the receiver's view from the screen and from the collection 
	of scheduled views. First see if the model is in a state to close. If 
	not, that is, if the model has changed and its dependents are in the 
	process of reacting to the change or if the model has previously 
	initiated a close, do nothing."

	model changeRequest ifFalse: [^self].
	model closeRequest ifFalse: [^self].
	status := #closed.
	view erase!

newLabel
	"Prompt the user for a new label. Notify the model as to the new 
	label. If the user types nothing, then do nothing."

	| newLabel |
	newLabel := FillInTheBlank request: 'Type the new label' initialAnswer: view label.
	newLabel = ''
		ifFalse: 
			[view deEmphasize.
			view newLabel: newLabel.
			view emphasize.
			model newLabel: newLabel]! !