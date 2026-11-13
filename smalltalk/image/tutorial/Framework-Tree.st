Association subclass: #AssociationTree
	instanceVariableNames: 'children '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Tree'!
AssociationTree comment:
'Instances of this class represent the basic notion of tree nodes.  Each tree node has a key (or name), a value, and a collection of children.

Instance Variables:
		children		<OrderedCollection> 		the receiver''s children'!


!AssociationTree methodsFor: 'accessing'!

at: anIndex 
	"Answer the child of the receiver identified by anIndex."

	^children at: anIndex!

children
	"Answer the receiver's OrderedCollection of children."

	children == nil ifTrue: [^OrderedCollection new].
	^children!

findIndexOfChild: someObject
	"Answer the index of someObject, that is, its position as one of the 
	children of the receiver. Answer nil if someObject is not a child of the 
	receiver."

	children == nil ifTrue: [^nil].
	1 to: children size 
		do: [:i | (children at: i) == someObject ifTrue: [^i]].
	^nil!

isLeaf
	"Answer whether or not the receiver is a leaf, i.e., whether the 
	receiver has children."

	^children == nil or: [children size = 0]!

name
	"Answer the name (key) of the receiver."

	^key!

size
	"Answer the number of children of the receiver."

	^children == nil
		ifTrue: [0]
		ifFalse: [children size]! !

!AssociationTree methodsFor: 'copying'!

copy
	"Answer another instance just like the receiver, but with a copy of 
	the receiver's value and a copy of each of the receiver's children."

	| cpy tmpChildren |
	tmpChildren := children.
	children := nil.
	cpy := self shallowCopy.
	cpy value: value copy.
	tmpChildren isNil
		ifFalse: [tmpChildren do: [:child | cpy addChild: child copy]].
	children := tmpChildren.
	^cpy!

copyAndReplaceInSet: aSet
	"Answer a copy of the receiver with all references to it in aSet 
	updated as well."

	| cpy tmpChildren |
	tmpChildren := children.
	children := nil.
	cpy := self shallowCopy.
	cpy value: value copy.
	(aSet includes: self)
		ifTrue: [aSet remove: self.
				aSet add: cpy].
	tmpChildren isNil
		ifFalse: [tmpChildren do:
					[:child |
					cpy addChild: (child copyAndReplaceInSet: aSet)]].
	children := tmpChildren.
	^cpy!

deepCopy
	"Answer a copy of the receiver with its own deepCopy of each instance variable."

	| tmpChildren cpy |
	tmpChildren := children.
	children := nil.
	cpy := super deepCopy.
	tmpChildren isNil
		ifFalse: [tmpChildren do:
					[:child |
					cpy addChild: child deepCopy]].
	children := tmpChildren.
	^cpy! !

!AssociationTree methodsFor: 'adding'!

addChild: anObject 
	"Add anObject as a child of the receiver."

	children == nil ifTrue: [children := OrderedCollection new].
	children addLast: anObject.!

addChild: anObject after: someObject 
	"Add anObject to the receiver's list of children after someObject."

	| index |
	index := self findIndexOfChild: someObject.
	index == nil
		ifTrue: [self error: 'object not found'].
	index = children size
		ifTrue: [^self addChild: anObject].
	self children add: anObject beforeIndex: index+1.!

addChild: anObject before: someObject 
	"Add anObject to the receiver's list of children before someObject."

	| index |
	index := self findIndexOfChild: someObject.
	index == nil
		ifTrue: [self error: 'object not found'].
	self children add: anObject beforeIndex: index.! !

!AssociationTree methodsFor: 'removing'!

removeChild: anObject 
	"Remove the anObject from the receiver's list of children."

	self children remove: anObject.
	self children isEmpty ifTrue: [children := nil]! !

!AssociationTree methodsFor: 'searching'!

childNamed: aKey 
	"Search just the receiver's children to find the child named aKey. 
	Answer the child if it exists, otherwise answer nil."

	^self children detect: [:each | each key = aKey]
		ifNone: [nil]!

