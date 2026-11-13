Object subclass: #PageStyle
	instanceVariableNames: 'pageSize tabStops margins '
	classVariableNames: 'DefaultMargins DefaultPageSize DefaultTabStops '
	poolDictionaries: ''
	category: 'System-Printing'!
PageStyle comment:
'Holds style information for both documents and paragraphs.  Each time the style changes, a copy gets dumped into the Document.

Instance Variables:
	pageSize					<Point>						The x and y size of the current page.
	currentStyle				<Symbol>					The name of the currently abstract style.
	defaultInfo					<Dictionary>				Describing default paragraph style.
	tabStops					<Array>						Defines tab stops across the width of the page.

Class Variables:

	DefaultDefaultInfo			<Dictionary>
	DefaultPageSize			<Point>
	DefaultTabStops			<Array>
'!


!PageStyle methodsFor: 'initialization'!

initialize
	"Set up an initial default document style."

	pageSize _ DefaultPageSize deepCopy.
	tabStops _ DefaultTabStops deepCopy.
	margins _ DefaultMargins deepCopy! !

!PageStyle methodsFor: 'accessing'!

margins
	"Return the current page margins."

	^margins!

margins: m 
	"Set the current margins."

	margins _ m!

pageHeight
	"Return the current height of the page."

	^pageSize y!

pageSize
	"Return the current size of the page."

	^pageSize!

pageSize: p 
	"Set the current size of the page."

	pageSize _ p!

pageWidth
	"Return the current height of the page."

	^pageSize x!

tabStops
	"Return the current tabstops."

	^tabStops!

tabStops: array 
	"Set the current tab stops to the given array."

	tabStops _ array! !

!PageStyle methodsFor: 'margins'!

bottomMargin
	"Return the value of the bottom margin."

	^self margins at: 2!

bottomMargin: inches 
	"Set the value of the bottom margin."

	self margins at: 2 put: inches!

height
	^self pageHeight - (self topMargin + self bottomMargin)!

leftMargin
	"Return the value of the left margin."

	^self margins at: 3!

leftMargin: inches 
	"Set the value of the left margin."

	self margins at: 3 put: inches!

printingHeight
	"Return the height of the printing area of the page."

	^self pageHeight - (self topMargin + self bottomMargin)!

printingWidth
	"Return the width of the printing area of the page."

	^self pageWidth - (self leftMargin + self rightMargin)!

rightMargin
	"Set the value of the right margin."

	^self margins at: 4!

rightMargin: inches 
	"Set the value of the right margin."

	self margins at: 4 put: inches!

topMargin
	"Return the value of the top margin."

	^self margins at: 1!

topMargin: inches 
	"Set the value of the top margin."

	self margins at: 1 put: inches!

width
	^self pageWidth - (self leftMargin + self rightMargin)! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

PageStyle class
	instanceVariableNames: ''!
PageStyle class comment:
'Select the browser switch "instance" to see the comment'!


!PageStyle class methodsFor: 'instance creation'!

default
	"Return a new defaulted document style."

	^self new!

new
	"Initialize."

	^super new initialize! !

!PageStyle class methodsFor: 'class initialization'!

initialize
	"Set up the details of the default margins,  page size,  and tabs."

	DefaultPageSize _ 8.5 @ 11.0.
	DefaultMargins _ #(1 1 1 1).

	DefaultTabStops _ Array new: 34.
	1 to: DefaultTabStops size do: [:i | DefaultTabStops at: i put: i * 0.25].! !

PageStyle initialize!


Object subclass: #PostScriptPrinter
	instanceVariableNames: 'document currentFontStyle currentFont currentSize currentCharWidths leftArrowWidth leftArrowOffsetY upArrowWidth currentTabWidths currentLineWidth currentWords chunks underlining pageHeight pageWidth leftMargin rightMargin topMargin bottomMargin currentY leading file PrinterResolution orientation '
	classVariableNames: 'Adjustment BreakScanner BreakScannerStops CharWidthTable KPointsPerInch TempFileName '
	poolDictionaries: ''
	category: 'System-Printing'!
PostScriptPrinter comment:
'Renders abstract document to PostScript.

Instance Variables:
	document				<Document>				The document being printed (an abstract representation of a document).
	currentFontStyle			<DocumentStyle>		The current (abstract) style driving printing.
	currentFont				<FontDescription>		The active font.
	currentSize				<Number>				The point size of current font.
	currentCharWidths		<Array>					Character widths of current font at current size.
	leftArrowWidth  		<Number>				Width of the left arrow (underscore) character in the current font
	leftArrowOffsetY		<Number>				Y offset of left arrow
	upArrowWidth    		<Number>				Width of the up arrow (caret) character in the current font
	currentTabWidths		<Collection of Integer>	Collection of tab stops
	currentLineWidth		<Number>				Width of the text as it is rendered (broken into words and lines) across the page.
	currentWords			<String>				Words being accumulated during line breaking.
	chunks					<OrderedCollection>		Built during line breaking: words and font change info.
	underlining				<Boolean>				Toggles state of underlining of text.
	pageHeight				<Number>				Height of current page in points.
	pageWidth				<Number>				Width of current page in points.
	leftMargin				<Number>				Left margin in inches.
	rightMargin				<Number>				Right margin in inches.
	topMargin				<Number>				Top margin in inches.
	bottomMargin			<Number>				Bottom margin in inches.
	currentY				<Number>				Current y-axis value, with (0,0) at the lower left corner of page.
	leading					<Number>				Leading amount between paragraphs and/or forms.
	file						<ExternalWriteStream>		File which holds the PostScript output.
	PrinterResolution		<Number> 	Printer resolution in pixels per point.
	orientation			<Symbol>	Defines orientation of page, either #portrait or #landscape

Class Variables:
	Adjustment				<Number>				Scale factor of the coordinate system.
	BreakScanner 			<CharacterScanner>	Scanner used for fast line breaking.
	BreakScannerStops 	<Collection of Symbol>	Table of stop conditions for break scanner.
	CharWidthTable 		<IdentityDictionary>	Cache of width tables from used fonts.
	KPointsPerInch 			<Number>				Scale factor of points per inch.
	TempFileName			<String>				Name of temporary output file.
'!


!PostScriptPrinter methodsFor: 'initialize-release'!

close
	"Do any needed shutdowns."

	document _ nil!

drive
	"Take the list of 'entities' and transform them into a stream of  
	Postscript code."

	document render: [:entity | self perform: entity key with: entity value]!

initialize
	"Set up to begin to render to a Postscript file."

	currentLineWidth _ 0.
	currentWords _ WriteStream on: (String new: 255).
	topMargin _ bottomMargin _ leftMargin _ rightMargin _ 0.
	leading _ 16 * Adjustment.
	chunks _ OrderedCollection new: 10.
	underlining _ false.
	orientation _ #portrait.
	self setPrinterResolutionToApple!

printer: aString print: aDocument onFileNamed: fileName
	"Send the named document to the named printer."

	document _ aDocument.
	file _ fileName asFilename writeStream.
	self drive!

setPrinterResolution: PixelsPerPoint 
	"Set an instance variable which speciffies the resolution of the output 
	printer for imaging tasks which need to know this."

	PrinterResolution _ PixelsPerPoint!

