Number subclass: #MetaNumeric
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Magnitude-Numbers-MetaNumeric'!
MetaNumeric comment:
'MetaNumeric is the abstract superclass for unrepresentable numbers.  These include Infinity (very large numbers), Infinitesimal (very tiny numbers), and NotANumber (undefinable values).  In addition, the class SomeNumber represents finitely expressable numbers in the domain of MetaNumerics, so that coercion is possible if necessary'!


!MetaNumeric methodsFor: 'coercing'!

coerce: aNumber

	^aNumber asMetaNumber!

generality

	^120! !

!MetaNumeric methodsFor: 'double dispatching'!

differenceFromDouble: aDouble

	^self differenceFromSomeNumber: aDouble asMetaNumber!

differenceFromFloat: aFloat

	^self differenceFromSomeNumber: aFloat asMetaNumber!

differenceFromFraction: aFraction

	^self differenceFromSomeNumber: aFraction asMetaNumber!

differenceFromInteger: aInteger

	^self differenceFromSomeNumber: aInteger asMetaNumber!

lessFromDouble: aDouble

	^self lessFromSomeNumber: aDouble asMetaNumber!

lessFromFloat: aFloat

	^self lessFromSomeNumber: aFloat asMetaNumber!

lessFromFraction: aFraction

	^self lessFromSomeNumber: aFraction asMetaNumber!

lessFromInteger: aInteger

	^self lessFromSomeNumber: aInteger asMetaNumber!

productFromDouble: aDouble

	^self productFromSomeNumber: aDouble asMetaNumber!

productFromFloat: aFloat

	^self productFromSomeNumber: aFloat asMetaNumber!

productFromFraction: aFraction

	^self productFromSomeNumber: aFraction asMetaNumber!

productFromInteger: aInteger

	^self productFromSomeNumber: aInteger asMetaNumber!

quotientFromDouble: aDouble

	^self quotientFromSomeNumber: aDouble asMetaNumber!

quotientFromFloat: aFloat

	^self quotientFromSomeNumber: aFloat asMetaNumber!

quotientFromFraction: aFraction

	^self quotientFromSomeNumber: aFraction asMetaNumber!

quotientFromInteger: aInteger

	^self quotientFromSomeNumber: aInteger asMetaNumber!

sumFromDouble: aDouble

	^self sumFromSomeNumber: aDouble asMetaNumber!

sumFromFloat: aFloat

	^self sumFromSomeNumber: aFloat asMetaNumber!

sumFromFraction: aFraction

	^self sumFromSomeNumber: aFraction asMetaNumber!

sumFromInteger: aInteger

	^self sumFromSomeNumber: aInteger asMetaNumber! !

!MetaNumeric methodsFor: 'converting'!

asMetaNumber
	"Represent the number as a MetaNumeric"

	^self! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MetaNumeric class
	instanceVariableNames: ''!


!MetaNumeric class methodsFor: 'constants access'!

unity
	"Answer the value which allows, for any given arithmetic value, the following to be true

		aNumber * aNumber class unity = aNumber

	This must be true regardless of how a given subclass chooses to define #*"

	^SomeNumber from: 1!

zero
	"Answer the value which allows, for any given arithmetic value, the following to be true

		aNumber + aNumber class zero = aNumber

	This must be true regardless of how a given subclass chooses to define #+"

	^SomeNumber from: 0! !

MetaNumeric subclass: #Infinity
	instanceVariableNames: 'negative '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Magnitude-Numbers-MetaNumeric'!
Infinity comment:
'Infinities represent numbers so large that they are unrepresentable in more conventional forms.  Dividing a number by zero is a case where an application may choose to generate instances of this class.

Instance variables
	negative	<Boolean> whether the value is greater or less than zero'!


!Infinity methodsFor: 'arithmetic'!

* aNumber 
	"Multiply aNumber by the receiver"

	^aNumber productFromInfinity: self!

+ aNumber 
	"Add aNumber to the receiver"

	^aNumber sumFromInfinity: self!