childrenNames
	"Answer the names of children in the receiver's list of children."

	^self children collect: [:each | each key]!

find: aKey
	"Recursively (depth-first) search the receiver's children to find the child named aKey. 
	Answer the child if it exists, otherwise return nil."

	| result |
	aKey = key
		ifTrue: [^self]
		ifFalse: [self isLeaf
					ifTrue: [^nil]
					ifFalse: [children do:
								[:child |
								result := child find: aKey.
								result == nil ifFalse: [^result]].
							^nil]]! !

!AssociationTree methodsFor: 'enumeration'!

childrenDo: aBlock 
	"For each of the receiver's children, execute aBlock with each child 
	as an argument."

	self children do: 
		[:m | 
		aBlock value: m.
		m childrenDo: aBlock]!

withChildrenDo: aBlock
	"For the receiver and each of its children, execute aBlock with each 
	as an argument."

	aBlock value: self.
	self children do: [:m | m withChildrenDo: aBlock]! !

AssociationTree subclass: #AssociationTreeWithParent
	instanceVariableNames: 'parent '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Tree'!
AssociationTreeWithParent comment:
'An instance of this class represents an AssociationTree with a parent. 

Instance Variables:
		parent		<Object> 	the receiver''s parent'!


!AssociationTreeWithParent methodsFor: 'accessing'!

parent
	"Answer the parent of the receiver."

	^parent!

parent: anObject
	"Set the parent of the receiver to be anObject."

	parent := anObject! !

!AssociationTreeWithParent methodsFor: 'copying'!

deepCopy
	"Answer a copy of the receiver with its own deepCopy of each instance variable."

	| tmpParent cpy |
	tmpParent := parent.
	parent := nil.
	cpy := super deepCopy.
	parent := tmpParent.
	^cpy! !

!AssociationTreeWithParent methodsFor: 'adding'!

addChild: someChild
	"Add aChild as a child of the receiver, and set someChild's 
	parent to be the receiver."

	super addChild: someChild. 
	someChild parent: self!

addChild: aChild after: someChild 
	"Add aChild to the receiver's list of children after someChild. Also, 
	make aChild's parent be the receiver."

	super addChild: aChild after: someChild.
	aChild parent: self.!

addChild: aChild before: someChild 
	"Add aChild to the receiver's list of children before someChild. Also, 
	make aChild's parent be the receiver."

	super addChild: aChild before: someChild.
	aChild parent: self! !

!AssociationTreeWithParent methodsFor: 'removing'!

removeChild: aChild 
	"Remove the aChild from the receiver's list of children. Also, set 
	aChild's parent to be nil."

	super removeChild: aChild.
	aChild parent: nil.! !

Model subclass: #TreeSelection
	instanceVariableNames: 'tree treeAccessor openedSet currentSelection '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Tree'!
TreeSelection comment:
'An instance of TreeSelection that holds a tree with a child selected and a set of children that have been opened for traversal.

Instance Variables:
	tree			<anObject> 	that represents the root of a tree structure
	treeAccessor	<TreeAccessor>	that acts as a protocol translator between the receiver 
									and the elements that comprise the tree
	openedSet		<IdentitySet>	set of tree elements whose children are considered traversable
	currentSelection <anObject>	the tree child that is currently selected

'!


!TreeSelection methodsFor: 'accessing'!

currentSelection
	"Answer the currently selected tree element."

	^currentSelection!

currentSelection: aNode
	"Set the receivers the currently selected tree element."

	| old |
	old := self currentSelectionState.
	currentSelection := aNode.
	currentSelection == self root
		ifTrue: [currentSelection := nil].
	self changedCurrentSelectionWithOld: old!

tree
	"Answer the receivers tree."

	^ tree!

tree: aTree
	"Set the receiver's tree to be aTree."

	tree := aTree.
	openedSet := IdentitySet new.
	openedSet add: tree.
	currentSelection := nil.!

