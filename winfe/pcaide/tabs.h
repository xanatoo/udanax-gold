//FILEHEADING_BEGIN
//FILEHEADING_END

     /********************************************************************
      *
      *   Source File: TABS.h                                            *
      *   Description:                                                   *
      *   Author:      Ravi Pandya                                       *
      *   Date:        Mon Mar 08 13:40:17 1993                          *
      *
      ********************************************************************/


//HEADERFILE_BEGIN
//HEADERFILE_END
// Field number defines


HANDLE   hInst;                           // Global application instance handle
VIEW     TABS;                           // Main view handle
HWND     hWndTABS;


VIEWPROC   lpfnMainWndProc;
LONG FAR PASCAL  MainWndProc(HWND, WORD, WORD, LONG);
HWND fn(HWND);
