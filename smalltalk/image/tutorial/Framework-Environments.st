TextHolder subclass: #Environment
	instanceVariableNames: 'locals '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Environments'!
Environment comment:
'Instances of this class are workspaces with local variables. 

Environments are like index cards in the paper world.  Each Environment has some textual information.  In addition, each Environment has a dictionary of local variables that are created by executing expressions within the context of the Environment.  These local variables serve as a replacement for temporary or global variables (as they are used in workspaces) but differ in that they persist for the life of the Environment.

Instance Variables:
	locals	<Dictionary> that maintains the local variables associated with an environment'!


!Environment methodsFor: 'accessing'!

addNewBinding: anAssociation 
	"Add a new binding (value) to the receiver's local variables. This may 
	be of interest to dependents, so broadcast a change."

	self locals add: anAssociation.
	self changed: #locals with: anAssociation!

locals
	"Answer the receiver's local variable dictionary."

	locals == nil ifTrue: [locals := Dictionary new].
	^locals!

locals: aDictionary
	"Set the receiver's local variable dictionary to be aDictionary."

	locals := aDictionary!

localScopes
	"Answer an array containing the receiver's local variables. This is 
	used by an EnvironmentCompiler for determining the lexical scope of 
	variables."

	^Array with: self locals! !

!Environment methodsFor: 'copying'!

copy
	"Answer another instance just like the receiver, but with a copy of the receiver's locals."

	| copy |
	copy := self shallowCopy.
	copy breakDependents.
	locals == nil
		ifFalse: [| localsCopy |
				localsCopy := Dictionary new.
				locals associationsDo: [:assoc | localsCopy add: assoc copy].
				copy locals: localsCopy].
	^copy! !

!Environment methodsFor: 'doIt/accept/explain'!

doItReceiver
	"Answer the object that should be informed of the result of evaluating a
	text selection.  In this default case, anwer nil that no object is informed."

	^self!

doItValue: ignored 
	"Process the value returned from an evaluation of selected text. By 
	default, inform any dependents that there may be a new local 
	variable to display."

	self changed: #localValue! !

!Environment methodsFor: 'private'!

defaultContents
	^ Text new! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Environment class
	instanceVariableNames: ''!


!Environment class methodsFor: 'compiler access'!

evaluatorClass
	"Answer an evaluator class appropriate for evaluating expressions in the 
	context of instances of this class."

	^EnvironmentCompiler! !

!Environment class methodsFor: 'examples'!

openAsWorkspace
	"An Environment that looks like a Workspace but has local variables 
	is created by reusing the StringHolder view and controller."

	"Environment openAsWorkspace"

	StringHolderView open: Environment new label: 'Environment'!

