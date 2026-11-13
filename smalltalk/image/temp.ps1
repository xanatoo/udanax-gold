%!

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
/finalPage
{
  /savefont currentfont def
  doFooter true eq { footer } if
  savefont setfont
  showpage
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
10 (Helvetica)  F
/yDelta 11.6667 def
5.56 3.33333 0.48618 4.69 5.0 0.48618 ArrowDim
/pageHeight 792.0 def
/pageWidth 612.0 def
/leftMargin 72 def
/topMargin 72 def
/rightMargin 72 def
/bottomMargin 72 def
/doFooter true def
/footerString (CalcProxy        Xanadu Operating Company Proprietary   ---   1 April 1992 at 8:42:39 am) def
/doPageNumbers true def
72.0 720.0 moveto
10 (Helvetica-Bold)  F
/yDelta 11.6667 def
5.56 3.33333 0.48618 5.84 5.0 0.48618 ArrowDim
(Calc subclass: #CalcProxy) show
CR
90.0 708.333 moveto
(instanceVariableNames: 'mySpecialist {RPCSpecialist}') show
CR
90.0 696.667 moveto
(classVariableNames: '') show
CR
90.0 685.0 moveto
(poolDictionaries: '') show
CR
90.0 673.333 moveto
(category: 'Xanadu-Calc') show
8 (Helvetica-Oblique)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
CR
(CalcProxy methodsFor: generated:) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
(create: rcvr {Rcvr} with: spec {RPCSpecialist}) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
90.0 617.333 moveto
(super create.Rcvr: rcvr.) show
CR
90.0 608.0 moveto
(mySpecialist ) show
137.12 610.667 leftArrow
141.568 608.0 moveto 
( spec.) show
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({void} sendProxyTo: xmtr {Xmtr}) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
90.0 580.0 moveto
(super sendSelfTo: xmtr) show
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
CR
(CalcProxy methodsFor: generated: proxy accessing) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({void} plantPopSensor: arg1 {PopSensor}) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
( ) show
CR
90.0 533.334 moveto
(mySpecialist requestVoid: self with: 'plantPopSensor:' withHeaper: arg1) show
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({Rational} pop) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
90.0 505.333 moveto
90.0 505.333 upArrow
93.752 505.333 moveto 
(\050mySpecialist requestHeaper: self with: 'pop'\051 cast: Rational) show
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({void} push: arg1 {Rational}) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
( ) show
CR
90.0 477.333 moveto
(mySpecialist requestVoid: self with: 'push:' withHeaper: arg1) show
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({void} times) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
90.0 449.333 moveto
(mySpecialist requestVoid: self with: 'times') show
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({void} timesArg: arg1 {Rational}) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
( ) show
CR
90.0 421.333 moveto
(mySpecialist requestVoid: self with: 'timesArg:' withHeaper: arg1) show
CR
CR
CR
10 (Helvetica-Bold)  F
/yDelta 11.6667 def
5.56 3.33333 0.48618 5.84 5.0 0.48618 ArrowDim
(CalcProxy class) show
CR
90.0 381.667 moveto
(instanceVariableNames: '') show
8 (Helvetica-Oblique)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
CR
(CalcProxy class methodsFor: generated:) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
CR
CR
8 (Helvetica-Bold)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 4.672 4.0 0.388944 ArrowDim
({BooleanVar} isGenerated) show
8 (Helvetica)  F
/yDelta 9.33333 def
4.448 2.66667 0.388944 3.752 4.0 0.388944 ArrowDim
( ) show
173.368 335.0 upArrow
177.12 335.0 moveto 
(true) show
CR
CR
CR

finalPage
state restore