treeAccessor
	"Answer the receiver's treeAccessor."

	^treeAccessor!

treeAccessor: aTreeAccessor
	"Set the receiver's treeAccessor to be aTreeAccessor."

	treeAccessor := aTreeAccessor! !

!TreeSelection methodsFor: 'tree accessor'!

childrenFor: aNode
	"Answer the children for node aNode."

	^treeAccessor childrenFor: aNode!

isLeaf: aNode
	"Answer whether aNode is a leaf."

	^treeAccessor isLeaf: aNode!

nameFor: aNode
	"Answer the name for node aNode."

	^treeAccessor nameFor: aNode!

root
	"Answer the root of the tree."

	^tree! !

!TreeSelection methodsFor: 'opened set accessing'!

addToOpenedSet: aCollection 
	"Add aCollection of elements to the receiver's set of traversable 
	children.  Do not notify dependents."

	aCollection == nil ifFalse: [openedSet addAll: aCollection]!

close: aChild 
	"Close aChild causing all of its children to be 'inaccessible'."

	openedSet remove: aChild ifAbsent: [^self].
	self changedOpenedSet!

closeCurrent
	"Close the currently selected child causing all of its children to be 
	'inaccessible'."

	currentSelection == nil ifTrue: [^self].
	self close: currentSelection!

deepCloseCurrent
	"Close the current tree element and any of its children."

	| sel |
	sel := self currentSelection.
	sel == nil
		ifTrue: [(self childrenFor: tree) do:
					[:node | self deepClose: node]]
		ifFalse: [self deepClose: sel].
	self changedOpenedSet!

deepOpenCurrent
	"Open the current tree element and any of its children."

	| sel |
	sel := self currentSelection.
	self deepOpen: ((sel == nil) ifTrue: [tree] ifFalse: [sel]).
	self changedOpenedSet!

isOpen: aChild 
	"Open aChild. This causes all of its children to be 'accessible'."

	^(openedSet includes: aChild)!

open: aChild 
	"Open aChild. This causes all of its children to be 'accessible'."

	(self isLeaf: aChild)
		ifFalse: 
			[(openedSet includes: aChild)
				ifFalse: [openedSet add: aChild.
						self changedOpenedSet]]!

openCurrent
	"Open the currently selected node causing all of its childern to be 'accessible'"

	currentSelection == nil
		ifTrue: [^self].
	self open: currentSelection!

openSetFor: aChild 
	"Answer the intersection of the opened set with the set of element 
	descendent from aChild that are in the opened set."
	
	| set |
	set := IdentitySet new.
	^(self isLeaf: aChild)
		ifTrue: [set]
		ifFalse: 
			[aChild withChildrenDo: 
				[:n | (self isOpen: n) ifTrue: [set add: n]].
			set]!

removedChild: aChild from: aParent 
	"Remove aChild from the opened set and remove aParent if aParent 
	now has no children."

	(openedSet includes: aChild)
		ifTrue: [aChild withChildrenDo: [:c | openedSet remove: c ifAbsent: []]].
	((openedSet includes: aParent) and: [aParent ~~ self root])
		ifTrue: [(self childrenFor: aParent) size = 0 ifTrue: [openedSet remove: aParent]].
	self changedOpenedSet!

removeFromOpenedSet: aCollection
	"Remove aCollection of nodes from the receivers opened set.
	Does not notify dependents."

	aCollection == nil
		ifFalse: [aCollection do: [:each | openedSet remove: each ifAbsent: []]]! !

!TreeSelection methodsFor: 'private'!

changedCurrentSelectionWithOld: oldSelectionState 
	"The current selection just changed. Do anything to respond including 
	telling dependents."

	self changed: #currentSelection with: oldSelectionState!

changedOpenedSet

	self changed: #openedSet!

currentSelectionState
	"Answer the receivers current selection."

	^currentSelection!

deepClose: aNode
	"Remove aNode and all children from the opened set."

	openedSet remove: aNode ifAbsent: [].
	(self childrenFor: aNode) do: 
		[:child | 
		self deepClose: child]!

