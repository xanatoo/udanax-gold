StandardSystemController subclass: #StripperController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'System-Releasing'!
StripperController comment:
'StripperController is a subclass of StandardSystemController, whose purpose
is to trap the "close" message so that the Stripper classes can be removed.'!


!StripperController methodsFor: 'menu messages'!

close
	"Close myself, and tell model that it may be ok to remove the associated classes."
	super close.
	model endOfSession! !

Object subclass: #Stripper
	instanceVariableNames: 'doCompiler doExtras doMenus isRunning hasRun '
	classVariableNames: 'CompilerList ExtrasList ImmutableList '
	poolDictionaries: ''
	category: 'System-Releasing'!
Stripper comment:
'This class removes the development tools from a Version 2.5 system image.  It also contains methods for (optionally) clearing up some system space by removing unuseful parts of the remaining system.

Instance Variables:
	doCompiler	<Boolean>	Indicates whether to remove the compiler classes.
	doExtras	<Boolean>	Indicates whether to remove the extra classes.
	doMenus	<Boolean>	Indicates whether to modify system menus.
	isRunning	<Boolean>	Indicates whether class removal is in progress.
	hasRun  	<Boolen>	Indicates whether a class removal has happened.

Class Variables:
	CompilerList 	<Array of Symbol>	Names of class who, with their subclasses, will be removed if doCompiler is true.
	ExtrasList   	<Array of Symbol>	Names of class who, with their subclasses, will be removed if doExtras is true.
	ImmutableList  	<Array of Symbol>	Names of class who, with their subclasses, will be removed no matter what.
'!


!Stripper methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables to the defaults:"
	doCompiler _ true.	"default: closed runtime, no compiler classes"
	doExtras _ false.	"default: no optional (extra) classes removed"
	doMenus _ false.	"default: do not modify system menus"
	isRunning _ false.	"default: not yet running"
	hasRun _ false		"default: has not yet run"! !

!Stripper methodsFor: 'user preference'!

