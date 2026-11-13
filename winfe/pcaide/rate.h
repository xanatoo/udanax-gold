//FILEHEADING_BEGIN
//FILEHEADING_END

     /********************************************************************
      *
      *   Source File: RATE.h                                            *
      *   Description: AKORD CGL Form                                    *
      *   Author:      Ravi Pandya                                       *
      *   Date:        Fri May 07 10:29:55 1993                          *
      *
      ********************************************************************/


//HEADERFILE_BEGIN
//HEADERFILE_END
// Field number defines


HANDLE   hInst;                           // Global application instance handle
VIEW     RATE;                           // Main view handle
HWND     hWndRATE;


FARPROC    lpfnMakeLongPointer;

BOOL FAR PASCAL  MakeLongPointer();
