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

Model subclass: #TrafficLight
	instanceVariableNames: 'lights '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Example-Lights'!
TrafficLight comment:
'An instance of class TrafficLight manages one or more lights.

Instance Variable Names:

	lights <Array> of Lights'!


!TrafficLight methodsFor: 'initialize-release'!

release
	"Release dependency relationships among all the lights."

	super release.
	lights do: [:eachLight | eachLight release].
	lights := nil!

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

turnOn: lightNumber
	"Turn on the light referred to by the argument lightNumber."

	lightNumber > 0 & (lightNumber <= lights size)
		ifTrue: [(lights at: lightNumber) turnOn.
				 self changed]! !