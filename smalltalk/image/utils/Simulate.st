'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!

Object subclass: #DelayedEvent
	instanceVariableNames: 'resumptionSemaphore resumptionCondition '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulations'!


!DelayedEvent methodsFor: 'accessing'!

condition
	"Answer a condition under which the event should be sequenced."

	^resumptionCondition!

condition: anObject
	"The argument, anObject, is the condition under which the event should be sequenced."

	resumptionCondition _ anObject! !

!DelayedEvent methodsFor: 'comparing'!

<= aDelayedEvent
	"Answer whether the receiver should be sequenced before the argument."
	
	resumptionCondition isNil
		ifTrue: [^true]
		ifFalse: [^resumptionCondition <= aDelayedEvent condition]! !

!DelayedEvent methodsFor: 'scheduling'!

pause
	"Suspend the current active process, that is, the current event that is running."

	Simulation active stopProcess.
	resumptionSemaphore wait!

resume
	"Resume the suspended process."
	Simulation active startProcess.
	resumptionSemaphore signal.
	^resumptionCondition! !

!DelayedEvent methodsFor: 'private'!

initialize
	resumptionSemaphore _ Semaphore new!

setCondition: anObject
	self initialize.
	resumptionCondition _ anObject! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DelayedEvent class
	instanceVariableNames: ''!


!DelayedEvent class methodsFor: 'instance creation'!

new
	^super new initialize!

onCondition: anObject
	^super new setCondition: anObject! !

DelayedEvent subclass: #WaitingSimulationObject
	instanceVariableNames: 'amount resource '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulations'!


!WaitingSimulationObject methodsFor: 'task language'!

consume: aNumber
	amount _ (amount - aNumber) max: 0!

release
	resource produce: amount.
	amount _ 0!

release: anAmount
	resource produce: anAmount.
	amount _ amount - anAmount! !

!WaitingSimulationObject methodsFor: 'accessing'!

amount
	^amount!

name
	^resource name!

resource
	^resource!

resource: aResource
	resource _ aResource! !

!WaitingSimulationObject methodsFor: 'private'!

setAmount: aNumber resource: aResource
	amount _ aNumber.
	resource _ aResource! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

WaitingSimulationObject class
	instanceVariableNames: ''!


!WaitingSimulationObject class methodsFor: 'instance creation'!

for: amount of: aResource withPriority: aNumber
	^(self onCondition: aNumber) setAmount: amount resource: aResource!

for: amount withPriority: aNumber
	^(self onCondition: aNumber) setAmount: amount resource: nil! !

Object subclass: #Resource
	instanceVariableNames: 'pending resourceName '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulations'!


!Resource methodsFor: 'accessing'!

acquire
	^self!

addRequest: aDelayedEvent
	pending add: aDelayedEvent.
	self provideResources.
	aDelayedEvent pause.!

name
	^resourceName! !

!Resource methodsFor: 'private'!

provideResources
	^self!

setName: aString
	resourceName _ aString.
	pending _ SortedCollection new! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Resource class
	instanceVariableNames: ''!


!Resource class methodsFor: 'instance creation'!

named: resourceName
	^self new setName: resourceName! !

Resource subclass: #ResourceCoordinator
	instanceVariableNames: 'whoIsWaiting '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulations'!


!ResourceCoordinator methodsFor: 'accessing'!

customersWaiting
	^whoIsWaiting == #customer!

queueLength
	^pending size!

serversWaiting
	^whoIsWaiting == #server! !

!ResourceCoordinator methodsFor: 'task language'!

acquire
	|waiting|
	self customersWaiting ifTrue: [^self giveService].
	"get here if there is no customer waiting for the server."
	waiting _ WaitingSimulationObject for: 1 withPriority: 0.
	whoIsWaiting _ #server.
	self addRequest: waiting.
	^waiting resource!

producedBy: aCustomer
	|waiting|
	waiting _ WaitingSimulationObject for: 1
					of: aCustomer
					withPriority: 0.
	self serversWaiting ifTrue: [^self getServiceFor: waiting].
	whoIsWaiting _ #customer.
	self addRequest: waiting! !

!ResourceCoordinator methodsFor: 'private'!

