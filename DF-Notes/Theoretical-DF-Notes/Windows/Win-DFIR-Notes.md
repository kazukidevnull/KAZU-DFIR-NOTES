## This document list various places on a windows system where information of interests for DFIR investigation resides as well as how to gather it and other important notes regarding doing so, like if there's only some systems which have a particular infomation and such

LEGEND:

NOTE: due to i am still trying to figure out best way to format and display everything, a lot of what is listed are not according to reality and some will be changed or removed in the future.

+ TOI= Things Of Interests, Sometimes there will be cases where all the information within something is of investigative interests, in these cases "TOI:" will just be listed with "ALL", in cases where there's a large amount of information within something which may be of interests except for a few parts, then the not equal symbol "=!" will be used at the start of the list of things to exclude
+ DFI = Directories Found Inside
+ {text}(THIS MAY CHANGE) = used to indicate information which is not fixed such as GUID, enconding or other information, Replace "text".

### Windows PIDs:


all windows PID's are divisible by 4, so system is always 4, pid 0 is reserved for the pseudo system idle process.

## files Found inside \\System32\\Config which are also found under "HKEY_LOCAL_MACHINE in the registry

+ Journal folder
+ RegBack folder: Used by windows for backup of certain config files
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

## Powershell Transcription logs

PTS are captured input/output of powershell commands, disabled by default but can be enabled by group policy or enable it trough the registry which can be found at "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription.

alternatively you can use the following commands to change it for local host using CMD:

reg add HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\Transcription /v EnableTranscripting /t REG_DWORD /d 0x1 /f
reg add HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\Transcription /v OutputDirectory /t REG_SZ /d C:/ /f
reg add HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\Transcription /v EnableInvocationHeader /t REG_DWORD /d 0x1 /f

the logs can also be enabled for specific users only by making the change in "HKEY_CURRENT_USER" instead of "HKEY_LOCAL_MACHINE", altought this is not recommended.

## Windows process genealogy

### windows process startup order

"System" starts "smss.exe" which starts the following processes before terminating itself(thus these have no parent)

+ csrss.exe 
+ wininit.exe 
+ winlogon.exe , 

"wininit.exe" then are responsible to start the following processes
+ Services.exe
+ Lsass.exe
+ lsaiso.exe(on wind10+ and only when credential guard is enabled, functionality is the split between this and lsass.exe)

Then Depending on what OS it is it "Services.exe" will then on win10+ start  
+ svchost.exe

which will then start 
+ runtimebroker.exe
+ taskhost.exe

or 

"services.exe" for versions below win10 will start
+ svchost.exe
+ taskhost.exe

regardlessy of the above,

"winlogon.exe" meanwhile will start 
+ userinit

which then starts
+ explorer.exe


### Windows process details

#### System

System have no parent and technically does not exist as There's no such thing as "system.exe" file on the system or anything like that 

+ Number of expected instances are: 1 
+ Associated user account: local system
+ start time: boot time
+ will mostly contain drivers and other things resposible for kernal mode initilization such as the kernel exe itself

#### smss.exe

smss is the session manager service which is responsible for creating new sessions

+ Image path is: System Root(C:\\Windows\\System32)
+ Expected instance: 1 for the "master" instance and another for each child instance per session
+ Associated user account: local system
+ Start time: seconds within boot time for the master instance

For each new session, smss.exe creates a new child instance, Once the child instance done it's work by initializing the new session by starting the "csrss.exe" (client server runtime subsystem) and then "wininit.exe" for session 0 and "windlogon.exe" for session 1 it terminates itself 

#### csrss.exe

it's the client server runtime subsystem resposible for implementing most of windows API and providing a lot of other windows features

+ image path: System Root(C:\\Windows\\System32)
+ parent process: smss.exe(which terminates itself and thus csrss shows no parent)
+ Expected instanced: 2 or more
+ Associated user accounts: local system
+ start time: seconds after boot for the first two instanced

#### wininit.exe

Is responsible for starting key background processes within session 0 which then starts service Control Manager (services.exe ) and "lsass.exe" (Local security authority subsystem service)

+ image path: System Root(C:\\Windows\\System32)
+ parent process: smss.exe(which terminates itself and thus wininit shows no parent)
+ Expected instanced: 1
+ Associated user accounts: local system
+ start time: seconds within boot time




#### services.exe

Responsible for implementing unified background process manager and service control manager(svchost.exe) which manager the services on the system  

+ image path: System Root(C:\\Windows\\System32)
+ parent process: wininit.exe
+ Expected instanced: 1
+ Associated user accounts: local system
+ start time: seconds within boot time

#### svchost.exe

Known as "the generic host process for windows services and is basically used for running service DLLs, it also have a number of parameters after the "-k" parameters which you should be familiar with and svchost without the "-k" parameter or unknown parameters after it are worth investigating.

+ image path: System Root(C:\\Windows\\System32)
+ parent process: services.exe
+ Expected instanced: numerous
+ Associated user accounts: vary, but will typically be local system, network service or local service, any others is worth investigating
+ start time: seconds after boot time but they can also be started after boot as needed


