# File Magic Numbers



## IMPORTANT NOTE:

This whole document is pretty much a pure copy taken directly from the source listed below, this Document is purely for ease of reference only and to make it conveniently accessible for myself in cases where i need access to the the info when offline, while i will naturally try spot errors as i see them and update with my own info or when the source is updated, you should head the source itself and keep yourself for the latest update 

Source: https://gist.github.com/leommoore/f9e57ba2aa4bf197ebc5 

---------------------------------------


Magic numbers are the first bits of a file which uniquely identify the type of file. This makes programming easier because complicated file structures need not be searched in order to identify the file type.

For example, a jpeg file starts with ffd8 ffe0 0010 4a46 4946 0001 0101 0047 ......JFIF.....G ffd8 shows that it's a JPEG file, and ffe0 identify a JFIF type structure. There is an ascii encoding of "JFIF" which comes after a length code, but that is not necessary in order to identify the file. The first 4 bytes do that uniquely.


## Image Files

| File type | Typical extension |	Hex digits xx = variable  |	Ascii digits . = not an ascii char |
| --------- | ------------------- | ------------------------- | ---------------------------------- |
| Bitmap format                       | .bmp 	      | 42 4d                             | 	BM     | 
| FITS format                         | .fits         | 53 49 4d 50 4c 45                 | 	SIMPLE | 
| GIF format                          | .gif          | 47 49 46 38                       | 	GIF8   | 
| Graphics Kernel System              | .gks          | 47 4b 53 4d                       | 	GKSM   | 
| IRIS rgb format                     | .rgb          | 01 da                             | 	..     | 
| ITC (CMU WM) format                 | .itc          | f1 00 40 bb                       | 	....   | 
| JPEG File Interchange Format        | .jpg 	      | ff d8 ff e0 	                  |     ....   |
| NIFF (Navy TIFF)                    | .nif          | 49 49 4e 31                       | 	IIN1   | 
| PM format                           | .pm           | 56 49 45 57                       | 	VIEW   | 
| PNG format                          | .png 	      | 89 50 4e 47                       | 	.PNG   | 
| Postscript format                   | .[e]ps 	      | 25 21 |                           |      %!    | 
| Sun Rasterfile                      | .ras          | 59 a6 6a 95                       | 	Y.j.   | 
| Targa format                        | .tga          | xx xx xx                          | 	...    | 
| TIFF format (Motorola - big endian) | .tif          | 4d 4d 00 2a                       | 	MM.*   | 
| TIFF format (Intel - little endian) | .tif          | 49 49 2a 00                       | 	II*.   | 
| X11 Bitmap format                   | .xbm 	      | xx xx                             |            | 
| XCF Gimp file structure             | .xcf          | 67 69 6d 70 20 78 63 66 20 76     | gimp xcf   | 
| Xfig format                         | .fig          | 23 46 49 47                       | 	#FIG   | 
| XPM format                          | .xpm          | 2f 2a 20 58 50 4d 20 2a 2f 	      | /* XPM */  | 

## Compressed files

| File type | Typical extension |	Hex digits xx = variable  |	Ascii digits . = not an ascii char |
| --------- | ------------------- | ------------------------- | ---------------------------------- |
| Bzip         | .bz  | 42 5a       | BZ   |
| Compress     | .Z   | 1f 9d       | ..   |
| gzip format  | .gz  | 1f 8b       | ..   |
| pkzip format | .zip | 50 4b 03 04 | PK.. |



## Archive files

| File type | Typical extension |	Hex digits xx = variable  |	Ascii digits . = not an ascii char |
| --------- | ------------------- | ------------------------- | ---------------------------------- |
TAR (pre-POSIX)| .tar |	xx xx          | (a filename)                |
TAR (POSIX)    | .tar |	75 73 74 61 72 | ustar (offset by 257 bytes) |

## Excecutable files

| File type | Typical extension |	Hex digits xx = variable  |	Ascii digits . = not an ascii char |
| --------- | ------------------- | ------------------------- | ---------------------------------- |
||MS-DOS, OS/2 or MS Windows  |	4d 5a        |	MZ   |
|Unix elf                     | 7f 45 4c 46  |	.ELF |

## Miscellaneous files

| File type | Typical extension |	Hex digits xx = variable  |	Ascii digits . = not an ascii char |
| --------- | ------------------- | ------------------------- | ---------------------------------- |
| pgp | public ring 	| 99 00 | .. |
| pgp | security ring 	| 95 01 | .. |
| pgp | security ring 	| 95 00 | .. |
| pgp | encrypted data 	| a6 00 | ¦. |