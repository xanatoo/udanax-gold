'From Smalltalk-80, Version 2.4 Beta2 of 18 August 1988 on 19 September 1988 at 2:04:37 am'!

UserPrimitives subclass: #UserPrimitiveTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'User Primitives'!
UserPrimitiveTests comment:
'I am a class to test the user primitive support routines.  I can only run my tests if the Virtual Machine includes all my User Primitives defined for this purpose.

To run my tests, do:

	"UserPrimitiveTests new run"

and watch the Transcript.  If an error occurs a Notifier will appear.'!


!UserPrimitiveTests methodsFor: 'top level'!

run
	"UserPrimitiveTests new run"

	Transcript cr; show: 'Starting user-primitive tests...'; cr.
	#(runtstUPbasicAt runtstUPbasicAtPut runtstUPbyteAt runtstUPbyteAtPut runtstUPcopyCtoSTfloatArray runtstUPcopyCtoSTIntArray runtstUPcopyCtoSTstring runtstUPcopySTtoCfloatArray runtstUPcopySTtoCintArray runtstUPcopySTtoCstring runtstUPCtoSTbool runtstUPCtoSTchar runtstUPCtoSTfloat runtstUPCtoSTint runtstUPfloatAt runtstUPfloatAtPut runtstUPindexVarSize runtstUPinstVarAt runtstUPinstVarAtPut runtstUPinstVarSize runtstUPintegerAtPut runtstUPisArrayOfFloat runtstUPisArrayOfInteger runtstUPisBoolean runtstUPisByteArray runtstUPisCharacter runtstUPisFloat runtstUPisInteger runtstUPisString runtstUPisByteLike runtstUPnil runtstUPreturnFalse runtstUPreturnHandle runtstUPreturnNil runtstUPreturnTrue runtstUPSTtoCchar runtstUPSTtoCfloat runtstUPSTtoCint runtstUP32Arguments runtstUPerrorHandler runtstUPassert ) do: 
		[:msg | 
		Transcript show: msg printString.
		self perform: msg.
		Transcript cr]! !

!UserPrimitiveTests methodsFor: 'individual tests'!

runtstUP32Arguments
	| result1 result2 array |
	array _ Array new: 33.
	1 to: 32 do: [:i | array at: i put: i].
	array at: 33 put: self.

	result1 _ self tstUP32Arguments: 01 a02: 02 a03: 03 a04: 04 a05: 05 a06: 06 a07: 07 a08: 08 a09: 09 a10: 10 a11: 11 a12: 12 a13: 13 a14: 14 a15: 15 a16: 16 a17: 17 a18: 18 a19: 19 a20: 20 a21: 21 a22: 22 a23: 23 a24: 24 a25: 25 a26: 26 a27: 27 a28: 28 a29: 29 a30: 30 a31: 31 a32: 32.
	(result1 size = 33 and: [result1 = array])
		ifFalse: [self message: 'tstUP32Arguments one failed'].

	array at: 1 put: $a.
	result2 _ self tstUP32Arguments: $a a02: 02 a03: 03 a04: 04 a05: 05 a06: 06 a07: 07 a08: 08 a09: 09 a10: 10 a11: 11 a12: 12 a13: 13 a14: 14 a15: 15 a16: 16 a17: 17 a18: 18 a19: 19 a20: 20 a21: 21 a22: 22 a23: 23 a24: 24 a25: 25 a26: 26 a27: 27 a28: 28 a29: 29 a30: 30 a31: 31 a32: 32.
	result1 _ self failCode.
	(result2 == nil and: [result1 = 1])
		ifFalse: [self message: 'tstUP32Arguments two failed']!

runtstUPassert
	| result |
	result _ self tstUPassert: true.
	(result == self)
		ifFalse: [self message: 'tstUPassert 1 failed'].
        Transcript cr; show: 'This validation suite will now cause an assertion to fail.
You should now receive external notification that this has happened.';cr.
	result _ self tstUPassert: false.
	(result == nil)
		ifFalse: [self message: 'tstUPassert 2 failed'].!

runtstUPbasicAt
	| result |
	result _ self tstUPbasicAt: #(1 20 3 ) with: 2.
	result == 20 ifFalse: [self message: 'tstUPbasicAt: anArray with: anIndex failed']!

