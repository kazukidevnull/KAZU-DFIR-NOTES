## This document list various places on a windows system where information of interests for DFIR Triage resides as well as how to gather it and other important notes regarding doing so, like if there's only some systems which have a particular infomation and such

## the information found within this triage document is not made to cover everything but what provides the best information in least amount of time on a system as well as important triage notes, please check the the "General-dfir-notes" folder for more in depth informations on other tools, places and notes related to DFIR.


### SHIMCHACHE

### USER ACCOUNT LOGGING(UAL)

### PREFETCH

### SHELLBAGS
 
### NTFS MFT JOUNAL

### WMI DB

Use autoruns from sysinternals or powershell to inspect DB on a live system and KAPE together with "PyWMIPersitenceFinder.py on a dead system using 

 Location: C:\WINDOWS\system32\wbem\Repository\OBJECTS.DATA & 
 C:\WINDOWS\system32\wbem\Repository\FS\OBJECTS.DATA
 
 CONTAINS: 
