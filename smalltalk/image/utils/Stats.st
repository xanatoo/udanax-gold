'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!

Stream subclass: #ProbabilityDistribution
	instanceVariableNames: ''
	classVariableNames: 'U '
	poolDictionaries: ''
	category: 'Statistics'!
ProbabilityDistribution comment:
'Initialization of the class is needed.  Use

	ProbabilityDistribution initialize'!


!ProbabilityDistribution methodsFor: 'random sampling'!

atEnd
	^false!

next
	"This is a general random number generation method for any probability law;  use the (0,1) uniformly distributed random varible U as the value of the law's distribution function.  Obtain the next random value and then solve for the inverse.  The inverse solution is defined by the subclass."

	^self inverseDistribution: U next! !

!ProbabilityDistribution methodsFor: 'probability functions'!

density: x

	self subclassResponsibility!

distribution: aCollection

	self subclassResponsibility! !

!ProbabilityDistribution methodsFor: 'private'!

computeSample: m outOf: n

	m>n ifTrue: [^0.0].
	^n factorial / (n-m) factorial!

inverseDistribution: x
	self subclassResponsibility! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ProbabilityDistribution class
	instanceVariableNames: ''!


!ProbabilityDistribution class methodsFor: 'instance creation'!

new
	
	^self basicNew! !

!ProbabilityDistribution class methodsFor: 'class initialization'!

initialize
	"Uniformly distributed random numbers in the range [o,1]."

	U _ Random new! !

ProbabilityDistribution initialize!


ProbabilityDistribution subclass: #ContinuousProbability
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!


!ContinuousProbability methodsFor: 'probability functions'!

distribution: aCollection
	"This is a slow and dirty trapezoidal integration to determine the area under the probability function curve y=density (x) for x in the specified collection.  The method assumes that the collection contains numerically-ordered elements."

	| t aStream x1 x2 y1 y2 |
	t _ 0.0.
	aStream _ ReadStream on: aCollection.
	x2 _ aStream next.
	y2 _ self density: x2.
	[x1 _ x2.  x2 _ aStream next]
		whileTrue: 
			[y1 _ y2.
		 	 y2 _ self density: x2.
			 t _ t + ((x2-x1)*(y2+y1))].
	^t*0.5! !

ContinuousProbability subclass: #Exponential
	instanceVariableNames: 'mu '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!


!Exponential methodsFor: 'accessing'!

mean
	^1.0/mu!

variance
	^1.0/(mu*mu)! !

!Exponential methodsFor: 'probability functions'!

density: x
	x > 0.0
		ifTrue: [^mu * (mu*x) negated exp]
		ifFalse: [^0.0]!

distribution: anInterval
	anInterval last <= 0.0
		ifTrue: [^0.0]
		ifFalse: [^1.0 - (mu * anInterval last) negated exp - (anInterval first > 0.0 ifTrue: [self distribution: (0.0 to: anInterval first)] ifFalse: [0.0])]! !

!Exponential methodsFor: 'private'!

inverseDistribution: x
	^ x ln negated / mu!

setParameter: p
	mu _ p! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Exponential class
	instanceVariableNames: ''!


!Exponential class methodsFor: 'instance creation'!

mean: p
	^self parameter: 1.0/p!

parameter:  p
	
	p > 0.0
		ifTrue: [^self new setParameter: p]
		ifFalse: [self error: 'The probability parameter must be greater than 0.0']! !

Exponential subclass: #Gamma
	instanceVariableNames: 'N '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!


!Gamma methodsFor: 'accessing'!

mean
	^super mean*N!

variance
	^super variance*N! !

!Gamma methodsFor: 'probability functions'!

density: x
	| t |
	x > 0.0
		ifTrue: [t _ mu * x.
			^(mu raisedTo: N) / (self gamma: N) *(x raisedTo: N-1) * t negated exp]
		ifFalse: [^0.0]! !

!Gamma methodsFor: 'private'!

gamma: n
	| t |
	t _ n - 1.0.
	^self computeSample: t outOf: t!

setEvents: events
	N _ events! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Gamma class
	instanceVariableNames: ''!


!Gamma class methodsFor: 'instance creation'!

events: k mean: p

	|  events |
	events _ k truncated.
	events > 0
		ifTrue: [^(self parameter: events/p) setEvents: events]
		ifFalse: [self error: 'the number of events must be greater than 0']! !

ContinuousProbability subclass: #Normal
	instanceVariableNames: 'mu sigma '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!
