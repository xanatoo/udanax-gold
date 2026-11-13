MouseMenuController subclass: #ScrollController
	instanceVariableNames: 'scrollBar marker '
	classVariableNames: 'HaltedScrollBar SavedArea YellowMenuForm '
	poolDictionaries: ''
	category: 'Interface-Support'!

!ScrollController methodsFor: 'basic control sequence'!

controlInitialize
	"The scrollbar has a two-pixel border, and for alignment it assumes that this sub-view
	has a one-pixel border and shares another one-pixel border from its neighbor/super view"
	super controlInitialize.
	view displayBox height <= (YellowMenuForm height + 4) ifTrue:[
	scrollBar region: (0 @ 0 extent: 32 @ (view displayBox height + 2 + YellowMenuForm height))]
	ifFalse: [ scrollBar region: (0 @ 0 extent: 32 @ (view displayBox height + 2))].
	marker region: self computeMarkerRegion.
	scrollBar _ scrollBar align: scrollBar topRight with: view displayBox topLeft - (0@1).
	marker _ marker align: marker topCenter with: self scrollBarOnlyArea topCenter.
	self class getSavedAreaFor: scrollBar.
	self displayScrollBar.
	self moveMarker! !

!ScrollController methodsFor: 'control defaults'!

controlActivity
	self scrollBarContainsCursor
		ifTrue: [self scroll]
		ifFalse: [super controlActivity]!

yellowMenuActivity
	sensor anyButtonPressed ifTrue: [self yellowButtonActivity]! !

!ScrollController methodsFor: 'scrolling'!

canScroll
	"Answer whether there is information that is not visible and can be seen
	by scrolling."
	^marker region height < self scrollBarOnlyArea height!

scroll
	"Check to see whether the user wishes to jump, scroll up, or scroll down."
	| savedCursor regionPercent |
	self yellowMenuContainsCursor
				ifTrue: [^self yellowMenuActivity].
	savedCursor _ sensor currentCursor.
	[self scrollBarOnlyContainsCursor]
		whileTrue: 
			[Processor yield.
			regionPercent _ 100 * (sensor cursorPoint x - scrollBar left) // scrollBar width.
			regionPercent <= 40
				ifTrue: [self scrollDown]
				ifFalse: [regionPercent >= 60
							ifTrue: [self scrollUp]
							ifFalse: [self scrollAbsolute]]].
	savedCursor show!

scrollAmount
	"Answer the number of bits of y-coordinate should be scrolled.  This is a 
	default determination based on the view's preset display transformation."

	^((view inverseDisplayTransform: sensor cursorPoint)
		- (view inverseDisplayTransform: self scrollBarOnlyArea topCenter)) y!

viewDelta
	"Answer an integer that indicates how much the view should be scrolled.
	The scroll bar has been moved and now the view must be so the amount to
	scroll is computed as a ratio of the current scroll bar position."

	^view window top - view boundingBox top -
		((marker top - self scrollBarOnlyArea top) asFloat /
			self scrollBarOnlyArea height asFloat *
				view boundingBox height asFloat) rounded! !

!ScrollController methodsFor: 'cursor'!

scrollBarOnlyContainsCursor
	"Answer whether the cursor is anywhere within the scroll bar area."
	^self scrollBarOnlyArea containsPoint: sensor cursorPoint!

yellowMenuContainsCursor
	"Answer whether the cursor is anywhere within the yellow menu area."
	^self yellowMenuArea containsPoint: sensor cursorPoint! !

!ScrollController methodsFor: 'marker adjustment'!

computeMarkerRegion
	"Answer the rectangular area in which the gray area of the scroll bar
	should be displayed."

	^0@0 extent: 10 @
			((view window height asFloat /
						view boundingBox height *
							self scrollBarOnlyArea height)
				 rounded min: self scrollBarOnlyArea height)!

markerDelta
	^marker top 
		- self scrollBarOnlyArea top  
		- ((view window top - view boundingBox top) asFloat 
			/ view boundingBox height asFloat *
				self scrollBarOnlyArea height asFloat) rounded!

markerRegion: aRectangle 
	"Set the area defined by aRectangle as the marker.  Fill it with gray tone."

	Display fill: marker mask: scrollBar insideColor.
	marker region: aRectangle.
	marker _ marker align: marker topCenter with: self scrollBarOnlyArea topCenter!

moveMarker: anInteger
	"Update the marker so that is is translated by an amount corresponding to
	a distance of anInteger, constrained within the boundaries of the scroll bar."

	Display fill: marker mask: scrollBar insideColor.
	marker _ marker translateBy: 0 @
				((anInteger min: self scrollBarOnlyArea bottom - marker bottom) max:
					self scrollBarOnlyArea top - marker top).
	marker displayOn: Display! !

!ScrollController methodsFor: 'private'!

displayScrollBar
	scrollBar displayOn: Display.
	YellowMenuForm displayOn: Display at: scrollBar inside topLeft!

scrollAbsolute
	| oldMarker |
	self changeCursor: Cursor marker.
	self canScroll & sensor anyButtonPressed ifTrue:
		[[sensor anyButtonPressed] whileTrue:
			[oldMarker _ marker.
			marker _ marker translateBy:
				0@((sensor cursorPoint y - marker center y min:
					self scrollBarOnlyArea bottom - marker bottom) max: self scrollBarOnlyArea top - marker top).
			(oldMarker areasOutside: marker), (marker areasOutside: oldMarker) do:
				[:region | Display fill: region rule: Form reverse mask: Form gray].
			self scrollView].
		self displayScrollBar.
		self moveMarker]!

scrollBarOnlyArea
	^scrollBar inside topLeft + (0@YellowMenuForm height)
		corner: scrollBar inside bottomRight!

