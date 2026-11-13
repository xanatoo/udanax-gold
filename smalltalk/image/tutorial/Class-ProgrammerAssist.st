'From Smalltalk-80, Version 2.5 alpha of 30 April 1989 on 25 May 1989 at 4:30:06 am'!



!Class methodsFor: 'subclass creation'!

accessingSubclass: className instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: stringOfPoolNames category: categoryName
	"This is a special initialization message for creating a new class as a subclass
	of an existing class (the receiver), with accessing messages for the instance
	variables already installed."

	| newClass |
	newClass := self subclass: className 
					instanceVariableNames: instVarString 
					classVariableNames: classVarString 
					poolDictionaries: stringOfPoolNames 
					category: categoryName.
	(newClass isKindOf: Class) 
		ifTrue: [newClass addReadingAccess.
				newClass addWritingAccess].
	^newClass!

addReadingAccess
		"For each instance variable, add in the message category accessing a message whose selector is the instance variable and whose method returns the value of the instance variable.  If there is already a message selector with the instance variable name, no replacement is made."
		
		self instVarNames do: 
			[ :eachName | 
			(self includesSelector: eachName asSymbol) 
				ifFalse: [ | aStream |
						aStream := String new writeStream.
						aStream nextPutAll: eachName.
						aStream cr; cr; tab.
						aStream nextPut: $^.
						aStream nextPutAll: eachName.
						self compile: aStream contents classified: #accessing]]!

addWritingAccess
		"For each instance variable, add in the message category accessing a message whose selector is the instance variable as a keyword with one argument, and whose method stores the argument as the new value of the instance variable.  If there is already a message selector with the instance variable name as keyword, no replacement is made."
		
		self instVarNames do: 
			[ :eachName | 
			(self includesSelector: (eachName, ':') asSymbol) 
				ifFalse: [ | aStream |
						aStream := String new writeStream.
						aStream nextPutAll: eachName.
						aStream nextPutAll: ': aValue'.
						aStream cr; cr; tab.
						aStream nextPutAll: '| oldValue |'.
						aStream cr; tab.
						aStream nextPutAll: 'oldValue := '.
						aStream nextPutAll: eachName.
						aStream nextPut: $.; cr; tab.
						aStream nextPutAll: eachName.
						aStream nextPutAll: ' := aValue.'.
						aStream cr; tab.
						aStream nextPutAll: 'self changed: #'.
						aStream nextPutAll: eachName.
						aStream nextPutAll: ' with: oldValue'.
						self compile: aStream contents classified: #accessing]]! !