Normal comment:
'How long before a success occurs or how many events occur in a certain time interval?'!


!Normal methodsFor: 'accessing'!

mean
	^mu!

variance
	^sigma squared! !

!Normal methodsFor: 'random sampling'!

next
	| v1 v2 s rand u |
	rand _ Uniform from: -1.0 to: 1.0.
	[v1 _ rand next.
	 v2 _ rand next.
	 s _ v1 squared + v2 squared.
	 s >= 1] whileTrue.
	u _ (-2.0 * s ln /s) sqrt.
	^mu + (sigma * v1 *u)! !

!Normal methodsFor: 'probability functions'!

density: x

	| twoPi t |
	twoPi _ 2 * 3.1415926536.
	t _ x - mu/sigma.
	^(-0.5 * t squared) exp / (sigma * twoPi sqrt)! !

!Normal methodsFor: 'private'!

setMean: m standardDeviation: s
	mu _ m.
	sigma _ s! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Normal class
	instanceVariableNames: ''!


!Normal class methodsFor: 'instance creation'!

mean: a deviation: b
	b > 0.0
	ifTrue: [^self new setMean: a standardDeviation: b]
	ifFalse: [self error: 'standard deviation must be greater than 0.0']! !

ContinuousProbability subclass: #Uniform
	instanceVariableNames: 'startNumber stopNumber '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!


!Uniform methodsFor: 'accessing'!

mean
	^ (startNumber + stopNumber)/2!

variance
	^ (stopNumber - stopNumber) squared / 12! !

!Uniform methodsFor: 'probability functions'!

density: x 
	(x between: startNumber and: stopNumber)
		ifTrue: [^1.0 / (stopNumber - startNumber)]
		ifFalse: [^0]! !

!Uniform methodsFor: 'private'!

inverseDistribution: x
	"x is a random  number between 0 and 1"
	^startNumber + (x * (stopNumber - startNumber))!

setStart: begin toEnd: end
	startNumber _ begin.
	stopNumber _ end! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Uniform class
	instanceVariableNames: ''!


!Uniform class methodsFor: 'instance creation'!

from: begin to: end 
	begin > end
		ifTrue: [self error: 'illegal interval']
		ifFalse: [^self new setStart: begin toEnd: end]! !

ProbabilityDistribution subclass: #DiscreteProbability
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!


!DiscreteProbability methodsFor: 'probability functions'!

distribution: aCollection
	"Answer the sum of the discrete values of the density function for each element in the collection."

	| t |
	t _ 0.0.
	aCollection do: [:i | t _ t + (self density: i)].
	^t! !

DiscreteProbability subclass: #Bernoulli
	instanceVariableNames: 'prob '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!
Bernoulli comment:
'Does an event occur?

density function answers the probability of occurrence of one of two events'!


!Bernoulli methodsFor: 'accessing'!

mean
	^prob!

variance
	^prob * (1.0 - prob)! !

!Bernoulli methodsFor: 'probability functions'!

density: x

	x=1 ifTrue: [^prob].
	x=0 ifTrue: [^1.0-prob].
	self error: ' outcomes of a Bernoulli can only be 1 or 0'! !

!Bernoulli methodsFor: 'private'!

inverseDistribution: x

	x <= prob
		ifTrue: [^1]
		ifFalse: [^0]!

setParameter: aNumber
	prob _aNumber! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Bernoulli class
	instanceVariableNames: ''!


!Bernoulli class methodsFor: 'instance creation'!

parameter: aNumber
	(aNumber between: 0.0 and: 1.0)
		ifTrue: [^self new setParameter: aNumber]
		ifFalse: [^self error: 'The probability must be between 0.0 and 1.0']! !

!Bernoulli class methodsFor: 'Examples'!

Cardgame

	"is the first draw of a card an ace?"
	(Bernoulli parameter: 4/52) next

	"does a car arrive in the next second?"

	"will a machine break down today?"! !

Bernoulli subclass: #Binomial
	instanceVariableNames: 'N '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!
Binomial comment:
'how many successes occurred in N trials?

density funciton answers what is the probability that x successes will occur in the next N trials?

i.e., N repeated Bernoulli trials'!


!Binomial methodsFor: 'random sampling'!

next
	
	|t|
	t _ 0.
	N timesRepeat: [t _ t + super next].
	^t! !

!Binomial methodsFor: 'probability functions'!