- aNumber 
	"Subtract aNumber from the receiver"

	^aNumber differenceFromInfinity: self!

/ aNumber 
	"Divide the receiver by aNumber"

	^aNumber quotientFromInfinity: self!

negated

	^self class negative: negative == false! !

!Infinity methodsFor: 'comparing'!

< aNumber 
	"Compare the receiver to aNumber"

	^aNumber lessFromInfinity: self!

hash

	^16383! !

!Infinity methodsFor: 'testing'!

isZero
	"Answer whether 'self = self class zero'.  We can't use #= because
	#= is defined in terms of #isZero"

	^false!

negative
	"Answer whether the receiver is less than zero"

	^negative!

positive
	"Answer whether the receiver is greater than zero"

	^negative == false! !

!Infinity methodsFor: 'truncation and roundoff'!

truncated

	^self class
		raise: #domainErrorSignal
		receiver: self
		selector: #truncated
		errorString: 'Can''t truncate infinity'! !

!Infinity methodsFor: 'printing'!

printOn: aStream

	aStream nextPut: (negative ifTrue: [$-] ifFalse: [$+]).
	aStream nextPutAll: 'infinity'! !

!Infinity methodsFor: 'double dispatching'!

differenceFromInfinitesimal: aNumber

	^self negated!

differenceFromInfinity: aNumber 

	self negative = aNumber negative
		ifTrue: [^self class
				raise: #domainErrorSignal
				receiver: aNumber
				selector: #-
				arg: self
				errorString: 'Can''t subtract Infinities with like signs']
		ifFalse: [^aNumber copy]!

differenceFromSomeNumber: aNumber

	^self negated!

lessFromInfinity: aNumber 

	aNumber negative = self negative
		ifTrue: [^self class
				raise: #unorderedSignal
				receiver: aNumber
				selector: #<
				arg: self
				errorString: 'Can''t compare Infinities of like signs']
		ifFalse: [^aNumber negative]!

lessFromInfinitesimal: aNumber

	^self positive!

lessFromSomeNumber: aNumber

	^self positive!

productFromInfinitesimal: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #*
		arg: self
		errorString: 'The product of Infinity and Infinitesimal is undefined'!

productFromInfinity: aNumber

	aNumber negative
		ifTrue:	[^self negated]
		ifFalse:	[^self copy]!

productFromSomeNumber: aNumber

	aNumber isZero
		ifTrue:	[^0].
	aNumber numericValue = 1
		ifTrue:	[^self].
	aNumber negative
		ifTrue:	[^self negated]
		ifFalse:	[^self copy]!

quotientFromInfinitesimal: aNumber

	self negative
		ifTrue:	[^aNumber negated]
		ifFalse:	[^aNumber copy]!

quotientFromInfinity: aNumber 

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #/
		arg: self
		errorString: 'Can''t divide Infinity by Infinity'!

quotientFromSomeNumber: aNumber 

	aNumber isZero
		ifTrue:	[^0].
	^Infinitesimal negative: aNumber negative ~= self negative!

sumFromInfinitesimal: aNumber

	^self copy!

sumFromInfinity: aNumber 

	self negative ~= aNumber negative
		ifTrue: [^self class
				raise: #domainErrorSignal
				receiver: aNumber
				selector: #+
				arg: self
				errorString: 'Can''t add Infinities of differing signs']
		ifFalse: [^aNumber copy]!

sumFromSomeNumber: aNumber

	aNumber isZero
		ifTrue:	[^self]
		ifFalse:	[^self copy]! !

!Infinity methodsFor: 'private'!

negative: aBoolean

	negative := aBoolean! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Infinity class
	instanceVariableNames: ''!


!Infinity class methodsFor: 'instance creation'!

negative
	"Answer negative infinity"

	^self negative: true!

negative: boolean
	"Answer a 'new' infinity, either positive or negative"

	^self basicNew negative: boolean!

