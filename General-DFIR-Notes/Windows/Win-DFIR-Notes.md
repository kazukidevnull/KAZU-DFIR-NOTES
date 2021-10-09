# This document list various places on a windows system where information of interests for DFIR investigation resides as well as how to gether it and other important notes regarding doing so, like if there's only some systems which have a particular infomation and such

LEGEND:

TOI= Things Of Interests
-> = Right found inside Left
& = in addition to the one before this symbol
 
## files Found inside \System32\Config which are also found under "HKEY_LOCAL_MACHINE in the registry

+ bbimigrate folder
+ Jounal folder
+ RegBack folder (Used by windows for backup of certain config files)
+ systemprofile folder
+ TxR folder
+ BBI
+ BCD-Template
+ COMPONENTS
+ DEFAULT
+ DRIVERS
+ ELAM 
+ SAM 
+ SECURITY 
+ SOFTWARE 
+ SYSTEM 
+ userdiff 
+ VSMIDK

### Notes:

Following files are automatically backuped to the RegBack folder and is often missed by people doing anti-forensic, the following files included in this folder is:  

+ DEFAULT
+ SAM 
+ SECURITY
+ SOFTWARE
+ SYSTEM 


## RunMRU


## SHIMCHACHE

## USER ACCOUNT LOGGING(UAL)
## PREFETCH
## SHELLBAGS

Location:
+ HKCU\SOFTWARE\Microsoft\Windows\Shell

TOI: 
+ \BagMRU
+ \Bags

## NTFS MFT JOUNAL

## Explorer

Location: 
+ HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer

TOI: 

+ \ComDlg32 -> \LastVistedPidIMRU & \OpenSavePidIMRU: Contains last visited or opened things such as documents and such, may be useful for detecting deleted files
+ \RecentDocs: can show recent things that have been opened or interacted with such as running a program or opening a document
+ \RunMRU(Most Recently Used): lists programs and such that have been opened and in what order indicated by the order of the letters in "MRUList"

+ \TypedPaths: list paths manually typed in by the user(normally indicate the user knew of the path beforehand)
+ \UserAssist: shows evidence of application executions and how many times(ROT13 encoded)

## Run/run once at login/startup
Location: 
+ HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
+ HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
+ HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
+ HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce

## UsrClass

Location: 
+ %USERPROFILE%\AppData\Local\Microsoft\Windows\UsrClass.dat

### Notes 

Plugs into registry at HKCU\SOFTWARE\Classes

Was added in win7 for segmentation reason to still allow low intergrity proccesses which does not have permission to write to the registry to still write to the registry while still keeping it seperate from rest of the registry.




## USB STORAGE INFO

Location:

+ HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR (Class ID/Serial #)
+ HKLM\SYSTEM\CurrentControlSet\Enum\USB (VID/PID)
+ HKLM\SOFTWARE\Microsoft\Windows Portable Devices\Devices(Find Serial # and then look for FriendlyName to obtain the Volume Name of the USB device)
+ HKLM\SYSTEM\MountedDevices(Find serial # to obtain the Drive Letter of the USB device & Find serial # to obtain the Volume GUID of the USB device )

### NOTES 

#### About "CurrentControlSet"
+ "CurrentControlSet" is only visible on a live system, when doing forensics on a dead system, it will be replaces with "ControlSet001"
+ when doing forensic on a dead system, there may be multiple "ControlSet" files" with different numbers such as "001, 002, 003, etc" if windows had trouble starting up or tried correcting issues on startup
+ To check which controlset was last used, check the "Current" value in the "Select" registry directory under "HKLM\SYSTEM", the last digit indicate what controlset was last used

#### USBSTOR: 
+ if the '&' symbol is near the end of the serial string it is likely a global USB ID and will likely be the ID of the USB device itself and thus worth documenting, if '&' is close the the beginning(3th char) of the serial, it indicate the usb device does not follow MS guidelines so windows had to generate a ID unique on that system





Following information are found in the USBSTOR:
+ DeviceDesc
+ Capabilities
+ ContainerID
+ HardwareID
+ CompatibleIDs
+ ClassGUID
+ Service
+ Driver
+ Mfg
+ FriendlyName
+ ConfigFlags




## EMDMgmt

Location: 
+ HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\EMDMgmt

Find serial # to obtain the Volume Serial Number of the USB device.
+ The Volume Serial Number will be in decimal so need to be coverted to Hex
+You can find a complete history of Volume Serial Numbers here, even if the device has been formatted multiple times.
+ The USB device's Serial # will appear multiple times, each with a different VolumeSerial Number generated on each format

### NOTE: 

+ only present if the system is NOT using SSD as it was originally used for readyboost windows function
+ not the number of the device but the volume serial number

## WMI DB

Use autoruns from sysinternals or powershell to inspect DB on a live system and KAPE together with "PyWMIPersitenceFinder.py on a dead system 

 Location: 
 + C:\WINDOWS\system32\wbem\Repository\OBJECTS.DATA & 
 + C:\WINDOWS\system32\wbem\Repository\FS\OBJECTS.DATA
 
 CONTAINS: 

--------------

## NOTES:

All REGISTRY itself on disk are found at "\windows\system32\config"

Also important to note, windows protects all files in \config folder from being opened, edited, moved or copied, so to access or copy the files you need to use a tool such as FTK-Imager to do so or do so on a dead system

Every user has a NTUSER.dat file inside their Users folder which connects as HKCU to the registery

HKEY_CURRENT_USER is NTUSER.dat

Normally HKEY_CURRENT_USER are used when talking about a live system while NTUSER.dat when talking about a dead system.

"HARDWARE" and some other files found inside HKEY_LOCAL_MACHINE are dynamically generated at boot based on the hardware, drivers loaded and such 

