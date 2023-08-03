## Linux Theoretical DF Notes

This files will be the main document in relation to Theoretical information for DF a linux system, unless specified otherwise, assume the information found within this document work for Ubuntu 22 as that is what is used as distro to test and verify stuff on, most, if not all information found within this document should still apply to most debian based systems unless specified otherwise, if some information is related to non-debian based systems only, such information will be listed in it's own section as needed.

-------------------------------------------------------------------------


### Basic Information

### OS and account Information gathering

File Path: `etc/os-release`


#### User Accounts:

Passwd file Path(contains general acc info): `/etc/passwd`
Shadow file Path(contains passwords): `/etc/passwd`

For information on user accounts on a linux system you can check out the passwd file which contains 7 colon-seperated fields with username, password info, user id(UID), group id(GID), description, home dir info as well as the default shell that execute when a user logs in.


+ All user created accounts have UID of 1000 or above as all lower numbered ones are reserved for system ones.
+ A `x` in the password field indicates the password is stored in the shadow file at `/etc/shadow`.
+ Default bash set to `/bin/bash`
+ Default home dir on ubuntu is set to `/home/ubuntu` but will be similiar on other distro's just with another distro name.


#### Group Info

The group file have information related to different groups a users are part of and contains username, password(usually a X which signifies the shadow file) GID number and groups the users belong to.

The File can be found at following path: `/etc/group`

#### Sudoers info

The `sudoers` file contains information of users and groups which are allowed to elevate privilege with the `sudo` command. elevate privileges are needed to view this file.

The file can be found at the follwing path: `/etc/sudoers`

#### Login Information

The log directory contains various files with information related to activity on the system such as Login, authentication, etc. The log files related to login are `wtmp` which keep historical data of logins and `btmp` which keep information about failed logins. 

the logs can be found at following path: `/var/log`

+ These logs can not be read using cat as the at binary files, so you need to use the `last` command to view them

#### Authentication log

The authentication logs keep information on all authentication activity weather they fail or not. while you can read them it using the `cat` command, due to it's size, you may want to limit how much it spew out on you at once with piping cat into commands such as `tail`, `head`, `more` or `less`.

auth logs file path: `/var/log/auth*.log`

### System Config Info

#### Hostname

Hostname file keep information on name of the system(host)

Hostname file path: `/etc/hostname`

+ if you are on a active system, then you can normally also just type `hostname` into the terminal and it should return answer.

#### Timezones

Timezone file keep information about the TimeZone the system is in, since evidences is based on timelines, this is important to check early.

TimeZone file path: `/etc/timezones`

#### network configs

Network config file: There's two primary ways to access network information depending if it's on a active system or a offline one.

For offline ones it's a little confusing so this part need to be updated later as it seems it depends on what system you use, before ubuntu 17 it was stored in `/etc/network/interfaces` but after, the new location are supposed to be a yaml file found within `/etc/netplan/`, but not much much information are found within it, so not sure where that file is stored.   

for active system however, it's pretty simple, you can just use the `ip address show` command

#### Active network conections

To show active network connections you can use `netstat`, to show for example protocol, rec/send queries, local address, foreign address. state and PID/Program, you can use the `-natp` option

#### Running processes

While there's many different tools such as htop, they are often not installed by default, the `ps` tool however is almost always available on most system, the most common option used with the ps command is `-aux` which shows  users, pid, cpu, mem, vsz, rss, tty, stat, start, time and command.

#### DNS info

The DNS info are kept in the `hosts` file. for information on 

hosts file path: /etc/hosts


### Persistence methods

Below will list various ways that can be used to archive persistance on a system.

#### Cron Jobs

the crontab file keep commands that run at defined time and date, most malwares or attackers tries to add commands to this file in a attempt to either execute certain commands at certain times to either perform a task or/and maintain access to the system,.

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

### Evidence of exec and access AKA: Log files

Most logs can be found in the `/var/log` directory, this include third-party ones such as webservers, databases, file share logs, etc

#### Sudo bash command history

Information about executed sudo commands can be found in the log `var/log` directory in the `auth.log` logs mentioned earlier above, to have a easier time looking for commands executed only, you can use the `grep` command along with the `-i` option to ignore case searching for words such as `COMMAND` as the logs prepend `COMMAND=/`before any command executed.

#### Bash command history

For commands that does not use sudo, you can find a history of them in the `bash_history` file stored in each user's home directory. if someone logs in as root and run commands, then they will appear here as well and not in the `auth.log`, so is important to check for root user as well.

bash command file path: `~/.bash_history

#### Files accessed using vim

vim keep it's own log file with information on command history, search strings history, etc for opened files in the `.viminfo` file which is stored in the user's home dir.

vim access log file path: `~/.viminfo` 

#### Syslog

The syslogs keep messenges that are recorded by the host about system activity and the detail of information it records are configurable, you can use the `cat` command to view them but due to size, it is recommended to pipe trough `tail`, `head`, `more` or `less`. the syslogs are also rotated out to keep them getting too big, so it's important to save these quickly on a active system.

syslogs path: `/var/log/syslogs*`

