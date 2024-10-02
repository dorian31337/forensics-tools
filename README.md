# Introduction to CSIRT's forensics toolkit  
# YARA

YARA is a tool intended to identify and classify malware samples. With YARA you can create descriptions of malware families (or whatever you want to describe) based on textual or binary patterns. Each description - "rule" consists of a set of strings and a boolean expression which determine its logic.  

It is possible to scan the entire filesystem, specific directory,
 single file or even a process given its PID.

Official documentation: https://yara.readthedocs.io/en/latest/

## Usage:

### For Windows run the batch file from the command prompt like this:
(The file with compiled rules is a batch file to avoid problems related to running powershell scripts, with a hardcoded compiled yara rules' file)

***yarascanner.bat file|path|PID***

Example: **yarascanner.bat C:\Users\user\31337.dll**

(make sure the binary name & path are correct inside of the `yarascanner.bat` file!)

***


### For Unix-like systems, run it like this:
yara [OPTION]... [NAMESPACE:]RULES_FILE... FILE | DIR | PID  

Example:

***yara -N -C -w -r 00_all.yc /Users/user/***

***
Which is, accordingly: 
* `-N,  --no-follow-symlinks`
* `-C,  --compiled-rules (file)`
* `-w,  --no-warning`
* `-r,  --recursive`

Other options such as maximum file size to scan, number of threads or a fast scan can be adjusted - check the --help switch

Feel free to filter out unwanted results from the output, such as the rule showing `PE_File`s

## Rule compilation
To make the proces simpler, faster and more effective, thousands of rules are compiled dynamically into a single file within **Makefile**, where rule repos' sources are defined. 
Then, the results are stripped from duplicates and a command `yarac all_rules.yara compiled_rules.yc` is performed.



## Good to know: 
I tried to bring **False Positives** down to an absolute minimum, adjusting **both** yara and XDR rules, however it is not entirely possible to avoid them. Examples of such results will be i.e.: PE/ELF64 files on MacOS, Penetration testing tools, legacy, possibly vulnerable apps & files  such as KeePass - use BitWarden instead (***However be warned - as you can see below, XDR does NOT always flag malicious script files, thus you always need verify the results manually***).


```
hacktool_multi_ntlmrelayx /Users/user//Library/Python/3.9/lib/python/site-packages/impacket/examples/ntlmrelayx/attacks/smbattack.py

crypto_vertical_transposition_wide /Users/user//Library/Python/3.9/lib/python/site-packages/cryptography/hazmat/bindings/_rust.abi3.so

crypto_LM_DES /Users/user//Library/Python/3.9/lib/python/site-packages/spnego/_ntlm_raw/crypto.py

hacktool_multi_ntlmrelayx /Users/user//Library/Python/3.9/lib/python/site-packages/impacket/examples/ntlmrelayx/attacks/ldapattack.py

VULN_KeePass_DB_Brute_Forcible /Users/user//exfil/KeePass/Ixxxxx.kdb

executable_elf64 /Users/user//Library/Python/3.9/lib/python/site-packages/tkinterdnd2/tkdnd/linux64/libtkdnd2.9.2.so

executable_pe /Users/user//Library/Python/3.9/lib/python/site-packages/tkinterdnd2/tkdnd/win64/libtkdnd2.9.2.dll
```

## Probl— Challenges

* YARA doesn't like and cannot compile duplicated rules. If you encounter one, the **name of the rule within the file** must be changed (or removed altogether) and **NOT** just the filename

* Yara's compiled rules MUST be compiled by the same version of Yarac (even the `minor` version number of the rule compiler matters)

* In the near future, expect minor changes to `Makefile`, repos and new tools added