openWithInspector1
	"An Environment that looks like a Workspace but has local variables 
	that appear in a dictionary inspector is created by reusing the 
	StringHolder view and controller as subviews (an inspector for a 
	DictionaryInspector is created). The inspector is formed with two 
	subviews--a SelectionInListView and a CodeView. 
	
	This is not a satisfactory solution because new local variables do 
	not automatically appear in the inspector, and the values of the 
	currently selected variable are not automatically displayed nor 
	updated."

	"Environment openWithInspector1"

	"
	To see it display, in the Environment text area, evaluate 
	DictionaryInspector allInstancesDo: [:e | e object = self locals ifTrue: 
	[e changed: #field. e update]] 
	"

	| me inspector aStringHolderView topView |
	me := self new.
	aStringHolderView := StringHolderView container: me.
	topView := StandardSystemView new.
	topView borderWidth: 1.
	topView model: me.
	topView label: 'An Environment'.
	topView minimumSize: 200 @ 150.
	topView
		addSubView: aStringHolderView
		in: (0 @ 0 extent: 1.0 @ 0.6)
		borderWidth: 1.

	inspector := DictionaryInspector inspect: me locals.
	topView
		addSubView: (SelectionInListView
				on: inspector
				printItems: false
				oneItem: false
				aspect: #field
				change: #field:
				list: #fieldList
				menu: #fieldMenu
				initialSelection: #field)
		in: (0@0.6 extent: 0.333 @ 0.4)
		borderWidth: 1.

	topView
		addSubView: (CodeView
				on: inspector
				aspect: #text
				change: #acceptText:from:
				menu: #textMenu
				initialSelection: nil)
		in: (0.333 @ 0.6 extent: 0.666 @ 0.4)
		borderWidth: 1.


	topView controller open!

openWithInspector2
	"An Environment that looks like a Workspace but has local variables 
	that appear in a dictionary inspector is created by reusing the 
	StringHolder view and controller as subviews, but now an inspector 
	for an EnvironmentInspector is created. This inspector has the 
	Environment as a dependent so when a new local variable is added, 
	the inspector knows and can update its dictionary. 
	
	This is still not a satisfactory solution because the value of the 
	currently selected variable is not automatically updated."
	"Environment openWithInspector2"

	| me aStringHolderView topView |
	me := self new.
	aStringHolderView := StringHolderView container: me.
	topView := StandardSystemView new.
	topView borderWidth: 1.
	topView model: me.
	topView label: 'An Environment'.
	topView minimumSize: 200 @ 150.
	topView
		addSubView: aStringHolderView
		in: (0 @ 0 extent: 1.0 @ 0.6)
		borderWidth: 1.
	EnvironmentInspector
		inspectorFor: (EnvironmentInspector new environment: me)
		in: topView
		box: (0 @ 0.6 extent: 1@0.4).
	topView controller open! !

Environment subclass: #HierarchicalEnvironment
	instanceVariableNames: 'parent '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Environments'!
HierarchicalEnvironment comment:
'An HierarchicalEnvironment is an Environment that can create hierarchical environments that know their parent. A parent bequeaths local variables to its descendents. Thus, an instance of this class is an Environment whose total set of local variables includes its own and any that it inherits from a chain of parents.

Instance Variables:
	parent	<Environment> 	the parent of the receiver'!


!HierarchicalEnvironment methodsFor: 'accessing'!

localScopes
	"Answer an OrderedCollection containing the receiver's local 
	variables. This is used by an EnvironmentCompiler for determining 
	the lexical scope of variables."

	| env scopes |
	scopes := OrderedCollection new.
	env := self.
	[env == nil]
		whileFalse: 
			[scopes addLast: env locals.
			env := env parent].
	^scopes!

parent
	"Answer the receiver's parent."

	^parent!

parent: aParent 
	"Set the receiver's parent to be aParent."

	parent := aParent! !

Compiler subclass: #EnvironmentCompiler
	instanceVariableNames: 'environment '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Environments'!
EnvironmentCompiler comment:
'An EnvironmentCompiler is a Smalltalk-80 compiler that is capable of evaluating code in the context of an environment with local scope.  Instances need to know about the legal local variables that may be referenced (i.e., environments must implement the message locals). Instances also specify which InteractiveCompilerErrorHandler to use when compilation errors occur.

Instance Variables
	environment	<Environment> that is used as the context for the compilation
'!


!EnvironmentCompiler methodsFor: 'public access'!

evaluate: textOrStream in: aContext receiver: anEnvironment notifying: aRequestor ifFail: failBlock 
	"This is the preferred method for having a compiler 
	compile/install/execute code. For the receiver, this method compiles 
	and executes the code in textOrStream. If the parameter 
	anEnvironment is not nil, then the text can refer to local variables of
	Environment. If aRequestor is not nil, then it will receive a notify:at: 
	message before the attempt to evaluate is aborted.  Failure results
	in the evaluation of the block failBlock."

	environment := anEnvironment.
	^super
		evaluate: textOrStream
		in: aContext
		receiver: anEnvironment
		notifying: aRequestor
		ifFail: failBlock! !

!EnvironmentCompiler methodsFor: 'private'!

getInteractiveCompilerErrorHandler
	"Answer an initialized instance of the error handler used by the 
	receiver."

	^(InteractiveEnvironmentCompilerErrorHandler new) 
		class: class; 
		editor: requestor; 
		environment: environment!

scopeForClass
	"Answer the sequence of scopes of variables available for reference 
	by the receiver's environment."

	| envScopes headScope tailScope scope |
	envScopes := environment localScopes.
	envScopes size = 0 ifTrue: [^super scopeForClass].
	headScope := tailScope := StaticScope variables: (envScopes at: 1).
	2 to: envScopes size do: 
		[:i | 
		scope := StaticScope variables: (envScopes at: i).
		tailScope outerScope: scope.
		tailScope := scope].
	tailScope outerScope: super scopeForClass.
	^headScope!

translate: aStream noPattern: noPattern ifFail: failBlock 
	"Translate the stream aStream into a compiled method. Chooses 
	which CompilerErrorHandler to use in the event of an exceptional 
	condition--interactive if the receiver's requestor is not nil, 
	otherwise non-interactive handler. Execute failBlock if the 
	translation fails."

	^self
		translate: aStream
		noPattern: noPattern
		ifFail: failBlock
		needSourceMap: false
		handlerClass: (requestor isNil
				ifTrue: [NonInteractiveCompilerErrorHandler]
				ifFalse: [InteractiveEnvironmentCompilerErrorHandler])! !

DictionaryInspector subclass: #EnvironmentInspector
	instanceVariableNames: 'environment '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Environments'!
EnvironmentInspector comment:
'An instance of EnvironmentInspector is a kind of DictionaryInspector that maintains the dictionary for the local variables of the Environment to which it refers.

Instance Variables:
	environment	<Environment>'!


!EnvironmentInspector methodsFor: 'accessing'!

environment: anEnvironment 
	"Set the receiver's environment to be anEnvironment. Then the 
	receiver is set to inspect the local variables of anEnvironment. 
	Since the choice of environment can dynamcially change, be care to 
	handle dependency references."

	environment removeDependent: self.
	environment := anEnvironment.
	environment == nil
		ifTrue: [environment := Environment new].
	environment addDependent: self.
	self inspect: environment locals! !

!EnvironmentInspector methodsFor: 'dependents access'!

removeDependent: anObject
	"Clean up any dependency relationships when all dependents of the receiver are gone.
	This is usually when the last view on the receiver is closed."

	super removeDependent: anObject.
	dependents == nil
		ifTrue: [environment removeDependent: self]! !

!EnvironmentInspector methodsFor: 'updating'!

update: anAspect with: aParameter from: anObject 
	"Because some aspect of the receiver's local variables has changed, 
	the receiver informs its inspector. In one aspect (#locals), a new 
	variable has been added."

	anAspect == #locals
		ifTrue: 
			[self field: aParameter key.
			self update.
			self changed: #field.
			^self update].
	anAspect == #localValue ifTrue: [^self update].
	^super
		update: anAspect
		with: aParameter
		from: anObject! !

!EnvironmentInspector methodsFor: 'menu commands'!

addField

	| aString key |
	aString := FillInTheBlank request: 'Enter key as a Smalltalk constant'.
	aString isEmpty ifTrue: [^self].
	key := aString asSymbol.
	object add: (Association key: key value: nil).
	field := key.
	self changed: #field! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

EnvironmentInspector class
	instanceVariableNames: ''!


!EnvironmentInspector class methodsFor: 'view creation'!

inspectorFor: aModel in: aView box: aRectangle
	"Create the subviews for the dictionary inspector on aModel and put 
	it into aView at the relative location starting at originPoint."

	aView
		addSubView: (SelectionInListView
				on: aModel
				printItems: false
				oneItem: false
				aspect: #field
				change: #field:
				list: #fieldList
				menu: #fieldMenu
				initialSelection: #field)
		in: (aRectangle origin extent: (aRectangle width/2)@aRectangle height)
		borderWidth: 1.

	aView
		addSubView: (CodeView
				on: aModel
				aspect: #text
				change: #acceptText:from:
				menu: #textMenu
				initialSelection: nil)
		in: (((aRectangle width/2) @ aRectangle origin y) extent: (aRectangle width/2)@aRectangle height)
		borderWidth: 1! !

!EnvironmentInspector class methodsFor: 'examples'!

openOn: anEnvironment 
	"Open a view of an EnvironmentInspector for an Environment. This 
	example permits the addition of fields in the inspector. A report goes 
	directly to the Environment that a new local variable has been 
	added."

	"EnvironmentInspector openOn: Environment new"

	| topView inspector |
	inspector := self new environment: anEnvironment.
	topView := StandardSystemView new label: 'An Environment Inspector'.
	topView borderWidth: 1.
	topView model: anEnvironment.
	topView minimumSize: 200 @ 150.
	self
		inspectorFor: inspector
		in: topView
		box: (0 @ 0 extent: 1 @ 1).
	topView controller open! !

Model subclass: #EnvironmentEditor
	instanceVariableNames: 'environment inspector '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Environments'!
EnvironmentEditor comment:
'An instance of EnvironmentEditor provides interactive support for editing the text of an Environment and its local variables.  In addition to a code editor, the instance provides dictionary inspection of the local variables declared in the Environment.  

Examples show an Environment Editor combined with various Browsers for browsing collections of Environments with simple lists or sophisticated hierarchical outlines.

Instance Variables:
	environment	<Environment>
	inspector		<EnvironmentInspector>'!


!EnvironmentEditor methodsFor: 'accessing'!

environment
	"Answer the receiver's environment."

	^environment!

environment: anEnvironment
	"Set the environment for the receiver to edit."

	environment := anEnvironment.
	environment == nil
		ifTrue: [environment := Environment new].
	self inspector environment: anEnvironment!

hasEnvironment
	"Answer true if the receiver has an environment,  otherwise answer false."

	^environment ~~ nil!

inspector
	"Answer the receiver's inspector."

	inspector == nil
		ifTrue: [inspector := EnvironmentInspector new.
				inspector environment: self environment].
	^inspector!

newValue
	"Answer an new value that the receiver can edit."

	^Environment new!

value
	"Answer the environment that the receiver is editing."

	^environment!

value: anEnvironment
	"Set the receiver's environment to be anEnvironment."

	self environment: anEnvironment.
	self changed: #text! !

!EnvironmentEditor methodsFor: 'text'!

acceptText: aText from: aController 
	"Accept the new text as the text for the current item's environment."

	self environment contents: aText copy.
	^true!

doItContext
	"Answer the context in which a text selection can be evaluated. 
	In this case, the context is the context of the selected environment, 
	in which local variables might be declared."

	^self environment doItContext!

doItReceiver
	"Answer the object that should be informed of the result of 
	evaluating a text selection. In this case, use the doItReceiver of the 
	current outline item."

	^self environment doItReceiver!

doItValue: ignored
	"Process the value returned from an evaluation of selected text."

	self environment doItValue: ignored.!

text
	"Answer the text in the environment of the currently selected item."

	| env |
	env := self environment.
	^env == nil
		ifTrue: [Text new]
		ifFalse: [env contents copy]!

textMenu
	"Answer a menu for the text view."

	"If the menu items hardcopy, style, font are desired because 
	Postscript printing of the environment is desired, then this is the 
	place to add it in. The corresponding messages are hardcopy 
	changeTextStyle changeFont."

	^ActionMenu
		labels: 'again\undo\copy\cut\paste\do it\print it\inspect\accept\cancel' withCRs
		lines: #(2 5 8 )
		selectors: #(#again #undo #copySelection #cut #paste #doIt #printIt #inspectIt #accept #cancel )! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

EnvironmentEditor class
	instanceVariableNames: ''!


!EnvironmentEditor class methodsFor: 'instance creation'!

open: anEnvironment label: aString
	"Create an editor on the environment anEnvironment.  That is,	
	a workspace with local variables."

	"EnvironmentEditor open: Environment new label: 'Environment Editor'"

	| me topView textView |
	me := self new.
	me environment: anEnvironment.

	topView := StandardSystemView new.
	topView borderWidth: 1.
	topView model: me.
	topView label: aString.
	topView minimumSize: 200 @ 150.

	textView := CodeView 
					on: me
					aspect: #text
					change: #acceptText:from:
					menu: #textMenu.
	textView controller: AlwaysAcceptCodeController new.

	topView
		addSubView: textView
		in: (0 @ 0 extent: 1.0 @ 0.6)
		borderWidth: 1.

	EnvironmentInspector
		inspectorFor: me inspector
		in: topView
		box: ( 0 @ 0.6 extent: 1@0.4).

	topView controller open!

openOnFile: aFilename 
	"Open an editor on information loaded
	from the file whose name is aFilename."

	"EnvironmentEditor openOnFile: 'testing'"

	| root |
	root := BinaryStorage fromFileNamed: aFilename.
	(root isKindOf: AssociationTree)
		ifTrue: [self openOutlineBrowserOn: root label: root key].
	(root isKindOf: SequenceableCollection)
		ifTrue: [self openListBrowserOn: root label: aFilename].
	(root isKindOf: Environment)
		ifTrue: [^self open: root label: aFilename].
	self error: 'unknown object'! !

!EnvironmentEditor class methodsFor: 'browser creation'!

openListBrowserOn: anAssociationList label: aString 
	"Create a browser that provides a simple list of names for accessing 
	Environments."

	"EnvironmentEditor 
				openListBrowserOn: OrderedCollection new
				label: 'Rolodex'"

	| topView textView listBrowser listView environmentEditor |
	environmentEditor := self new.
	listBrowser := ListBrowser new.
	listBrowser editor: environmentEditor.
	listBrowser list: anAssociationList accessor: (NameAccessor name: #key).
	topView := StandardSystemView new.
	topView borderWidth: 1.
	topView model: listBrowser.
	topView label: aString.
	topView minimumSize: 200 @ 150.
	topView controller: CollectionBrowserController new.
	listView := ListSelectionView
				on: listBrowser selectionHolder
				menuChannel: (MessageSend receiver: listBrowser selector: #selectionListMenu)
				changeRequestChannel: 
					[environmentEditor changeRequest and:
						[environmentEditor inspector changeRequest]].
	topView
		addSubView: listView
		in: (0 @ 0 extent: 1.0 @ 0.3)
		borderWidth: 1.
	textView := OnlyWhenSelectedCodeView
				on: environmentEditor
				aspect: #text
				change: #acceptText:from:
				menu: #textMenu
				initialSelection: nil
				selection: #hasEnvironment.
	topView
		addSubView: textView
		in: (0 @ 0.3 extent: 1.0 @ 0.5)
		borderWidth: 1.
	EnvironmentInspector
		inspectorFor: environmentEditor inspector
		in: topView
		box: (0 @ 0.8 extent: 1 @ 0.2).
	topView controller open!

openOutlineBrowserOn: anAssociationTree label: aString
	"Create a browser that provides a hierarchical outline of names for accessing 
	Environments."

	" | path | 	
	  path := ':Tutorial:'.
	  EnvironmentEditor 
		openOutlineBrowserOn: (BinaryStorage fromFileNamed: path, 'Tutorial-Text') 
		label: 'Tutorial Browser'."

	"EnvironmentEditor 
		openOutlineBrowserOn: (AssociationTreeWithParent key: 'Tutorial' value: Environment new)
		label: 'Tutorial Browser'"

	| topView textView outlineBrowser listView environmentEditor |
	environmentEditor := self new.
	outlineBrowser := OutlineBrowser new.
	outlineBrowser editor: environmentEditor.
	outlineBrowser
		tree: anAssociationTree
		accessor: (TreeAccessor isLeaf: #isLeaf children: #children name: #key).
	topView := StandardSystemView new.
	topView borderWidth: 1.
	topView model: outlineBrowser.
	topView label: aString.
	topView minimumSize: 200 @ 150.
	topView controller: CollectionBrowserController new.
	listView := ListSelectionView
				on: outlineBrowser selectionHolder
				menuChannel: (MessageSend receiver: outlineBrowser selector: #selectionListMenu)
				changeRequestChannel: 
					[environmentEditor changeRequest and:
						[environmentEditor inspector changeRequest]].
	topView
		addSubView: listView
		in: (0 @ 0 extent: 1.0 @ 0.3)
		borderWidth: 1.
	textView := CodeView
				on: environmentEditor
				aspect: #text
				change: #acceptText:from:
				menu: #textMenu.
	textView controller: AlwaysAcceptCodeController new.
	topView
		addSubView: textView
		in: (0 @ 0.3 extent: 1.0 @ 0.5)
		borderWidth: 1.
	EnvironmentInspector
		inspectorFor: environmentEditor inspector
		in: topView
		box: (0 @ 0.8 extent: 1 @ 0.2).
	topView controller open! !

InteractiveCompilerErrorHandler subclass: #InteractiveEnvironmentCompilerErrorHandler
	instanceVariableNames: 'environment '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Environments'!
InteractiveEnvironmentCompilerErrorHandler comment:
'InteractiveEnvironmentCompiler represents a specialized InteractiveCompilerErrorHandler used when compiling expressions in the context of an Environment. The instance receives error notifications during code generation, and converts them to interactive messages. Then the instance adds the ''local'' option to the default set provided by its superclass. Thus, users can define variables to be local to a given environment.

Instance Variables:
	environment	<Environment> 	the context for the compilation''
'!


!InteractiveEnvironmentCompilerErrorHandler methodsFor: 'accessing'!

environment: anEnvironment 
	"Set the environment used by the receiver."

	environment := anEnvironment! !

!InteractiveEnvironmentCompilerErrorHandler methodsFor: 'private'!

declareLocal: assoc from: codeStream 
	"The user has selected local, so add the association to the receiver's 
	local variables."

	assoc key: assoc key asSymbol.
	environment addNewBinding: assoc.
	^true!

getChoiceMenu
	"Answer the menu to be presented to the user."

	^ActionMenu
		labels: 'temp\class var\global\undeclared\local\correct it\abort' withCRs
		lines: #(5 )
		selectors: #(#declareTemp:from: #declareClassVar:from: #declareGlobal:from: #declareUndeclared:from: #declareLocal:from: #declareCorrect:from: #declareFailed:from: )!

undeclared: association at: sourceRange from: codeStream 
	"An undeclared variable has been detected. Present the user with a 
	menu of options from which a selection is to be made."

	| menu index |
	Cursor normal show.
	self selectRange: sourceRange.
	menu := self getChoiceMenu.
	index := menu startUp: #anyButton withHeading: ' declare ' asText , (association key contractTo: 20) asText allBold , ' as ' asText.
	index = 0 ifTrue: [^self declareFailed: association from: codeStream].
	^self
		perform: (menu selectorAt: index)
		with: association
		with: codeStream! !