setPrinterResolutionToApple
	"Set an instance variable which specifies the resolution in pixels per 
	point of the output printer for imaging tasks which need to know
	this to that of the Apple LaserWriter."

	self setPrinterResolution: 300 / 72! !

!PostScriptPrinter methodsFor: 'rendering'!

doFooter: values 
	"Set the page footer."

	| str |
	str _ WriteStream on: (String new: 255).
	(values at: 1)
		= false
		ifTrue: [chunks add: (Array with: #misc with: '/doFooter false def
')]
		ifFalse: 
			[chunks add: (Array with: #misc with: '/doFooter true def
').
			str nextPutAll: '/footerString ('.
			str nextPutAll: (values at: 2).
			str nextPutAll: ') def'; cr.
			chunks add: (Array with: #misc with: str contents).
			(values at: 3)
				= true
				ifTrue: [chunks add: (Array with: #misc with: '/doPageNumbers true def
')]
				ifFalse: [chunks add: (Array with: #misc with: '/doPageNumbers false def
')]]!

end: aNil 
	"Put out a termination for the PostScript document,  doing any      
	needed cleanup."
	self outputChunks.
	file nextPutAll: '
newPage
end
state restore
'.
	file close.
	Cursor wait showWhile: [self class sendToPrinter]!

fontStyle: aFontStyle 
	"Set various style entities from a passed style packet."

	| newSize newFace newFont |
	self flushBuffer.
	newSize _ aFontStyle currentSize.
	newFace _ aFontStyle currentFace.
	newFont _ self
				mapFamily: aFontStyle currentFamily
				size: newSize
				face: newFace.
	(currentFont == nil or: [currentFont fullName ~= (newFont at: 1) or: [newSize ~= currentSize]])
		ifTrue: [self changeFont: newFont].
	currentFontStyle _ aFontStyle.!

image: aForm 
	"Print the form,  in a device independent way,  as closely to the 
	screen size as possible."

	| newWidth newY |
	self outputChunks.
	self deltaY: leading.
	newY _ currentY - (aForm height * Adjustment).
	newY < bottomMargin
		ifTrue: 
			[self newPage.
			newY _ currentY - (aForm height * Adjustment)].
	newWidth _ aForm width + 15 truncateTo: 16.
	file nextPutAll: ' /pix '.
	newWidth / 8 printOn: file.
	file nextPutAll: ' string def'; cr.
	self gsave.
	self translate: leftMargin @ newY.
	self gsave.
	self clipBox: aForm height width: aForm width.
	self scale: newWidth @ aForm height.
	self
		imageWidth: newWidth
		height: aForm height
		bits: aForm bits.
	self grestore.
	self box: aForm height width: aForm width.
	self grestore.
	self moveto: leftMargin @ (currentY _ newY)!

imageOneToN: aFormandScale 
	"Print the form,  scaled one pixel in the form to n pixels on the printer."

	| newWidth newY aForm scale |
	aForm _ aFormandScale at: 1.
	scale _ aFormandScale at: 2.
	self outputChunks.
	self deltaY: leading.
	newY _ currentY - (aForm height / PrinterResolution * scale * Adjustment).
	newY < bottomMargin
		ifTrue: 
			[self newPage.
			newY _ currentY - (aForm height / PrinterResolution * scale * Adjustment)].
	newWidth _ aForm width + 15 truncateTo: 16.
	file nextPutAll: ' /pix '.
	newWidth / 8 printOn: file.
	file nextPutAll: ' string def'; cr.
	self gsave.
	self translate: leftMargin @ newY.
	self gsave.
	self clipBox: (aForm height / PrinterResolution * scale) asFloat width: (aForm width / PrinterResolution * scale) asFloat.
	self scale: (newWidth / PrinterResolution * scale) asFloat @ (aForm height / PrinterResolution * scale) asFloat.
	self
		imageWidth: newWidth
		height: aForm height
		bits: aForm bits.
	self grestore.
	self box: (aForm height / PrinterResolution * scale) asFloat width: (aForm width / PrinterResolution * scale) asFloat.
	self grestore.
	self moveto: leftMargin @ (currentY _ newY)!

landscape: Nil 
	"Rotate the page 90 degrees."

	orientation _ #landscape.
	chunks add: (Array with: #misc with: '/orientation landscape def
').
	chunks add: (Array with: #misc with: 'setOrientation
').
	"self rotate: -90. 
	self translate: 0 - pageWidth @ 0"!

mapFamily: family size: size face: face
	"Map a Strike font family onto a PostScript face, and set the type size."

	| newFamily newFace |
	newFace _ face.
	family == #Serif
		ifTrue: 
			[newFamily _ #Times.
			"face == #Default ifTrue: [newFace _ #Roman]]"
			face == #Default ifTrue: [newFace _ '']]
		ifFalse: [family == #SanSerif
				ifTrue: 
					[newFamily _ #Helvetica.
					face == #Default ifTrue: [newFace _ '']]
				ifFalse: [family == #FixedPitch
						ifTrue: 
							[newFamily _ #Courier.
							face == #Default ifTrue: [newFace _ '']]]].
	^Array with: (newFamily , newFace) asSymbol with: size!

margins: anArray 
	"Set margins from a passed array of displacements from the page    
	edges."

	| str |
	str _ WriteStream on: (String new: 255).
	topMargin _ pageHeight - ((anArray at: 1)
					* KPointsPerInch).
	bottomMargin _ (anArray at: 2)
				* KPointsPerInch.
	leftMargin _ (anArray at: 3)
				* KPointsPerInch.
	rightMargin _ pageWidth - ((anArray at: 4)
					* KPointsPerInch).
	str nextPutAll: '/leftMargin '.
	(anArray at: 3)
		* 72 printOn: str.
	str nextPutAll: ' def'; cr.
	str nextPutAll: '/topMargin '.
	(anArray at: 1)
		* 72 printOn: str.
	str nextPutAll: ' def'; cr.
	str nextPutAll: '/rightMargin '.
	(anArray at: 4)
		* 72 printOn: str.
	str nextPutAll: ' def'; cr.
	str nextPutAll: '/bottomMargin '.
	(anArray at: 2)
		* 72 printOn: str.
	str nextPutAll: ' def'; cr.
	chunks add: (Array with: #misc with: str contents)!

newPage
	"Print the current page,  and get ready to print another."

	self showPage.
	currentY _ topMargin.
	self moveto: leftMargin @ currentY!

newPage: Nil 
	"Print the current page,  and get ready to print another."

	self newPage.!

pageHeight: inches 
	"Set the height of the printed page."

	| str |
	pageHeight _ inches * KPointsPerInch.
	str _ WriteStream on: (String new: 255).
	str nextPutAll: '/pageHeight '.
	inches * 72 printOn: str.
	str nextPutAll: ' def'; cr.
	chunks add: (Array with: #misc with: str contents)!

pageWidth: inches 
	"Set the width of the printed page."

	| str |
	pageWidth _ inches * KPointsPerInch.
	str _ WriteStream on: (String new: 255).
	str nextPutAll: '/pageWidth '.
	inches * 72 printOn: str.
	str nextPutAll: ' def'; cr.
	chunks add: (Array with: #misc with: str contents)!

start: aNil 
	"Put a preample for the Postscript document,  defining a dictionary  
	and any needed support."

	file nextPutAll: '%!!

% start of setup.
save /state exch def
initgraphics
/PPS 255 dict def PPS begin
/leftMargin 72 def
/yDelta 16 def
/portrait 0 def
/landscape 1 def
/orientation portrait def
/doFooter false def
/doPageNumbers true def
/doLogo false def

/F  %  Fast font setup.
{
  findfont exch scalefont setfont
} bind def

/ArrowDim % Pop the dimensions of the arrows off the stack.
{
/upArrowThickness exch def
/upArrowHeight exch def
/upArrowWidth exch def
/leftArrowThickness exch def
/leftArrowheadHeight exch def
/leftArrowWidth exch def
} bind def

/upArrow %  Draw an up arrow.
{ 
	gsave
	0 setlinecap
	0 setlinejoin
	/upArrowY exch def
	/upArrowX exch def
	upArrowThickness setlinewidth
	/upArrowX upArrowX upArrowWidth 2 div add def
	/upArrowSpace upArrowWidth 10 div def
	/upArrowRenderWidth upArrowWidth upArrowSpace upArrowSpace add sub 3 div def
	newpath
	upArrowX upArrowY moveto
	0 upArrowHeight rlineto 
	stroke
	newpath
	upArrowX upArrowRenderWidth sub upArrowY upArrowHeight add upArrowHeight 3 div sub moveto
	upArrowX upArrowY upArrowHeight add lineto
	upArrowX upArrowRenderWidth add upArrowY upArrowHeight add upArrowHeight 3 div sub lineto
	stroke
	grestore
} bind def

/leftArrow  %  Draw a left arrow.
{ 
	gsave
	0 setlinecap
	0 setlinejoin
	/leftArrowY exch def
	/leftArrowX exch def
	leftArrowThickness setlinewidth
	/leftArrowSpace leftArrowWidth 10 div def
	/leftArrowX leftArrowX leftArrowSpace add def
	/leftArrowRenderWidth leftArrowWidth leftArrowSpace leftArrowSpace add sub def
	/leftArrowheadWidth leftArrowRenderWidth 3 div def
	newpath
	leftArrowX leftArrowY moveto
	leftArrowRenderWidth 0 rlineto 
	stroke
	newpath
	leftArrowX leftArrowheadWidth add leftArrowY leftArrowheadHeight 2 div add moveto
	leftArrowX leftArrowY lineto
	leftArrowX leftArrowheadWidth add leftArrowY leftArrowheadHeight 2 div sub lineto
	stroke
	grestore
} bind def

/CR			%stack: -- --> --
{	
 currentpoint exch pop leftMargin exch yDelta sub moveto 
} bind def

/Ustart		%stack: -- --> --
{
	/ULstart currentpoint pop def
} bind def

/UStop		% stack: underlineThickness underlineYDelta --> --
{
	currentpoint
	/ULY exch def
	/ULX exch def
	gsave newpath
	ULY add ULstart exch moveto
	ULX ULstart sub 0 rlineto
	setlinewidth stroke grestore
} bind def

/pageNum 1 def
/pageString 4 string def

/pageNumFont 
{
  /Times-Roman findfont 10 scalefont
} bind def

/footerStringFont 
{
  /Times-Italic findfont 10 scalefont
} def


/footerString () def

/footer
{
   leftMargin bottomMargin 2 div moveto
  doPageNumbers true eq 
  {
    pageNumFont setfont
    pageNum pageString cvs show
    (  ) show
  } if
  footerStringFont setfont
  footerString show
} bind def

/newPage 
{  
  /savefont currentfont def
  doFooter true eq { footer } if
   showpage
  /pageNum 1 pageNum add def
  setOrientation
  savefont setfont
} bind def

/setOrientation
{
  orientation landscape eq 
  {
    -90 rotate
    0 pageWidth sub 0 translate
  } if
} bind def


% end of setup.

'!

startParagraph: arg 
	"Start a new paragraph."

	self  outputChunks.
	self deltaY: leading.
	self moveto: leftMargin @ currentY!

string: aString 
	"Output this string in the current font.  Break into lines   
	based on character width info."

	self breakIntoLines: aString!

tabs: anArray 
	"Set tab stops from a passed array of x positions."

	| i len |
	currentTabWidths _ Array new: anArray size.
	i _ 0.
	len _ anArray size.
	[(i _ i + 1) <= len]
		whileTrue: [currentTabWidths at: i put: (anArray at: i)
					* KPointsPerInch]!

underline: boolean 
	"Set the state of underlining."

	underlining
		ifTrue: [self stopUnderlining]
		ifFalse: [self startUnderlining]! !

!PostScriptPrinter methodsFor: 'private'!

advanceToNextTabstop: n 
	"Advance the current x position to the n'th next tab stop."

	| tabX count |
	count _ n.
	1 to: currentTabWidths size do: [:i | (tabX _ currentTabWidths at: i) > currentLineWidth
			ifTrue: 
				[currentLineWidth _ tabX.
				count _ count - 1.
				count > 0
					ifFalse: 
						[self moveto: currentLineWidth + leftMargin @ currentY.
						^nil]]]!

box: height width: width 
	"Draws a box at the current origin.  Assumes gsave and grestore are  
	done externally."

	file nextPutAll: 'newpath 0 0 moveto 0 '.
	height asFloat printOn: file.
	file nextPutAll: ' rlineto '.
	width asFloat printOn: file.
	file nextPutAll: ' 0 rlineto 0 '.
	height negated asFloat printOn: file.
	file nextPutAll: ' rlineto closepath 1 72 div setlinewidth stroke'; cr!

breakIntoLines: aString 
	"Return the word , the width and the breakChar."

	| newWord width i  index length spaceWidth loc result n tab sSize space rmargin |
	rmargin _ rightMargin - leftMargin.
	tab _ Character tab.
	space _ Character space.
	spaceWidth _ (currentCharWidths at: 33) asFloat.
	loc _ 1.
	sSize _ aString size.
	[true]
		whileTrue: 
			[result _ BreakScanner
						scanCharactersFrom: loc
						to: sSize
						in: aString
						rightX: 1
						stopConditions: BreakScannerStops
						displaying: false.
			i _ BreakScanner lastIndex.
			
			(i > loc or: [i = loc and: [result == #endOfRun]])
				ifTrue: 
					[newWord _ aString copyFrom: loc to: (result == #endOfRun
									ifTrue: [i]
									ifFalse: [i - 1]).
					width _ index _ 0.
					length _ newWord size.
					[(index _ index + 1) <= length]
						whileTrue: [width _ width + (currentCharWidths at: (newWord at: index) asInteger + 1)].
					width _ width asFloat.
					currentLineWidth + width <= rmargin
						ifTrue: 
							[currentWords nextPutAll: newWord.
							currentLineWidth _ currentLineWidth + width]
						ifFalse: 
							[self outputChunks.
							self resetXdeltaY: 1.
							currentWords nextPutAll: newWord.
							currentLineWidth _ currentLineWidth + width.
							]].
			result == #space
				ifTrue: [currentLineWidth + spaceWidth <= rmargin
						ifTrue: 
							[currentLineWidth _ currentLineWidth + spaceWidth.
							currentWords nextPut: space]
						ifFalse: 
							[self outputChunks.
							self resetXdeltaY: 1]]
				ifFalse: [result == #tab
						ifTrue: 
							[n _ 1.
							[(i _ i + 1) <= sSize and: [(aString at: i)
									== tab]]
								whileTrue: [n _ n + 1].
							self outputChunks.
							self advanceToNextTabstop: n.
							i > sSize
								ifTrue: [^self]
								ifFalse: [i _ i - 1]]
						ifFalse: [result == #leftArrow
								ifTrue: [self putLeftArrow]
								ifFalse: [result == #upArrow
										ifTrue: [self putUpArrow]
										ifFalse: [result == #cr
												ifTrue: [self outputChunks; resetXdeltaY: 1]
												ifFalse: [result == #endOfRun
														ifTrue: [^self outputChunks]
														ifFalse: [result == #formFeed ifTrue: [self outputChunks; newPage]]]]]]].
			loc _ i + 1]!

changeFont: array 
	"Change to a new PostScript font and size combination.  Also scales   
	 the leading in proportion to the font size, and passes new       
	dimensions for the characters ^ and _."

	| fname size str names thickness |
	str _ WriteStream on: (String new: 255).
	fname _ array at: 1.
	size _ array at: 2.
	currentFont _ FontDescription named: fname.
	names _ (fname , size printString) asSymbol.
	currentCharWidths _ CharWidthTable at: names ifAbsent: [CharWidthTable at: names put: (currentFont widths collect: [:wid | wid * size])].
	underlining ifTrue: [self doUnderline: true].
	leading _ size asFloat / 6.0 + size asFloat * Adjustment.
"
	str nextPut: $/; nextPutAll: currentFont fullName; nextPutAll: ' findfont '.
	size printOn: str.
	str nextPutAll: ' scalefont setfont
/yDelta '.
"
	size printOn: str.
	str nextPutAll: ' ('; nextPutAll: currentFont fullName; nextPutAll: ') '.
	str nextPutAll: ' F
/yDelta '.
	leading asFloat / Adjustment printOn: str.
	str nextPutAll: ' def'; cr.
	currentSize _ size asFloat.
	leftArrowWidth _ currentCharWidths at: $_ asInteger + 1.
	leftArrowWidth asFloat / Adjustment printOn: str.
	str space.
	"leftArrowheadHeight" currentSize / 3.0 printOn: str.
	thickness _ currentFont underlineThickness * currentSize * 0.666 / Adjustment.
	str space.
	thickness printOn: str. "for left arrow"
	leftArrowOffsetY _ currentSize * Adjustment / 3.0.
	upArrowWidth _ currentCharWidths at: $^ asInteger + 1.
	str space.
	upArrowWidth asFloat / Adjustment printOn: str.
	str space.
	"upArrowHeight" currentSize / 2.0 printOn: str.
	str space.
	thickness printOn: str. "for up arrow"
	str nextPutAll: ' ArrowDim'; cr.
	chunks add: (Array with: #misc with: str contents)!

clipBox: height width: width 
	"Makes a box at the current origin,  and use it as the current clip  
	path.  Assumes gsave and grestore are done externally."

	file nextPutAll: 'newpath 0 0 moveto 0 '.
	height asFloat printOn: file.
	file nextPutAll: ' rlineto '.
	width asFloat printOn: file.
	file nextPutAll: ' 0 rlineto 0 '.
	height negated asFloat printOn: file.
	file nextPutAll: ' rlineto closepath clip'; cr!

currentTransformation: a b: b c: c d: d tx: e ty: f 
	"Output the PostScript code to set the current graphics coordinate 
	transformation matrix."

	file nextPut: $[.
	a asFloat printOn: file.
	file space.
	b asFloat printOn: file.
	file space.
	c asFloat printOn: file.
	file space.
	d asFloat printOn: file.
	file space.
	e asFloat printOn: file.
	file space.
	f asFloat printOn: file.
	file nextPutAll: ']'; cr!

deltaY: n 
	"'n' is the number of PostScript points to change the y    
	position.  If the page overflows, skip to a new page."

	currentY == nil
		ifTrue: [currentY _ topMargin]
		ifFalse: 
			[currentY _ currentY - n.
			currentY < bottomMargin ifTrue: [self newPage]]!

doUnderline: boolean 
	"Print an underline."

	| string |
	string _ (currentFont underlineThickness * currentSize / Adjustment) asFloat printString , ' ' , (currentFont underlinePosition * currentSize / Adjustment) asFloat printString , ' UStop
'.
	boolean
		ifTrue: [chunks add: (Array with: #underlining with: string)]
		ifFalse: [file nextPutAll: string]!

flushBuffer
	"Flush any waiting text out to 'chunks'."
	currentWords isEmpty
		ifFalse: 
			[chunks addLast: (Array
					with: #string
					with: currentWords contents
					with: currentFont
					with: currentSize).
			currentWords _ WriteStream on: (String new: 255)]!

grestore
	"Emit the PostScript code to restore a graphics state saved on the 
	PostScript stack."

	file nextPutAll: ' grestore'; cr!

gsave
	"Emit the PostScript code to save the current graphics state on the 
	PostScript stack."

	file nextPutAll: ' gsave'; cr!

imageWidth: width height: height bits: bits 
	"Emit the PostScript code needed to print a bitmap...  any needed 
	scaling,  translation,  etc.  is done externally."

	| hex s word n perLine |
	hex _ 'fedcba9876543210'.
	width printOn: file.
	file space.
	height printOn: file.
	file nextPutAll: ' 1 '.
	self
		currentTransformation: width
		b: 0
		c: 0
		d: height negated
		tx: 0
		ty: height.
	file nextPutAll: ' {currentfile pix readhexstring pop} image'; cr.
	perLine _ width / 16.
	n _ 0.
	"s _ ReadStream onCollection: bits."
	s _ ReadStream
				on: bits
				from: 1
				to: bits size.
	[s atEnd]
		whileFalse: 
			[word _ s next.
			file nextPut: (hex at: ((word bitShift: -12)
						bitAnd: 15)
						+ 1).
			file nextPut: (hex at: ((word bitShift: -8)
						bitAnd: 15)
						+ 1).
			file nextPut: (hex at: ((word bitShift: -4)
						bitAnd: 15)
						+ 1).
			file nextPut: (hex at: (word bitAnd: 15)
						+ 1).
			n _ n + 1.
			n = perLine
				ifTrue: 
					[file nextPut: $
.
					n _ 0]]!

lineto: aPoint 
	"Emit the Postscript code to draw a lineto to a position on the page."

	(aPoint x / Adjustment) asFloat printOn: file.
	file space.
	(aPoint y / Adjustment) asFloat printOn: file.
	file nextPutAll: ' lineto'; cr!

moveto: aPoint 
	"Emit the Postscript code to move to a position on the page."
	aPoint x asFloat / Adjustment printOn: file.
	file space.
	aPoint y asFloat / Adjustment printOn: file.
	file nextPutAll: ' moveto'; cr!

outputChunks
	"Output a 'chunk' of accumulated text. Chunks are represented as:   
	Array with: #type with: currentWords with: fontDescription."

	self flushBuffer.
	chunks do: [:aChunk | (aChunk at: 1)
			== #string
			ifTrue: 
				[self outputString: (aChunk at: 2).
				file nextPutAll: ' show'; cr]
			ifFalse: [file nextPutAll: (aChunk at: 2)]].
	chunks _ OrderedCollection new: 10!

outputString: aString 
	"Check for '( ' and ')' and '\' characters, and translate them so 
	PostScript can handle them.  
	Code for translating characters greater than ascii 127 to octal  
	escape sequences is here also,  but is currently commented out as it  
	is not needed at this time."

	| index length c |
	file nextPut: $(.
	index _ 0.
	length _ aString size.
	[(index _ index + 1) <= length]
		whileTrue: 
			[c _ aString at: index.
			c == $(
				ifTrue: [file nextPutAll: '\050']
				ifFalse: [c == $)
						ifTrue: [file nextPutAll: '\051']
						ifFalse: [c == $\
								ifTrue: [file nextPutAll: '\\']
								ifFalse: [file nextPut: c]]]].
	"ifFalse: [c asInteger > 127 
	ifTrue:  
	[file nextPut: $\. 
	c asInteger printOn: file base: 8] 
	ifFalse: [file nextPut: c]]]]]."
	file nextPut: $)!

putLeftArrow
	"Emit the code to print a 'left arrow'  -  invokes a predefined    
	Postscript method."

	| arrowStartX arrowEndX arrowY str |
	self flushBuffer.
	str _ WriteStream on: (String new: 80).
	arrowStartX _ currentLineWidth + leftMargin.
	arrowEndX _ arrowStartX + leftArrowWidth.
	arrowY _ currentY + leftArrowOffsetY.
	arrowEndX <= rightMargin
		ifFalse: 
			[self resetXdeltaY: 1.
			arrowStartX _ currentLineWidth + leftMargin.
			arrowEndX _ arrowStartX + leftArrowWidth.
			arrowY _ currentY + leftArrowOffsetY].
	currentLineWidth _ currentLineWidth + leftArrowWidth.
	arrowStartX asFloat / Adjustment printOn: str.
	str space.
	arrowY asFloat / Adjustment printOn: str.
	str nextPutAll: ' leftArrow'; cr.
	(currentLineWidth + leftMargin) asFloat / Adjustment printOn: str.
	str space.
	currentY asFloat / Adjustment printOn: str.
	str nextPutAll: ' moveto '; cr.
	chunks add: (Array with: #misc with: str contents)!

putUpArrow
	"Emit the code to print an 'up arrow'  -  invokes a predefined   
	Postscript method."

	| upArrowStartX upArrowEndX upArrowY str |
	self flushBuffer.
	str _ WriteStream on: (String new: 80).
	upArrowStartX _ currentLineWidth + leftMargin.
	upArrowEndX _ upArrowStartX + upArrowWidth.
	upArrowY _ currentY.
	upArrowEndX <= rightMargin
		ifFalse: 
			[self resetXdeltaY: 1.
			upArrowStartX _ currentLineWidth + leftMargin.
			upArrowEndX _ upArrowStartX + upArrowWidth.
			upArrowY _ currentY].
	currentLineWidth _ currentLineWidth + upArrowWidth.
	upArrowStartX asFloat / Adjustment printOn: str.
	str space.
	upArrowY asFloat / Adjustment printOn: str.
	str nextPutAll: ' upArrow'; cr.
	(currentLineWidth + leftMargin) asFloat / Adjustment printOn: str.
	str space.
	currentY asFloat / Adjustment printOn: str.
	str nextPutAll: ' moveto '; cr.
	chunks add: (Array with: #misc with: str contents)!

resetXdeltaY: n 
	"Rest x position to the start of a line,  and advance y down n lines."

	underlining ifTrue: [self doUnderline: false].
	currentY - (n * leading) < bottomMargin
		ifTrue: [self newPage]
		ifFalse: [n
				timesRepeat: 
					[file nextPutAll: 'CR'; cr.
					currentY _ currentY - leading]].
	underlining ifTrue: [self startUnderlining].
	currentLineWidth _ 0!

rlineto: aPoint 
	"Emit the Postscript code to draw a line to a position relative to the 
	current position on the page."

	(aPoint x / Adjustment) asFloat printOn: file.
	file space.
	(aPoint y / Adjustment) asFloat printOn: file.
	file nextPutAll: ' rlineto'; cr!

rotate: degrees 
	"Emit the PostScript code to rotate the coordinate system."

	degrees asFloat printOn: file.
	file nextPutAll: ' rotate'; cr!

scale: aPoint 
	"Emit the PostScript code to scale the coordinate system...  'aPoint' is 
	not really a point,  but rather the x and y scale factors."

	aPoint x asFloat printOn: file.
	file space.
	aPoint y asFloat printOn: file.
	file nextPutAll: ' scale'; cr!

show: string 
	"Emit the PostScript code to print a string of characters."

	self outputString: string.
	file nextPutAll: ' show'; cr!

showPage
	"Emit the PostScript code to actually print the current page...  push 
	paper!!"

	file nextPutAll: ' newPage'; cr!

startUnderlining
	"Set up to underline the following text."

	self flushBuffer.
	chunks add: (Array with: #underlining with: 'Ustart
').
	underlining _ true!

stopUnderlining
	"Defeat the underlining of the following text."

	self flushBuffer.
	self doUnderline: true.
	underlining _ false!

translate: aPoint 
	"Emit the PostScript code to translate the PostScript coordinate 
	system."

	| newPoint |
	newPoint _ aPoint / Adjustment.
	newPoint x asFloat printOn: file.
	file space.
	newPoint y asFloat printOn: file.
	file nextPutAll: ' translate'; cr!

underline
	"Add the parameters needed for the underlining."

	chunks add: (Array with: #underlining with: (currentFont underlineThickness * currentSize / Adjustment) asFloat printString , ' ' , (currentFont underlinePosition * currentSize / Adjustment) asFloat printString , ' UStop
')! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

PostScriptPrinter class
	instanceVariableNames: ''!
PostScriptPrinter class comment:
'Select the browser switch "instance" to see the comment'!


!PostScriptPrinter class methodsFor: 'class initialization'!

initialize
	"Initialize the printer... output file name,  character scanner 
	parameters, and some misc scaling/coordinate stuff."

	CharWidthTable _ IdentityDictionary new.
	Adjustment _ 1000.0.
	KPointsPerInch _ 72.0 * Adjustment.
	TempFileName _ 'temp.postscript'.
	BreakScanner _ CharacterScanner new.
	BreakScanner xTable: (Array new: 257 withAll: 0).
	BreakScannerStops _ Array new: 258.
	BreakScannerStops at: Character cr asciiValue + 1 put: #cr.
	BreakScannerStops at: Character space asciiValue + 1 put: #space.
	BreakScannerStops at: Character tab asciiValue + 1 put: #tab.
	BreakScannerStops at: 12 + 1 put: #formFeed.
	"formfeed"
	BreakScannerStops at: $_ asciiValue + 1 put: #leftArrow.
	BreakScannerStops at: $^ asciiValue + 1 put: #upArrow.
	BreakScannerStops at: 257 put: #endOfRun.
	BreakScannerStops at: 258 put: #crossedX.
	BreakScanner stopConditions: BreakScannerStops.
	BreakScanner destX: 0!

new
	"Initialize."

	^super new initialize! !

!PostScriptPrinter class methodsFor: 'instance creation'!

named: aString print: aDocument 
	"Send the document to be rendered to the named PostScript printer..."

	| fileName |
	fileName _ Filename
		request: 'PostScript output file name?'
		initially: TempFileName
		shouldExist: false. 
	(fileName isEmpty not and: [FileDirectory isLegalFileName: fileName])
		ifFalse: [^Transcript show: 'not printed'].
	TempFileName _ fileName.
	self new printer: aString print: aDocument onFileNamed: TempFileName! !

!PostScriptPrinter class methodsFor: 'printing'!

sendToPrinter
	"Send the temp file to the printer via a system call, or   
	print a failure message."

	Transcript show: 'sending to printer... '.
	"(ExternalProcess defaultClass forkJob: 'lpr' arguments: (Array with: TempFileName)) wait."
	Transcript show: ' ...cannot print directly; to really print (on a UNIX system), open a terminal window and type: lpr ' , TempFileName , '.'; cr! !

!PostScriptPrinter class methodsFor: 'temp file access'!

tempFileName: aString
	"Set the name for temp files."

	TempFileName _ aString! !

PostScriptPrinter initialize!


Object subclass: #FontStyle
	instanceVariableNames: 'currentStyle defaultInfo '
	classVariableNames: 'DefaultDefaultInfo '
	poolDictionaries: ''
	category: 'System-Printing'!
FontStyle comment:
'I manage font style attributes, such as family, face, style, and size.'!


!FontStyle methodsFor: 'initialization'!

initialize
	"Set up an initial default font style."

	currentStyle _ #Default.
	defaultInfo _ DefaultDefaultInfo deepCopy.! !

!FontStyle methodsFor: 'fonts'!

currentAttributes
	"Return the appropriate info for the current style setting."

	currentStyle == #Default ifTrue: [^defaultInfo].
	self error: 'funny style'!

currentFace
	"Return the current typeface."

	^self currentAttributes at: #face!

currentFamily
	"Return the current type family."

	^self currentAttributes at: #family!

currentSize
	"Return the current type point size."

	^self currentAttributes at: #size!

currentStyle
	"Return the current font style."

	^currentStyle!

setFace: aSymbol 
	"Set the current type face to the named one."

	self currentAttributes add: (Association key: #face value: aSymbol)!

setFamily: aSymbol 
	"Set the current type family."

	self currentAttributes add: (Association key: #family value: aSymbol).
	self setFace: #Default!

setSize: anInteger 
	"Set the point size of the type."

	self currentAttributes add: (Association key: #size value: anInteger)!

setStyle: abstractFontName 
	"Set the current type style."

	currentStyle _ abstractFontName! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

FontStyle class
	instanceVariableNames: ''!
FontStyle class comment:
'Select the browser switch "instance" to see the comment'!


!FontStyle class methodsFor: 'instance creation'!

default
	"Return a new defaulted font style."

	^self new!

new
	"Initialize."

	^super new initialize! !

!FontStyle class methodsFor: 'class initialization'!

initialize
	"Set up the details of the default style."

	DefaultDefaultInfo _ Dictionary new.
	DefaultDefaultInfo	at: 		#face put: #Default;
						at:		#size put: 10;
						at:		#family put: #SanSerif.! !

FontStyle initialize!


Object subclass: #FontDescription
	instanceVariableNames: 'fullName widths italicAngle weight fixedPitch familyName underlinePosition underlineThickness '
	classVariableNames: 'PSFonts '
	poolDictionaries: ''
	category: 'System-Printing'!
FontDescription comment:
'I hold useful information from the afm files.  My metaclass contains code to parse the afm file and build instances.

Instance Variables:
	fullName			<String>				The name from the afm file.
	widths				<Array>					The width info from  afm file -- assumes 1000 points in coordinate system.
	italicAngle			<Number>				From the afm file.
	weight				<String>				From the afm file.
	fixedPitch			<Boolean>				Signals a monospaced font.
	familyName			<String>				From the afm file.	
	underlinePosition	<Number>				From the afm file.
	underlineThickness	<Number>				From the afm file.

Class Variables:
	PSFonts	<Dictionary>						Holds the font declarations.
'!


!FontDescription methodsFor: 'accessing'!

familyName: string 
	"Set the type family to the name in the string."

	familyName _ string!

fixedPitch: bool 
	"Set whether or not a fixed pitch font."

	fixedPitch _ bool!

fullName
	"return the full name of the current font."

	^fullName!

fullName: string 
	"Set the current full name of the current font."

	fullName _ string!

italicAngle: number 
	"Set the angle at which the font is italicized."

	italicAngle _ number!

underlinePosition
	"Return where the underline goes in the current font."

	^underlinePosition!

underlinePosition: number 
	"Set where the underline goes in the current font."

	underlinePosition _ number!

underlineThickness
	"Return how thick an underline is done in the current font."

	^underlineThickness!

underlineThickness: number 
	"Set how thick the underline should be in the current font.."

	underlineThickness _ number!

weight: string 
	"Set the weight of the current font."

	weight _ string!

widths
	"Return an array of the widths of all the characters in the current  
	font."

	^widths!

widths: array 
	"Set the widths of all the characters in the current font from the 
	contents of the given array."

	widths _ array! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

FontDescription class
	instanceVariableNames: ''!
FontDescription class comment:
'Select the browser switch "instance" to see the comment'!


!FontDescription class methodsFor: 'initialization'!

fixNameInternal: string 
	"Massage the font name,  getting rid of spaces.  Also,  map 'Oblique' 
	to 'Italic',  'medium' to '',  'Light' to '',  'Demi' to 'Bold',  'Roman'   
	to '',  for internal use... this is necessary to deal with some of the   
	Adobe special naming choices."

	| new foundIndex1 foundIndex2 c |
	foundIndex1 _ string findString: 'Book' startingAt: 1.
	foundIndex2 _ string findString: 'Bookman' startingAt: 1.
	foundIndex2 == 0 ifTrue: [foundIndex1 == 0 ifFalse: [string
				replaceFrom: foundIndex1
				to: foundIndex1 + 3
				with: '    ']].
	foundIndex1 _ string findString: 'Demi' startingAt: 1.
	foundIndex1 == 0 ifFalse: [string
			replaceFrom: foundIndex1
			to: foundIndex1 + 3
			with: 'Bold'].
	foundIndex1 _ string findString: 'Oblique' startingAt: 1.
	foundIndex1 == 0 ifFalse: [string
			replaceFrom: foundIndex1
			to: foundIndex1 + 6
			with: 'Italic '].
	foundIndex1 _ string findString: 'Light' startingAt: 1.
	foundIndex1 == 0 ifFalse: [string
			replaceFrom: foundIndex1
			to: foundIndex1 + 4
			with: '     '].
	foundIndex1 _ string findString: 'Medium' startingAt: 1.
	foundIndex1 == 0 ifFalse: [string
			replaceFrom: foundIndex1
			to: foundIndex1 + 5
			with: '      '].
	foundIndex1 _ string findString: 'Roman' startingAt: 1.
	foundIndex1 == 0 ifFalse: [string
			replaceFrom: foundIndex1
			to: foundIndex1 + 4
			with: '     '].
	new _ WriteStream on: (String new: 1).
	1 to: string size do: 
		[:i | 
		c _ string at: i.
		c == 32 asCharacter ifFalse: [new nextPut: c]].
	^new contents!

getDirName
	"Prompt for and return the base directory name of the font metric files."

	^FillInTheBlank request: 'Where are the Font Metric files?'  initialAnswer: 
'printing',( String with: FileDirectory separator),'AFM'!

initialize
	"Process the default fonts for the LaserWrite-Plus."
	"FontDescription initialize."

	| dirList flag directoryName |
	PSFonts _ Dictionary new.
	flag _ false.
	[directoryName _ FontDescription getDirName.
	directoryName isEmpty or: 
		[(FileDirectory isDirectory: directoryName) not
		or: [(dirList _ (FileDirectory named: directoryName) 
						filesMatching: '*AFM') isEmpty]]]
		whileTrue: 
			[BinaryChoice
				message: 'try again?'
				displayAt: Sensor mousePoint
				centered: true
				ifTrue: nil
				ifFalse: [flag _ true].
			flag ifTrue: [^self]].
	self processAdobeFiles: dirList!

processAdobeFiles
	"Load in the Adobe Font Metric (AFM) files,  and massage them into a 
	set of  internal font descriptions..."

	^self processAdobeFiles: ((FileDirectory named: self getDirName)
		filesMatching: '*AFM')!

processAdobeFiles: aCollection
	"Load in the Adobe Font Metric (AFM) files,  and massage them into a 
	set of  internal font descriptions..."

	| key f s i c width widths index angle weight pitch family named desc 
underlineThickness underlinePosition spaceWidth psName |
	aCollection
		do: 
			[:aName | 
			Transcript cr; show: 'Processing ' , aName.
			key _ aName.
			widths _ Array new: 256.
			f _ aName asFilename.
			s _ f contentsOfEntireFile.
			named _ self extractFieldNamed: 'FullName' from: s.
			psName _ self extractFieldNamed: 'FontName' from: s.
			key _ (self fixNameInternal: named) asSymbol.
			angle _ Number readFrom: (ReadStream on: (self extractFieldNamed: 
'ItalicAngle' from: s)).
			underlineThickness _ Number readFrom: (ReadStream on: (self 
extractFieldNamed: 'UnderlineThickness' from: s)).
			underlinePosition _ Number readFrom: (ReadStream on: (self 
extractFieldNamed: 'UnderlinePosition' from: s)).
			weight _ self extractFieldNamed: 'Weight' from: s.
			pitch _ (self extractFieldNamed: 'IsFixedPitch' from: s)
						= 'true'.
			family _ self extractFieldNamed: 'FamilyName' from: s.
			i _ s indexOfSubCollection: 'StartCharMetrics' startingAt: 1.
			i _ s indexOfSubCollection: 'C ' startingAt: i.
			f _ s readStream.
			f position: i.

			[c _ f next.
			c = Character space ifFalse: [self afmReadError].
			index _ Integer readFrom: f.
			index < 0
				ifFalse: 
					[[c _ f next = $W] whileFalse.
					c _ f next.
					c = $X ifFalse: [self afmReadError].
					c _ f next.
					c = Character space ifFalse: [self afmReadError].
					width _ Integer readFrom: f.
					widths at: index + 1 put: width].
			f skipThrough: 13 asCharacter.
			c _ f next.
			c = $C] whileTrue.
			spaceWidth _ widths at: 32 + 1.
			"for non-glyphed characters, the printer will output a space   
			   glyph.  make measurement work correctly"
			1 to: 256 do: [:j | (widths at: j)
					== nil ifTrue: [widths at: j put: spaceWidth]].
			f close.
			"			desc _ (FontDescription new) familyName: family; fullName: 
			named; widths: widths; italicAngle: angle; weight: weight; 
			fixedPitch: pitch; underlineThickness: underlineThickness; 
			underlinePosition: underlinePosition.
			"
			desc _ (FontDescription new) familyName: family; fullName: psName; 
widths: widths; italicAngle: angle; weight: weight; fixedPitch: pitch; 
underlineThickness: underlineThickness; underlinePosition: underlinePosition.
			PSFonts at: key put: desc].
	^PSFonts! !

!FontDescription class methodsFor: 'accessing'!

named: aSymbol 
	"Return the font description corresponding to the given name."

	^PSFonts at: aSymbol! !

!FontDescription class methodsFor: 'private'!

afmReadError
	self error: 'Can''t parse font metrics file'!

extractFieldNamed: field from: string 
	"Find a named field in a string,  and return it."

	| i result |
	i _ string indexOfSubCollection: field startingAt: 1.
	i _ string indexOfSubCollection: ' ' startingAt: i.
	result _ string copyFrom: i + 1 to: (string indexOfSubCollection: '
' startingAt: i)
					- 1.
	^result! !

FontDescription initialize!


Object subclass: #Document
	instanceVariableNames: 'entities currentStyle currentFontStyle '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'System-Printing'!
Document comment:
'I am an abstract representation of a printable document.

Instance Variables:
	entities				<OrderedCollection>		The DocumentStyles and entities (paragraphs and forms) which make up this document.
	currentStyle		<DocumentStyle>		Current only when an entity is being added during document creation.

'!


!Document methodsFor: 'initialize-release'!

close
	"Close out the current document."

	currentStyle _ 0!

initialize
	"Set up defaults,  and create an ordered collection to hold the 
	intermediate representation of the document."

	entities 			_ OrderedCollection new: 255.
	currentStyle 		_ PageStyle default.
	currentFontStyle 	_ FontStyle default.
	self fontStyleChanged.

	self setpageHeight: currentStyle pageHeight deepCopy.
	self setpageWidth: currentStyle pageWidth deepCopy.
	self setTabs: currentStyle tabStops deepCopy.
	self setMargins: currentStyle margins deepCopy! !

!Document methodsFor: 'rendering control'!

render: aBlock 
	"Render the entities to PostScript."

	aBlock value: (Association key: #start: value: nil).
	entities do: [:entity | aBlock value: entity].
	aBlock value: (Association key: #end: value: nil)!

toPrinter
	"Send the data to the printer... note that 'PostScriptPrinter' expects 
	a string naming the device.  This is just a stub, but in the future..."

	PostScriptPrinter named: '' print: self! !

!Document methodsFor: 'Smalltalk compatibility'!

addText: aText 
	"Add a formatted Text (strings and runs) to the document,    
	using TextStyle default."

	self addText: aText asText under: TextStyle default!

addText: aText under: aTextStyle 
	"Add a formatted Text (strings and runs) to the document,    
	using a specified text style."

	| changed familySizeFace size face familyName underlined |
	changed _ false.
	self stringsAndIndexesFor: aText do: 
		[:string :index | 
		familySizeFace _ (aTextStyle fontAt: index) familySizeFace.
		underlined _ aTextStyle isFontUnderlined: index.
		familyName _ self getFontLike: familySizeFace.
		size _ familySizeFace at: 2.
		face _ familySizeFace at: 3.
		face _ #(Default Bold Italic BoldItalic ) at: face + 1.
		familyName ~= currentFontStyle currentFamily
			ifTrue: 
				[currentFontStyle setFamily: familyName.
				changed _ true].
		size ~= currentFontStyle currentSize
			ifTrue: 
				[currentFontStyle setSize: size.
				changed _ true].
		face ~= currentFontStyle currentFace
			ifTrue: 
				[currentFontStyle setFace: face.
				changed _ true].
		underlined
			ifTrue: 
				[self startUnderlining.
				changed _ true].
		changed
			ifTrue: 
				[self fontStyleChanged].
		self addString: string.
		underlined ifTrue: [self stopUnderlining]]!

getFontLike: familySizeFace 
	"Map a strike font to an abstract type family."

	| family |
	family _ familySizeFace at: 1.
	(family = 'TIMESROMAN' or: [family = 'SERIF'])
		ifTrue: [^#Serif].
	(family = 'HELVETICA' or: [family = 'SANSERIF' or: [family = 'SANS-SERIF']])
		ifTrue: [^#SanSerif].
	(family = 'FIXED' or: [family = 'ICON'])
		ifTrue: [^#FixedPitch].
	self error: 'don''t know how to handle this font yet!!'! !

!Document methodsFor: 'adding entities'!

addImage: aForm 
	"Add a form to the list of entities,  to be printed in a device 
	independent scaling giving an image at screen resolution."

	entities add: (Association key: #image: value: aForm deepCopy)!

addImageOneToN: aFormandScale 
	"Add a form to the list of entities,  to be printed in a device  
	dependent scaling giving an image at one-to-n pixel resolution."

	entities add: (Association key: #imageOneToN: value: aFormandScale deepCopy)!

addItalicHeader: aString pointSize: pointSize 
	"Add to the list of entities an italic header,  at a point size given by 
	the user."

	| oldStyle oldSize |
	oldStyle _ currentFontStyle currentFace.
	oldSize _ currentFontStyle currentSize.
	currentFontStyle setFace: #Italic.
	currentFontStyle setSize: pointSize.
	self fontStyleChanged.
	entities add: (Association key: #string: value: aString).
	currentFontStyle setFace: oldStyle.
	currentFontStyle setSize: oldSize.
	self fontStyleChanged!

addString: aString 
	"Add the given string to the current paragraph."

	
	entities add: (Association key: #string: value: aString)!

doFooter: doFooter footerString: footerString doPageNumbers: doPageNumbers 
	"Set the footer of the page."

	entities add: (Association key: #doFooter: value: (Array
				with: doFooter
				with: footerString
				with: doPageNumbers))!

fontStyleChanged
	"Something stylistic has changed,  so copy all the font style stuff  
	into the list of entities."

	entities add: (Association key: #fontStyle: value: currentFontStyle deepCopy)!

newPage
	"Advance to the next page."

	entities add: (Association key: #newPage: value: nil)!

setLandscape
	"Rotate the rendering 90 degrees."

	| oldPageWidth oldPageHeight |
	oldPageWidth _ currentStyle pageWidth.
	oldPageHeight _ currentStyle pageHeight.
	currentStyle pageSize: oldPageHeight @ oldPageWidth.
	self setpageHeight: currentStyle pageHeight deepCopy.
	self setpageWidth: currentStyle pageWidth deepCopy.
	entities add: (Association key: #landscape: value: nil).
	self setMargins: currentStyle margins deepCopy!

setMargins: anArray 
	"Set the margins to the given displacements inward from the page 
	edges."

	entities add: (Association key: #margins: value: anArray)!

setpageHeight: height 
	"Set the height of the page to the given value."

	entities add: (Association key: #pageHeight: value: height)!

setpageWidth: width 
	"Set the width of the page to the given value."

	entities add: (Association key: #pageWidth: value: width)!

setTabs: anArray 
	"Set the tab stops to the given x positions."

	entities add: (Association key: #tabs: value: anArray)!

startParagraph
	"Set up to start a new paragraph of text."

	
	entities add: (Association key: #startParagraph: value: nil)!

startUnderlining
	"Set up to underline any subsequent text."

	entities add: (Association key: #underline: value: true)!

stopUnderlining
	"Set up to not underline subsequent text."

	entities add: (Association key: #underline: value: false)! !

!Document methodsFor: 'errors'!

errorNotBuilding
	"If not building a paragraph when something is added to one,  print an 
	error message."

	self error: 'paragraph not being built!!'! !

!Document methodsFor: 'margins'!

margins
	"Return the current margin settings."

	^currentStyle margins!

setBottomMargin: newY 
	"Set the value of the bottom margin."

	currentStyle bottomMargin: newY!

setLeftMargin: newX 
	"Set the value of the left margin."

	currentStyle leftMargin: newX!

setRightMargin: newX 
	"Set the right margin."

	currentStyle rightMargin: newX!

setTopMargin: newY 
	"Set the top margin."

	currentStyle topMargin: newY! !

!Document methodsFor: 'private'!

stringsAndIndexesFor: aText do: aBlock 
	"Send string and strike font index to aBlock for a text."

	| fontruns values str index string|
	string _ aText string.
	index _ 1.
	fontruns _ aText runs runs.
	values _ aText runs values.
	1 to: fontruns size do: 
		[:i | 
		str _ string copyFrom: index to: (fontruns at: i) + index - 1.
		aBlock value: str value: (values at: i).
		index _ index + str size]! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Document class
	instanceVariableNames: ''!
Document class comment:
'Select the browser switch "instance" to see the comment'!


!Document class methodsFor: 'instance creation'!

new
	"Initialize."

	^super new initialize!

open
	"Make a new document."

	^self new! !

!Document class methodsFor: 'examples'!

doTest1
	"Make a simple PostScript file... just some text,  with everything 
	defaulted."
	"Document doTest1"

	| document |
	Cursor wait
		showWhile: 
			[document _ Document new.
			document startParagraph.
			document addString: 'Oh,  nooooooo Mr. Bill!!'.
			document close.
			document toPrinter]!

doTest2
	"Make a simple PostScript file... a screendump scaled in a device 
	independent way."
	"Document doTest2"

	| document |
	Cursor wait
		showWhile: 
			[document _ Document new.
			document startParagraph.
			document addItalicHeader: 'Screendump:' pointSize: 24.
			document addImage: Form fromUser.
			document close.
			document toPrinter]!

doTest3
	"Make a screendump,  at one-to-n pixel resolution from screen          
	pixels to printer pixels,  to a PostScript file... a scale factor of four   
	looks nice on the Apple laserwriter:  it prints at 75 'points' to the 
	inch rather than Adobe's 72 'points' to the inch,  resulting in better  
	looking bitmaps. A scale factor of one will print one form pixel to one  
	printer pixel; this looks very nice indeed but takes a lot of data!!"
	"Document doTest3"

	| document scale |
	scale _ 2.
	Cursor wait
		showWhile: 
			[document _ Document new.
			document startParagraph.
			document addItalicHeader: 'Screendump:' pointSize: 24.
			document addImageOneToN: (Array with: Form fromUser with: scale).
			document close.
			document toPrinter]!

doTest4
	"Make a simple PostScript file... some text,  with page numbers and a footer, in landscape mode."
	"Document doTest4"

	| document |
	Cursor wait
		showWhile: 
			[document _ Document new.
			document
				doFooter: true
				footerString: 'Foobar!!'
				doPageNumbers: true.
			document setLandscape.
			document startParagraph.
			document addString: '0
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42'.
			document close.
			document toPrinter]! !

