'From Smalltalk-80, Version 2.4 Beta2 of 18 August 1988 on 19 September 1988 at 1:54:36 am'!

Object subclass: #UserPrimitives
	instanceVariableNames: ''
	classVariableNames: 'FailCodes UPErrorSignal '
	poolDictionaries: ''
	category: 'User Primitives'!
UserPrimitives comment:
'I am a place to hang behavior for user-defined primitives.

My metaclass has protocol for interpreting error codes.

Class Variables:
	FailCodes		<IdentityDictionary>
						Maps standard failure codes to strings.
	UPErrorSignal	<Signal>
						Standard exception signal for user-defined primitive errors.

	'!


!UserPrimitives methodsFor: 'error reporting'!

failCode
	"Answer the failure code reported by the last user-defined primitive."
	"Delegate to metaclass."

	^self class failCode!

failString
	"Answer the failure code reported by the last user-defined primitive, 
	as a string."

	^self class errorStringFor: self failCode! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

UserPrimitives class
	instanceVariableNames: ''!


!UserPrimitives class methodsFor: 'class initialization'!

initFailCodes

	FailCodes _ IdentityDictionary new: 20.

	FailCodes at: 0 put: 'failure code lost'.
	FailCodes at: -1 put: 'C argument out of range'.
	FailCodes at: -2 put: 'Smalltalk argument out of range'.
	FailCodes at: -3 put: 'argument not an object'.
	FailCodes at: -4 put: 'object incorrect type'.
	FailCodes at: -5 put: 'declared arg wrong type'.
	FailCodes at: -6 put: 'C int was not a SmallInteger'.
	FailCodes at: -7 put: 'C data structure too small'.
	FailCodes at: -8 put: 'Smalltalk datum too small to be represented in C'.
	FailCodes at: -9 put: 'Smalltalk datum too big to be represented in C'.
	FailCodes at: -10 put: 'Smalltalk object memory allocation failed'.
	FailCodes at: -11 put: 'arg count mismatch'.
	FailCodes at: -12 put: 'user primitive is not installed'.
	FailCodes at: -13 put: 'too many arguments'.
	FailCodes at: -14 put: 'no value returned'.
	FailCodes at: -15 put: 'assertion failure'!

initialize
	"UserPrimitives initialize"

	UPErrorSignal _ (Object errorSignal newSignal)
			notifierString: 'User-defined primitive Error';
			nameClass: self message: #errorSignal.
	self initFailCodes! !

!UserPrimitives class methodsFor: 'error reporting'!

errorStringFor: code
	"Answer a string describing the error code."

	^FailCodes at: code ifAbsent: ['error code ', code printString]!

signalError
	"Raise a signal, with the failure code as an argument."

	self errorSignal raiseWith: self failCode!

signalErrorProceeding
	"Raise a signal, with the failure code as an argument."

	^self errorSignal raiseRequestWith: self failCode! !

!UserPrimitives class methodsFor: 'class accessing'!

errorSignal
	"Return the standard error signal for user-defined primitive errors."

	^UPErrorSignal!

failCode
	"Answer the failure code reported by the last user-defined primitive."

	<primitive: 9999>
	^0! !

UserPrimitives initialize!
