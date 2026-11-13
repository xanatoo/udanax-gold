//FILEHEADING_BEGIN
//FILEHEADING_END

     /********************************************************************
      *
      *   Source File: UM.h                                              *
      *   Description:                                                   *
      *   Author:      Dean Tribble                                      *
      *   Date:        Mon Mar 08 13:40:31 1993                          *
      *
      ********************************************************************/


//HEADERFILE_BEGIN
//HEADERFILE_END
// Field number defines


HANDLE   hInst;                           // Global application instance handle
VIEW     UM;                           // Main view handle
HWND     hWndUM;


FARPROC    lpfnMakeLongPointer;

BOOL FAR PASCAL  MakeLongPointer();