deepOpen: aNode
	"Add aNode and all children to the opened set."

	openedSet add: aNode.
	(self childrenFor: aNode) do: 
		[:child | 
		self deepOpen: child]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeSelection class
	instanceVariableNames: ''!


!TreeSelection class methodsFor: 'instance creation'!

on: aTree
	"Create a new instance of the receiver on aTree."

	^self new tree: aTree! !

TreeSelection subclass: #IndentedTreeSelection
	instanceVariableNames: 'selectionList currentSelectionIndex nonTerminalBolding '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Tree'!
IndentedTreeSelection comment:
'Instances of this class represent protocol converters for accessing the structure of tree-type elements as indented lists.  (Note that if the tree should be shown as a digraph, another class is needed.)

Instance Variables:
	selectionList		<OrderedCollection> 	that contains a collection of strings representing the 
												depth first order traversal of the instance
	currentSelectionIndex 	<Integer> 			representing the number (relative to the selectionList) 
												of the currently selected item
	nonTerminalBolding		<Boolean>			true if the instance has children, the children are not 
												displayed, and the selection should be shown emphasized

'!


!IndentedTreeSelection methodsFor: 'accessing'!

nonTerminalBolding: aBoolean
	"Set the receiver's non terminal bolding to true or false."

	nonTerminalBolding := aBoolean!

resetChild: aChild 
	"Signal that a new list is necessary. Set the receiver's current 
	selection to be aChild."

	selectionList := nil.
	self changed: #list.
	self currentSelection: aChild!

tree: aTree
	"Set the receiver's tree to be aTree."

	super tree: aTree.
	currentSelectionIndex := 0.
	selectionList := nil.
	nonTerminalBolding := true! !

!IndentedTreeSelection methodsFor: 'tree list messages'!

list
	"Answer the receiver's indented list."

	selectionList == nil ifTrue: [self buildIndentedList].
	^selectionList!

listIndex
	"Answer the receiver`s indented list index."

	^currentSelectionIndex!

toggleListIndex: aNumber 
	"Change the receiver`s indented list index to be aNumber."

	| old |
	currentSelectionIndex = nil ifTrue: [^self].
	old := self currentSelectionState.
	currentSelectionIndex := aNumber.
	aNumber = 0
		ifTrue: [currentSelection := nil]
		ifFalse: [currentSelection := 
					self findChildForIndex: currentSelectionIndex
						currentIndex: 0
						child: self root].
	self changed: #currentSelection with: old! !

!IndentedTreeSelection methodsFor: 'private'!

addChild: aChild indentLevel: indentLevel 
	"Add aChild to the the receiver's indented list at indentLevel."

	aChild == self root 
		ifFalse: [selectionList add: (self nameFor: aChild indentLevel: indentLevel)].
	(self isOpen: aChild)
		ifTrue: [(self childrenFor: aChild)
					do: [:child | self addChild: child indentLevel: indentLevel + 1]]!

addOpenChild: anOpenNode indentlevel: indentLevel 
	"Add anOpenNode to the receiver's indented list at indentLevel."

	| openChildern |
	selectionList add: (self nameFor: anOpenNode indentLevel: indentLevel).
	openChildern := self openChildrenFor: anOpenNode.
	openChildern do: [:child | self addOpenChild: child indentlevel: indentLevel + 1]!

buildIndentedList
	"Build the receiver's indented list."
	
	selectionList := OrderedCollection new.
	currentSelectionIndex := 0.
	self addChild: self root indentLevel: -1.!

changedCurrentSelectionWithOld: oldSelectionState
	"The current selection just changed. Reset selection indexes and 
	tell dependents."

	currentSelection == nil 
		ifTrue: [currentSelectionIndex := 0]
		ifFalse: [currentSelectionIndex := 
					self findIndexForChild: currentSelection
						currentIndex: 0
						child: self root.
				(currentSelectionIndex isMemberOf: Array)
					ifTrue: [currentSelectionIndex := currentSelectionIndex at: 1]
					ifFalse: [currentSelectionIndex := 0]].
	self changed: #listIndex with: oldSelectionState.
	super changedCurrentSelectionWithOld: oldSelectionState!

