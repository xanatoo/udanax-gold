'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!

Object subclass: #Histogram
	instanceVariableNames: 'tallyArray lowerBound upperBound step minValue maxValue totalValues extraEntries '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulation statistics gathering'!


!Histogram methodsFor: 'accessing'!

contains: aValue
	^lowerBound <= aValue and: [aValue < upperBound]!

store: aValue 
	| index |
	minValue isNil
		ifTrue: [minValue _ maxValue _ aValue]
		ifFalse: 
			[minValue _ minValue min: aValue.
			maxValue _ maxValue max: aValue].
	totalValues _ totalValues + aValue.
	(self contains: aValue)
		ifTrue: 
			[index _ (aValue - lowerBound // step) + 1.
			tallyArray at: index put: (tallyArray at: index) + 1]
		ifFalse: [extraEntries _ extraEntries + 1]! !

!Histogram methodsFor: 'printing'!

firstHeader: aStream
	aStream cr; tab.
	aStream nextPutAll: 'Number of '.
	aStream tab.
	aStream nextPutAll: 'Minimum '.
	aStream tab.
	aStream nextPutAll: 'Maximum '.
	aStream tab.
	aStream nextPutAll: 'Average '.
	aStream cr; tab.
	aStream nextPutAll: 'Objects '.
	aStream tab.
	aStream nextPutAll: 'Value '.
	aStream tab.
	aStream nextPutAll: 'Value '.
	aStream tab.
	aStream nextPutAll: 'Value '.!

printStatisticsOn: aStream 
	| totalObjs pos |
	self firstHeader: aStream.
	aStream cr; tab.
	totalObjs _ extraEntries.
	tallyArray do: [:each | totalObjs _ totalObjs + each].
	totalObjs printOn: aStream.
	aStream tab.
	minValue printOn: aStream.
	aStream tab.
	maxValue printOn: aStream.
	aStream tab.
	(totalValues / totalObjs) asFloat printOn: aStream.
	aStream cr.
	self secondHeader: aStream.
	aStream cr.
	pos _ lowerBound.
	tallyArray do: 
		[:entry | 
		pos printOn: aStream.
		aStream nextPut: $-.
		(pos _ pos + step) printOn: aStream.
		aStream tab.
		entry printOn: aStream.
		aStream tab.
		(entry / totalObjs) asFloat printOn: aStream.
		aStream tab.
		aStream nextPut: $|.
		entry rounded timesRepeat: [aStream nextPut: $X].
		aStream cr]!

secondHeader: aStream
	aStream cr; tab.
	aStream nextPutAll: 'Number of '.
	aStream cr.
	aStream nextPutAll: 'Entry '.
	aStream tab.
	aStream nextPutAll: 'Objects '.
	aStream tab.
	aStream nextPutAll: 'Frequency '.! !

!Histogram methodsFor: 'private'!

newLower: lowerNum upper: upperNum by: stepAmount
	tallyArray _ Array new: (upperNum - lowerNum // stepAmount).
	tallyArray atAllPut: 0.
	lowerBound _ lowerNum.
	upperBound _ upperNum.
	step _ stepAmount.
	minValue _ maxValue _ nil.
	totalValues _ 0.
	extraEntries _ 0! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Histogram class
	instanceVariableNames: ''!


!Histogram class methodsFor: 'class initialization'!

from: lowerNum to: upperNum by: step
	^self new newLower: lowerNum upper: upperNum by: step! !

Simulation subclass: #StatisticsWithSimulation
	instanceVariableNames: 'statistics '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulation statistics gathering'!


!StatisticsWithSimulation methodsFor: 'initialization'!

initialize
	super initialize.
	statistics _ Dictionary new.! !

!StatisticsWithSimulation methodsFor: 'simulation scheduling'!

enter: anObject 
	statistics at: anObject put: (SimulationObjectRecord new entrance: currentTime)!

exit: anObject 
	(statistics at: anObject) exit: currentTime! !

!StatisticsWithSimulation methodsFor: 'statistics'!

printStatisticsOn: aStream 
	| stat |
	aStream cr.
	aStream nextPutAll: ' Object'.
	aStream tab.
	aStream nextPutAll: 'Entrance Time'.
	aStream tab.
	aStream nextPutAll: 'Duration'.
	aStream cr.
	stat _ SortedCollection sortBlock: [:i :j | i value entrance <= j value entrance].
	statistics associationsDo: [:each | stat add: each]. 
	stat do: 
		[:anAssociation | 
		aStream cr.
		anAssociation key printOn: aStream.
		aStream tab.
		anAssociation value printOn: aStream]! !

SimulationObject subclass: #EventMonitor
	instanceVariableNames: 'label '
	classVariableNames: 'Counter DataFile '
	poolDictionaries: ''
	category: 'Simulation statistics gathering'!


!EventMonitor methodsFor: 'scheduling'!

finishUp
	super finishUp.
	self timeStamp.
	DataFile nextPutAll: ' exits '.!

startUp
	self timeStamp.
	DataFile nextPutAll: ' enters '.
	super startUp! !

!EventMonitor methodsFor: 'task language'!

acquire: amount ofResource: resourceName
	| aStaticResource |
	self timeStamp.
	DataFile nextPutAll: ' requests '.
	amount printOn: DataFile.
	DataFile nextPutAll: ' of ', resourceName.
	aStaticResource _ super acquire: amount ofResource: resourceName.
	self timeStamp.
	DataFile nextPutAll: ' obtained '.
	amount printOn: DataFile.
	DataFile nextPutAll: ' of ', resourceName.
	^aStaticResource!

acquire: amount ofResource: resourceName withPriority: priorityNumber
	| aStaticResource |
	self timeStamp.
	DataFile nextPutAll: ' requests '.
	amount printOn: DataFile.
	DataFile nextPutAll: ' at priority '.
	priorityNumber printOn: DataFile.
	DataFile nextPutAll: ' of ', resourceName.
	aStaticResource _ super acquire: amount ofResource: resourceName withPriority: priorityNumber.
	self timeStamp.
	DataFile nextPutAll: ' obtained '.
	amount printOn: DataFile.
	DataFile nextPutAll: ' of ', resourceName.
	^aStaticResource!

acquireResource: resourceName
	| anEvent |
	self timeStamp.
	DataFile nextPutAll: ' wants to serve for '.
	DataFile nextPutAll: resourceName.
	anEvent _ super acquireResource: resourceName.
	self timeStamp.
	DataFile nextPutAll: ' can serve '.
	anEvent resource printOn: DataFile.
	^anEvent!

holdFor: aTimeDelay
	self timeStamp.
	DataFile nextPutAll: ' holds for '.
	aTimeDelay printOn: DataFile.
	super holdFor: aTimeDelay!

produce: amount ofResource: resourceName
	self timeStamp.
	DataFile nextPutAll: ' produces '.
	amount printOn: DataFile.
	DataFile nextPutAll: ' of ', resourceName.
	super produce: amount ofResource: resourceName!

produceResource: resourceName
	self timeStamp.
	DataFile nextPutAll: ' wants to get service as '.
	DataFile nextPutAll: resourceName.
	super produceResource: resourceName!

release: aStaticResource
	self timeStamp.
	DataFile nextPutAll: ' releases '.
	aStaticResource amount printOn: DataFile.
	DataFile nextPutAll: ' of ', aStaticResource name.
	super release: aStaticResource!

resume: anEvent
	self timeStamp.
	DataFile nextPutAll: ' resumes '.
	anEvent resource printOn: DataFile.
	super resume: anEvent! !

!EventMonitor methodsFor: 'private'!

timeStamp
	DataFile cr.
	Simulation active time printOn: DataFile.
	DataFile tab.
	self printOn: DataFile! !

!EventMonitor methodsFor: 'initialization'!

initialize
	super initialize.
	self setLabel! !

!EventMonitor methodsFor: 'accessing'!

label
	^label!

setLabel
	Counter _ Counter + 1.
	label _ Counter printString.! !

!EventMonitor methodsFor: 'printing'!

printOn: aStream
	self class name printOn: aStream.
	aStream space.
	aStream nextPutAll: self label! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

EventMonitor class
	instanceVariableNames: ''!


!EventMonitor class methodsFor: 'class initialization'!

file: aFile
	DataFile _ aFile.
	Counter _ 0! !

Object subclass: #SimulationObjectRecord
	instanceVariableNames: 'entranceTime duration '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Simulation statistics gathering'!


!SimulationObjectRecord methodsFor: 'accessing'!

duration
	^duration!

entrance
	^entranceTime!

entrance: currentTime
	entranceTime _ currentTime!

exit
	^entranceTime + duration!

exit: currentTime
	duration _ currentTime - entranceTime! !

!SimulationObjectRecord methodsFor: 'printing'!

printOn: aStream
	entranceTime printOn: aStream.
	aStream tab.
	duration printOn: aStream! !