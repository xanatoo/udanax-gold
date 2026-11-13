Model subclass: #Jumper
	instanceVariableNames: 'state '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Jumpers'!
Jumper comment:
'Instances of this class represent any object that has the abstract ability to respond to jumping protocol (standUp, sitDown, whirlAround, jumpUp).

Concrete subclasses have to define
	commanding
		jumpUp

Instance Variables:
	state	<Symbol>	the current state of the instance, for example, standing or sitting'!


!Jumper methodsFor: 'initialize-release'!

initialize
	"All Jumpers start out sitting down."

	state := #sitting! !

!Jumper methodsFor: 'accessing'!

currentState
	"Answer the current state of the receiver."

	^state! !

!Jumper methodsFor: 'commanding'!

jumpUp
	"Receiver takes an action resembling changing state to a jumping-like 
	position. Respond here by stating that the receiver does not 
	understand the jump up message. Subclasses override this 
	implementation to provide specific jump up behavior."

	self speak: 'notunderstand'.
	self speak: 'jumpUp'!

sitDown
	"Change state of the receiver to sitting."

	self newState: #sitting!

speak: aString
	"The receiver wants to speak aString for any object monitoring that cares."

	self changed: #spoke with: aString!

standUp
	"Change state of the receiver to standing."

	self newState: #standing!

whirlAround
	"Change state of the receiver to whirling."

	| oldState |
	oldState := self currentState.
	self newState: #whirling.
	self letTimePass: 1.
	self newState: oldState! !

!Jumper methodsFor: 'private'!

letTimePass: timeAmount 
	"Changing state needs a transition time of timeAmount."

	(Delay forSeconds: timeAmount) wait!

newState: aSymbol 
	"Change the state of the receiver to be aSymbol and then 
	inform any dependents that the current state changed, 
	providing the prior state information."

	| oldState |
	oldState := self currentState.
	state := aSymbol.
	self changed: #currentState with: oldState! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Jumper class
	instanceVariableNames: ''!


!Jumper class methodsFor: 'instance creation'!

new
	"Create a new instance of the receiver."

	^super new initialize! !

Jumper subclass: #Delegator
	instanceVariableNames: 'friend '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Jumpers'!
Delegator comment:
'An instance of Delegator represents a Jumper that prefers to get a friend to do its jumping.

Instance Variables:
	friend	<Model | Jumper> who will be sent (delegated) the jumpUp message'!


!Delegator methodsFor: 'accessing'!

beFriendsWith: anObject 
	"Make a new friend, anObject."

	| oldFriend |
	oldFriend := friend.
	friend := anObject.
	self changed: #friend with: oldFriend!

friend
	"Answer current friend."

	^friend! !

!Delegator methodsFor: 'commanding'!

jumpUp
	"Delegate the responsibility for jumping to the receiver's 
	friend. "

	self newState: #pointing.
	self speak: 'delegate'.
	friend jumpUp.
	[self letTimePass: 1.
	  self sitDown] fork! !

Jumper subclass: #Whirler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Jumpers'!
Whirler comment:
'An instance of Whirler represents a kind of Jumper that stands up and whirls around when asked to jump up.'!


!Whirler methodsFor: 'commanding'!

jumpUp
	"The receiver responds by standing up and whirling around."

	self standUp.
	self whirlAround.! !

Whirler subclass: #LazyWhirler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Jumpers'!
LazyWhirler comment:
'An instance of LazyWhirler represents a kind of jumper that prefers to stay seated whenever possible.'!


!LazyWhirler methodsFor: 'commanding'!

jumpUp
	"The receiver's response to jump up is to act like instances 
	of Whirler, but to finish by sitting down."

	super jumpUp.
	self sitDown! !

Whirler subclass: #HyperWhirler
	instanceVariableNames: 'caffineLevel '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Jumpers'!
HyperWhirler comment:
'An instance of HyperWhirler represents a kind of Jumper that keeps on whirling as long as there is enough caffine to create hyperactivity.

Instance Variables
	caffineLevel	<Integer>	number of cups of coffee the receiver has consumed'!


!HyperWhirler methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	super initialize.
	caffineLevel := 0! !

!HyperWhirler methodsFor: 'accessing'!

caffineLevel
	"Answer the amount of caffine the receiver is experiencing."

	^caffineLevel!

caffineLevel: anAmount
	"Modify the amount of caffine the receiver is experiencing."

	| oldValue |
	oldValue := caffineLevel.
	caffineLevel := anAmount.
	self changed: #caffineLevel with: oldValue!

hyperness
	"Answer the caffine level of the receiver."

	^self caffineLevel! !

!HyperWhirler methodsFor: 'commanding'!

drinkCoffee: numberOfCups 
	"Set caffine level for the receiver.  The receiver's level of 
	hyper activity is tied to caffine level."

	self caffineLevel: self caffineLevel + numberOfCups!

jumpUp
	"Receiver takes an action resembling changing state to a  
	jumping-like position.  In this case, the receiver keeps 
	responding to the jumpUp message as long as the receiver 
	is hyper."
	
	[super jumpUp.
	[self hyperness > 0]
		whileTrue: 
			[self letTimePass: 24 / self caffineLevel.
			self caffineLevel: self caffineLevel - 1.
			self whirlAround].
	self sitDown] fork! !

Jumper subclass: #ObstinateJumper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-Jumpers'!
ObstinateJumper comment:
'An instance of ObstinateJumper represents a kind of Jumper that refuses to take orders.'!


!ObstinateJumper methodsFor: 'commanding'!

jumpUp
	"The receiver refuses to jump up and simply pouts."

	self speak: 'refuse'.
	self pout!

pout
	"The receiver pouts for a few seconds before returning to a 
	more natural sitting position."

	self newState: #pouting.
	
	[self letTimePass: 2.
	self sitDown] fork! !