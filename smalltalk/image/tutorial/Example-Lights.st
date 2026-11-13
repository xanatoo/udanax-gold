Model subclass: #Light
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Example-Lights'!
Light comment:
'An instance of class Light represents an object that is either on or off.
'!


!Light methodsFor: 'initialize-release'!

setOff
	"In initializing this receiver, set it to off."!

setOn
	"In initializing this receiver, set it to on."! !

!Light methodsFor: 'operate'!

turnOff
	"If the receiver is not already off, set it to off."!

turnOn
	"If the receiver is not already on, set it to on. Make sure dependents 
	are informed of the change in status."! !

!Light methodsFor: 'testing'!

isOff
	"Answer whether or not the receiver is currently off."!

isOn
	"Answer whether or not the receiver is currently on."! !

!Light methodsFor: 'updating'!

update: statusChange with: aLight 
	"The receiver is dependent upon the light, aLight. The status of 
	aLight was just changed to statusChange. If the receiver is not the 
	same as aLight, and statusChange is set to on, then turn off the 
	receiver."! !

Model subclass: #TrafficLight
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Example-Lights'!
TrafficLight comment:
'An instance of class TrafficLight manages one or more lights.'!


!TrafficLight methodsFor: 'initialize-release'!

release
	"Release dependency relationships among all the lights."!

with: anInteger 
	"Set the receiver to manage anInteger number of lights such that 
	 only one light will be on at a time."! !

!TrafficLight methodsFor: 'operate'!

turnOn: lightNumber
	"Turn on the light referred to by the argument lightNumber."! !