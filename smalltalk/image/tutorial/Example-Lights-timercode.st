Model subclass: #Light
	instanceVariableNames: 'status '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Example-Lights'!
Light comment:
'An instance of class Light represents an object that is either on or off.

Instance Variable Names:
	
	status	<Boolean> true if on, false if off'!


!Light methodsFor: 'initialize-release'!

setOff
	"In initializing this receiver, set it to off."

	status := false!

setOn
	"In initializing this receiver, set it to on."

	status := true! !

!Light methodsFor: 'operate'!

turnOff
	"If the receiver is not already off, set it to off."

	self isOn ifTrue:  [status := false.
					   self changed: #toOff with: self]!

turnOn
	"If the receiver is not already on, set it to on. Make sure dependents 
	are informed of the change in status."

	self isOff ifTrue: [status := true.
					  self changed: #toOn with: self]! !

!Light methodsFor: 'testing'!

isOff
	"Answer whether or not the receiver is currently off."

	^ status not!

isOn
	"Answer whether or not the receiver is currently on."

	^status! !

!Light methodsFor: 'updating'!

update: statusChange with: aLight 
	"The receiver is dependent upon the light, aLight. The status of 
	aLight was just changed to statusChange. If the receiver is not the 
	same as aLight, and statusChange is set to on, then turn off the 
	receiver."

	aLight == self ifTrue: [^self].
	statusChange = #toOn & self isOn ifTrue: [self turnOff]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Light class
	instanceVariableNames: ''!


!Light class methodsFor: 'instance creation'!

new
	"Create an instance of the receiver set to off."

	^(super new) setOff! !

Model subclass: #TrafficLight
	instanceVariableNames: 'lights lightProcess '
	classVariableNames: 'Timer '
	poolDictionaries: ''
	category: 'Example-Lights'!
TrafficLight comment:
'An instance of class TrafficLight manages one or more lights.

Instance Variable Names:

	lights <Array> of Lights
	lightProcess <Process>

Class Variable Name:
	Timer	<Integer>  measured in milliseconds

	'!


!TrafficLight methodsFor: 'initialize-release'!

release
	"Release dependency relationships among all the lights."

	super release.
	lights do: [:eachLight | eachLight release].
	lights := nil.
	lightProcess release.
	lightProcess := nil!

with: anInteger 
	"Set the receiver to manage anInteger number of lights such that 
	 only one light will be on at a time."

	lights := Array new: (anInteger max: 1).
	1 to: anInteger do: [:index | lights at: index put: Light new setOff].

	"Link the dependencies"
	lights do: [:eachLight | 
				lights do: [:dependentLight | 
							eachLight ~~ dependentLight 
								ifTrue: [eachLight addDependent: dependentLight]]]! !

!TrafficLight methodsFor: 'operate'!

startUp
	"Install the receiver and continually turn lights on and off until asked to stop."

	| index |

	index := 0.

	lightProcess := 
		[[(Delay forMilliseconds: Timer) wait.
			index := (index + 1) \\ lights size.
			self turnOn: index + 1] repeat]
		newProcess.

	lightProcess resume!

stop
	"The receiver should no longer continually turn lights on and off."

	lightProcess terminate!

turnOn: lightNumber
	"Turn on the light referred to by the argument lightNumber."

	lightNumber > 0 & (lightNumber <= lights size)
		ifTrue: [(lights at: lightNumber) turnOn.
				 self changed]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TrafficLight class
	instanceVariableNames: ''!


!TrafficLight class methodsFor: 'class initialization'!

setTimer: anAmount
	"Set the timer interval for changing lights to be anAmount."

	Timer := anAmount! !