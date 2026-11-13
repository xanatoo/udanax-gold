//  The manager for a history trail

#ifndef FECLIP
#define FECLIP

class FEClipManager {
public:
	/* Set up the ClipManager. */
	static void startup ();

  /* Return the SingleRef which is the current Xanadu clipboard. */
  static XuSingleRefP clipboard ();

  /* Copy newClip into the Xanadu clip and reset the Windows clip. */
  static void copy (XuSingleRefP newClip);

  /* Render the Xanadu clipboard in the format given. */
	static void renderFormat (UINT format);

  /* Render all formats. */
  static void renderAllFormats ();

  /* Return a XuSingleRef of the clipboard fetched from Windows. */ 
	static void paste ();

  /* Are any of our formats available? */
  static int canPaste ();
};

#endif // FECLIP

