//FILEHEADING_BEGIN
//FILEHEADING_END

     /********************************************************************
      *
      *   Source File: MEMO.h                                            *
      *   Description: MEMO form                                         *
      *   Author:      Ravi Pandya                                       *
      *   Date:        Mon Mar 08 13:39:26 1993                          *
      *
      ********************************************************************/


//HEADERFILE_BEGIN
//HEADERFILE_END
// Field number defines


HANDLE   hInst;                           // Global application instance handle
VIEW     MEMO;                           // Main view handle
HWND     hWndMEMO;


FARPROC    lpfnMakeLongPointer;

BOOL FAR PASCAL  MakeLongPointer();
