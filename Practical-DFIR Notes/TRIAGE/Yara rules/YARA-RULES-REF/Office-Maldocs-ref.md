## Office Maldocs yara rules ref


this document have details about the various rules included in the "Office-maldocs" yara rule file:

-------------------------------------


## OLEVBA/Binary CFBF

This is rule olevba, for Office documents that use the binary CFBF aka ole file format

"uint32be(0) == 0xD0CF11E0" is a test to check if the file starts with D0CF11E0: that is the magic header of ole files.

The ASCII representation of 00 41 74 74 72 69 62 75 74 00 65 is ".Attribut.e", where the dot (.) represents a NULL byte. This sequence, is the start sequence of compressed VBA code generated by the VBA IDE (e.g., not been tampered with like VBA stomping).

If these 2 conditions are met, the YARA rule will trigger. False positives can occur, especially when string $attribut_e is found inside binary data that is not compressed VBA data.

Source:https://isc.sans.edu/forums/diary/Simple+YARA+Rules+for+Office+Maldocs/28062/

## pkvba/OOXML file

OOXML is essentially: a ZIP container, containing XML files.

using a regular expression (/[a-zA-Z\/]*\/?vbaProject\.bin/) to find filename vbaProject.bin. That's because the full filename is preceded by a path, and that path differs per type of Office document. For example, inside Word documents, that filename is "word/vbaProject.bin"

30 bytes before string "word/vbaProject.bin", one will find the header of the PKZIP file record

The header of a PKZIP file record starts with magic sequence "50 4B 03 04".

this is checked with the following clause in my YARA rule:

(uint32be(@vbaprojectbin[i] - 30) == 0x504B0304)

Since more than one instance of $vbaprojectbin can be found there's a need to tests all instances, to find one that fullfills all the conditions following expression is used:

for any i in (1..#vbaprojectbin): (...)

#vbaprojectbin is the number of instances (#) found.

i is an index (integer) that varies between 1 and the number of found instances.

@vbaprojectbin[i] represents the position of the found instance with index number i. Subtracting 30 from that position, brings me to the start of the PKZIP file record header. I check that this is indeed the case, by comparing with the magic sequence:

(uint32be(@vbaprojectbin[i] - 30) == 0x504B0304)

Another test performed in this rule is to check if the length of the found instance of string vbaprojectbin corresponds to the integer that is stored inside the filenamelength field of a PKZIP file record. That field is 4 bytes in front of the filename:

vbaProject.bin is the filename of the ole file that contains the VBA project.

If these conditions are met, the YARA rule will trigger.

Source: https://isc.sans.edu/forums/diary/YARA+Rule+for+OOXML+Maldocs+Less+False+Positives/28066/

## 