changeSysemMenus
	"If doMenus is true, remove do it, print it, inspect, etc. from the known
	menus and remove Browser from the ScreenController menu.

	Note, this redefines menus, it does not modify them.  If you have also 
	redefined these menus (e.g., filed in the printing code), you should either
	modify this method or not use it."

	doMenus ifFalse: [^nil].

	FileList 
		compile:
			'fileListMenu 
				"Answer the menu for my list subview."

				fileName == nil ifTrue: [^nil].
				FileMenu == nil ifTrue:
					[FileMenu _
						ActionMenu
							labels: ''get contents\copy name\rename\remove\spawn'' withCRs
							lines: #(1 3 4)
							selectors: #(getFile  copyName renameFile deleteFile spawnFileList)].
				^ FileMenu
				"Evaluate this when you change this method:
					FileList flushMenus"'
		classified: 'file name list'.

	HierarchicalFileList
		compile: 
				'textMenu 
					isDirectory ifFalse: [^super textMenu].
					fileName == nil ifTrue: [^ nil].
					^ActionMenu
							labelList: #((again undo) (copy cut paste))
							selectors: #(again undo copySelection cut paste)'
		classified: 'text'.

	FileModel
		compile: 
			'textMenu 
				"FileModel flushMenus"
				fileName == nil ifTrue: [^ nil].
				TextMenu == nil ifTrue:
					[TextMenu _ ActionMenu
						labelList: #((again undo) (copy cut paste) (put get ) (spawn))
						selectors: #(again undo copySelection cut paste accept getNew:from: spawnFile:from: )].
				^ TextMenu'
		classified: 'text'.

	StringHolderController class
		compile: 
			'initialize
				"Initialize the yellow button pop-up menu and corresponding messages."
				"StringHolderController initialize"

				CodeYellowButtonMenu _ 
					PopUpMenu 
						labelList: #((again undo) (copy cut paste) (accept cancel)).
		CodeYellowButtonMessages _ 
					#(again undo copySelection cut paste accept cancel )'
		classified: 'class initialization'.

	ProjectController class
		compile: 
			'initialize
				"Initialize the menu for the yellow mouse button."
				"ProjectController initialize"

				ProjectYellowButtonMenu _ 
					PopUpMenu
						labelList: #((again undo) (copy cut paste) (accept cancel) (enter)).
				ProjectYellowButtonMessages _ 
						#(again undo copySelection cut paste accept cancel enter)'
		classified: 'class initialization'.

	TerminalController
		compile: 
			'initializeYellowButtonMenu
				"Sets up our yellow button commands."

				self yellowButtonMenu:
						(PopUpMenu labelList: #((again) (copy paste)))
					yellowButtonMessages: #(again copySelection sendPasteBuffer)'
		classified: 'private'.

	ScreenController class
		compile:
			'initialize
				"Initialize the System Menu."

				"ScreenController initialize.
				ScreenController allInstancesDo: [:c | c initializeYellowButtonMenu]"

				ScreenYellowButtonMenu _
					PopUpMenu
						labels: 
''restore display
garbage collect
screen saver
exit project
workspace
file list
file editor
terminal
project
system transcript
system workspace
desk top
save
quit''
						lines: #(4 9 11 12).
				ScreenYellowButtonMessages _
					#(restoreDisplay garbageCollect openScreenSaver exitProject
					openWorkspace openFileList 
					openFileEditor openTerminal openProject 
					openTranscript openSystemWorkspace 
					openDeskTop save quit)'
		classified: 'class initialization'.

	FileModel flushMenus.
	FileList flushMenus.

	StringHolderController initialize.
	StringHolderController allInstances do: [:c | c initializeYellowButtonMenu].

	ProjectController initialize.
	ProjectController allInstances do: [:c | c initializeYellowButtonMenu].

	TerminalController allInstances do: [:c | c initializeYellowButtonMenu].

	ScreenController initialize.
	ScreenController allInstances do: [:c | c initializeYellowButtonMenu].!

extrasList
	"Answer the list of any extra classes to be removed, along with their subclasses."

	^doExtras 
		ifTrue: 
			[ExtrasList] 
		ifFalse: [#()]!

postStrip
	"Hook for users to insert code at the end of stripping."!

preStrip
	"Hook for users to insert code at the start of stripping."! !

!Stripper methodsFor: 'accessing'!

doCompiler
	"Answer whether the instance is poised for removing the compiler classes."
	^doCompiler!

doCompiler: aBoolean
	"Set the boolean indicating whether to remove the compiler classes."
	doCompiler _ aBoolean.
	self changed: #doCompiler!

doExtras
	"Answer whether the instance is poised for removing the extra classes."
	^doExtras!

doExtras: aBoolean
	"Set the boolean indicating whether to remove the extra classes."
	doExtras _ aBoolean.
	self changed: #doExtras!

doMenus
	"Answer whether the instance is poised for modifying system menus."
	^doMenus!

doMenus: aBoolean
	"Set the boolean indicating whether to modify system menus."
	doMenus _ aBoolean.
	self changed: #doMenus!

isRunning
	"Answer whether a class removal is in progress."
	^isRunning!

isRunning: aBoolean
	"Set the boolean indicating that the object is now removing classes."
	isRunning _ aBoolean.
	self changed: #isRunning! !

!Stripper methodsFor: 'class removal'!

doStringsAndOrgs
	"Remove instance variable strings and class organizers from existing classes,
	 to save the space they take up, since they are of little use in a stripped system."
	Smalltalk allBehaviorsDo: [:cl | cl zapInstStringsAndOrgs].!

emptySystemOrganization
	"Remove all classes from SystemOrganizer"
	SystemOrganization setDefaultList!

endOfSession
	"Message sent to myself at the end of removing classes.  Remove the
	Stripper classes themselves if has run and if the user agrees."

	hasRun ifFalse: [^self].
	(BinaryChoice message: 'Do you want to remove the Stripper classes?')
		ifTrue: [self removeSelf]!

installNewNotifier
	"Replace NotifierView with SimpleNotifierView.
	Do this by replacing the value in the global association and trading
	names.  That way, clients of NotifierView do not have to be recompiled."
	| nvAssn snvAssn key val |
	nvAssn _ Smalltalk associationAt: #NotifierView.
	snvAssn _ Smalltalk associationAt: #SimpleNotifierView.
	key _ nvAssn key.
	nvAssn key: snvAssn key.
	snvAssn key: key.
	val _ nvAssn value.
	nvAssn value: snvAssn value.
	snvAssn value: val.
	Smalltalk rehash!

listOfClasses
	"Answer the list of the classes to be removed along with their subclasses"

	^self listOfClassNames
		collect: [:clName | Smalltalk at: clName]!

listOfClassNames
	"Answer the list of the names of the classes to be removed along with 
	their subclasses"

	^self immutableList, self compilerList, self extrasList!

removeLocalPools
	"Remove pool dictionaries from Smalltalk that are only shared among 
	the classes to be removed."
	| outList poolList |
	poolList _ Set new.
	outList _ OrderedCollection new.
	"Store all the classes to be removed, and all their subclasses in outList."
	self listOfClasses do: 
		[:class | outList addAll: class withAllSubclasses].
	"Store all the pool dictionaries used by these classes in poolList."
	outList do:
		[:class |
		poolList addAll: class sharedPools].
	"Remove any pools used by remaining classes from poolList."
	Smalltalk allBehaviorsDo:
		[:class |
		(outList includes: class)
			ifFalse:
				[class sharedPools do:
					[:pool | poolList remove: pool ifAbsent: [] ]]].
	"Remove remaining pools from the Smalltalk dictionary."
	poolList do:
		[:pool | Smalltalk remove: pool]!

removeOpcodePool
	"The pool dictionary, OpcodePool, needs to be treated specially.
	Empty it, remove it from Smalltalk, hide its keys, but keep its
	associations around in case they are used."
	| assn |
	OpcodePool keys do:
		[:key |
		assn _ OpcodePool associationAt: key.
		"Remove association from dictionary"
		OpcodePool removeKey: key.
		"Hide name of opcode"
		assn key: #xxxxx].
	Smalltalk removeKey: #OpcodePool ifAbsent: []!

removeSelf
	"Remove the classes only used in stripping.
	Fork this code so that the message can return before this class
	goes away."
	[StripperController disable.
	Stripper disable] fork!

stripSystem
	"Here's where everything happens."

	| startClasses endClasses startSpace endSpace array |
		"First, run user supplied code, if any"
	self preStrip.
		"Look to see if there are any tools open."
	self openViewTest
		ifFalse: [^self].
	array _ self classesAndBytesLeft.
	startClasses _ array at: 1. startSpace _ array at: 2.
	Transcript cr; show: 
		'Change system menus if desired'.
	self changeSysemMenus.
	Transcript cr; show: 
		'Remove all classes from System Organizer'.
	self emptySystemOrganization.
	Transcript cr; show: 
		'Remove the opcode pool dictionary'.
	self removeOpcodePool.
	Transcript cr; show: 
		'Remove to-be-removed pool dictionaries from Smalltalk'.
	self removeLocalPools.
	Transcript cr; show: 
		'Change Projects so they do not use ChangeSets'.
	self projectsWithoutChangeSets. "Must be done before lockout"
	Transcript cr; show: 
		'Add class-zapping messages to the right classes'.
	self installDisableMessages.
	hasRun _ true.		"from this point on, can consider having run"
	Transcript cr; show:
		'Change Behavior to allow only DoIts'.
	self installBehaviorLockouts.
	Transcript cr; show: 
		'Install simple notifier'.
	self installNewNotifier.
	self listOfClasses do:
		[:class | class disable]. "Zap them"
	SourceFiles _ nil.	"Remove access to source files"
	Transcript cr; show: 
		'Remove all instance variable strings and class organizers'.
	self doStringsAndOrgs.
		"Let go of class name references"
	self removeRefsToClassNames.
		"Run user supplied code, if any"
	self postStrip.
	Transcript cr; show: 
			'Get rid of newly-unreferenced Symbols...'.
	Symbol initialize.
	array _ self classesAndBytesLeft.
	endClasses _ array at: 1. endSpace _ array at: 2.
	(BinaryChoice message: 'Do you want a report?')
		ifTrue: [self doReportStartClasses: startClasses endClasses: endClasses 
					startSpace: startSpace endSpace: endSpace].
	Transcript cr; show: '...done.
BE SURE TO SNAPSHOT'!

stripSystem: argumentFromButton
	"Sent from the user interface, toggle isRunning boolean before and after
	removing system classes."

	self isRunning: true.
	self stripSystem.
	self isRunning: false! !

!Stripper methodsFor: 'messages in other classes'!

installBehaviorAddSelector
	"Change the message(s) in Behavior to disable all but DoIts.
	This also must be done after the last other compilation.
	Note: this modifies existing methods.  If these have been modified elsewhere,
	this method might need changing."
	Behavior compile:
		'addSelector: selector withMethod: compiledMethod 
			"Add the message selector with the corresponding compiled method to the receiver''s
			method dictionary."

			selector ~~ #DoIt ifTrue: [self error: ''Compiles not allowed''].
			methodDict at: selector put: compiledMethod.
			self flushVMmethodCacheEntriesFor: selector'
		classified: 'creating method dictionary'.!

installBehaviorLockouts
	"Change the messages in Behavior to disable all but DoIts
	and change the #organizaiton message in ClassDescription
	not to generate one.
	This must be done after the last other compilation."

	self installCDOrganization.
	self installBehaviorAddSelector.!

installCDOrganization
	"Replace the #organization message in ClassDescription to return a new
	ClassOrganizer for compilations, but not save it in an instance variable.
	Note: this modifies existing methods.  If these have been modified elsewhere,
	this method might need changing."
	ClassDescription
		compile:
			'organization
				^ClassOrganizer new'
		classified: 'organization'!

installCDStringsOrgs
	"Install the message #zapInstStringsAndOrgs in ClassDescription to remove
	 instance variable strings and the class organizer."
	ClassDescription
		compile:
			'zapInstStringsAndOrgs
				"get rid of the instance variable name strings 
				 and also get rid of the organization"
				instanceVariables==nil
					ifFalse: 
						[instanceVariables do:
							[:iv | iv atAllPut: Character space].
				instanceVariables atAllPut: nil.
				instanceVariables _ nil].
				organization _ nil'
		classified: 'initialize-release'!

installClassDescriptionDisable
	"Install the message #disable in ClassDescription to disable (remove) 
	the class."
	ClassDescription
		compile:
			'disable
				"Remove the methods from my method dictionary, 
				 Do a normal obsolete to get rid of me, and
				 Get rid of my instance variable strings and my organization"
				self selectors do: [:selector | self removeSelectorSimply: selector].
				self obsolete.
				self zapInstStringsAndOrgs'
		classified: 'initialize-release'!

installClassDisable
	"Install the message #disable in Class to disable (remove) the class."
	Class
		compile:
			'disable
				"Recur through my subclasses, depth-first, doing
				 ClassDescription>>disable, and removing me from the
				 Smalltalk dictionary."
				self subclasses do: [:sc | sc disable].
				Transcript cr; show: ''Removing '',  name.
				Smalltalk at: name put: nil.
				Smalltalk removeKey: name.
				super disable.
				name atAllPut: $*.
				superclass _ Object'
		classified: 'initialize-release'!

installDisableMessages
	"Install the messages in Class and ClassDescription to disable (remove) 
	the class."

	self installClassDescriptionDisable.
	self installCDStringsOrgs.
	self installClassDisable!

projectsWithoutChangeSets
	"Modify the messages in class Project so they do not generate ChangeSets.
	Note: this modifies existing methods.  If these have been modified elsewhere,
	this method might need changing."
	Project 
		compile:
			'initialProject
				projectWindows _ ScheduledControllers.
				projectChangeSet _ Set new.
				projectHolder _ self'
		classified: 'private'.
	Project 
		compile:
			'noChanges
				"Reset the receiver''s ChangeSet so that it is empty."
				projectChangeSet _ Set new.
				Smalltalk newChanges: projectChangeSet'
		classified: 'change management'.	
	Project 
		compile:
			'setProjectHolder: aProject 
				projectWindows _ ControlManager new.
				projectChangeSet _ Set new.
				projectTranscript _ TextCollector new.
				projectHolder _ aProject'
		classified: 'private'.! !

!Stripper methodsFor: 'private'!

classesAndBytesLeft
	"Answer an array of the number of classes and the amount
	of free memory."
	| classes bytes |
	Smalltalk garbageCollect.	"To start clean."
	classes _ Metaclass instanceCount.
	bytes _ Smalltalk coreLeft.
	^Array with: classes with: bytes!

compilerList
	"Answer the list of the compiler related classes to be removed, 
	along with their subclasses."

	^doCompiler
		ifTrue: [CompilerList]
		ifFalse: [#()]!

doReportStartClasses: startClasses endClasses: endClasses startSpace: startSpace endSpace: endSpace
	| fileName aFileStream |
	fileName _ Filename 
					request: 'Write report on' 
					initially: ('Stripper.report') 
					shouldExist: false. 
	fileName = '' ifTrue: [^nil].
	aFileStream _ fileName asFilename writeStream.
	aFileStream nextPutAll: 'System classes removed on '.
	aFileStream nextPutAll: Date today printString.
	aFileStream space; nextPutAll: Time now printString.
	aFileStream cr; cr.
	doCompiler
		ifTrue: [aFileStream nextPutAll: 'Compiler classes removed']
		ifFalse: [aFileStream nextPutAll: 'Compiler classes kept'].
	aFileStream cr; cr.
	doExtras
		ifTrue: [aFileStream nextPutAll: 'Extra classes removed']
		ifFalse: [aFileStream nextPutAll: 'No Extra classes removed'].
	aFileStream cr; cr.
	doMenus
		ifTrue: [aFileStream nextPutAll: 'Menus changed']
		ifFalse: [aFileStream nextPutAll: 'Menus unaffected'].
	aFileStream cr; cr.
	aFileStream nextPutAll: (startClasses - endClasses) printString, ' classes removed'.
	aFileStream cr; cr.
	aFileStream nextPutAll: (endSpace - startSpace) printString, ' bytes saved'.
	aFileStream cr; cr.
	aFileStream close!

immutableList
	"Answer the list of the classes that are required to be removed for runtime, 
	along with their subclasses"

	^ImmutableList!

openViewTest
	"See if there are any known development tools open.
	Note this checks the current project ONLY, and it only
	checks for a small number of potential tools.
	Return true if the stripping should continue, false if it should stop."
	| view |
	ScheduledControllers scheduledControllers do:
		[:ssc |
		view _ ssc view.
		(view isKindOf: BrowserView) |
				(view isKindOf: InspectorView) |
				(view isKindOf: NotifierView)
			ifTrue:
				[view flash.
				(BinaryChoice message: 
'This is an open view whose class will disappear.
Do you want to close it (yes) or stop (no)?.') ifTrue: [ssc closeAndUnschedule] ifFalse: [^false]]].
	^true!

removeRefsToClassNames
	"Remove all my references to stripped class names, so that the names
	may be garbage-collected"

	ImmutableList _ CompilerList _ ExtrasList _ nil.
	self class class removeSelectorSimply: #initExtras.
	self class class removeSelectorSimply: #initialize.! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Stripper class
	instanceVariableNames: ''!


!Stripper class methodsFor: 'user preferences'!

initExtras
	"The user may modify this list, but should remember to evaluate
		Stripper initExtras
	and to set doExtras."

	ExtrasList _ #(Path MappedCollection BitEditor FormEditor FormButtonCache 
			FormMenuController FormMenuView FormHolderView )! !

!Stripper class methodsFor: 'accessing'!

compilerClassNames
	"Answer the list of names of compiler classes that would be stripped."

	^CompilerList copy!

extraClassNames
	"Answer the list of names of the 'extra' classes that would be stripped."

	^ExtrasList copy!

immutableClassNames
	"Answer the list of names of classes that will definitely be stripped."

	^ImmutableList copy! !

!Stripper class methodsFor: 'class initialization'!

initialize
	"Initialize the immutable, compiler, and extras class lists."
	"Stripper initialize"

	CompilerList _ #(#SmalltalkCompiler #ByteCodeStream #ByteCodeReadWriteStream #InstructionPrinter #Scanner #ScannerTable #CodeLabel #DeferredBlock #CompilerErrorHandler #DefineOpcodePool #MethodNodeHolder #VariableDefinition #NameScope #ProgramNode #ProgramNodeBuilder ).
	ImmutableList _ #(#ClassBuilder #Decompiler #ChangeList #ChangeListView #ChangeListController #ChangeController #MessageTally #NotifierController #NotifierView #Inspector #InspectorView #Browser #BrowserView #Explainer #SyntaxError #ClassCategoryReader #Change #ChangeSet #ClassOrganizer #RemoteString ).
	self initExtras! !

!Stripper class methodsFor: 'instance creation'!

new
	^super new initialize!

open
	"Open an interactive view on an instance of myself."
	"Stripper open"
	| topView model stringView |
	topView _ StandardSystemView new.
	topView label: 'Stripper'.
	topView controller: StripperController new.

	model _ self new.
	topView model: model.
	topView borderWidth: 2.
	topView minimumSize: 500@300.

	stringView _ StringHolderView new model: 
			(TextHolder new contents: 
('	Remove Compiler Classes?
Required for "closed runtime" and will remove
an additional ~50 classes and ~150K bytes.' asText
	emphasizeFrom: 1 to: 26 with: 2)).
	stringView controller: Controller new.
	topView addSubView: stringView
		in: (0.05@0.05 extent: 0.6@0.2) borderWidth: 0.

	topView addSubView: (BooleanView on: model aspect: #doCompiler
			label: 'Yes' asText change: #doCompiler: value: true)
		in: (0.7@0.1 extent: 0.1@0.1) borderWidth: 1.
	topView addSubView: (BooleanView on: model aspect: #doCompiler
			label: 'No' asText change: #doCompiler: value: false)
		in: (0.8@0.1 extent: 0.1@0.1) borderWidth: 1.

	stringView _ StringHolderView new model: 
			(TextHolder new contents: 
('	Remove "Extra" Classes?
Extra classes are user-preference.
See #initExtras in Stripper class.' asText
	emphasizeFrom: 1 to: 24 with: 2)).
	stringView controller: Controller new.
	topView addSubView: stringView
		in: (0.05@0.3 extent: 0.6@0.2) borderWidth: 0.

	topView addSubView: (BooleanView on: model aspect: #doExtras
			label: 'Yes' asText change: #doExtras: value: true)
		in: (0.7@0.35 extent: 0.1@0.1) borderWidth: 1.
	topView addSubView: (BooleanView on: model aspect: #doExtras
			label: 'No' asText change: #doExtras: value: false)
		in: (0.8@0.35 extent: 0.1@0.1) borderWidth: 1.

	stringView _ StringHolderView new model: 
			(TextHolder new contents: 
('Remove do it/print it/inspect from menus?
May interact with application.' asText
	emphasizeFrom: 1 to: 41 with: 2)).
	stringView controller: Controller new.
	topView addSubView: stringView
		in: (0.05@0.55 extent: 0.6@0.2) borderWidth: 0.

	topView addSubView: (BooleanView on: model aspect: #doMenus
			label: 'Yes' asText change: #doMenus: value: true)
		in: (0.7@0.6 extent: 0.1@0.1) borderWidth: 1.
	topView addSubView: (BooleanView on: model aspect: #doMenus
			label: 'No' asText change: #doMenus: value: false)
		in: (0.8@0.6 extent: 0.1@0.1) borderWidth: 1.

	topView addSubView: (BooleanView on: model aspect: #isRunning
			label: 'Run' asText change: #stripSystem: value: true)
		in: (0.4@0.8 extent: 0.2@0.15) borderWidth: 2.

	topView controller open! !

Stripper initialize!


View subclass: #SimpleNotifierView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'System-Releasing'!
SimpleNotifierView comment:
'This is a very simple replacement for class NotifierView.  Its purpose is to change places with NotifierView, including trading names.  SimpleNotifierView reimplements the public message protocol of NotifierView, brining up a very simple error view, that does not allow for debugging.

Application developers are encouraged first to catch all signals, so that the NotifierView never comes up at all.  If they do not do this, they are encouraged to modify this class to give at least a more visually pleasant indication of a system error.
'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SimpleNotifierView class
	instanceVariableNames: ''!


!SimpleNotifierView class methodsFor: 'instance creation'!

openContext: haltContext label: aString contents: contentsString proceedable: isProceedable
	"Create and schedule a simple notification of some error or other
	event (self halt) that caused a process to be suspended in haltContext.
	The view will be labeled with aString.  Do not display contentsString."

	| displayPoint |
	ErrorRecursion
		ifTrue: 
			[ErrorRecursion _ false.
			self primitiveError: aString].
	ErrorRecursion _ true.
	displayPoint _ 
		ScheduledControllers activeController == nil
			ifTrue: [Display boundingBox center]
			ifFalse: [ScheduledControllers activeController view displayBox center].
	self openLabel: aString
		displayAt: displayPoint.
	ErrorRecursion _ false.
	Processor activeProcess terminate!

openException: anException
	"Create and schedule a simple notification of some error or other
	event (self halt) that caused a process to be suspended in haltContext.
	The view will be labeled with aString.  Do not display contentsString."

	self openContext: anException parameter
		label: anException errorString
		contents: anException parameter shortStack
		proceedable: true! !

!SimpleNotifierView class methodsFor: 'private'!

openLabel: labelString displayAt: aPoint 
	| topView aFormView form |
	Cursor normal show.
	Cursor cursorLink: true.
	form _ 'System Error' asDisplayText form magnifyBy: 2@2.
	aFormView _ FormView new model: form.
	aFormView controller: Controller new.
	topView _ StandardSystemView new.
	topView borderWidth: 1.
	topView model: form.
	topView addSubView: aFormView.
	topView label: labelString.
	topView minimumSize: form extent.
	topView controller openNoTerminateDisplayAt: aPoint.
	^topView! !