runtstUPbasicAtPut
	| result anArray |
	anArray _ Array with: #foo with: #bar with: #who.
	result _ self
				tstUPbasicAtPut: anArray
				with: 2
				with: #who.
	(result = #bar and: [anArray = #(foo who who )])
		ifFalse: [self message: 'tstUPbasicAtPut: anArray with: anIndex with: toBePut failed']!

runtstUPbyteAt
	| result aByteArray |
	aByteArray _ ByteArray new: 3.
	aByteArray at: 1 put: 8.
	aByteArray at: 2 put: 16.
	aByteArray at: 3 put: 24.
	result _ self tstUPbyteAt: aByteArray with: 2.
	result == 16 ifFalse: [self message: 'tstUPbyteAt: aByteArray with: anIndex failed']!

runtstUPbyteAtPut
	| result aByteArray |
	aByteArray _ ByteArray new: 3.
	aByteArray at: 1 put: 8.
	aByteArray at: 2 put: 16.
	aByteArray at: 3 put: 24.
	result _ self
				tstUPbyteAtPut: aByteArray
				with: 2
				with: 20.
	(result = 16 and: [(aByteArray at: 1)
			== 8 and: [(aByteArray at: 2)
				== 20 and: [(aByteArray at: 3)
					== 24]]])
		ifFalse: [self message: 'tstUPbyteAt: aByteArray with: anIndex failed']!

runtstUPcopyCtoSTfloatArray
	"Test new runtstUPcopyCtoSTfloatArray"

	| result anArray |
	anArray _ #(2.0 2.0 2.0 2.0 2.0 2.0 ) copy.
	result _ self
				tstUPcopyCtoSTfloatArray: anArray
				with: 3
				with: 4.
	(result = 3 and: [anArray = #(2.0 2.0 2.0 -1.0 2.0 -3.0 )])
		ifFalse: [self message: 'tstUPcopyCtoSTfloatArray 1 failed'].
	anArray _ #(2.0 2.0 2.0 2.0 2.0 2.0 ) copy.
	result _ self
				tstUPcopyCtoSTfloatArray: anArray
				with: 3
				with: 1.
	(result = 3 and: [anArray = #(-1.0 2.0 -3.0 2.0 2.0 2.0 )])
		ifFalse: [self message: 'tstUPcopyCtoSTfloatArray 2 failed'].
	anArray _ #(2.0 2.0 2.0 2.0 2.0 2.0 ) copy.
	result _ self
				tstUPcopyCtoSTfloatArray: anArray
				with: 1
				with: 6.
	(result = 1 and: [anArray = #(2.0 2.0 2.0 2.0 2.0 -1.0 )])
		ifFalse: [self message: 'tstUPcopyCtoSTfloatArray 3 failed']!

runtstUPcopyCtoSTIntArray
	"Test new runtstUPcopyCtoSTIntArray"

	| result anArray |
	anArray _ #(2 2 2 2 2 2 ) copy.
	result _ self tstUPcopyCtoSTIntArray: anArray with: 3 with: 4.
	(result = 3 and: [anArray = #(2 2 2 1 2 3 )])
		 ifFalse: [self message: 'tstUPcopyCtoSTIntArray 1 failed'].
	anArray _ #(2 2 2 2 2 2 ) copy.
	result _ self tstUPcopyCtoSTIntArray: anArray with: 3 with: 1.
	(result = 3 and: [anArray = #(1 2 3 2 2 2)])
		 ifFalse: [self message: 'tstUPcopyCtoSTIntArray 2 failed'].
	anArray _ #(2 2 2 2 2 2 ) copy.
	result _ self tstUPcopyCtoSTIntArray: anArray with: 1 with: 6.
	(result = 1 and: [anArray = #(2 2 2 2 2 1)])
		 ifFalse: [self message: 'tstUPcopyCtoSTIntArray 3 failed'].!

runtstUPcopyCtoSTstring
	| result anArray |
	anArray _ 'bbbbbb' copy.
	result _ self tstUPcopyCtoSTstring: anArray with: 3 with: 4.
	(result = 3 and: [anArray = 'bbbabc'])
		 ifFalse: [self message: 'tstUPcopyCtoSTstring 1 failed'].
	anArray _ 'bbbbbb' copy.
	result _ self tstUPcopyCtoSTstring: anArray with: 3 with: 1.
	(result = 3 and: [anArray = 'abcbbb'])
		 ifFalse: [self message: 'tstUPcopyCtoSTstring 2 failed'].
	anArray _ 'bbbbbb' copy.
	result _ self tstUPcopyCtoSTstring: anArray with: 1 with: 6.
	(result = 1 and: [anArray = 'bbbbba'])
		 ifFalse: [self message: 'tstUPcopyCtoSTstring 3 failed']!

runtstUPcopySTtoCfloatArray
	"Test new runtstUPcopySTtoCfloatArray"
	| result proto |
	proto _ Array with: 1.0 with: 2.0 with: 3.0.
	result _ self tstUPcopySTtoCfloatArray: proto with: 3 with: 4.
	result asArray = #(2.0 2.0 2.0 1.0 2.0 3.0 )
		 ifFalse: [self message: 'tstUPcopySTtoCfloatArray 1 failed'].

	result _ self tstUPcopySTtoCfloatArray: proto with: 3 with: 1.
	result asArray = #(1.0 2.0 3.0 2.0 2.0 2.0 )
		 ifFalse: [self message: 'tstUPcopySTtoCfloatArray 2 failed'].

	result _ self tstUPcopySTtoCfloatArray: proto with: 1 with: 6.
	result asArray = #(2.0 2.0 2.0 2.0 2.0 1.0 )
		 ifFalse: [self message: 'tstUPcopySTtoCfloatArray 3 failed']!

runtstUPcopySTtoCintArray
	| result proto |
	proto _ Array with: 1 with: 2 with: 3.
	result _ self tstUPcopySTtoCintArray: proto with: 3 with: 4.
	result asArray = #(2 2 2 1 2 3 )
		 ifFalse: [self message: 'tstUPcopySTtoCintArray 1 failed'].
	result _ self tstUPcopySTtoCintArray: proto with: 3 with: 1.
	result asArray = #(1 2 3 2 2 2 )
		 ifFalse: [self message: 'tstUPcopySTtoCintArray 2 failed'].
	result _ self tstUPcopySTtoCintArray: proto with: 1 with: 6.
	result asArray = #(2 2 2 2 2 1 )
		 ifFalse: [self message: 'tstUPcopySTtoCintArray 3 failed']!

runtstUPcopySTtoCstring
	| result | 
	result _ self tstUPcopySTtoCstring: 'abc' with: 3 with: 4.
	result = 'bbbabc'
		 ifFalse: [self message: 'tstUPcopySTtoCstring 1 failed'].
	result _ self tstUPcopySTtoCstring: 'abc' with: 3 with: 1.
	result = 'abcbbb'
		 ifFalse: [self message: 'tstUPcopySTtoCstring 2 failed'].
	result _ self tstUPcopySTtoCstring: 'abc' with: 1 with: 6.
	result = 'bbbbba'
		 ifFalse: [self message: 'tstUPcopySTtoCstring 3 failed']!

runtstUPCtoSTbool
	| result |
	result _ self tstUPCtoSTbool.
	result ifFalse: [self message: 'tstUPCtoSTbool failed']!

runtstUPCtoSTchar
	| result |
	result _ self tstUPCtoSTchar.
	result == $c ifFalse: [self message: 'tstUPCtoSTchar  failed']!

runtstUPCtoSTfloat
	| result |
	result _ self tstUPCtoSTfloat.
	result = 3.14 ifFalse: [self message: 'tstUPCtoSTfloat  failed']!

runtstUPCtoSTint
	| result |
	result _ self tstUPCtoSTint.
	result == 42 ifFalse: [self message: 'tstUPCtoSTint  failed']!

runtstUPerrorHandler
	| result |
	result _ self tstUPerrorHandler.
	result ~= 93 ifTrue: [self message: 'tstUPerrorHandler failed']!

runtstUPfloatAt
	| result |
	result _ self tstUPfloatAt: #(1.0 2.0 3.0 ) with: 3.
	result = 3.0
		 ifFalse: [self message: 'tstUPfloatAt: anArray with: anIndex failed']!

runtstUPfloatAtPut
	| result aFloatArray |
	aFloatArray _ Array with: 8.0 with: 16.0 with: 24.0 .
	result _ self tstUPfloatAtPut: aFloatArray with: 2 with: 20.0 .
	(result = 16.0
		 and: [(aFloatArray at: 1) = 8.0
		 and: [(aFloatArray at: 2) = 20.0
		 and: [(aFloatArray at: 3) = 24.0]]])
			ifFalse: [self message: 'tstUPfloatAtPut: aFloatArray with: anIndex failed']!

runtstUPindexVarSize
	| result |
	result _ self tstUPindexVarSize: self.
	result == self size
		 ifFalse: [self message: 'tstUPindexVarSize: anyObjectWithIndexVars failed 0'].
	result _ self tstUPindexVarSize: #(enie meenie meenie moe ).
	result == 4
		 ifFalse: [self message: 'tstUPindexVarSize: anyObjectWithIndexVars failed 1'].
	result _ self tstUPindexVarSize: (Array new: 5000).
	result == 5000
		 ifFalse: [self message: 'tstUPindexVarSize: anyObjectWithIndexVars failed 2']!

runtstUPinstVarAt
	| result anAssoc |
	anAssoc _ Association key: #foo value: #bar.
	result _ self tstUPinstVarAt: anAssoc with: 1.
	result == #foo
		 ifFalse: [self message: 'tstUPinstVarAt: anArray with: anIndex 1 failed'].
	result _ self tstUPinstVarAt: anAssoc with: 2.
	result == #bar
		 ifFalse: [self message: 'tstUPinstVarAt: anArray with: anIndex 2 failed']!

runtstUPinstVarAtPut
	| result anAssoc |
	anAssoc _ Association key: #foo value: #bar.
	result _ self tstUPinstVarAtPut: anAssoc with: 2 with: #foo.
	(result == #bar
		 and: [anAssoc key == #foo
		 and: [anAssoc value == #foo]])
			ifFalse: [self message: 'tstUPinstVarAtPut: anArray with: anIndex failed']!

runtstUPinstVarSize
	| result |
	result _ self tstUPinstVarSize: self.
	result == 0
		 ifFalse: [self message: 'tstUPinstVarSize: anyObjectWithInstVars 1 failed'].
	result _ self tstUPinstVarSize: (Array new: 3).
	result == 0
		 ifFalse: [self message: 'tstUPinstVarSize: anyObjectWithInstVars 2 failed'].
	result _ self tstUPinstVarSize: Association new.
	result == 2
		 ifFalse: [self message: 'tstUPinstVarSize: anyObjectWithInstVars 3 failed']!

runtstUPintegerAtPut
	| result anArray |
	anArray _ Array new: 3.
	result _ self tstUPintegerAtPut: anArray with: 2 with: 8.
	(result = 0 and: [anArray = (Array with: nil with: 8 with: nil)])
		 ifFalse: [self message: 'tstUPintegerAtPut: anArray with: anIndex with: toBePut failed']!

runtstUPisArrayOfFloat
	| result |
	result _ self tstUPisArrayOfFloat: (Array with: 1.0 with: 2.0 with: 3.0).
	result
		 ifFalse: [self message: 'tstUPisArrayOfFloat: anArrayOfFloat failed 1'].
	result _ self tstUPisArrayOfFloat:  (Array with: 1  with: 2  with: 3).
	result
		 ifTrue: [self message: 'tstUPisArrayOfFloat: anArrayOfFloat failed 2'].
	result _ self tstUPisArrayOfFloat: (Array with: 1.0 with: 2.0 with: 3).
	result
		 ifTrue: [self message: 'tstUPisArrayOfFloat: anArrayOfFloat failed 3']!

runtstUPisArrayOfInteger
	| result |
	result _ self tstUPisArrayOfInteger: #(1 2 3 4 5 ).
	result
		 ifFalse: [self message: 'tstUPisArrayOfInteger: anArrayOfInteger 1 failed'].
	result _ self tstUPisArrayOfInteger: #(1 f2 f3 f4 f5 ).
	result
		 ifTrue: [self message: 'tstUPisArrayOfInteger: anArrayOfInteger 2 failed']!

runtstUPisBoolean
	| result |
	result _ self tstUPisBoolean: true.
	result
		 ifFalse: [self message: 'tstUPisBoolean: aBoolean failed 1'].
	result _ self tstUPisBoolean: false.
	result
		 ifFalse: [self message: 'tstUPisBoolean: aBoolean failed 2'].
	result _ self tstUPisBoolean: 7.
	result
		 ifTrue: [self message: 'tstUPisBoolean: aBoolean failed 3']!

runtstUPisByteArray
	| result |
	result _ self tstUPisByteArray:
		 (ByteArray with: 2 with: 3).
	result ifFalse: [self message: 'tstUPisByteArray: aByteArray failed']!

runtstUPisByteLike

	| result |
	result _ self tstUPisByteLike: (ByteArray new: 2).
	result ifFalse: [self message: 'tstUPisByteLike 1 failed'].
	result _ self tstUPisByteLike: (UninterpretedBytes new: 2).
	result ifFalse: [self message: 'tstUPisByteLike 2 failed'].
	result _ self tstUPisByteLike: (Array new: 2).
	result ifTrue: [self message: 'tstUPisByteLike 3 failed']!

runtstUPisCharacter
	| result |
	result _ self tstUPisCharacter: $h.
	result ifFalse: [self message: 'tstUPisCharacter: aCharacter failed']!

runtstUPisFloat
	| result |
	result _ self tstUPisFloat: 3.14.
	result
		 ifFalse: [self message: 'tstUPisFloat: aFloat failed 1'].
	result _ self tstUPisFloat: 3.
	result
		 ifTrue: [self message: 'tstUPisFloat: aFloat failed 2']!

runtstUPisInteger
	| result |
	result _ self tstUPisInteger: 2.
	result ifFalse: [self message: 'tstUPisInteger: aInteger failed']!

runtstUPisString
	| result |
	result _ self tstUPisString: 'aString'.
	result ifFalse: [self message: 'tstUPisString: aString failed']!

runtstUPnil
	| result |
	result _ self tstUPnil.
	result == nil ifFalse: [self message: 'tstUPnil  failed']!

runtstUPreturnFalse
	| result |
	result _ self tstUPreturnFalse.
	result ifTrue: [self message: 'tstUPreturnFalse  failed']!

runtstUPreturnHandle
	| result |
	result _ self tstUPreturnHandle: self.
	result == self ifFalse: [self message: 'tstUPreturnHandle  failed']!

runtstUPreturnNil
	| result |
	result _ self tstUPreturnNil.
	result == nil ifFalse: [self message: 'tstUPreturnNil  failed']!

runtstUPreturnTrue
	| result |
	result _ self tstUPreturnTrue.
	result ifFalse: [self message: 'tstUPreturnTrue  failed']!

runtstUPSTtoCchar
	| result |
	result _ self tstUPSTtoCchar: $h.
	result == $h ifFalse: [self message: 'tstUPSTtoCchar: aChar failed']!

runtstUPSTtoCfloat
	| result |
	result _ self tstUPSTtoCfloat: 3.14.
	result = 3.14 ifFalse: [self message: 'tstUPSTtoCfloat: aFloat failed']!

runtstUPSTtoCint
	| result |
	result _ self tstUPSTtoCint: 2.
	result == 2 ifFalse: [self message: 'tstUPSTtoCint: aInt failed']! !

!UserPrimitiveTests methodsFor: 'test primitives'!

tstUP32Arguments: a01 a02: a02 a03: a03 a04: a04 a05: a05 a06: a06 a07: a07 a08: a08 a09: a09 a10: a10 a11: a11 a12: a12 a13: a13 a14: a14 a15: a15 a16: a16 a17: a17 a18: a18 a19: a19 a20: a20 a21: a21 a22: a22 a23: a23 a24: a24 a25: a25 a26: a26 a27: a27 a28: a28 a29: a29 a30: a30 a31: a31 a32: a32
	<primitive: 10052>
	^nil!

tstUPassert: aBoolean
	<primitive: 10029>
	^nil!

tstUPbasicAt: anArray with: anIndex
	<primitive: 10016>
	^self reportError!

tstUPbasicAtPut: anArray with: anIndex with: toBePut
	<primitive: 10017>
	^self reportError!

tstUPbyteAt: anArray with: anIndex
	<primitive: 10018>
	^self reportError!

tstUPbyteAtPut: anArray with: anIndex with: toBePut
	<primitive: 10019>
	^self reportError!

tstUPcopyCtoSTbytes: anArray with: aCount with: aStartIndex 
	<primitive: 10021>
	^self reportError!

tstUPcopyCtoSTfloatArray: anArray with: aCount with: aStartIndex 
	<primitive: 10022>
	^self reportError!

tstUPcopyCtoSTIntArray: anArray with: aCount with: aStartIndex 
	<primitive: 10020>
	^self reportError!

tstUPcopyCtoSTstring: anArray with: aCount with: aStartIndex 
	<primitive: 10023>
	^self reportError!

tstUPcopySTtoCbytes: anArray with: aCount with: aStartIndex 
	<primitive: 10024>
	^self reportError!

tstUPcopySTtoCfloatArray: anArray with: aCount with: aStartIndex 
	<primitive: 10025>
	^self reportError!

tstUPcopySTtoCintArray: anArray with: aCount with: aStartIndex 
	<primitive: 10026>
	^self reportError!

tstUPcopySTtoCstring: anArray with: aCount with: aStartIndex 
	<primitive: 10027>
	^self reportError!

tstUPCtoSTbool 
	<primitive: 10001>
	^self reportError!

tstUPCtoSTchar 
	<primitive: 10002>
	^self reportError!

tstUPCtoSTfloat 
	<primitive: 10003>
	^self reportError!

tstUPCtoSTint 
	<primitive: 10004>
	^self reportError!

tstUPerrorHandler
	<primitive: 10050>
	^nil!

tstUPfloatAt: anArray with: anIndex
	<primitive: 10030>
	^self reportError!

tstUPfloatAtPut: anArray with: anIndex
	<primitive: 10031>
	^self reportError!

tstUPfloatAtPut: anArray with: anIndex with: aFloat
	<primitive: 10031>
	^self reportError!

tstUPindexVarSize: anyObjectWithIndexVars
	<primitive: 10032>
	^self reportError!

tstUPinstVarAt: anArray with: anIndex
	<primitive: 10033>
	^self reportError!

tstUPinstVarAtPut: anArray with: anIndex with: toBePut
	<primitive: 10034>
	^self reportError!

tstUPinstVarSize: anyObjectWithInstVars
	<primitive: 10035>
	^self reportError!

tstUPintegerAtPut: anArray with: anIndex with: toBePut
	<primitive: 10036>
	^self reportError!

tstUPisArrayOfFloat: anArrayOfFloat
	<primitive: 10037>
	^self reportError!

tstUPisArrayOfInteger: anArrayOfInteger
	<primitive: 10038>
	^self reportError!

tstUPisBoolean: aBoolean
	<primitive: 10039>
	^self reportError!

tstUPisByteArray: aByteArray
	<primitive: 10040>
	^self reportError!

tstUPisByteLike: obj
	<primitive: 10051>
	^self reportError!

tstUPisCharacter: aCharacter
	<primitive: 10041>
	^self reportError!

tstUPisFloat: aFloat
	<primitive: 10042>
	^self reportError!

tstUPisInteger: aInteger
	<primitive: 10043>
	^self reportError!

tstUPisString: aString
	<primitive: 10044>
	^self reportError!

tstUPnil 
	<primitive: 10045>
	^self reportError!

tstUPreturnFalse 
	<primitive: 10046>
	^self reportError!

tstUPreturnHandle: aHandle
	<primitive: 10047>
	^self reportError!

tstUPreturnNil 
	<primitive: 10048>
	^self reportError!

tstUPreturnTrue 
	<primitive: 10049>
	^self reportError!

tstUPSTtoCchar: aChar
	<primitive: 10006>
	^self reportError!

tstUPSTtoCfloat: aFloat
	<primitive: 10007>
	^self reportError!

tstUPSTtoCint: aInt
	<primitive: 10008>
	^self reportError! !

!UserPrimitiveTests methodsFor: 'private'!

message: aString
	Transcript show: ' -- ', aString.
	^self error: aString printString!

reportError
	^self error: 'User-defined primitive error -- ', self failString! !
