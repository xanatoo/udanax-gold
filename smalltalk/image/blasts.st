'From Objectworks for Smalltalk-80(tm), Version 2.5 of 29 July 1989 on 15 April 1992 at 7:41:32 pm'!



!Heaper class methodsFor: 'global: blasts'!

BLAST: problem {Symbol}
	(self signal: problem) raise!

PROBLEM: exception

	^exception signal!

problems.AllBlasts
	"A ProblemList for all X++ BLASTs"
	
	XppBlast == nil ifTrue:
			[XppBlast := Signal new nameClass: 'BLAST' message: #All; notifierString: 'BLAST(!!!!)'].
	^XppBlast!

{Signal} signal: signal {Symbol}
	"Define a blast and return a unique and persistent signal for it."
	
	AllBlasts!

{Signal} signals: signals {Array of: Symbol}
	"Define a set of blasts blast and return a SignalCollection."
	
	| result |
	signals size = 1 ifTrue:
		[^self signal: signals first].
	result := SignalCollection new.
	signals do: [ :each |
		result add: (self signal: each)].
	^result! !