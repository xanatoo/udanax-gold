!TextController methodsFor: 'menu messages'!

localMenuItem: selector
	^ #(cut paste copySelection again undo cancel accept changeTextStyle changeFont hardcopy) includes: selector! !

!HierarchicalFileList methodsFor: 'text'!

textMenu 
	isDirectory ifFalse: [^super textMenu].
	fileName == nil ifTrue: [^ nil].
	^ActionMenu
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) (spawn) (hardcopy) (style font))
			selectors: #(again undo copySelection cut paste doIt printIt inspectIt  spawnFile:from: hardcopy changeTextStyle changeFont)! !

!Browser methodsFor: 'text'!

textMenu
	"Browser flushMenus"
	TextMenu == nil ifTrue:
		[TextMenu _ ActionMenu
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) (accept cancel) (format spawn explain) (hardcopy) (style font))
			selectors: #(again undo copySelection cut paste doIt printIt inspectIt accept cancel format spawnEdits:from: explain  hardcopy changeTextStyle changeFont)].
	^ TextMenu! !

!SyntaxError methodsFor: 'text'!

textMenu
	"SyntaxError flushMenus"
	TextMenu == nil ifTrue:
		[TextMenu _ ActionMenu
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) (accept cancel) (proceed) (hardcopy) (style font))
			selectors: #(again undo copySelection cut paste doIt printIt inspectIt accept cancel proceed hardcopy changeTextStyle changeFont)].
	^ TextMenu! !

!FileModel methodsFor: 'text'!

textMenu 
	"FileModel flushMenus"
	fileName == nil ifTrue: [^ nil].
	TextMenu == nil ifTrue:
		[TextMenu _ ActionMenu
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) ('file it in') (put get) (spawn) (hardcopy) (style font))
			selectors: #(again undo copySelection cut paste doIt printIt inspectIt fileItIn:from: accept getNew:from: spawnFile:from: hardcopy changeTextStyle changeFont)].
	^ TextMenu! !

!Inspector methodsFor: 'text'!

textMenu
	"Inspector flushMenus"
	TextMenu == nil ifTrue:
		[TextMenu _ ActionMenu
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) (accept cancel) (hardcopy) (style font))
			selectors: #(again undo copySelection cut paste doIt printIt inspectIt accept cancel hardcopy changeTextStyle changeFont)].
	^ TextMenu! !

!StringHolderController class methodsFor: 'class initialization'!

initialize
	"Initialize the yellow button pop-up menu and corresponding messages."
	"StringHolderController initialize"

	CodeYellowButtonMenu _ 
		PopUpMenu 
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) (accept cancel) (hardcopy) (style font)).
	CodeYellowButtonMessages _ 
		#(again undo copySelection cut paste doIt printIt inspectIt accept cancel hardcopy changeTextStyle changeFont)! !

!FillInTheBlankController methodsFor: 'private'!

initializeYellowButtonMenu
	self 
		yellowButtonMenu:
			(PopUpMenu	labelList: #((again undo) (copy cut paste) (accept cancel) (style font)))
		yellowButtonMessages:
			#(again undo copySelection cut paste accept cancel hardcopy changeTextStyle changeFont)! !

!ProjectController class methodsFor: 'class initialization'!

initialize
	"Initialize the menu for the yellow mouse button."
	"ProjectController initialize"

	ProjectYellowButtonMenu _ 
		PopUpMenu
			labelList: #((again undo) (copy cut paste) ('do it' 'print it' inspect) (accept cancel) (enter) (hardcopy) (style font)).
	ProjectYellowButtonMessages _ 
			#(again undo copySelection cut paste doit printIt inspectIt accept cancel enter hardcopy changeTextStyle changeFont)! !

Browser flushMenus!

SyntaxError flushMenus!

FileModel flushMenus!

Inspector flushMenus!

ProjectController initialize!

ProjectController allInstances do: [:c | c initializeYellowButtonMenu]!

StringHolderController initialize!

StringHolderController allInstances do: [:c | c initializeYellowButtonMenu]!

TextCollectorController allInstances do: [:c | c initializeYellowButtonMenu]!