yellowMenuArea
	^scrollBar inside topLeft extent: YellowMenuForm extent! !

!ParagraphEditor methodsFor: 'scrolling'!

viewDelta 
	^paragraph clippingRectangle top 
		- paragraph compositionRectangle top 
		- ((marker top - self scrollBarOnlyArea top) asFloat 
				/ self scrollBarOnlyArea height asFloat * self scrollRectangleHeight asFloat)
			roundTo: paragraph lineGrid! !

!ParagraphEditor methodsFor: 'marker adjustment'!

computeMarkerRegion
	paragraph compositionRectangle height = 0
		ifTrue:	[^0@0 extent: 10 @ self scrollBarOnlyArea height]
		ifFalse:	[^0@0 extent:
					10 @ ((paragraph clippingRectangle height asFloat /
							self scrollRectangleHeight * self scrollBarOnlyArea height) rounded
							min: self scrollBarOnlyArea height)]!

markerDelta
	^marker top - self scrollBarOnlyArea top - ((paragraph clippingRectangle top -
		paragraph compositionRectangle top) asFloat /
			(self scrollRectangleHeight max: 1) asFloat *
				self scrollBarOnlyArea height asFloat) rounded! !

!ScrollController class methodsFor: 'class initialization'!

dontDoYellowMenu
	"ScrollController dontDoYellowMenu"
	YellowMenuForm _  Form extent: 0@0!

initialize
	"ScrollController initialize"
	YellowMenuForm _ 
		(Form
	extent: 30@16
	fromArray: #( 0 0 0 0 3847 33728 6540 50784 4299 25648 4300 58416 4299 25648 4300 58416 4299 25648 6604 58992 4039 58352 1923 49632 0 0 0 0 0 0 65535 65535)
	offset: 0@0)! !

ScrollController initialize!

!ListController methodsFor: 'marker adjustment'!

computeMarkerRegion
	| viewList |
	viewList _ view list.
	^ 0@0 extent: 10@
			((viewList clippingRectangle height asFloat /
						viewList compositionRectangle height *
							self scrollBarOnlyArea height)
					rounded min: self scrollBarOnlyArea height)!

markerDelta
	| viewList |
	viewList _ view list.
	^(marker top - self scrollBarOnlyArea top) -
		((viewList clippingRectangle top -
				viewList compositionRectangle top) asFloat /
			viewList compositionRectangle height asFloat *
			self scrollBarOnlyArea height asFloat) rounded! !

!ListController methodsFor: 'scrolling'!

scrollAmount
	^sensor cursorPoint y - self scrollBarOnlyArea top!

viewDelta
	| viewList |
	viewList _ view list.
	^(viewList clippingRectangle top -
			viewList compositionRectangle top -
			((marker top - self scrollBarOnlyArea top) asFloat /
				self scrollBarOnlyArea height asFloat *
				viewList compositionRectangle height asFloat))
		roundTo: viewList lineGrid! !

!TextEditor methodsFor: 'scrolling'!

scrollAbsolute

	| oldMarker delta newMarkerRegion oldCursorY cursorY offsetY |
	self changeCursor: Cursor marker.
	oldCursorY _ marker center y.
	self canScroll & sensor anyButtonPressed ifTrue:
		[[sensor anyButtonPressed] whileTrue:
			[oldMarker _ marker copy.
			cursorY _ sensor cursorPoint y.
			delta _ ((marker center y - cursorY) asFloat / self scrollBarOnlyArea height asFloat 
						* (paragraph textSize max: 1) asFloat) truncated.
			(oldCursorY - cursorY) * delta <= 0 ifTrue: [delta _ 0].
			self scrollView: delta.
			oldCursorY _ cursorY.
			newMarkerRegion _ self computeMarkerRegion.
			offsetY _ (((paragraph lines at: 1) - 1) asFloat 
							/ (paragraph textSize max: 1) asFloat 
								* self scrollBarOnlyArea height asFloat) rounded 
									min: self scrollBarOnlyArea height - newMarkerRegion height. 
			marker region: (marker left@(self scrollBarOnlyArea top + offsetY) extent: newMarkerRegion corner).
			(oldMarker areasOutside: marker), (marker areasOutside: oldMarker) do:
				[:region | Display fill: region rule: Form reverse mask: Form gray]].
		self displayScrollBar.
		self moveMarker]!

scrollAmount

	^paragraph lineLength - 1 min: (((sensor cursorPoint y - self scrollBarOnlyArea top) asFloat 
				/ paragraph lineGrid asFloat) truncated max: 1)!

viewDelta

	^(paragraph lines at: 1) - 1 
		- ((marker top - self scrollBarOnlyArea top) asFloat 
				/ self scrollBarOnlyArea height asFloat * (paragraph textSize max: 1) asFloat) truncated! !

!TextEditor methodsFor: 'marker adjustment'!

computeMarkerRegion
	"Answer the rectangular area in which the gray area of the scroll bar
	should be displayed."

	paragraph textSize = 0
		ifTrue:	
			[^0@0 extent: 10 @ self scrollBarOnlyArea height]
		ifFalse:	
			[^0@0 extent: 10 @ 
				((((paragraph nextChar - (paragraph lines at: 1)) asFloat 
						/ (paragraph textSize max: 1) asFloat 
							* self scrollBarOnlyArea height asFloat) rounded max: 4) 	
						min: self scrollBarOnlyArea height)]!

markerDelta

	^marker top - self scrollBarOnlyArea top 
		- (((paragraph lines at: 1) - 1) asFloat / 
				(paragraph textSize max: 1) asFloat *
					self scrollBarOnlyArea height asFloat) rounded! !

