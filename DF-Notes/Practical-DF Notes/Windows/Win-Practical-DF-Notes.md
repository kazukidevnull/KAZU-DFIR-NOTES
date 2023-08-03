## Notes related to the practical aspect of Windows DFIR





## Index
+ Event Log
+ Memory

### Event log

#### RDP Event ID 1029

When a computer initiate a connection, Event ID "1029" are created which contains the hash of the username being used, 

however, there's following problems:
+ It's in base64
+ it's also in SHA256

which essential means, you can NOT reverse it and get the name, however, you CAN compare it against know hashes, for instance, if there's 4 users on a system, just find out which of them generate that hash, and you have the name.

To generate a hash of the user without actually connecting each user you can use tool to generate hashes from username to compare, If you only have a couple username, then tool such as Cyberchef should be more then enough by using the following recipe:
1. add "Encode text" with Encoding = "UTF-16LE(1200)"
2. add "SHA2" with size = "256" and Rounds = "64" 
3. Add "From Hex" with Delimiter = "space"
4. Add "To Base64" with Alphabet = "A-Z-z0-9+/="
5. add username to input
6. BAKE!

If you need to go trough and match lots of users(maybe thousands) then tools that can automate it might be best, such as mikes "1029_crack.py tool which you can find over at https://github.com/BeanBagKing/1029_crack.py, Note: this is using python 2!

##### Notes:
this log is not visible by default in event viewer, so you have to open it in Event Viewer by going to the "%SYSTEMROOT%\system32\winevt\Logs" directory and selecting the "Microsoft-Windows-TerminalServices-RDPClient%4Operational" log

Also, do not include the "dash" after the "=" sign



## Accessing mounted Images from WSL

Since this is about WSL i putted this here.

If you need to access a Image while WSL is running and it won't appear in WSL, you can use the command `Sudo mount -t drvfs {drive-letter} /mnt/{mount point}` which will mount it and make it accessible in WSL.