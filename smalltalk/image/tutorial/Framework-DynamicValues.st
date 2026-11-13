SelectiveMonitor subclass: #DisplayItemMonitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Framework-DynamicValues'!
DisplayItemMonitor comment:
'An instance of DisplayItemMonitor responds to the update message to see if the change is a change in the value of its model.  If it is, then the value of the monitored object, which presumably is the same as or is like the model, has changed as well.  So the DisplayListItem presenting the object should be redisplayed on the outputMedium.'!


!DisplayItemMonitor methodsFor: 'updating'!

update: anAspect with: anArgument from: anObject 
	"Store onto the receiver's output log the current status of 
	the object."

	| oldValue |
	(anAspect == #value) 
		ifTrue: [ oldValue := outputMedium item.
				oldValue text: object value.
				outputMedium display: oldValue]! !