density: x

	(x between: 0 and: N)
		ifTrue: [^((self computeSample: x outOf: N) / (self computeSample: x outOf: x)) * (prob raisedTo: x)*((1.0 - prob) raisedTo: N-x)]
		ifFalse: [^0.0]! !

!Binomial methodsFor: 'private'!

events: n mean: m

	N _ n truncated.
	self setParameter: m/N! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Binomial class
	instanceVariableNames: ''!


!Binomial class methodsFor: 'instance creation'!

events: n mean: m

	n truncated <= 0 ifTrue: [self error: 'number of events must be > 0'].
	^self new events: n mean: m! !

!Binomial class methodsFor: 'Examples'!

FlippingCoins

	| sampleA sampleB |
	sampleA _ Bernoulli parameter: 0.5.

	"Did I get heads?"
	sampleA next.

	sampleB _ Binomial events: 5 mean: 2.5.
	
	"How many heads did I get in 5 trials?"
	sampleB next! !

Bernoulli subclass: #Geometric
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!
Geometric comment:
'How many repeated, independent Bernoulli trials are needed before the first success is obtained?

e.g., how many seconds before the next car arrives (as versus how many cars arrive in the next 20 sec as in a binomial question)'!


!Geometric methodsFor: 'accessing'!

mean
	^ 1.0 / prob!

variance
	^ (1.0 - prob) / prob squared! !

!Geometric methodsFor: 'probability functions'!

density: x

	x>0 ifTrue: [^prob * ((1.0 - prob) raisedTo: x-1)]
		ifFalse: [^0.0]! !

!Geometric methodsFor: 'private'!

inverseDistribution: x

	^(x ln / (1.0 - prob) ln) ceiling! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Geometric class
	instanceVariableNames: ''!


!Geometric class methodsFor: 'instance creation'!

mean: m

	^self parameter: m! !

!Geometric class methodsFor: 'Examples'!

CarsArriving

	| sample |
	
	"two cars arrive every minute"
	sample _ Geometric mean: 60/2.

	"what is the probability that it will take 30 sec before the next car arrives?"
	sample density: 30.

	"Did the next car arrive in 30 to 40 seconds?"
	sample distribution: (30 to: 40)! !

DiscreteProbability subclass: #Poisson
	instanceVariableNames: 'mu '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!
Poisson comment:
'how many events occur in a unit time?
	used for sampling potential demands by customers for service

	The Poisson is typically the rate at which the service is provided.

	density function determines the probability that, in a unit interval, x events will occur.
'!


!Poisson methodsFor: 'accessing'!

mean
	^mu!

variance
	^mu! !

!Poisson methodsFor: 'random sampling'!

next
	| p n q |
	p _ mu negated exp.
	n _ 0.
	q _ 1.0.
	[q _ q * U next.
	 q >= p]
		whileTrue: [n _ n + 1].
	^n! !

!Poisson methodsFor: 'probability functions'!

density: x

	x >= 0
		ifTrue: [^ ((mu raisedTo: x) * (mu negated exp)) / x factorial]
		ifFalse: [^0.0]! !

!Poisson methodsFor: 'private'!

setMean: p
	mu _ p! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Poisson class
	instanceVariableNames: ''!


!Poisson class methodsFor: 'instance creation'!

mean: p

	p > 0.0
		ifTrue: [^self new setMean: p]
		ifFalse: [self error: 'mean must be greater than 0.0']! !

DiscreteProbability subclass: #SampleSpace
	instanceVariableNames: 'data '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Statistics'!


!SampleSpace methodsFor: 'probability functions'!

density: x
	"x must be in the sample space;  the probability must sum over all occurrences of x in the sample space."

	(data includes: x)
		ifTrue: [^(data occurrencesOf: x) / data size]
		ifFalse: [^0]! !

!SampleSpace methodsFor: 'private'!

inverseDistribution: x
	
	^data at: (x*data size) truncated + 1!

setData: aCollection
	
	data _ aCollection! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SampleSpace class
	instanceVariableNames: ''!


!SampleSpace class methodsFor: 'instance creation'!

data: aCollection
	
	^self new setData: aCollection! !

!SampleSpace class methodsFor: 'Examples'!

heights

	| heights |
	heights _ SampleSpace data: #(60 60 60 62 62 64 64 64 64 66 66 66 68 68 68 68 68 70 70 70).
	
	"what is the probability of randomly selecting a student with height 64?"
	heights density: 64.

	"what is the probability of randomly selecting a student whose height is between 60 and 64?"
	heights distribution: (60 to: 64 by: 2)! !