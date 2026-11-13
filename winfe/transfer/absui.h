// A support class to abstract trivial user-interface things like error messages.

#ifndef ABSUI
#define ABSUI

#define FE_MYTEXTLEN 50
class FEDraft;

class FEUI {
	public:
    // tell the user something.
		static void tell(LPSTR message, LPSTR title);

		// ask the user a yes or no question
		static int ask(LPSTR question, LPSTR title);

		// beep at the user.
		static void beep();

		// get the parameters for logging in to the server.
		static void loginParams(char* hostBuf, char* loginBuf);

		// bring up the information dialog for the draft
    static void draftInformation(FEDraft* draft);

		// align a window with the edges of the screen
		enum Alignment {Default, Min, Center, Max};
		static void align (HWND,
			FEUI::Alignment horizontal,
			FEUI::Alignment vertical);

};

#endif // ABSUI

