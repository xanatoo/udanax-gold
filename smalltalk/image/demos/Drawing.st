'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!

!Form class methodsFor: 'examples'!

toothpaste
	"Form toothpaste"
	"Draw spheres ala Ken Knowlton, Computer Graphics, v15 n4 p352. 
	Draws while red is held, terminated by yellow."
	
	| facade outliner filter point queue cursorPoint |
	facade _ Form
		extent: 20@20
		fromArray: #( 65471 61440 63191 61440 64699 61440 57453 61440 55307
			28672 61463 61440 53285 28672 47123 61440 54493 61440 65191 28672
			53981 61440 48983 61440 62847 61440 65517 61440 61151 61440 65407
			61440 65535 61440 65535 61440 65535 61440 65535 61440)
		offset: -10@-10.
	outliner _ Form dotOfSize: facade extent x + 4.
	queue _ SharedQueue new: 32.
	16 timesRepeat: [queue nextPut: 0@0].
	Cursor normal show.
	filter _ Sensor cursorPoint.
	[Sensor yellowButtonPressed] whileFalse:
		[cursorPoint _ Sensor cursorPoint.
		filter _ filter * 0.8
						"slower but cleaner: + (Sensor cursorPoint * 0.2)"
					+ (cursorPoint x asFloat * 0.2 @ (cursorPoint y asFloat * 0.2)).
		point _ Sensor redButtonPressed
				"slower but cleaner: ifTrue: [filter] ifFalse: [0@0]."
			ifTrue: [filter x truncated @ filter y truncated] ifFalse: [0@0].
		outliner displayOn: Display at: point rule: Form under.
		facade displayOn: Display at: queue next rule: Form and.
		queue nextPut: point]! !