positive
	"Answer positive infinity"

	^self negative: false! !

MetaNumeric subclass: #Infinitesimal
	instanceVariableNames: 'negative '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Magnitude-Numbers-MetaNumeric'!
Infinitesimal comment:
'Infinitesimals represent numbers so close to zero that they are unrepresentable in more conventional forms.  Infinitesimal may be thought of as the reciprocal of Infinity.

Instance variables
	negative	<Boolean> whether the value is greater or less than zero'!


!Infinitesimal methodsFor: 'arithmetic'!

* aNumber 
	"Multiply aNumber by the receiver"

	^aNumber productFromInfinitesimal: self!

+ aNumber 
	"Add the receiver to aNumber"

	^aNumber sumFromInfinitesimal: self!

- aNumber 
	"Subtract aNumber from the receiver"

	^aNumber differenceFromInfinitesimal: self!

/ aNumber 
	"Divide the receiver by aNumber"

	^aNumber quotientFromInfinitesimal: self!

negated

	^self class negative: negative == false! !

!Infinitesimal methodsFor: 'comparing'!

< aNumber 
	"Compare the receiver and aNumber"

	^aNumber lessFromInfinitesimal: self!

hash

	^16382! !

!Infinitesimal methodsFor: 'testing'!

isZero
	"Answer whether 'self = self class zero'.  We can't use #= because
	#= is defined in terms of #isZero"

	^false!

negative
	"Answer whether the receiver is less than zero"

	^negative!

positive
	"Answer whether the receiver is greater than zero"

	^negative == false! !

!Infinitesimal methodsFor: 'truncation and roundoff'!

truncated

	^0! !

!Infinitesimal methodsFor: 'printing'!

printOn: aStream

	aStream nextPut: (negative ifTrue: [$-] ifFalse: [$+]).
	aStream nextPutAll: 'tiny'! !

!Infinitesimal methodsFor: 'double dispatching'!

differenceFromInfinitesimal: aNumber 

	self negative ~= aNumber negative
		ifTrue: [^aNumber copy]
		ifFalse: [^self class
				raise: #domainErrorSignal
				receiver: aNumber
				selector: #-
				arg: self
				errorString: 'Can''t compute the difference of Infinitesimals of like sign']!

differenceFromInfinity: aNumber

	^aNumber copy!

differenceFromSomeNumber: aNumber

	aNumber isZero
		ifTrue:	[^self negated].
	^aNumber numericValue!

lessFromInfinitesimal: aNumber 

	aNumber negative = self negative
		ifTrue: [^self class
				raise: #unorderedSignal
				receiver: aNumber
				selector: #<
				arg: self
				errorString: 'Can''t compare Infinitesimals of like sign']
		ifFalse: [^aNumber negative]!

lessFromInfinity: aNumber

	^aNumber negative!

lessFromSomeNumber: aNumber

	aNumber isZero
		ifTrue:	[^self positive].
	^aNumber negative!

productFromInfinitesimal: aNumber 

	self negative
		ifTrue: [^aNumber negated]
		ifFalse: [^aNumber copy]!

productFromInfinity: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #*
		arg: self
		errorString: 'The product of Infinity and Infinitesimal is undefined'!

productFromSomeNumber: aNumber

	aNumber isZero
		ifTrue:	[^0].
	aNumber numericValue = 1
		ifTrue:	[^self].
	aNumber negative
		ifTrue:	[^self negated]
		ifFalse:	[^self copy]!

quotientFromInfinitesimal: aNumber 

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #/
		arg: self
		errorString: 'Can''t divide an Infinitesimal by an Infinitesimal'!

quotientFromInfinity: aNumber 

	self negative
		ifTrue:	[^aNumber negated]
		ifFalse:	[^aNumber copy]!

quotientFromSomeNumber: aNumber 

	aNumber isZero
		ifTrue:	[^0].
	^Infinity negative: aNumber negative ~= self negative!

