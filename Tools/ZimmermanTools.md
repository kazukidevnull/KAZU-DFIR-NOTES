# DFIRTOOLS
 
This Document contains various information regarding all the tools by eric zimmerman which are used for DFIR for ease of reference in the future, 


Legend: 
TBW: To Be Written


## TOOLS

Name | Description |
| --- | ------- |
| AmcacheParser 	        | Amcache.hve parser with lots of extra features. Handles locked files |
| AppCompatCacheParser 	    | AppCompatCache aka ShimCache parser. Handles locked files |
| bstrings 	                | Find them strings yo. Built in regex patterns. Handles locked files |
| EZViewer 	                | Standalone, zero dependency viewer for .doc, .docx, .xls, .xlsx, .txt, .log, .rtf, .otd, .htm, .html, .mht, .csv, and .pdf. Any non-supported files are shown in a hex editor (with data interpreter!) |
| Evtx Explorer/EvtxECmd    | Event log (evtx) parser with standardized CSV, XML, and json output! Custom maps, locked file support, and more! |
| Hasher 	                | Hash all the things |
| JLECmd 	                | Jump List parser |
| JumpList Explorer         | GUI based Jump List viewer |
| LECmd 	                | Parse lnk files |
| MFTECmd 	                | $MFT, $Boot, $J, $SDS, and $LogFile (coming soon) parser. Handles locked files |
| MFTExplorer 	            | Graphical $MFT viewer |
| PECmd                     | Prefetch parser |
| RBCmd                     | Recycle Bin artifact (INFO2/$I) parser |
| RecentFileCacheParser     | RecentFileCache parser |
| Registry Explorer/RECmd   | Registry viewer with searching, multi-hive support, plugins, and more. Handles locked files |
| SDB Explorer 	            | Shim database GUI |
| ShellBags Explorer        | GUI for browsing shellbags data. Handles locked files |
| SQLECmd 	                | Find and process SQLite files according to your needs with maps! |
| SumECmd 	                | Process Microsoft User Access Logs found under 'C:\Windows\System32\LogFiles\SUM' |
| SrumECmd 	                | Process SRUDB.dat and (optionally) SOFTWARE hive for network, process, and energy info! |
| Timeline Explorer         | View CSV and Excel files, filter, group, sort, etc. with ease |
| VSCMount 	                | Mount all VSCs on a drive letter to a given mount point |
| WxTCmd                    | Windows 10 Timeline database parser |
                    
Other Tools 
Name | Description |
| --- | ------- |
| KAPE 	             | Kroll Artifact Parser/Extractor: Flexible, high speed collection of files as well as processing of files. Many many features |
| iisGeoLocate 	     | Geolocate IP addresses found in IIS logs, extracts unique IPs, records bad data from logs |
| TimeApp 	         | A simple app that shows current time (local and UTC) and optionally, public IP address. Great for testing |
| XWFIM              | X-Ways Forensics installation manager |
| Get-ZimmermanTools | PowerShell script to auto discover and update everything above. |

Other files
Name | Description |
| --- | ------- |
| nlog.config |	Place this in same directory as CLI tools and you can alter the colors used. Good for white background with black font, etc. Do not change anything but the colors.


### NOTES:
 

## Tools details


### EvtxECmd
+  the magic of this utility is in the maps that are included with EvtxECmd or that can be custom created, a map is used to convert the event data which is the meat of the event log which is the most important and unique part of the event to a more standardized and easier to understand format.
+ it's also VSS aware, so by using a simple command line option the tool will automatically iterate through all available volume shadows and extract the events from the specified file or directory path and even automatically deduplicate them, the tool will also allow you to explicitly include or exclude certain event IDs.


more info:
https://binaryforay.blogspot.com/2019/04/introducing-evtxecmd.html


### PECmd

PECmd.exe(Prefetch Explorer)
 
Parses and displays prefetch files(.pf),  

highlights the exe itself in yellow and all TEMP/TMP files in red, you can also add to the keyword list by using the -K perameter