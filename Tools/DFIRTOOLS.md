# DFIRTOOLS
 
This Document contains various information regarding tools used for DFIR, tools listed here should be free/basically free helpful, for ease of overview in the future, 

all tools listed here comes under 3 different levels of usefulness.

"level 1" are tools that are most useful and/or commonly used. "level 2" are for tools that are still pretty good but is often a alternative to a "level 1" tool. 
"level 3" is for everything else that can be useful/helpful under certain circumstances but not for day to day stuff

Legend: 
TBW: To Be Written
## NOTES:
+ Zimmerman tools will have it's own document detailing the tools and details about how to us what in greater details in it's own document

## TOOLS


| Name | Author | Description | LINKS |
| --- | ----------- | ------- | ---- |
| ExifTool | Phil Harvey | show metadata of many types of files |
| vshadowinfo | Jaochim Metz | parse Volume Shadown Copies |
| ewfmount | Jaochim Metz | Mounting image files such as "E" case files|
| vshadowmount | Jaochim Metz | Mounting Volume Shadow Copies|
| Impacked | TBW | A collection of python classes for working with network protocols, is needed when dealing with NTLM hashes |
| Plaso | TBW | Python-based backend engine that powers 
| Log2Timeline | TBW | Tool designed to extract timestamps and forensic artifacts from a computer system to facilitate analysis and create what is referred to as a "Super Timeline" |
| FLS | TBW | Used to create File System Timeline and is part of The Sleuth Kit |
| Volatility | volatilityfundation | A advanced memory forensic framework | https://github.com/volatilityfundation/volatility |
| KAPA | Kroll and Eric Zimmerman | KAPE is an efficient and highly configurable triage program that will target any device or storage location, find and parse forensically useful artifacts | 
| USBDeviceForensics | TBW | TBW |
| DCode| TBW | Converts data to Date/Time values |
| analyzeMFT | dkovar | Designed to fully parse the MFT file from an NTFS Filesystem and present the result as accurately as possible in multiple formats
| INDXParser | TBW | Used to parse $I30 files |
| $I Parse | Jason Hale  | Used to parse $I files |
| bmc-tools | ANSSI-FR | RDP Bitmap cache parser | 
| SRUM-DUMP2 | Mark Baggett | SRUM Dump extracts information from the System Resource Utilization Management Database and creates a Excel spreadsheet. |
| PyWMIPersistenceFinder.py | davidpany | used to parse WMI file |
| RawCopy | jschicht | This a console application that copy files off NTFS volumes by using low level disk reading method | https://github.com/jschicht/RawCopy

### Tools to add later to the list above:


### Level 1

### LEVEL 2

| Name | Description |
| --- | ----------- |
| NAME | Description |

NetworkMiner

### LEVEL 3

| Name | Description |
| --- | ----------- |
| NAME | Description |


## Tools Details

### Plaso

Python-based backend egine that powers Log2Timeline and is also an extensible framework which means that new parsers and plug-ins can be added to provide additional functionality

can also parse files from all systems such as windows, unix and MacOS, even androids.

While plaso supports numerous file formats, if the artifacts to be parsed is not in one of those supported formats, a plugin have to be used instead of a parser.

Supports running on win, unix systems including MacOS.

### Log2Timeline

Tool designed to extract timestamps and forensic artifacts from a computer system to facilitate analysis and create what is referred to as a "Super Timeline" which is in contrast to other tools that create "File System Timeline" which only include file system-based metadata

Running L2T on it's own without any extra options except for the output and input will process all the files on the target system, which can be quick(less then a hour) or very slow(days) to go trough

| Description | Systax | Notes |
| ---- | ---- | ------ |
| List available parsers | log2timeline.py --parsers list |
| select and use a parser | log2timeline.py --parsers {PARSER-GROUP-NAME}{OUTPUT FILE}{TARGET} | To exclude a parser, use the "!" symbol in front of the parser you want to exlude, like "win7,\\!prefetch", the backslash is needed to escape Bash |

can any windows path to L2T and it will parse it, due to the number of places valuable infomation can be stored however, it is open best to use a pre-compiled list for all the places that have interesting things and then supply it using the "f" switch

one good list for such is the one made by "mark-hallman" named "plaso_filters" which have all the places that might be of interests when triaging a system.


### Super Timelines vs File System Timelines

"File System Timelines"(hereafter referred to as FST) can be created more quickly, and only include a small subset of data compared to a "Super Timeline"(hereafter referred to as ST)

This is sometimes to FST's advantage as it will allow to create a timeline quicker in a TRIAGE and get to informations quicker and then create a ST later 

Common tools that create FST are FLS(The Sleuth Kit) and MFTEcmd
    
ST include additional information compared to FTS, few of these are things like 
+ Windows Event Logs
+ Prefetch
+ Shellbags
+ Link Files



### Impacked

Impacked is a collection of python classes for working with network protocols. impacket is focused on providing low-level programmatic access to the packets and for some protocols(e.g. SMB1-3 and MSRPC) the protocol implementation itself. packets can be constructed from scratch, as well as parsed from raw data, and the object oriented API makes it simple to work with deep hierarchies of protocols. The library provides a set of tools as examples of what can be done with the context of this library

is needed when dealing with NTLM hashes




## Volatility:


### Prefetch parsing from memdump file

#### various plugins and libraries for volatility software that is needed to parse prefetch files

Open source implementations of Microsoft Compression algorithms:
https://github.com/coderforlife/ms-compress

+ run "./build" in ms-compress directory to build the libary first then move the "libMSCompression.so*" file to "/usr/lib"

volatility plugins:
https://github.com/superponible/plugins


### SRUM-DUMP2

SRUM Dump extracts information from the System Resource Utilization Management Database and creates a Excel spreadsheet.
The SRUM is one of the best sources for applications that have run on  your system in the last 30 days and is invaluable to your incident  investigations!

To use the tool you will need a copy of the SRUM (located in c:\windows\system32\sru\srudb.dat, but locked by the OS).
This tool also requires a SRUM_TEMPLATE that defines table and field  names. You can optionally provide the SOFTWARE registry hive and the  tool will tell you which wireless networks were in use by applications.

If you are looking for a version of this tool that creates CSV files  instead of an Excel spreadsheet, dumps targeted tables or processes any  ese then check out ese2csv.  ese2csv.exe is designed specifically for csv files with the CLI user in mind.

Source:
https://github.com/MarkBaggett/srum-dump

# tools and stuff to get to later

## Links
