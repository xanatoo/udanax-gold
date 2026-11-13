//FILEHEADING_BEGIN
//FILEHEADING_END

     /********************************************************************
      *
      *   Source File: ATTN.h                                            *
      *   Description:                                                   *
      *   Author:      Ravi Pandya                                       *
      *   Date:        Sun Mar 07 11:19:23 1993                          *
      *
      ********************************************************************/


//HEADERFILE_BEGIN
//HEADERFILE_END
// Field number defines


HANDLE   hInst;                           // Global application instance handle
VIEW     ATTN;                           // Main view handle
HWND     hWndATTN;


VIEWPROC   lpfnMainWndProc;
LONG FAR PASCAL  MainWndProc(HWND, WORD, WORD, LONG);
HWND fn(HWND);
