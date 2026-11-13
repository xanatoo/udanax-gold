'From Smalltalk-80, Version 2.4 of 28 January 1989 on 14 May 1989 at 2:48:01 pm'!

ArithmeticValue subclass: #Complex
	instanceVariableNames: 'real imaginary '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Magnitude-Numbers'!
Complex comment:
'This is an implementation of complex numbers.  A complex number has real and imaginary parts which must be manipulated simultaneously in any numeric processing.  Complex numbers can be used in many of the same places that regular numbers can be used with one major exception of comparisons, since complex numbers cannot be directly compared for size (except through lengths of vectors (see absolute value)).

Instance variables:
	real			<Number> the part of the number which can be expressed as a Real number
	imaginary	<Number> the part of the number which, in terms of how the number behaves,
					has been multiplied by ''i'' (-1 sqrt)
'!


!Complex methodsFor: 'accessing'!

imaginary
	"Return the imaginary part of the complex number."
	^ imaginary!

real
	"Return the real part of the complex number."
	^ real! !

!Complex methodsFor: 'arithmetic'!

* aNumber 
	"Return the product of the receiver and the argument."

	aNumber isComplex
		ifTrue: 
			[| u v |
			u := aNumber real.
			v := aNumber imaginary.
			^Complex
				real: real * u - (imaginary * v)
				imaginary: real * v + (imaginary * u)]
		ifFalse: [^self retry: #* coercing: aNumber]!

+ aNumber 
	"Return the sum of the receiver and the argument."

	aNumber isComplex
		ifTrue: [^Complex
					real: aNumber real + real
					imaginary: aNumber imaginary + imaginary]
		ifFalse: [^self retry: #+ coercing: aNumber]!

- aNumber
	"Return the difference of the receiver and the argument."

	aNumber isComplex
		ifTrue: [^Complex
					real: real - aNumber real
					imaginary: imaginary - aNumber imaginary]
		ifFalse: [^self retry: #- coercing: aNumber]!

/ aNumber 
	"Return the quotient of the receiver and the argument."

	aNumber isComplex
		ifTrue: 
			[| denom u v |
			u := aNumber real.
			v := aNumber imaginary.
			denom := u * u + (v * v).
			^Complex
				real: u * real + (v * imaginary) / denom
				imaginary: u * imaginary - (v * real) / denom]
		ifFalse: [^self retry: #/ coercing: aNumber]!

abs
	"Return the magnitude (or absolute value) of the complex number."

	^ (real * real + (imaginary * imaginary)) sqrt!

conjugated
	"Return the complex conjugate of this complex number."

	^ Complex real: real imaginary: imaginary negated! !

!Complex methodsFor: 'mathematical functions'!

sqrt
	"Return the square root of the receiver"

	| u v |
	(imaginary = 0 and: [real >= 0])
		ifTrue:	[^real sqrt].
	v := (self abs - real / 2) sqrt.
	u := imaginary / 2 / v.
	^Complex real: u imaginary: v! !

!Complex methodsFor: 'comparing'!

< aNumber

	^Number
		raise: #unorderedSignal
		receiver: self
		selector: #<
		arg: aNumber
		errorString: 'Complex numbers are not well ordered'!

hash
	"Hash is implemented because equals is implemented."

	^ real hash! !

!Complex methodsFor: 'testing'!

isComplex

	^true!

isZero
	"Answer whether 'self = self class zero'.  We can't use #= because
	#= is defined in terms of #isZero"

	^real isZero and: [imaginary isZero]!

sign

	^Complex real: real sign imaginary: imaginary sign! !

!Complex methodsFor: 'coercing'!

coerce: aNumber

	^aNumber asComplex!

generality

	^150! !

!Complex methodsFor: 'converting'!

asComplex

	^self!

asDouble

	imaginary = 0 ifTrue: [^real asDouble].
	^Number
		raise: #coercionErrorSignal
		receiver: self
		selector: #asDouble
		errorString: 'Can''t coerce an instance of Complex to a Double'!

asFloat

	imaginary = 0 ifTrue: [^real asFloat].
	^Number
		raise: #coercionErrorSignal
		receiver: self
		selector: #asFloat
		errorString: 'Can''t coerce an instance of Complex to a Float'!

asInteger

	imaginary = 0 ifTrue: [^real asInteger].
	^Number
		raise: #coercionErrorSignal
		receiver: self
		selector: #asInteger
		errorString: 'Can''t coerce an instance of Complex to an Integer'!

asPoint
	"Return the complex number as a point."
	^ real @ imaginary!

reduceGeneralityIfPossible
	"Answer the receiver transformed to a lower generality, if such a 
	transformation is possible without losing information. If not, answer 
	the receiver"

	imaginary isZero
		ifTrue:	[^real]
		ifFalse:	[^self]! !

!Complex methodsFor: 'printing'!

printOn: aStream
	aStream nextPut: $(.
	real storeOn: aStream.
	aStream nextPutAll: '%'.
	imaginary storeOn: aStream.
	aStream nextPut: $).!

storeOn: aStream
	aStream nextPut: $(.
	real storeOn: aStream.
	aStream nextPutAll: '%'.
	imaginary storeOn: aStream.
	aStream nextPut: $).! !

!Complex methodsFor: 'private'!

setReal: u setImaginary: v
	real := u.
	imaginary := v.! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Complex class
	instanceVariableNames: ''!


!Complex class methodsFor: 'instance creation'!

fromReal: aNumber
	"Create a new complex number from the given real number."
	^ self basicNew setReal: aNumber setImaginary: 0!

real: u imaginary: v
	"Create a new complex number with the given real and imaginary parts.  If the imaginary part is zero, return the real part of the number."
	^v = 0
		ifTrue:	[u]
		ifFalse:	[self basicNew setReal: u setImaginary: v]! !

!Complex class methodsFor: 'exception handling'!

trapImaginary: aBlock
	"Complex trapImaginary: [-27 sqrt]"

	^Number domainErrorSignal
		handle: [ :ex |
				| send |
				send := ex parameter.
				(send selector = #sqrt or: [send selector = #sqrtTruncated])
					ifTrue:	[send receiver: send receiver asComplex.
							ex proceedWith: send value]
					ifFalse:	[ex reject]]
		do: aBlock! !

!Complex class methodsFor: 'constants access'!

unity
	"Answer the value which allows, for any given arithmetic value, the following to be true

		aNumber * aNumber class unity = aNumber

	This must be true regardless of how a given subclass chooses to define #*"

	^self fromReal: 1!

zero
	"Answer the value which allows, for any given arithmetic value, the following to be true

		aNumber + aNumber class zero = aNumber

	This must be true regardless of how a given subclass chooses to define #+"

	^self fromReal: 0! !

!ArithmeticValue methodsFor: 'testing'!

isComplex
	"Answer whether the receiver has an imaginary part"

	^false! !

!Number methodsFor: 'converting'!

% aNumber 
	"Answer a complex number with the receiver as the real part and 
	aNumber as the imaginary part"

	^Complex real: self imaginary: aNumber!

asComplex
	"Answer a complex number with the receiver as the real part and 
	zero as the imaginary part"

	^Complex fromReal: self! !


