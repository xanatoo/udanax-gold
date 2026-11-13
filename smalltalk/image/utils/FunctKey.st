'From Smalltalk-80, Version 2.2 of July 4, 1987 on 9 July 1987 at 11:27:15 am'!

!ParagraphEditor methodsFor: 'editing'!

indentedCR: characterStream key: aChar
	"Replace the current text selection with a CR plus 
	the number of tabs and spaces found at the beginning of 
	the current line"

	| text index character whiteString |

	"Construct text, which is the body of text up to the current position."
	text _ (paragraph text copyFrom: 1 to: startBlock stringIndex - 1)
				, characterStream contents asText.

	"Sniff backwards along text string till CR or beginning of string."
	index _ text size + 1.
	character _ nil.
	[character = CR or: [index = 1]]
		whileFalse: 
			[index _ index - 1.
			character _ text at: index].

	"Special exit for immediate encounter of CR or string beginning."
	(text size = index) | ( text size = 0)
		ifTrue: 
			[characterStream nextPut: CR.
			^false"keep scanning"].

	"Now accunmulate whitespace into whiteString till first non-white  
	character, or end of string."
	whiteString _ String with: CR.
	character == CR ifTrue: [index _ index + 1].
	character _ text at: index.
	[character = Tab | (character = Space) & (index <= text size)]
		whileTrue: 
			[whiteString _ whiteString , (String with: character).
			index _ index + 1.
			index <= text size ifTrue: [character _ text at: index]].
	characterStream nextPutAll: whiteString.
	^false "keep scanning"! !


ParagraphEditor dispatchTable
	at: 169 + 1  "L10 key"
	put: #indentedCR:key:!
