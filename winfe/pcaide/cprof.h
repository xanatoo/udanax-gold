//FILEHEADING_BEGIN
//FILEHEADING_END

     /********************************************************************
      *
      *   Source File: CPROF.h                                           *
      *   Description:                                                   *
      *   Author:      Ravi Pandya                                       *
      *   Date:        Mon Mar 08 13:39:13 1993                          *
      *
      ********************************************************************/


//HEADERFILE_BEGIN
//HEADERFILE_END
// Field number defines


HANDLE   hInst;                           // Global application instance handle
VIEW     CPROF;                           // Main view handle
HWND     hWndCPROF;


VIEWPROC   lpfnMainWndProc;
FARPROC    lpfnMakeLongPointer;

LONG FAR PASCAL  MainWndProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL  MakeLongPointer();
