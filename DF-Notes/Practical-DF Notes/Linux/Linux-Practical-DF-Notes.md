## Linux Practical DF Notes

This files will be the main document in relation to practical information doing DF on a linux system, unless specified otherwise, assume the information found within this document work for Ubuntu 22 as that is what is used as distro to test and verify stuff on, most of not all information found within this document should still apply to most debian based systems unless specified otherwise, if some information is related to non-debian based systems only, such information will be listed in it's own section as needed.

also, some text may overlap with the theoretical document(and by extension, the other way around) since it's faster to sometimes just copy+paste if the information in both will be pretty much the same, a least in the beginning.

-------------------------------------------------------------------------

Since everything on linux is a file, pretty much everything can be viewed using the `cat` command, for some files with a lot of information, you may want to pipe(`|`) it into the `less` command


### Basic Information

### OS and account Information gathering

OS Release file: `etc/os-release`

#### User Accounts:

Passwd file Path(contains general acc info): `/etc/passwd`
Shadow file Path(contains passwords): `/etc/passwd`

passwd contains a lot of information such as Usernames, password info, UID, GID, Description, Home Dir info and default shell on login.

while you can use the `cat` command by itself to view the file, it is recommended to pipe(`|`) it into the `column` command with the `-ts :` options such as `cat /etc/passwd | column -ts :` to make it more readable

+ x in password field = pass in shadow file
+ user accs have UID above 1000
+ Default bash and home dir is `/bin/bash/` & `/home/ubuntu`(on ubuntu) respectively

#### Group Info

The group file have information related to different groups a users are part of and contains username, password(usually a X which signifies the shadow file) GID number and groups the users belong to.

The File can be found at following path: `/etc/group`

#### Sudoers info

The `sudoers` file contains information of users and groups which are allowed to elevate privilege with the `sudo` command. elevate privileges are needed to view this file.

The file can be found at the follwing path: `/etc/sudoers`

#### Login Information

The log directory contains various files with information related to activity on the system such as Login, authentication, etc. 

LogDir:`/var/log`

btmp file: failed logins 
wtmp: historical login info

+ As they are binary file, you can't cat them, so you need to use the `last` command such as `sudo last -f /var/log/btmp`

#### Authentication log

The authentication logs keep information on all authentication activity weather they fail or not. recommended to pipe cat into `tail`, `head`, `more` or `less` due to amount

### System Config Info

#### Hostname

Hostname file keep information on name of the system(host)

Hostname file path: `/etc/hostname`

+ if you are on a active system, then you can normally also just type `hostname` into the terminal and it should return answer.

#### Timezones

Timezone file keep information about the TimeZone the system is in, since evidences is based on timelines, this is important to check early.

TimeZone file path: `/etc/timezones`

#### network info

For offline ones it's a little confusing so this part need to be updated later as it seems it depends on what system you use, before ubuntu 17 it was stored in `/etc/network/interfaces` but after, the new location are supposed to be a yaml file found within `/etc/netplan/`, but not much much information are found within it, so not sure where that file is stored.   

for active system however, it's pretty simple, you can just use the `ip address show` command

#### Active network conections

To show active network connections you can use `netstat`, to show for example protocol, rec/send queries, local address, foreign address. state and PID/Program, you can use the `-natp` option

#### Running processes

to show running processes, you can use the `ps` command which should be available on most systems along with the `-aux` command which is the most common used one.

#### DNS info

The DNS config info are kept in the `hosts` file while the info about DNS servers that linux talk to can be found in the `resolv.conf` file.

hosts file path: /etc/hosts
resolv.conf file path: /etc/resolv.conf

#### Cron Jobs

the crontab file keep commands that run at defined time and date, most malwares or attackers tries to add commands to this file in a attempt to either execute certain commands at certain times to either perform a task or/and maintain access to the system.

the crontab file path: `/etc/crontab`

#### service startups

The init.d directory keep files that will be run as services on system boot which are also often used by malwares/attackers to gain persistance, since each file is a service, you can show all with the `ls` command

init.d file path: `/etc/init.d`

#### .Bash

When bash is spawned it runs the commands stored in `.bashrc`, since commands within this file is executed on shell spawn, it can also be used to archive persistance and thus a good place to check when dealing with attackers/malware.

System wide settings are stored in the `bash.bashrc` and `/etc/profile` files as well and not just the user, so these should be checked as well

local bash file path: `~/.bash`
System-wide bash file path: `/etc/bash.bashrc`
System-wide bash profile file path: `/etc/profile`


### Evidence of exec

#### Sudo bash command history

Information about executed sudo commands can be found in the log `var/log` directory in the `auth.log` logs mentioned earlier above, to have a easier time looking for commands executed only, you can use the `grep` command along with the `-i` option to ignore case searching for words such as `COMMAND` as the logs prepend `COMMAND=/`before any command executed.

#### Bash command history

For commands that does not use sudo, you can find a history of them in the `bash_history` file stored in each user's home directory. if someone logs in as root and run commands, then they will appear here as well and not in the `auth.log`, so is important to check for root user as well.

bash command file path: `~/.bash_history

#### Files accessed using vim

vim keep it's own log file with information on command history, search strings history, etc for opened files in the `.viminfo` file which is stored in the user's home dir.

vim access log file path: `~/.viminfo` 
