/* 
This Yar file contains rules related to Office documents and is part of the @kazukidevnull's "KAZU-DFIR-NOTES" TRIAGE repo.

To keep the yara rule itself small, i have only included a short description about the rules as well as a link of possible to either the IoC itself or article related to it, For further details about each rule in this document, please consult the appropiate document inside the "YARA-RULES-REF" directory found inside the same directory as this rule
 */


 // This is rule olevba, for Office documents that use the binary CFBF aka ole file format
 // Source: https://isc.sans.edu/forums/diary/Simple+YARA+Rules+for+Office+Maldocs/28062/

 rule olevba {
    strings:
        $attribut_e = {00 41 74 74 72 69 62 75 74 00 65}
    condition:
        uint32be(0) == 0xD0CF11E0 and $attribut_e
}


// This is rule pkvba, for Office documents that use the OOXML file format:
// Source: https://isc.sans.edu/forums/diary/YARA+Rule+for+OOXML+Maldocs+Less+False+Positives/28066/

rule pkvbare {
    strings:
        $vbaprojectbin = /[a-zA-Z\/]*\/?vbaProject\.bin/
    condition:
        uint32be(0) == 0x504B0304 and
        $vbaprojectbin and
        for any i in (1..#vbaprojectbin): ((uint32be(@vbaprojectbin[i] - 30) == 0x504B0304) and
                                           (!vbaprojectbin[i] == uint16(@vbaprojectbin[i] - 4))
                                           )
}