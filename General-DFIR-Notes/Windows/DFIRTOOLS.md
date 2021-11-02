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


| Name | Author | Description | Link   |
| --- | ----------- | ------- | ------ |
| KAPA | Kroll and Eric Zimmerman | KAPE is an efficient and highly configurable triage program that will target any device or storage location, find and parse forensically useful artifacts | 
| USBDeviceForensics | TBW | TBW |
| DCode| TBW | Converts data to Date/Time values |
| analyzeMFT | dkovar | Designed to fully parse the MFT file from an NTFS Filesystem and present the result as accurately as possible in multiple formats
| INDXParser | TBW | Used to parse $I30 files |
| $I Parse | Jason Hale  | Used to parse $I files |
| bmc-tools | ANSSI-FR | RDP Bitmap cache parser | 
| Impacked | TBW | A collection of python classes for working with network protocols, is needed when dealing with NTLM hashes |
| SRUM-DUMP2 | Mark Baggett | SRUM Dump extracts information from the System Resource Utilization Management Database and creates a Excel spreadsheet. |
| Plaso | TBW | Python-based backend engine that powers 
| Log2Timeline | TBW | Tool designed to extract timestamps and forensic artifacts from a computer system to facilitate analysis and create what is referred to as a "Super Timeline" |
| FLS | TBW | Used to create File System Timeline and is part of The Sleuth Kit |
| PyWMIPersistenceFinder.py | davidpany | used to parse WMI file |
| RawCopy | jschicht | This a console application that copy files off NTFS volumes by using low level disk reading method | https://github.com/jschicht/RawCopy


### LEVEL 1

### LEVEL 2


NetworkMiner

### LEVEL 3


## Tools Details

### Impacked

Impacked is a collection of python classes for working with network protocols. impacket is focused on providing low-level programmatic access to the packets and for some protocols(e.g. SMB1-3 and MSRPC) the protocol implementation itself. packets can be constructed from scratch, as well as parsed from raw data, and the object oriented API makes it simple to work with deep hierarchies of protocols. The library provides a set of tools as examples of what can be done with the context of this library

is needed when dealing with NTLM hashes

### SRUM-DUMP2

SRUM Dump extracts information from the System Resource Utilization Management Database and creates a Excel spreadsheet.
The SRUM is one of the best sources for applications that have run on  your system in the last 30 days and is invaluable to your incident  investigations!

To use the tool you will need a copy of the SRUM (located in c:\windows\system32\sru\srudb.dat, but locked by the OS).
This tool also requires a SRUM_TEMPLATE that defines table and field  names. You can optionally provide the SOFTWARE registry hive and the  tool will tell you which wireless networks were in use by applications.

If you are looking for a version of this tool that creates CSV files  instead of an Excel spreadsheet, dumps targeted tables or processes any  ese then check out ese2csv.  ese2csv.exe is designed specifically for csv files with the CLI user in mind.

Source:
https://github.com/MarkBaggett/srum-dump





### Plaso Heimdall

### Useful CMD commands

| NAME | Description | SYNTAX | NOTES/REASON |
| ---- | ----------- | -------| ------------ |
| attrib | Changes attributes of files | attrib {OPTIONS}{SOURCE FILE} | some files, like NTFS root files, will have SH attributes which make them not visible anywhere, so use this command on exported files to remove them with "attrib -s -h {SOURCE FILE} " |
### Useful Powershell commands