'From Smalltalk-80 of March 9, 1983 on 4 April 1983 at 12:02:51 pm'!

Object subclass: #ProtocolBrowser
	instanceVariableNames: 'list classDictionary selectedClass selectedSelector '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-Protocol'!

ProtocolBrowser comment:
'I am an example of a new type of Browser.
I show the entire protocol of the class i browse, including all super classes.

My instance variables are:
	list 					<OrderedCollection> all the methods in the given class and its superclasses
	classDictionary		<Dictionary> dictionary likking the methods to their classes
	selectedClass		<Class> class of the selected method
	selectedSelector	<Symbol> currently-selected message selector.

I am an example of Smalltalk-80 User Interface Programming.
'!


!ProtocolBrowser methodsFor: 'list access'!

selector: aString 
	"set the selector."

	aString == nil
		ifTrue: 
			[selectedSelector _ aString.
			^self].
	selectedSelector _ (aString copyUpTo: Character tab) asSymbol.
	selectedClass _ classDictionary at: selectedSelector.
	self changed: #text!

selectorList
	"return the selector list."

	^list!

selectorListMenu
	"generate the selector list menu."

	selectedSelector isNil
		ifTrue: [^nil]
		ifFalse: [^ActionMenu
				labels: 'senders\implementors\messages' withCRs
				lines: #()
				selectors: #(browseSenders browseImplementors browseMessages )]! !

!ProtocolBrowser methodsFor: 'text access'!

acceptText: aText from: aController 
	"accept changes to the text."

	| newSelector |
	newSelector _ selectedClass
				compile: aText
				classified: (selectedClass organization categoryOfElement: selectedSelector)
				notifying: aController.
	newSelector == nil ifTrue: [
		^false].
	newSelector == selectedSelector ifFalse: [
		self newSelectorList: newSelector].
	^true!

text
	"return the text or an empty string."

	selectedSelector == nil 
		ifTrue: [
			^'' asText].
	^(selectedClass sourceCodeAt: selectedSelector) asText makeSelectorBoldIn: selectedClass!

textMenu
	"return the menu for the text view."

	^ActionMenu
		labels: 'again\undo\copy\cut\paste\do it\print it\accept\cancel' withCRs
		lines: #(2 5 7)
		selectors: #(again undo copySelection cut paste doIt printIt accept cancel)! !

!ProtocolBrowser methodsFor: 'list functions'!

browseImplementors
	"open a message-set browser on all implementors of the selected method name."

	Smalltalk browseAllImplementorsOf: selectedSelector!

browseMessages
	"let the user select an item from a menu of messages sent from this method, then open a message-set browser on all implementors of it."

	Smalltalk showMenuThenBrowse:
		(selectedClass compiledMethodAt: selectedSelector)
			messages asSortedCollection!

browseSenders
	"open a message-set browser on all senders of the selected method name."

	Smalltalk browseAllCallsOn: selectedSelector! !

!ProtocolBrowser methodsFor: 'do it'!

doItContext
	"needed for do it"

	^ nil!

doItReceiver
	"needed for do it"

	^ nil!

doItValue: ignored
	"must be here"! !

!ProtocolBrowser methodsFor: 'private'!

on: aClass 
	"Create the protocol browser for the class, a Class."

	| defClass |
	list _ OrderedCollection new.
	classDictionary _ Dictionary new.
	aClass allSelectors asSortedCollection do: 
		[ :selector | 
			defClass _ aClass whichClassIncludesSelector: selector.
			list add: selector printString , '	(' , defClass name , ')'.
			classDictionary add: (Association key: selector value: defClass)]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ProtocolBrowser class
	instanceVariableNames: ''!


!ProtocolBrowser class methodsFor: 'instance creation'!

openForClass: aClass 
	"Create and schedule a browser for the entire protocol of the class."
	"ProtocolBrowser openForClass: ProtocolBrowser."

	| topView aPBrowser label |
	aPBrowser _ ProtocolBrowser new on: aClass.
	label _ 'Entire protocol of: ' , aClass name.
	topView _ StandardSystemView
				model: aPBrowser
				label: label
				minimumSize: 200 @ 200.
	topView addSubView: (SelectionInListView
				on: aPBrowser
				aspect: #selector
				change: #selector:
				list: #selectorList
				menu: #selectorListMenu
				initialSelection: nil)
		in: (0 @ 0.0 extent: 1 @ 0.3)
		borderWidth: 1.
	topView addSubView: (CodeView
				on: aPBrowser
				aspect: #text
				change: #acceptText:from:
				menu: #textMenu
				initialSelection: nil)
		in: (0 @ 0.3 extent: 1 @ 0.7)
		borderWidth: 1.
	topView controller open! !