#### runtimebroker.exe

This part is only on win10 and above and used to facilitate universal interactions between universal windows platforms(UWPApps, which was formely know as metro apps) and the full windows API

Credential Guard are used to protect secrets and other creditials used by systems or apps

+ image path: System Root(C:\\Windows\\System32\\runtimebroker.exe)
+ parent process: wininit.exe
+ Expected instanced: 0 when Credential Guard is disabled and 1 when enabled
+ Associated user accounts: local system 
+ start time: within seconds of boot time


#### lsaiso.exe

are closely related to lsass and 

+ image path: System Root(C:\\Windows\\System32\\lsaiso.exe)
+ parent process: svchost.exe
+ Expected instanced: normally a 1-1 mapping between a UWP App to a runtimebroker instance
+ Associated user accounts: can vary but typical of the logged in users and/or local service accounts 
+ start time: can vary greatly

#### taskhost.exe'

Generic host process for windows tasks such as scheduled tasks and so forth and runs in a continues loop listening for trigger event such as defined schedule, event or other such things

+ image path: System Root(C:\\Windows\\System32)
+ parent process: services.exe on version earlier then win10 and svchost for version 10+
+ Expected instanced: 1 or more
+ Associated user accounts: can vary and be owned by logged in users and/or local service accounts 
+ start time: can vary greatly


#### lsass.exe

is the "Local security subsystem service" and responsible for autenticating users on the system

+ image path: System Root(C:\\Windows\\System32)
+ parent process: Services.exe
+ Expected instanced: 1
+ Associated user accounts: local system
+ start time: seconds within boot


#### winlogon.exe

Handles things related to interactive user logins and logoffs as well as launching "logonUI.exe" and so forth, does not do the actually autenthication but passes the login details to "lsass.exe"
  
+ image path: System Root(C:\\Windows\\System32)
+ parent process: smss.exe(which terminates itself and thus csrss shows no parent)
+ Expected instanced: 1 
+ Associated user accounts: local system
+ start time: seconds within boot for the first instance(session 1) and additional as needed which normally are trough remote logon or user switching.

#### userinit.exe

will specify the programs that is run when a user logs on, which will then run various scripts and other programs needed for the system to work such as network, explorer.exe and so forth

+ image path: System Root(C:\\Windows\\System32)
+ parent process: winlogon.exe
+ Expected instanced: 1
+ Associated user accounts: local system
+ start time: user logon

#### explorer.exe

is the windows GUI used to graphically interact with windows

+ image path: System Root(C:\\Windows)
+ parent process: userinit.exe(which is a instance of userinit which terminates itself afterwards)
+ Expected instanced: 1 per interactively logged on user
+ Associated user accounts: logged in users
+ start time: user logon

### 
## SHIMCHACHE

Is resposible to make sure backwards compatibilities and can contains some useful information in relations to DFIR.

Shimcache facts:
+ Provides Compability for older software running in newer version of windows
+ Executeable file name, file path and timestamp are recorded
+ Timestamp is the LAST modification time of the executeable file, it is NOT the time it was added to the shimcache
+ Windows 7/8/8.1 had a "execution flag" that could indicate if a program was executed or not
+ Windows 10 DOES NOT have this "execution flag" and thus you are NOT able to determined when the file was executed.
+ Files visible in Windows Explorer can determined what is added to the shimchache
+ timestamp is recorded in 64-bit format
+ Renaming or moving a executeable file will cause it to be "re-simmed", it will not however update the modification date as you are not modifying the file contents only the metadata, this fact can be used to determined if a file was renamed or not 
+ last 1024 entries are retained
+ Most tools tools will output data with the most recently shimmed entries at the top
+ stored in SYSTEM registry hive
+ shimcache will only be written to on shutdown or reboot, before that it's stored in memory
+ Shimcache can be used to show executable files present on or accessed via a system
+ using shimchache, it's possible to determined if a file once existed on a system or was accessed via a external drive or UNC path
due to the fact that data is only written to shimchache at shutdown and reboot it can make anti-forensic harder.
+ Extracting or Viewing executeable files using command prompt will NOT record the executeable file to shimcache.



## MACB(Modified, Accessed, MFT Record Change, Birth(creationg))