sumFromInfinitesimal: aNumber 

	self negative = aNumber negative
		ifTrue: [^aNumber copy]
		ifFalse: [^self class
				raise: #domainErrorSignal
				receiver: aNumber
				selector: #+
				arg: self
				errorString: 'Can''t add Infinitesimals of differing signs']!

sumFromInfinity: aNumber

	^aNumber copy!

sumFromSomeNumber: aNumber
	"Return the identity of the receiver, so that equality works.
	Try the following code for an example

	Number unorderedSignal
		handle:
			[ :ex |
			Transcript cr; show: 'i = i can''t be tested'.
			ex returnWith: false]
		do:	[| i |
			0 + (i := Infinitesimal positive) = i
				ifTrue:	[Transcript cr; show: 'i = i'].
			i + i = i
				ifFalse:	[Transcript cr; show: 'i ~= i']]
	"

	aNumber isZero
		ifTrue:	[^self].
	^aNumber numericValue! !

!Infinitesimal methodsFor: 'converting'!

asDouble
	"Answer a Double that approximates the receiver."

	^0 asDouble!

asFloat
	"Answer a Float that approximates the receiver."

	^0.0!

asRational
	"Answer a Rational number that approximates the receiver."

	^0! !

!Infinitesimal methodsFor: 'private'!

negative: aBoolean

	negative := aBoolean! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Infinitesimal class
	instanceVariableNames: ''!


!Infinitesimal class methodsFor: 'instance creation'!

negative
	"Answer negative infinitesimal"

	^self negative: true!

negative: boolean
	"Answer a 'new' infinitesimal, either positive or negative"

	^self basicNew negative: boolean!

positive
	"Answer positive infinitesimal"

	^self negative: false! !

MetaNumeric subclass: #NotANumber
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Magnitude-Numbers-MetaNumeric'!
NotANumber comment:
'NotANumbers are very poor citizens of the number-object world.  They are basically placeholders that indicate that an illegal mathematical operation occurred at some unknown point in the past.  An application may generate NotANumbers when such operations occur as taking the square root of -729, computing the arcSin of 8, etc.'!


!NotANumber methodsFor: 'arithmetic'!

* aNumber

	^self class
		raise: #domainErrorSignal
		receiver: self
		selector: #*
		arg: aNumber
		errorString: 'Can''t perform arithmetic functions on NaN'!

+ aNumber

	^self class
		raise: #domainErrorSignal
		receiver: self
		selector: #+
		arg: aNumber
		errorString: 'Can''t perform arithmetic functions on NaN'!

- aNumber

	^self class
		raise: #domainErrorSignal
		receiver: self
		selector: #-
		arg: aNumber
		errorString: 'Can''t perform arithmetic functions on NaN'!

/ aNumber

	^self class
		raise: #domainErrorSignal
		receiver: self
		selector: #/
		arg: aNumber
		errorString: 'Can''t perform arithmetic functions on NaN'! !

!NotANumber methodsFor: 'testing'!

isZero
	"Answer whether 'self = self class zero'.  We can't use #= because
	#= is defined in terms of #isZero"

	^self class
		raise: #unorderedSignal
		receiver: self
		selector: #isZero
		errorString: 'Can''t do comparisons on NaN'! !

!NotANumber methodsFor: 'comparing'!

< aNumber

	^self class
		raise: #unorderedSignal
		receiver: self
		selector: #<
		arg: aNumber
		errorString: 'Can''t do comparisons on NaN'! !

!NotANumber methodsFor: 'double dispatching'!

differenceFromInfinitesimal: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #-
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

differenceFromInfinity: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #-
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

differenceFromSomeNumber: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #-
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

lessFromInfinitesimal: aNumber

	^self class
		raise: #unorderedSignal
		receiver: aNumber
		selector: #<
		arg: self
		errorString: 'Can''t do comparisons on NaN'!

lessFromInfinity: aNumber

	^self class
		raise: #unorderedSignal
		receiver: aNumber
		selector: #<
		arg: self
		errorString: 'Can''t do comparisons on NaN'!

