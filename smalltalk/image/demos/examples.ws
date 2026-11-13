Workspace for Examples

The following is a small example workspace one can use for filing in and executing some of the examples.  You may need to edit the file names to add your path to these files.  It is intended for instructional purposes.


"Protocol Browser Example (in utils)"
	"To file it in:"
		(Filename named: 'ProtBrow.st') fileIn.
	"To execute it:"
		ProtocolBrowser openForClass: ProtocolBrowser.


"Project Browser Example (in utils)"
	"To file it in:"
		(Filename named: 'ProjBrow.st') fileIn.
	"To execute it:"
		ProjectBrowser open.


"Financial History Example (in demos)"
	"To file it in:"
		(Filename named: 'Finance.st') fileIn.
	"To execute it:
			 (See the method FinancialHistory class exampleWorkspace)"

				"do this first"
		Smalltalk at: #HouseholdFinances put: nil.

				"then these"
		HouseholdFinances _ FinancialHistory initialBalance: 1560.
		HouseholdFinances spend: 700 for: 'rent'.
		HouseholdFinances spend: 78.53 for: 'food'.
		HouseholdFinances receive: 820 from: 'pay'.
		HouseholdFinances receive: 22.25 from: 'interest'.
		HouseholdFinances spend: 135.65 for: 'utilities'.
		HouseholdFinances spend: 146.14 for: 'food'.
		FinancialHistoryView open: HouseholdFinances.



"Animation Example (in demos)"
	"To file it in:"
		(Filename named: 'Animate.st') fileIn.
	"To execute it:"
		WindowNode example.
	"terminate with any mouse button while cursor is in the view"


"Pointing Hand Example (in demos)"
	"To file it in:"
		(Filename named: 'ShowHand.st') fileIn.
	"To execute it:"
		"First, place the cursor inside a window"
		"Then, hold down the left-shift key on the keyboard"
		"Finally, press and hold down the 'view' mouse button"


"Toothpaste Example (in demos)"
	"To file it in:"
		(Filename named: 'Drawing.st') fileIn.
	"To execute it:"
		Form toothpaste.
	"'select' button draws, 'operate' button terminates"


"Counter View Example (in demos)"
	"To file it in:"
		(Filename named: 'Counter.st') fileIn.
	"To execute it:"
		CounterView open.
	"'operate' button for menu"


See also the example message at the end of the default System Workspace or try the simple drawing examples:
	Pen penSampler
	Pen new mandala: 30 diameter: 400.
	Pen new spiral: 200 angle: 89; home; spiral: 200 angle: -89.
	Pen new dragon: 8.
	Pen new filberts: 2 side: 20.
	Pen new hilberts: 4.
	Pen new hilbert: 4 side: 24. 

