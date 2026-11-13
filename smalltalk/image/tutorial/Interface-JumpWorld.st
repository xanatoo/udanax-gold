Model subclass: #JumpWorld
	instanceVariableNames: 'actors displayList '
	classVariableNames: 'PictureDictionary '
	poolDictionaries: ''
	category: 'Interface-JumpWorld'!
JumpWorld comment:
'Class JumpWorld represents a data structure in which the Jumpers or actors, Pictures, and DisplayList can be remembered.  The message protocol is designed primarily for initializing and accessing information about the actors and the display list in which the actor animation is shown.

Class Variable Names

	PictureDictionary 	<Dictionary>	of Forms keyed by a picture name

Instance Variable Names

	actors			<Dictionary> of actor names and corresponding instances of Jumper classes
	displayList		<DisplayList> containing items to show the jumper sequence animations, actor name labels, and message buttons.'!


!JumpWorld methodsFor: 'initialize-release'!

createActors
	"This game is set with seven jumpers.  The user is asked the name of each
	jumper.  The HyperWhirler jumper is set with six cups of coffee and the 
	Delegator is assigned an instance of Jumper as the friend."

	| special actorNames |

	actorNames := OrderedCollection new.
	#(LazyWhirler Whirler Whirler HyperWhirler Delegator Jumper ObstinateJumper ) do: 
		[:class | | actorName|
			[(actorName := self getNameFor: class) isNil] whileTrue.
			 actors at: actorName put: (Smalltalk at: class) new.
			 actorNames addLast: actorName.
			 class = #HyperWhirler ifTrue: [(actors at: actorName) drinkCoffee: 6]].

	special := actors detect: [:jumper | jumper class = Delegator].
	special beFriendsWith: (actors detect: [:jumper | jumper class = Jumper]).

	self putActorsInDisplayList: actorNames!

createButtons
	"Labels exist for each actor name in order to select the actor.
	Buttons exist for each action that an actor might take.  Answer
	the dictionary of buttons that are created."

	| buttonDictionary button |
	buttonDictionary := IdentityDictionary new.

	button := DisplayButton 
					up: (self withName: 'Sit Down'
							on: (PictureDictionary at: #Bup)
							at: 15 @ 7)
					down: (self withName: 'Sit Down'
								on: (PictureDictionary at: #Bdown)
								at: 17 @ 9)
					at: 20 @ 350.
	buttonDictionary at: button put: #sitDown.
	displayList add: button.

	button :=DisplayButton
				up: (self withName: 'Stand Up'
							on: (PictureDictionary at: #Bup)
							at: 15 @ 7)
				down: (self withName: 'Stand Up'
								on: (PictureDictionary at: #Bdown)
								at: 17 @ 9)
				at: 170 @ 350.
	buttonDictionary at: button put: #standUp.
	displayList add: button.

	button := DisplayButton
				up: (self withName: 'Whirl Around'
					on: (PictureDictionary at: #Bup)
					at: 3 @ 7)
				down: (self withName: 'Whirl Around'
					on: (PictureDictionary at: #Bdown)
					at: 5 @ 9)
				at: 320 @ 350.
	buttonDictionary at: button put: #whirlAround.
	displayList add: button.

	button := DisplayButton
				up: (self withName: 'Jump Up'
						on: (PictureDictionary at: #Bup)
						at: 15 @ 7)
				down: (self withName: 'Jump Up'
						on: (PictureDictionary at: #Bdown)
						at: 17 @ 9)
				at: 470 @ 350.
	buttonDictionary at: button put: #jumpUp.
	displayList add: button.

	^buttonDictionary!

initialize
	"Initialize the instance variables of the receiver."

	actors := Dictionary new.
	displayList := DisplayList new.!

monitorActors
	"In case you want to watch or hear the changing 
	state of the actors, create the watchers."

	| watcher speaker |
	watcher := TranscriptMonitor new.
	watcher outputMedium: Transcript.

	speaker := SoundMonitor new.
	speaker outputMedium: SoundPlayer onSystem.

	actors values do: 
		[:each | 
		watcher monitor: each.
		speaker monitor: each]! !

!JumpWorld methodsFor: 'accessing'!

actors
	"Answer the dictionary of animated objects."

	^actors!

displayList
	"Answer the display of labels, buttons, and of animated objects."

	^displayList! !

!JumpWorld methodsFor: 'private'!

getNameFor: aClass
	"Ask the user for a name for the next actor.  
	Answer nil if the user provides a name that already exists."

	| actorName |
	actorName := FillInTheBlank request: 'Name of ' , aClass.
	actorName = '' ifTrue: [actorName := #NoName].
	actorName := actorName asSymbol.
	actors at: actorName ifAbsent: [^actorName].
	^nil!

putActorsInDisplayList: names
	"For each actor, create the corresponding display item.  To do
	so requires asking the user for the sex of the actor."

	| x chair  |
	x := 0.
	chair := PictureDictionary at: #Chair.
	names do: 
		[:each | 
		| actor actorSex body item |
		actor := actors at: each.
		actorSex := FillInTheBlank request: 'Sex of ' , each.
		actorSex = '' ifTrue: [actorSex := #male].
		actorSex := actorSex asSymbol.
		displayList add: (DisplayItem display: chair at: x @ 0).
		displayList add: (DisplayLabel
					label: each
					at: x + 20 @ (chair height + 20)
					border: 2).
		item := DisplayItem new.
		item moveTo: x@20.
		(actor isKindOf: Jumper)
			ifTrue:	[body := actorSex == #male
								ifTrue: [JumperSequenceMonitor man: actor]
								ifFalse: [JumperSequenceMonitor woman: actor].
					body outputMedium: item.
					]
			ifFalse: [item display: 
						(actorSex == #male 
								ifTrue: [JumperSequenceMonitor manSitting] 
								ifFalse: [JumperSequenceMonitor womanSitting])].
		(actor isKindOf: HyperWhirler) 
			ifTrue: [displayList add: 
						(DisplayItem 
								display: (PictureDictionary at: #CoffeeCup)
								at: x + 30 @ (chair height + 50))].
		(actor isKindOf: Delegator) 
			ifTrue: [displayList add: 
						(DisplayItem 
								display: (PictureDictionary at: #Friend)
								at: x + 40 @ (chair height + 50))].
		displayList add: item.
		x := x + chair width - 35].!

withName: aString on: aForm at: pt 
	"Create a form that combines a background with a label."

	| f t |
	f := aForm deepCopy.
	t := (DisplayText text: (Text string: aString emphasis: 5)
		textStyle: (TextStyle styleNamed: #large)) form.
	t  displayOn: f at: pt.
	^f! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

JumpWorld class
	instanceVariableNames: ''!


!JumpWorld class methodsFor: 'class initialization'!

initializePictures
	"Make sure that the dictionary of single pictures, sounds, as well as 
	the animations are loaded.  The user is prompted for the name of the 
	directory where the pictures can be found.  There should be 
	a Friend, a chair, a CoffeeCup, a buttonUp and a 
	buttonDown form."

	| dirName |
	dirName := FillInTheBlank request: 'Name of Directory for Jumper Pictures'.
	JumperSequenceMonitor getPictures: dirName.
	SoundPlayer initSystem.	"SoundPlayer onFileNamed: aString"
	PictureDictionary := BinaryStorage fromFileNamed: (dirName, 'JumpForms').! !

!JumpWorld class methodsFor: 'instance creation'!

new
	"Create an instance of the receiver and initialize its
	instance variables."

	^ super new initialize! !

!JumpWorld class methodsFor: 'examples'!

startUp
	"This is the example supported by the class.  Make sure that
	the pictures are initialized."

	"JumpWorld startUp"

	"JumpWorld initializePictures."

		| game buttons |

		game := JumpWorld new.
		game createActors.
		buttons := game createButtons.
		game monitorActors.

		JumpWorldView 
			open: game displayList 
			withJumpWorld: game 
			withButtons: buttons.! !

DisplayListView subclass: #JumpWorldView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-JumpWorld'!
JumpWorldView comment:
'An instance of JumpWorldView is a view of a jumping exercise with labels and message buttons used to select the actors and to send messages to the actors.'!


!JumpWorldView methodsFor: 'controller defaults'!

defaultControllerClass

	^JumpWorldController! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

JumpWorldView class
	instanceVariableNames: ''!


!JumpWorldView class methodsFor: 'instance creation'!

open: aDisplayList withJumpWorld: aJumpWorld withButtons: aDictionary
	"Create a standard view in which a jump world can be 
	displayed and invoked.  The displayable elements of the
	view are stored in a display list, aDisplayList, with their
	relative positions.  All of the actors in the exercise are
	stored as part of the model aJumpWorld."

	| sv dlv |
	sv := StandardSystemView new.
	sv borderWidth: 2.
	dlv := self new model: aDisplayList.
	dlv controller receiver: aJumpWorld buttons: aDictionary.
	sv addSubView: dlv.
	sv cacheRefresh: false.
	sv controller open! !

SelectListController subclass: #JumpWorldController
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Interface-JumpWorld'!
JumpWorldController comment:
'An instance of JumpWorldController modifies the behavior of a SelectListController so that the message receiver is the currently selected actor/jumper.'!


!JumpWorldController methodsFor: 'selecting'!

processSelector: aSymbol
	"If the user has selected an executable message, evaluate it.  Otherwise
	do nothing."

	| jumper |
	view selection isNil ifTrue: [^view flash].
	aSymbol == nil ifTrue: [^self].
	jumper := messageReceiver actors at: (view selection label) asSymbol.
	jumper speak: view selection label.
	jumper speak: aSymbol asString.
	jumper perform: aSymbol! !