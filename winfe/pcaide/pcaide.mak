.AUTODEPEND

#                       *Translator Definitions*
CC = bcc +PCAIDE.cfg
TASM = TASM
TLINK = tlink

#                       *Implicit Rules*
.cpp.obj:
  $(CC) -c {$< }

#                        *List Macros*
Link_Exclude =  \
  PCAIDE.res

Link_Include = \
 PCAIDE.obj \
 AKORD.obj \
 RATE.obj \
 CPROF.obj \
 TABS.obj \
 MEMO.obj \
 UM.obj \
 ATTN.obj \
 PCAIDE.def

#                        *Explicit Rules*
PCAIDE.exe: PCAIDE.cfg $(Link_Include) $(Link_Exclude)
   $(TLINK)  /x/c/Twe/P-/C/L @&&|
c0wl.obj+
AKORD.obj+
RATE.obj+
CPROF.obj+
TABS.obj+
MEMO.obj+
UM.obj+
ATTN.obj+
PCAIDE.obj
PCAIDE
                     # no map file
owl.lib+
import.lib+
tclasdll.lib+
mathwl.lib+
pv.lib+
pvctl.lib+
crtldll.lib+
cwl.lib
PCAIDE.def
|
  RC -30 PCAIDE.res PCAIDE.exe

#                         *Individual File Dependancies*
PCAIDE.res: PCAIDE.rc
   RC -r -I -FO PCAIDE.res PCAIDE.RC

AKORD.obj: AKORD.cpp

RATE.obj: RATE.cpp

CPROF.obj: CPROF.cpp

TABS.obj: TABS.cpp

MEMO.obj: MEMO.cpp

UM.obj: UM.cpp

ATTN.obj: ATTN.cpp

PCAIDE.obj: PCAIDE.cpp