+ Used by windows to keep track of modification timestamps of windows files 
+ stored within "$STANDARD_INFORMATION"(also known as #$SI)
+ $STANDARD_INFO Attribute: stores file metadata such as flags, the file SID, the file owner and a set of MACB timestamps and is the timestamps collected by windows Explorer, fls, mactime, timestomp, find and other utilities related to timestamps
+ Is stored inside $MFT of a NTFS volume root and keeo tracks of all the files on the disk.
+ all NTFS metadata files will start with a "$"
+ Keeps track of all the files on disk, not only times but also permissions and ownership information
+ in some cases if the file is small enough, it will be also stored inside "$MFT" (known as "resident data")
+ there's more then one copy of the set of four timestamps stored within the MFT called "$FILE_NAME"(also known as $FN)
+ $FN: contains the filename in unicode and another set of MACB timestamps.
+ $FN is ONLY modifiable by windows kernel and not by users
+ when tools are used to change timestamps of files, it is usually only changing the "$SI" timestamps while not the "$FN" ones
+ Windows Explorer can only show MAB times and not C
+ if modified date is earlier then accessed or created timestamps, it indicate the file is a copy of another file
+ when using CMD/powershell to copy files, it reflect the time the copy operation occured which is not the case if done using Explorer 
+ windows use very high resolution for it's timestamps(Nanosec), so changed done by 3th party tools are easily detected by the lack of resolution, since FN information can not be changed, this fact is not really critical bu is nice to easily spot files that have been time and date modified.

### notes

Table of when each 4FN attribute is changed based on operation, C for "change" are left out which indicate MFT entry modification, windows explorer can only show the MAB, 

| Operation | Modified | Accessed | Birth(created)
| --- | ----------- | ------- | ------- |
| File Create | Yes | Yes | Yes |
| File Modify | Yes | No | No |
| File Copy | No(inherited)** | Yes | Yes |
| File access | No | No* | no |

Check links below for more in-depth overview of timestamps

https://www.sans.org/blog/digital-forensics-detecting-time-stamp-manipulation/?reply-to-comment=16788

https://www.sans.org/blog/control-panel-forensics-evidence-of-time-manipulation-and-more/


+ *Last Access attribute is disabled if "NtfsDisableLastAccessUpdate" key found inside HKLM\\SYSTEM\\CurrentControlSet\\Control\\FileSystem is set to "1" which is the default on windows systems

+ Does not mean access is never updated, but is only done so under certain circumstances.

+ ** copying a file inherits Modified timestamps attributes from the file being copied from.


## Windows NTFS Index Attributes($I30 INDX File)
$I30 indx files are found within various directories on a windows system

Each $I30 INDX file contains the following information

+ Full filename
+ Parent director
+ MACB timestamps($FN)
+ Size(Physical and logical)

$I30 also stores a duplicate set of $FN timestamps.

Also:

+ while normally $FN and $SI time is updating inconsiding with each others, In case of $I30 files, $FN mirrors those of $SI
+ Evidence of deleted or overwritten files may possible be present within the slack of the $I30 file
+ Hex signature(magic number) for INDX file are "49 4E 44 58"




## WMI(Windows Management Instrumentation)

(IMPORTANT NOTES: this whole topic should be re-written in the future as there's a lot of errors)


WMI is microsoft's implementation of WBEM(Web-Based Enterprise Management) which in turn are based on CIM(Common Information Model) which are a set of standards for administration of devices and applications

The purpose is to provide a way to manage various components of the operating systems, locally or remotely.

The current version are called MI(Management Infrastructure) which have robust API for developers to access the data.

As this is a buil-in component of windows, it does not need additional binaries and is often not affected by application whitelisting or other host-based security which means it's often abused by attackers for recon, persistence and script executions.
+ it's often hard to seperate normal and malicious activity unless you know what to look for.

WMI Db path:
+ %SYSTEMROOT%\system32\wbem\Repository

file:
+ OBJECTS.DATA

Powershell commands:
get eventfilter:
+ Get-WMIObject -Namespace root/Subscription -Class __EventFilter
Get EventConsumer:
+ Get-WMIObject -Namespace root/Subscription -Class __EventConsumer
Get Consumer Binding:
+ Get-WMIObject -Namespace root/Subscription -Class __FilterToConsumerBinding



### NOTES OF INTERESTS:
While SCM Event Log Filter" is know to be safe, it have been know to be used maliciously as well


#### __EventConsumer(SUPERCLASS)

__CLASS: CommandLineEventConsumer:
+ malicious activity is generally going to be of this type or "Activescript"

CommandLineTemplate: 
+ lists the command that is executed by the event consumer

__CLASS: NTEventLogEventConsumer: 
+ known good and is often whitelisted

#### __FilterToConsumerBinding

this shows filters that is binded to consumers

"SCM Event Log Filter" is a known good but malicious activity may hide as one.
### Tools you can use
On a live system:
+ autoruns from sysinternals and powershell

On a dead system:
+ KAPE which are then parsed trough tools such as "PyWMIPersistenceFinder.py"
### Notes

Event Filter: Defines the conditions that must be met before and event consumer is called.

Event Consumer: Perform actions such as running and exe or script once the conditions defined in the event filter have been met.

Binding: is the "marriage" of the Event Filter and Event Consumer, when a event occurs that matches the defined filter, the action specified via the consumer must occur.




## USER ACCOUNT LOGGING(UAL)(Not that UAL)
(NOTE: THIS TOPIC NEEDS IMPROVEMENTS AS IT DOES NOT RELECT UAL COMPLETELY) 
UAL collects user access and system related statistical data in near real time 

is often missed by anti-forensic's and may specially help in cases when the box have minimal logging and can tell a lot of what have happened. 

+ Present and enabled by default since server 2012
+ Collects user access and system-related statistical data in near real-time
+ Examples of services and roles from which data is collected include DNS, DHCP, IIS, WSUS, etc
+ SystemIdentity.mdb, Current.mdb and one more file with a GUID-based name should exist
+ SystemIdentity.mdb will track other UAL databases and contain basic server configuration info
+ Current.mdb, by default, will contain data for the past 24 hours
+ In addition to the current year, 2 years of historicaldata is kept in the other (GUID-named) databases
+ Database will be locked/in use when the system is running(use KAPE, RawCopy, etc)
+ Database repair may be necessary if the collected files are in a "dirty" state
+ Eric zimmerman's SumECmd and brian moran's KStrike can parse the artifact
+ These files are not on Windows Desktop, on server editions.

Stored within multiple .MDB files(ESE databases) located in 
+ c:\Windows\System32\LogFiles\SUM"

Information Contained within the files are things like:
+ Role GUID
+ Role description
+ Authenticated User Name
+ Total accesess
+ Insert Data
+ Last Access
+ IP Address
+ Client Name
+ Tenant ID

Note: Using KAPE for this may be not a good idea as it have been reported unrepairable files when this tool are used, so use tools like RawCopy instead.

If database is dirty, use the window build in "esentutl.exe" tool with the "/p {dbname}.mdb" parameters

References:

https://advisory.kpmg.us/blog/2021/digital-forensics-incident-response.html

## PREFETCH(technically "Prefetcher")

Was introduced with Winxp and monitors up to the first 10 seconds of an application's execution in a attempt to cache it for later to speed up future subsequent launches and reducing the need to use disk access and instead memory which is a lot quicker and uses the ".pf" file extensions for it's files

Paths
+ C:\Windows\Prefetch

As mentioned, 10sec is prefetch's maximum monitoring time of a file execution, but the actually time will vary greating depending on the size and complexity of the program with the average time between 4-8 seconds, running things like CMD will for instance be less then a second.

The Prefetch files are named after the binary of the file it monitored starting with the name of the executed binary and then a dash followed by a hash value from windows own algo,
+ The hash algorithm used varies by each windows system OS 
+ file naming hash is computed based on the full path and name of the executeable
+ in some cases even commandline parameter is included in the hash and with parameters and path affecting the hash, such as with dllhost.exe, mmc.exe and rundll.exe
+ There will be multiples prefetch files for the binaries mentioned above dllhost.exe, mmc.exe and rundll.exe and other system files as a new PF us created for each different parameter and such
+ if the date modified is different then date created, it means binary was a least runned twice
 + you can check file properties of prefetch file for higher timestamp resolution

Prefetch file naming algorithm order:

+ The full path for the file is determined e.g. c:\windows\notepad.exe.
+ The path isconverted to Unicode string.
+ The full path is converted from to a device path e.g. \DEVICE\HARDDISKVOLUME1\WINDOWS\NOTEPAD.EXE.
+ Now, the hashing function is applied to the buffer.
+ Then the Prefetch file name is determined as a filename-hash e.g. CALC.EXE-02CD573A.pf.


Important Note:

+ Prefetch is only enabled on windows workstations by default and not servers 
+ some anti-forensic tools or malwares may delay their execution past the their first 10 sec to avoid prefetch from logging their activity
+ windows XP, Vista and 7 limited the maximum number of prefetch files to 128
+ windows 8 extented that number to 1,024
+ Oldest files are removed first
+ when looking at pf files date modified and created, subtract aprox 10sec(likely less) as file will only be written once monitoring is done
+ "access" data is the least useful timestamp avaiable as there's too many things that can affect it to be reliable
+ When a program is re-executed, the existing prefetch file   associated with that program is referenced, the same file is also   updated to reflect infomation about the current execution,
  
  however, both reading and updating the file can not occur at the   same time, to accomplish this, windows use "File System Tunneling"   which result in the cluster run associated with the previous   Prefetch file will be discarded on each susequent execution, 
    
  the discarded files are stll present in unallocated space however

Each .pf file contains:

+ Date Created
+ Date Modified
+ Date Last accessed(just ignore this one)
+ executeable name
+ pf file hash value
+ File size(in bytes)
+ version(from what windows version it's from)
+ Run count
+ Last Run
+ other run times(Max 8 and check notes below)
+ Volume Information(such as GUID, SERIAL, created, directories and files referenced)

NOTE: also note that the "last run/other run times" time is the true time something was executed and the "modified/Created time" includes the delta between monitoring of executeable started and then stopped and saved.

"other run times" which shows max 8 latest run times, are only available from win8+

Generally, if the PF file is from win+ you will be able to see the first and last 8 times something was executed, if pre win8, then it will only show last run time and how many times the executable have run,

 ### tools to parse Prefetch files
 + PECmd.exe(Prefetch Explorer) by Eric zimmerman(it also highlights the exe itself in yelow and all TEMP/TMP files in red, you can also add to the keyword list by using the -K perameter)



## Recycle bin

Location**: 
+ c:\\$Recycle.bin\\SID*\\$Ixxxxxx(contains file metadata)
+ c:\\$Recycle.bin\\SID*\\$Rxxxxxx(contains content of the actually file)

*The SID Sub-folder corresponds to the SID of the user who deleted the file. The sub-folder is created for a given user upon first deletion of a file that is send to the recycle bin 

**for windows vista and Later

Contains:

+ File name(\\$Ixxxxxx)
+ full path of the deleted file(\\$Ixxxxxx)
+ Size of the deleted file(\\$Ixxxxxx)
+ Date/Time at which the file was deleted(\\$Ixxxxxx)
+ File content(\\$Rxxxxxx)

### NOTE

Prior to win10 the $I file did not have "File Name Lenght" data which replaced the offset value of "24" for "File Name" and moved it to offset of 28.

| $I file structure prior to Windows 10 
| Offset | Size | Description |
|-----|------|-----|
| 0 | 8 | Header |
| 8 | 8 | File Size |
| 16 | 8 | Deleted Timestamp |
| 24 | 520 | File Name |

Windows 10+
| Offset | Size | Description |
|-----|------|-----|
| 0 | 8 | Header |
| 8 | 8 | File Size |
| 16 | 8 | Deleted Timestamp |
| 24 | 4 | File Name Lenght |
| 24 | var | File Name |

Due to this, the $I files from a Windows 10+ system will typically be smaller due to the Lenght value which make it only as big as needed, it also make it possible to tell if the $I file come from a Win10+


Link to Additional informations:
https://df-stream.com/2016/04/fun-with-recycle-bin-i-files-windows-10/

## LNK Files

The Windows Shortcut file has the extension .lnk. It basically is a metadata file, specific for the Microsoft Windows platform and is interpreted by the Windows Shell. The file format indicates that these files contain a specific signature, 0x4C (4C 00 00 00) at offset 0 within the file/stream. Further, the GUID (CLSID) 00021401-0000-0000-c000-000000000046 stored at byte offset 4 makes a good identifier. 

Path:
+ C:\Users\\\[username\]\\Appdata\\Roaming\\Microsoft\\Recent
+ C:\Users\\\[username\]\\Appdata\\Roaming\\Microsoft\\Office\\Recent(if MS office are installed)

Contains:
+ Timestamps for the target file and link file such as modification, access and creation.
+ Size of the target file
+ Attributes associated with the target file such as Read-Only, Hidden, System and so forth.
+ System Name, Volume Name, Volume Serial Number and sometimes the MAC address of the system on which the link file is present.
+ Information indicative of whether or not the target resource is local or located on remote computer
+ creation time of the link file will usually indicate the date and time that the target file was first opened 
Modification time of the link file will usually indicate the time and date the target file was last opened.
+ starting with win10+ the extension is included in the name in addition to .lnk at the end.

TOI:ALL

Also, even if the terget file is deleted, the LNK file may contain all the information needed of the delete file.

### Further References:

https://forensicswiki.xyz/wiki/index.php?title=LNK

https://www.magnetforensics.com/blog/forensic-analysis-of-lnk-files/

## Jump Lists

Jump-Lists was introduced with win7 and was created to make it easier for users to jump to common tasks or recent files.

There exist 3 different "flavors" of jump lists:

+ automatic (autodest, or *.automaticDestinations-ms) files
+ custom (custdest, or *.customDestinations-ms) files
+ Explorer StartPage2 ProgramsCache Registry values
+ Neither "AutomaticDestinations" or "CustomDestinations" will be visible in the recent folder when using windows explorer even if you have the settings to view all files enabled, using CMD is needed to see them


### AutomaticDestinations

The AutomaticDestinations Jump List files are located in the user profile path and contains jump lists provided by the Winodws API that are common acroos all applications:

Path:
+ C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations

Files: 
+ *.automaticDestinations-ms

Structure:

The AutomaticDestinations Jump List files are OLECF files (OLE: Object Linking and Embedding + CF: Compound Files)  

+ containing multiple streams of data within a single file
+ also referred to as a "compound Binary File" and is extensively used within MS office documents
+ within .automaticdestinations-ms, each stream contains and embedded LNK file which can be extracted and parsed
+ hexadecimal numbered, e.g. "1a"
+ DestList: acts as a MRU(Most Recently Used) List
+ each ".automaticDestinations-ms" file starts with a app ID which identifies the app.

Each of the hexadecimal numbered streams contains data similar of that of a Windows Shortcut (LNK). One could extract all the streams and analyze them individually with a LNK parser.

The "DestList" stream acts as a most recently/frequently used (MRU/MFU) list. This stream consists of a 32-byte header, followed by the various structures that correspond to each of the individual numbered streams. Each of these structures is 114 bytes in size, followed by a variable length Unicode string. The first 114 bytes of the structure contains the following information at the corresponding offsets: 

| Offset | Size | Description
| ---- | ---- | ------- |
0x48 | 16 bytes | NetBIOS name of the system; padded with zeros to 16 bytes |
0x58 | 8 bytes | Stream number; corresponds to the numbered stream within the jump list |
0x64 | 8 bytes | Last modification time, contains a FILETIME structure |
0x70 | 2 bytes | Path string size, the number of characters (UTF-16 words) of the path string |
0x72 | ... | Path string | 

### CustomDestinations

The CustomDestinations Jump List files are located in the user profile path and provides application specific features that can vary depending on how the developer have implemented it.
+ CustomDestinations-ms are not in OLECF format and do not contain streams
+ series of LNK files sequentially appended to each others
+ LNK file data can often be carved from these files
Manual parsing via Hex editor is also possible
+ are also created when a user pin things to the task menu.


Path: 
+ C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations

Files: 
+ *.customDestinations-ms

Structure: 
+ CustomDestinations Jump List files reportedly follow a structure of sequential MS-SHLLINK binary format segments. 


## Windows Shadow Volumes

Used by windows to create periodically "snapshots" and used to create restore points, was not used for restore points until Windows vista+.

+ Block level differetial copy in 16k chunks
+ stored in the root of the boot volume in the system volume information folder
+ on a windows workstation snapshot is done on a weekly basis while done daily on a Windows Server(unless changed)
+ uses aproximately 3-5% of the disk size 

use "vssadmin list shadows" command as a admin to list shadow volumes currently on the system.

To easily access volumes shadowns on a system, just use the "mklink /d \[Name to use\] \[Shadow Copy Volume path\]\\
+ backslash importent to include or else you get permission error on created link folder


## RDP(mstsc) Cache

Used to cache section of the screen which infrequently change
+ Stored in .BIN files containing 64x64 bitmap files.
+ cache is not written in any predictable order, movement of mouse coursor likely affects this as well.

Location:
+ C:\Users\\\[username\]\\AppData\Local\Microsoft\Terminal Server Client\Cache

## RDP Event Log

Windows Event logs stores events related to RDP connection activity
+ thses events may appear out of order and some may not even be present.
+ logs found on TARGET system, not the system it was connected from
+ to add logs to the "saved log section of event viewer such as LocalSessionManager and RemoteSessionmanager, go to "actions" then Open Saved Log and browse to "%SYSTEMROOT%\System\winevt\logs" and selct the needed log

EVENT ID:

*Source: Ponderthebits(check reference section at the end)

Logon: 
| Status | Event | Event ID | Description | Log Location | Notes |
| --- | ----- | -------- | ----------- | -------- | --- |
| Successful Logon | Network Connection | 1149 | User Authentication succeeded | Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx |
| Successful Logon | Authentication | 4624(Type 10 7 for Reconnect) | An account was successfully logged on | Security.evtx |
| Successful Logon | Logon | 21 | Remote Desktop Services: session logon succeeded | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Successful Logon | Logon | 23 | Remote Desktop Services: Shell start notification received | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Unsuccessful Logon | Authentication | 4625(10, 7 for reconnect) | An account failed to log on | Security.evtx | Event ID 1149 will preceed this event as 1149 is referencing the network connection itself and not the actually logon |


Session Disconnect(Window closed):
| Status | Event | Event ID | Description | Log Location | Notes |
| --- | ----- | -------- | ----------- | -------- | --- |
| Session Disconnect(Window closed) | Network Connection | 24 | Remote Desktop Services: session has been disconnected | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Session Disconnect(Window closed) | Session Disconnect/ Reconnect | 40 | Session <X> has been disconnected, reason code <Z> | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Session Disconnect(Window closed) | Network Connection   | 4779 | A session was disconnected from a Window Station | Security.evtx |
| Session Disconnect(Window closed) | Logoff | 4634 | An account was logged off | Security.evtx |


Session Disconnect via (disconnect menu option):
| Status | Event | Event ID | Description | Log Location | Notes |
| --- | ----- | -------- | ----------- | -------- | --- |
| Session Disconnect(via disconnect menu option) | Network Connection | 24 | Remote Desktop Services: session has been disconnected | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Session Disconnect(via disconnect menu option) | Session Disconnect/ Reconnect | 39 | Session <X> has been disconnected by session <Y> | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Session Disconnect(via disconnect menu option) | Session Disconnect/ Reconnect | 40 | Session <X> has been disconnected, reason code <Z> | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| Session Disconnect(via disconnect menu option) | Network Connection   | 4779 | A session was disconnected from a Window Station | Security.evtx |
| Session Disconnect(via disconnect menu option) | Logoff | 4634 | An account was logged off | Security.evtx |

RDP Session Reconnect:

| Status | Event | Event ID | Description | Log Location | Notes |
| --- | ----- | -------- | ----------- | -------- | --- |
| RDP Session Reconnect | Network Connection | 1149 | User Authentication succeeded | Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx |
| RDP Session Reconnect | Authentication | 4624 type 7) | An account was successfully logged on | Security.evtx |
| RDP Session Reconnect | Session Disconnect/Reconnect | 25 | Remote Desktop Services: session reconnection succeeded | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx |
| RDP Session Reconnect | Session Disconnect/ Reconnect | 40* | Session <X> has been disconnected, reason code <Z> | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx | Events also indicate/correlate to reconnections | 
| RDP Session Reconnect | Session Disconnect/Reconnect | 4778 | A session was reconnected to a windows station | Security.evtx |

RDP Session Logoff:

| Status | Event | Event ID | Description | Log Location | Notes |
| --- | ----- | -------- | ----------- | -------- | --- |
| RDP Session Logoff | Logoff | 23 | Remote Desktop Services: Session logoff suceeded | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx
| RDP Session Logoff | Logoff | 4634 | An account was logged off | Security.evtx |
| RDP Session Logoff | Logoff | 4647 | User initiated logoff | Security.evtx |
| RDP Session Logoff | Logoff | 9009 | The Desktop Window Manager has exited with code (<X>) | System.evtx |
### Further References:

https://ponderthebits.com/2018/02/windows-rdp-related-event-logs-identification-tracking-and-investigation/


## SHELLBAGS

Location:
+ HKCU\\SOFTWARE\\Microsoft\\Windows\\Shell

TOI: 
+ \\BagMRU
+ \\Bags

## NTFS MFT JOUNAL

Maintains a transactional record of all changes made such that is able to keep track of everything that is happening so it can recover from faults such as crashes, power failues or other events that may affect the intergrity by either undo changes or continue where it left off.

Contains a lot of useful information for DFIR related infomation such as the only way to prove something was deleted from an NTFS volume. 

Mantain two different journals
+ USN JOURNAL
+ LOGFILE

### USN Journal

Also know as "The update sequence number journal" or simple "change Journal" and tracks changes of the actual files and directories on disk 

+ Stored within the root of the volume in the $EXTEND Directory within the $USNJRNL File
+ Contains Alternative Data Streams which contains additional data attributes which are $MAX and $J(and also a file called $J.FileSlack)
+ The $J is the one of most interests for investigative purposes as it tracks all the changes to each file and directory along with reason for it
+ USN value stored in $SI($Standard_Information) in the "direct index into $J" attribute which are referenced from within the $J file and contains a record of each files USN value[POORLY WRITTEN; CLEAN UP LATER]
+ Used by Backup and anti-malware softwares to avoid touching every file on disk for performance reason

### LOGFILE

Stored in the root of the volume in a file called $LOGFILE and tracks changes to MFT metadata such as timestamps, etc


## Explorer

Location: 
+ HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer

TOI: 

+ \\ComDlg32 -> \\LastVistedPidIMRU & \\OpenSavePidIMRU: Contains last visited or opened things such as documents and such, may be useful for detecting deleted files
+ \\RecentDocs: can show recent things that have been opened or interacted with such as running a program or opening a document
+ \\RunMRU(Most Recently Used): lists programs and such that have been opened and in what order indicated by the order of the letters in "MRUList"

+ \\TypedPaths: list paths manually typed in by the user(normally indicate the user knew of the path beforehand)
+ \\UserAssist: shows evidence of application executions and how many times(ROT13 encoded)

## Run/run once at login/startup
Location: 
+ HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run
+ HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\RunOnce
+ HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run
+ HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\RunOnce

## UsrClass

Location: 
+ %USERPROFILE%\\AppData\\Local\\Microsoft\\Windows\\UsrClass.dat

### Notes 

Plugs into registry at HKCU\\SOFTWARE\\Classes

Was added in win7 for segmentation reason to still allow low intergrity proccesses which does not have permission to write to the registry to still write to the registry while still keeping it seperate from rest of the registry.



## USB STORAGE INFO

Location:

+ HKLM\\SYSTEM\\CurrentControlSet\\Enum\\USBSTOR (Class ID/Serial #)
+ HKLM\\SYSTEM\\CurrentControlSet\\Enum\\USB (VID/PID)
+ HKLM\\SOFTWARE\\Microsoft\\Windows Portable Devices\\Devices(Find Serial # and then look for FriendlyName to obtain the Volume Name of the USB device)
+ HKLM\\SYSTEM\\MountedDevices(Find serial # to obtain the Drive Letter of the USB device & Find serial # to obtain the Volume GUID of the USB device )

### NOTES 
+ windows will periodically clean out the USBSTOR, USB, etc registry for USB devices that have not been used for a while, so checking secondary places not affected by the cleaning may be required.
#### About "CurrentControlSet"
+ "CurrentControlSet" is only visible on a live system, when doing forensics on a dead system, it will be replaces with "ControlSet001"
+ when doing forensic on a dead system, there may be multiple "ControlSet" files" with different numbers such as "001, 002, 003, etc" if windows had trouble starting up or tried correcting issues on startup
+ To check which controlset was last used, check the "Current" value in the "Select" registry directory under "HKLM\\SYSTEM", the last digit indicate what controlset was last used

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


## Windows Event Logs

Location: C:\Windows\System32\winevt\Logs

## EMDMgmt

Location: 
+ HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\EMDMgmt

Find serial # to obtain the Volume Serial Number of the USB device.
+ The Volume Serial Number will be in decimal so need to be coverted to Hex
+ You can find a complete history of Volume Serial Numbers here, even if the device has been formatted multiple times.
+ The USB device's Serial # will appear multiple times, each with a different VolumeSerial Number generated on each format

### NOTE: 

+ only present if the system is NOT using SSD as it was originally used for readyboost windows function
+ not the number of the device but the volume serial number

## WMI DB

Use autoruns from sysinternals or powershell to inspect DB on a live system and KAPE together with "PyWMIPersitenceFinder.py on a dead system 

 Location: 
 + C:\\WINDOWS\\system32\\wbem\\Repository\\OBJECTS.DATA & 
 + C:\\WINDOWS\\system32\\wbem\\Repository\\FS\\OBJECTS.DATA
 
 CONTAINS: 

 ## TimeZoneInformation

 Location:
 + HKLM\\SYSTEM\\CurrentControlSet\\Control\\TimeZoneInformation

Have information regarding current timezone of the system and other stuff related to current timezone time


 TOI: TimeZoneKeyName



 ## ComputerName

 Location:
 + HKLM\\SYSTEM\\CurrentControlSet\\Control\\ComputerName\\ComputerName

 TOI:ComputerName: Name of the system

 ## LanmanServer(Shares)

 Location:
 + HKLM\\SYSTEM\\CurrentControlSet\\services\\LanmanServer\\Shares

have information regading any shares configured on the system. 

DFI:
+ Aliases
+ AutotunedParameters
+ Default Security
+ Linkage
+ Parameters
+ ShareProviders
+ Shares

TOI:
+ LanmanServer\\Shares\\

## FileSystem

Location:
+ HKLM\\SYSTEM\\CurrentControlSet\\Control\\FileSystem

Contains various NTFS FileSystem setting to enable or disable a feature such as: 
+ DisableDeleteNotification
+ FilterSupportFeaturedMode
+ LongPathsEnabled
+ NtfsAllowExtendedCharacter8dot3Rename
+ NtfsBugcheckOnCorrupt
+ NtfsDisable8dot3NameCreation
+ NtfsDisableCompression
+ NtfsDisableEncryption
+ NtfsDisableLastAccessUpdate
+ NtfsDisableVolsnapHints
+ NtfsEncryptPagingFile
+ NtfsMemoryUsage
+ NtfsMftZoneReservation
+ NtfsQuotaNotifyRate
+ SymlinkLocalToLocalEvaluation
+ SymlinkLocalToRemoteEvaluation
+ SymlinkRemoteToLocalEvaluation
+ SymlinkRemoteToRemoteEvaluation
+ UdfsCloseSessionOnEject
+ UdfsSoftwareDefectManagement
+ Win31FileSystem
+ Win95TruncatedExtensions

TOI: 
+ Look for "NtfsDisableLastAccessUpdate", which is set to '0x1' by default, which means that access time stamps are turned OFF by default

## Tcpip

 
Location:
+ HKLM\\SYSTEM\\CurrentControlSet\\services\\Tcpip\\Parameters\\Interfaces

Contains information regarding network interfaces configured on the system

TOI:
+ display interfaces and their associated IP address configurations(take specially note of the GUID)

## Network Location Awareness(NLA)

Location: 
+ nHKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\NetworkList


+ Network Location Awareness(NLA) was included in Vista and up, and aggregates the network information for a PC and generates a GUID to identify each network(a "network profile"). The Windows Firewall uses that information to apply firewall rules to the appropiate profile. You can find evidences of every network a machine has connected to using NLA registry keys.
+ check the last write time of a key to determine the last time a PC connected to a network

+ DFI:
+ DefaultMediaCost
+ NewNetworks
+ Nla
+ Permissions
+ Profiles
+ Signatures -> \\Managed & \\Unmanaged

TOI:
+ \\Signatures\\Unmanaged\\: DefaultGatewayMac, DNSSuffix, FirstNetwork(SSID), ProfileGuid
+ \\Managed
+ Nla
+ Profiles: Have folder which GUID of networks


### Notes

\\profiles\\{GUID}\\NameType: value of 6 indicate a wired network, 47 indicate a wireless network and 17 would indicated a broadband connectiong(such as celluar)

\\profiles\\{GUID}\\DateCreated:Time in "128-bit windows system time structure stored in UTC, so time need to be converted(remove dashes if you use DCode tool)

\\profiles\\{GUID}\\DateLastConnected:Time in 128-bit windows system time structure stored in UTC, so time need to be converted(remove dashes if you use DCode tool)

On a wirless network, the FirstNetwork will contain the SSID of the network.

Most info regarding NLA will be stored under the NetworkList key above and also in HKLM\\SOFTWARE\\Microsoft\\WindowsCurrentVersion/HomeGroup which have the following information 

+ network type
+ First/Last time connected

## LNK files

 

--------------

## General NOTES:

All REGISTRY itself on disk are found at "\\windows\\system32\\config"

Also important to note, windows protects all files in \\config folder from being opened, edited, moved or copied, so to access or copy the files you need to use a tool such as FTK-Imager to do so or do so on a dead system

Every user has a NTUSER.dat file inside their Users folder which connects as HKCU to the registery

HKEY_CURRENT_USER is NTUSER.dat

Normally HKEY_CURRENT_USER are used when talking about a live system while NTUSER.dat when talking about a dead system.

"HARDWARE" and some other files found inside HKEY_LOCAL_MACHINE are dynamically generated at boot based on the hardware, drivers loaded and such 


## EVENTTRANSCRIPT.db