getServiceFor: aCustomerRequest

	| aServerRequest |
	aServerRequest _ pending removeFirst.
	pending isEmpty ifTrue: [whoIsWaiting _ #none].
	aServerRequest resource: aCustomerRequest.
	aServerRequest resume.
	aCustomerRequest pause!

giveService
	|aCustomerRequest|
	aCustomerRequest_ pending removeFirst.
	pending isEmpty ifTrue: [whoIsWaiting _ #none].
	^aCustomerRequest!

setName: aString
	super setName: aString.
	whoIsWaiting _ #none! !

Resource subclass: #ResourceProvider
	instanceVariableNames: 'amountAvailable '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulations'!


!ResourceProvider methodsFor: 'accessing'!

amountAvailable
	^amountAvailable! !

!ResourceProvider methodsFor: 'task language'!

acquire: amountNeeded withPriority: priorityNumber 
	| waiting |
	waiting _ WaitingSimulationObject
					for: amountNeeded 
					of: self
					withPriority: priorityNumber.
	self addRequest: waiting.
	^waiting!

produce: amount
	amountAvailable _ amountAvailable + amount.
	self provideResources! !

!ResourceProvider methodsFor: 'private'!

provideResources
	| waiting |
	[pending isEmpty not and: [pending first amount <= amountAvailable]]
		whileTrue: 
			[waiting _ pending removeFirst.
			amountAvailable _ amountAvailable - waiting amount.
			waiting resume]!

setName: aResourceName with: amount
	super setName: aResourceName.
	amountAvailable _ amount! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ResourceProvider class
	instanceVariableNames: ''!


!ResourceProvider class methodsFor: 'instance creation'!

named: aResourceName
	^self new setName: aResourceName with: 0!

named: aResourceName with: amount
	^self new setName: aResourceName with: amount! !

Object subclass: #Simulation
	instanceVariableNames: 'resources currentTime eventQueue processCount '
	classVariableNames: 'RunningSimulation '
	poolDictionaries: ''
	category: 'Simulations'!
Simulation comment:
'

Expects to handle several kinds of resources, represented abstractly by class Resource, and concretely by subclasses of Resource:  ResourceProvider, StaticResource, and ResourceCoordinator'!


!Simulation methodsFor: 'initialization'!

activate
	"This instance is now the active simulation"	
	RunningSimulation _ self!

defineArrivalSchedule
	"A subclass specifies the schedule by which simulation objects dynamically enter into the simulation."
	^self!

defineResources
	"A subclass specifies the schedule by which simulation objects that are initially entered into the simulation."
	^self!

initialize
	resources _ Set new.
	currentTime _ 0.0.
	processCount _ 0.
	eventQueue _ SortedCollection new! !

!Simulation methodsFor: 'task language'!

coordinate: resourceName
	(self includesResourceFor: resourceName)
		ifFalse: [resources add: ( ResourceCoordinator named: resourceName)]!

produce: amount of: resourceName 
	(self includesResourceFor: resourceName)
		ifTrue: [(self provideResourceFor: resourceName)
				produce: amount
			"sends produce: to a ResourceProvider"]
		ifFalse: [resources add: (ResourceProvider named: resourceName with: amount)]!

schedule: actionBlock after: timeDelay
	self schedule: actionBlock at: currentTime + timeDelay!

schedule: aBlock at: timeInteger
	"This is the mechanism for scheduling a single action."
	self newProcessFor: [self delayUntil: timeInteger.  aBlock value]!

scheduleArrivalOf: aSimulationObjectClass accordingTo: aProbabilityDistribution 
	"This means start now"

	self
		scheduleArrivalOf: aSimulationObjectClass
		accordingTo: aProbabilityDistribution
		startingAt: currentTime!

scheduleArrivalOf: aSimulationObjectClass accordingTo: aProbabilityDistribution startingAt: timeInteger 
	"Note that aSimulationObjectClass is the class Simulation or one of 
	its subclasses.  The real work is done in the private message 
	schedule:startingAt:andThenEvery:. "

	self
		schedule: [aSimulationObjectClass new startUp]
		startingAt: timeInteger
		andThenEvery: aProbabilityDistribution!

scheduleArrivalOf: aSimulationObject at: timeInteger 
	self schedule: [aSimulationObject startUp]
		at: timeInteger! !

!Simulation methodsFor: 'scheduling'!

delayFor: timeDelay
	self delayUntil: currentTime+timeDelay!

delayUntil: aTime
	| delayEvent |
	delayEvent _ DelayedEvent onCondition: aTime.
	eventQueue add: delayEvent.
	"self stopProcess."
	delayEvent pause.
	"self startProcess"!

newProcessFor: aBlock
	self startProcess.
	[aBlock value. self stopProcess] fork!

startProcess
	processCount _ processCount +1!

stopProcess
	processCount _ processCount - 1! !

!Simulation methodsFor: 'simulation control'!

enter: anObject
	^self!

exit: anObject
	^self!

finishUp
	"We need to empty out the event queue."
	eventQueue _ SortedCollection new.
	^nil!

proceed
	| eventProcess |
	[self readyToContinue]
		whileFalse: [Processor yield].
	eventQueue isEmpty
		ifTrue: [^self finishUp]
		ifFalse: 
			[eventProcess _ eventQueue removeFirst.
			currentTime _ eventProcess condition.
			eventProcess resume]!

startUp
	self activate.
	self defineResources.
	self defineArrivalSchedule! !

!Simulation methodsFor: 'accessing'!

includesResourceFor: resourceName 
	| test |
	test _ resources 
				detect: [:each | each name = resourceName]
				ifNone: [nil].
	^test notNil!

provideResourceFor: resourceName
	^resources detect: [ :each | each name = resourceName]!

time
	^currentTime! !

!Simulation methodsFor: 'private'!

readyToContinue
	^processCount = 0!

schedule: aBlock startingAt: timeInteger andThenEvery: aProbabilityDistribution 
	self newProcessFor: 
			[self delayUntil: timeInteger.
			self newProcessFor: aBlock copy.
			aProbabilityDistribution do: 
				[:nextTimeDelay | 
				self delayFor: nextTimeDelay.
				self newProcessFor: aBlock copy]]! !

!Simulation methodsFor: 'reporting'!

report: label
	Transcript show: label.
	Transcript tab.
	Transcript show: 'pc: ', processCount printString.
	Transcript space.
	Transcript show: 'procs: ', (Processor processesAt: Processor userSchedulingPriority) printString.
	Transcript space.
	Transcript show: 'events: ', eventQueue size printString.
	Transcript cr! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Simulation class
	instanceVariableNames: ''!


!Simulation class methodsFor: 'instance creation'!

new
	^super new initialize! !

!Simulation class methodsFor: 'accessing'!

active
	^RunningSimulation! !

Object subclass: #SimulationObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulations'!
SimulationObject comment:
'A SimulationObject represents any object that can be given a sequence of tasks to do.  The class specifies a general control sequence by which the object enters, carries out its tasks, and leaves the simulation.

	Resources can be produced, consumed, acquired, and tested by queries such as amountAvailable, serversWaiting, custoemrsWaiting?'!


!SimulationObject methodsFor: 'initialization'!

initialize
	"Do nothing.  Subclasses will initialize instance variables."

	^self! !

!SimulationObject methodsFor: 'simulation control'!

finishUp
	"Tell the simulation that the receiver is done with its tasks."
	Simulation active exit: self!

startUp
	Simulation active enter: self.
	"First tell the simulation that the receiver is beginning to do my tasks."
	self tasks.
	self finishUp!

tasks
	"Do nothing.  Subclasses will schedule activities."
	^self! !

!SimulationObject methodsFor: 'task language'!

acquire: amount ofResource: resourceName 
	"Get the resource and then tell it to acquire amount of it.  Answers 
	an instance of StaticResource."

	^(Simulation active provideResourceFor: resourceName)
		acquire: amount withPriority: 0!

acquire: amount ofResource: resourceName withPriority: priority 
	"Returns a StaticResource"
	^(Simulation active provideResourceFor: resourceName)
		acquire: amount withPriority: priority!

acquireResource: resourceName
	"Returns a StaticResource"
	^(Simulation active provideResourceFor: resourceName) acquire!

holdFor: aTimeDelay
	Simulation active delayFor: aTimeDelay!

inquireFor: amount ofResource: resourceName
	^(Simulation active provideResourceFor: resourceName) amountAvailable >= amount!

numberOfProvidersOfResource: resourceName
	| resource |
	resource _ Simulation active provideResourceFor: resourceName.
	resource serversWaiting
		ifTrue: [^resource queueLength]
		ifFalse: [^0]!

numberOfRequestersOfResource: resourceName
	| resource |
	resource _ Simulation active provideResourceFor: resourceName.
	resource customersWaiting
		ifTrue: [^resource queueLength]
		ifFalse: [^0]!

produce: amount ofResource: resourceName
	Simulation active produce: amount of: resourceName!

produceResource: resourceName
	^(Simulation active provideResourceFor: resourceName) producedBy: self!

release: aStaticResource
	^aStaticResource release!

resourceAvailable: resourceName
	"Does the active simulaton have a resource with this attribute available?"
	^Simulation active includesResourceFor: resourceName!

resume: anEvent
	^anEvent resume!

stopSimulation
	Simulation active finishUp! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SimulationObject class
	instanceVariableNames: ''!


!SimulationObject class methodsFor: 'instance creation'!

new
	^super new initialize! !