changedOpenedSet
	"Build the receiver's indented list starting at the current selection."

	| tmpSelection |
	tmpSelection := currentSelectionIndex.
	self buildIndentedList.
	currentSelectionIndex := tmpSelection.
	self changed: #list.
	super changedOpenedSet!

currentSelectionState
	"Answer the receiver's current selection and current selection index 
	in an Array."

	^Array with: currentSelectionIndex with: currentSelection!

findChildForIndex: aNumber currentIndex: cIndex child: aChild 
	"Answer the child associate with aNumber in the indented list."

	| tmp |
	cIndex >= aNumber ifTrue: [^aChild].
	(self isOpen: aChild) ifFalse: [^cIndex].
	tmp := cIndex.
	(self childrenFor: aChild)
		do: [:baby | 
			tmp := tmp + 1.
			tmp := self findChildForIndex: aNumber
						currentIndex: tmp
						child: baby.
			(tmp isMemberOf: SmallInteger)
				ifFalse: [^tmp]].
	^tmp!

findIndexForChild: aChild currentIndex: cIndex child: cChild
	"Answer the index in the indented list associated with aChild."

	| tmp children |
	cChild == aChild ifTrue: [^Array with: cIndex].
	(self isOpen: cChild) ifFalse: [^cIndex].
	tmp := cIndex.
	children := (self childrenFor: cChild).
	1 to: children size do:
			[:i | | baby |
			baby := children at: i.
			tmp := tmp + 1.
			tmp := self findIndexForChild: aChild
						currentIndex: tmp
						child: baby.
			(tmp isMemberOf: Array) ifTrue: [^tmp]].
	^tmp!

nameFor: child indentLevel: num
	"Answer a string for child with the proper level of indenting."
	
	| aStream string |
	aStream := (String new: 25) writeStream.
	num timesRepeat: [aStream nextPut: Character space; space; space; space].
	aStream nextPutAll: (self nameFor: child).
	string := aStream contents.
	(self isLeaf: child)
		ifTrue: [^string].
	^(nonTerminalBolding == true and: [(openedSet includes: child) not])
		ifTrue: [Text string: string emphasis: 2]
		ifFalse: [string]! !

Object subclass: #TreeAccessor
	instanceVariableNames: 'isLeafTranslation childrenTranslation nameTranslation '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Tree'!
TreeAccessor comment:
'An instance of TreeAccessor represents a protocol translator for using the tree protocol to access objects that do not understand tree protocol directly.  The replacement protocol is saved as properties of the instance.  TreeAccessors are used to translate messages children and name, and sometimes isLeaf.

Instance Variables:
	isLeafTranslation		<nil | Symbol> 	nil means that there is no direct translation for the message isLeaf;
											otherwise, the Symbol is the appropriate translation.
	childrenTranslation		<Symbol> 		the translation for children
	nameTranslation		<Symbol> 		the translation for name


'!


!TreeAccessor methodsFor: 'accessing'!

childrenFor: aChild
	"Answer the children for aChild."

	^aChild perform: childrenTranslation!

isLeaf: aChild
	"Answer true or false as to whether aChild has children."

	isLeafTranslation == nil
		ifTrue: [^(self childrenFor: aChild) size = 0].
	^aChild perform: isLeafTranslation!

nameFor: aChild
	"Answer a printable name for aChild."

	^aChild perform: nameTranslation! !

!TreeAccessor methodsFor: 'private'!

setIsLeaf: leafSelector children: childSelector name: nameSelector
	"Set the adaptor messages for the receiver."

	isLeafTranslation := leafSelector.
	childrenTranslation := childSelector.
	nameTranslation := nameSelector! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeAccessor class
	instanceVariableNames: ''!


!TreeAccessor class methodsFor: 'instance creation'!