lessFromSomeNumber: aNumber

	^self class
		raise: #unorderedSignal
		receiver: aNumber
		selector: #<
		arg: self
		errorString: 'Can''t do comparisons on NaN'!

productFromInfinitesimal: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #*
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

productFromInfinity: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #*
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

productFromSomeNumber: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #*
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

quotientFromInfinitesimal: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #/
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

quotientFromInfinity: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #/
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

quotientFromSomeNumber: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #/
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

sumFromInfinitesimal: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #+
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

sumFromInfinity: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #+
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'!

sumFromSomeNumber: aNumber

	^self class
		raise: #domainErrorSignal
		receiver: aNumber
		selector: #+
		arg: self
		errorString: 'Can''t perform arithmetic functions on NaN'! !

!NotANumber methodsFor: 'printing'!

printOn: aStream

	aStream nextPutAll: 'NaN'! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

NotANumber class
	instanceVariableNames: ''!


!NotANumber class methodsFor: 'class initialization'!

initialize
	"NotANumber initialize"

	(Smalltalk includesKey: #Double)
		ifTrue:	[Double initialize]! !

!NotANumber class methodsFor: 'instance creation'!

new

	^self basicNew! !

NotANumber initialize!


MetaNumeric subclass: #SomeNumber
	instanceVariableNames: 'value '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Magnitude-Numbers-MetaNumeric'!
SomeNumber comment:
'SomeNumber represents a nonMetaNumeric scalar Number coerced into the MetaNumeric domain.  SomeNumbers responds to numeric protocol the same way that their value would, except that their generality is that of other MetaNumerics, and they know how to perform computations relative to MetaNumeric values

Instance variables:
	value		<Number> the number that this instance represents
'!

!SomeNumber methodsFor: 'accessing'!

numericValue
	"Represent the receiver as a non-meta scalar quantity"

	^value! !

!SomeNumber methodsFor: 'arithmetic'!

* aNumber 
	"Answer the result of multiplying the receiver by the argument, aNumber."

	^aNumber productFromSomeNumber: self!

+ aNumber 
	"Answer the sum of the receiver and the argument, aNumber."

	^aNumber sumFromSomeNumber: self!

- aNumber 
	"Answer the difference between the receiver and aNumber."

	^aNumber differenceFromSomeNumber: self!

/ aNumber 
	"Answer the result of dividing receiver by aNumber."

	^aNumber quotientFromSomeNumber: self! !

!SomeNumber methodsFor: 'testing'!

isZero
	"Answer whether 'self = self class zero'.  We can't use #= because
	#= is defined in terms of #isZero"

	^value isZero! !

!SomeNumber methodsFor: 'comparing'!

< aNumber

	^aNumber lessFromSomeNumber: self! !

!SomeNumber methodsFor: 'truncation and round off'!

truncated
	"Answer an integer nearest the receiver toward zero."

	^value truncated! !

!SomeNumber methodsFor: 'double dispatching'!

differenceFromInfinitesimal: aNumber

	value = 0
		ifTrue:	[^aNumber]
		ifFalse:	[^value negated]!

differenceFromInfinity: aNumber

	value = 0
		ifTrue:	[^aNumber]
		ifFalse:	[^aNumber copy]!

differenceFromSomeNumber: aNumber

	^aNumber numericValue - value!

lessFromInfinitesimal: aNumber

	value = 0
		ifTrue:	[^aNumber negative].
	^self positive!

lessFromInfinity: aNumber

	^aNumber negative!

lessFromSomeNumber: aNumber

	^aNumber numericValue < value!

productFromInfinitesimal: aNumber

	value = 0
		ifTrue:	[^0].
	value = 1
		ifTrue:	[^aNumber].
	^value negative
		ifTrue:	[aNumber negated]
		ifFalse:	[aNumber copy]!

productFromInfinity: aNumber

	value = 0
		ifTrue:	[^0].
	value = 1
		ifTrue:	[^aNumber].
	^value negative
		ifTrue:	[aNumber negated]
		ifFalse:	[aNumber copy]!

productFromSomeNumber: aNumber

	^aNumber numericValue * value!

quotientFromInfinitesimal: aNumber 

	value = 0 ifTrue: [^self class
			raise: #divisionByZeroSignal
			receiver: aNumber
			selector: #/
			arg: self
			errorString: 'Can''t divide a number by zero'].
	value = 1
		ifTrue:	[^aNumber].
	^value negative
		ifTrue: [aNumber negated]
		ifFalse: [aNumber copy]!

quotientFromInfinity: aNumber

	value = 0 ifTrue: [^self class
			raise: #divisionByZeroSignal
			receiver: aNumber
			selector: #/
			arg: self
			errorString: 'Can''t divide a number by zero'].
	value = 1
		ifTrue:	[^aNumber].
	^value negative
		ifTrue:	[aNumber negated]
		ifFalse:	[aNumber copy]!

quotientFromSomeNumber: aNumber

	^aNumber numericValue / value!

sumFromInfinitesimal: aNumber

	value = 0
		ifTrue:	[^aNumber]
		ifFalse:	[^value]!

sumFromInfinity: aNumber

	value = 0
		ifTrue:	[^aNumber]
		ifFalse:	[^aNumber copy]!

sumFromSomeNumber: aNumber

	^aNumber numericValue + value! !

!SomeNumber methodsFor: 'converting'!

asDouble
	"Answer a Double that represents the receiver."

	^value asDouble!

asFloat
	"Answer a Float that represents the receiver."

	^value asFloat!

asRational
	"Answer a Rational number that represents the receiver."

	^value asRational!

reduceGeneralityIfPossible
	"Answer the receiver transformed to a lower generality, if such a 
	transformation is possible without losing information. If not, answer 
	the receiver"

	^value! !

!SomeNumber methodsFor: 'printing'!

printOn: aStream 
	"Print the receiver on the stream, aStream.
	Numbers print in a form recognized by the compiler."

	value printOn: aStream! !

!SomeNumber methodsFor: 'private'!

setValue: aValue

	value := aValue! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SomeNumber class
	instanceVariableNames: ''!


!SomeNumber class methodsFor: 'instance creation'!

from: aValue
	"Create a wrapper around the given number that allows it to masquerade as a MetaNumber"

	^self basicNew setValue: aValue! !


!Number methodsFor: 'converting'!

asMetaNumber
	"Represent the number as a MetaNumeric"

	^SomeNumber from: self! !

!ArithmeticValue methodsFor: 'double dispatching'!

differenceFromInfinitesimal: aNumber

	^aNumber retry: #- coercing: self!

differenceFromInfinity: aNumber

	^aNumber retry: #- coercing: self!

lessFromInfinitesimal: aNumber

	^aNumber retry: #< coercing: self!

lessFromInfinity: aNumber

	^aNumber retry: #< coercing: self!

productFromInfinitesimal: aNumber

	^aNumber retry: #* coercing: self!

productFromInfinity: aNumber

	^aNumber retry: #* coercing: self!

quotientFromInfinitesimal: aNumber 

	^aNumber retry: #/ coercing: self!

quotientFromInfinity: aNumber

	^aNumber retry: #/ coercing: self!

sumFromInfinitesimal: aNumber

	^aNumber retry: #+ coercing: self!

sumFromInfinity: aNumber

	^aNumber retry: #+ coercing: self!

differenceFromSomeNumber: aNumber

	^aNumber retry: #- coercing: self!

lessFromSomeNumber: aNumber

	^aNumber retry: #< coercing: self!

productFromSomeNumber: aNumber

	^aNumber retry: #* coercing: self!

quotientFromSomeNumber: aNumber 

	^aNumber retry: #/ coercing: self!

sumFromSomeNumber: aNumber

	^aNumber retry: #+ coercing: self! !