children: childSelector name: nameSelector
	"Create a new instance of the receiver with appropriate adaptor messages."

	^self new setIsLeaf: nil children: childSelector name: nameSelector!

isLeaf: leafSelector children: childSelector name: nameSelector
	"Create a new instance of the receiver with appropriate adaptor messages."

	^self new setIsLeaf: leafSelector children: childSelector name: nameSelector! !

Model subclass: #TreeBrowser
	instanceVariableNames: 'tree treeSelection '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Tree'!
TreeBrowser comment:
'An instance of TreeEditor provides an interface to create and modify trees as indented lists.

Instance Variables:
	tree			<Object>			any object for which a TreeAccessor can provide translation 
	treeSelection	<TreeSelection>		an object that remembers a current selection for the tree-like object'!


!TreeBrowser methodsFor: 'initialize-release'!

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

!TreeBrowser methodsFor: 'accessing'!

currentChild
	"Answer the receiver's currently selected child."

	^treeSelection currentSelection!

currentChild: aChild
	"Set the receiver's currently selected child to be aChild."

	^treeSelection currentSelection: aChild!

tree
	"Answer the receiver's tree."

	^tree!

treeSelection
	"Answer the receiver's tree selection."

	^treeSelection! !

!TreeBrowser methodsFor: 'open set accessing'!

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

!TreeBrowser methodsFor: 'updating'!

update: anAspect with: aParameter from: anObject 
	"Receive a change notice from an object, denoted by aSender, 
	of whom the receiver is a dependent."

	anObject == 
		treeSelection 
			ifTrue: [self
					updateTreeSelection: anAspect
					with: aParameter
					from: anObject]!

updateTreeSelection: anAspect with: aParameter from: anObject 
	"The receiver's tree selection has changed. The default is to do 
	nothing."! !

!TreeBrowser methodsFor: 'menu messages'!

selectionListMenu
	"Answer a menu for messages in the receiver." 

	^ActionMenu
		labels: 'open\close\deep open\deep close' withCRs
		selectors: #(openCurrent closeCurrent deepOpenCurrent deepCloseCurrent)! !

!TreeBrowser methodsFor: 'dependents access'!

removeDependent: anObject
	"Clean up any dependency relationships when all dependents of the receiver are gone.
	This is usually when the last view on the receiver is closed."

	super removeDependent: anObject.
	dependents == nil
		ifTrue: [self cleanUpDependency]! !

!TreeBrowser methodsFor: 'private'!

cleanUpDependency
	"Clean up any dependency relationships that the receiver has."!

inCleanDependencyEnvironmentDo: aBlock 
	"Execute aBlock with selected dependency relationships of the 
	receiver removed.  This is useful with binary storage."

	self cleanUpDependency.
	aBlock valueNowOrOnUnwindDo: [self setUpDependency]!

setUpDependency
	"Set up any dependency relationships that the receiver needs."! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TreeBrowser class
	instanceVariableNames: ''!


!TreeBrowser class methodsFor: 'examples'!

editClass: aClass 
	"Open a tree editor on aClass. The tree-like behavior for a class 
	is assumed to be the subclass hierarchy."

	"TreeBrowser editClass: Object"

	| me topView listView treeAccessor |
	treeAccessor := TreeAccessor children: #subclasses name: #name.
	me := self new.
	me tree: aClass accessor: treeAccessor.
	topView := StandardSystemView new label: aClass name asString.
	topView borderWidth: 1.
	topView insideColor: Form white.
	listView := self getListViewFor: me.
	listView borderWidth: 1.
	topView addSubView: listView.
	topView controller open! !

!TreeBrowser class methodsFor: 'private'!

getListViewFor: aTreeEditor
	"Answer an initialized list view on aTreeEditor."

	^ListSelectionView
			on: aTreeEditor treeSelection
			menuChannel: (MessageSend receiver: aTreeEditor selector: #selectionListMenu)
			changeRequestChannel: [aTreeEditor changeRequest]! !