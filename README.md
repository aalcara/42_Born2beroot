# 42_Born2beroot
Introduction to the wonderful world of virtualization, creating my first machine in VirtualBox.

With this project I had my first contact with 

## VirtualBox machine Settings
Before install the Operating system is needed to set some settings

* General -> Disk encryption -> Enable Disk Encryption
* Network: Bridged Adapter

## Operating System install
* Partition Method -> Guided - Use entire disk and set up encrypted LVM;
* Partition Scheme -> Separate /home partition
* On software selection, mark only SSH server and standard system utilities;
* Install GRUB? Yes.

## Install sudo
Sudo needs to be configured too, but following the subject's guidelines, this will be done later.

as root:
```bash
apt-get install sudo
```
References:
- https://portaldosaber.net/2017/10/habilitando-o-sudo-no-debian-9-x-stretch/

## SSH
To changes ssh settings, is needed to change the file `/etc/ssh/sshd_config`
Locate the line that describe the port, uncomment and set port as 4242:
```bash
Port 4242
```
Locate the line PermitRootLogin, uncomment and set as:
```bash
PermitRootLogin no
```

### Check if SSH is working
Now to test if your SSH is working you has to make the following commands on you host terminal:
```
ssh <username>@<ip-address> -p <port>
```
References:
- https://www.cyberciti.biz/faq/howto-change-ssh-port-on-linux-or-unix-server/
- https://askubuntu.com/questions/264046/how-to-ssh-on-a-port-other-than-22

## UFW
First of all, make sure you are logged as root, since we don't set sudo users yet.
To install UFW use the following command:
```bash
sudo apt install ufw
```
Check if UFW status:
```bash
sudo ufw status verbose
```
If inactive, you can enable it:
```
sudo ufw status enable 
```
Setting um Default polices, and can be altered by following commands:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

References:
- https://www.tecmint.com/setup-ufw-firewall-on-ubuntu-and-debian/

## Change Hostname
we can change the hostname in various ways, some of them is:

### Changing some files:
To not need to restart the system, make this command:
```bash
sudo hostname <new_name>
```
Nest edit `/etc/hostname` file, changing the old name for the new name:
```bash
sudo nano /etc/hostname
```
Then change `/etc/hosts`, again changing from old to new name:
```bash
sudo nano /etc/hosts
```
### By command line
As root, only have to make the following command:
```bash
hostnamectl set-hostname new_hostname
```
To check the hostname:
```bash
hostnamectl
```

## Password Policy
To change the default configuration to new or modified users is needed to change `/etc/login.defs` :
```bash
sudo nano /etc/login.defs
```
and change the lines:
- PASS_MAX_DAYS 30	: Maximum number of days a password may be used = 30;
- PASS_MIN_DAYS 2	: Minimum number of days aallowed between password changes = 2;
- PASS_WARN_AGE 7	: Number of days warning given before a password expires = 7.

For the others policies it is necessary to install password quality checking library using command:
```bash
sudo apt-get install libpam-pwquality
sudo apt-get install libpam-cracklib
```
Then, edit `/etc/pam.d/common-password` file:
```bash
sudo nano /etc/pam.d/common-password
```
in the line as follow:

> ...
> 
> password	requisite	pam_pwquality.so ...
> 
> ...

put the following settings:
- **minlen=10** : 10 characters long;
- **ucredit=-1** : If it have to contains at least a uppercase letter;
- **dcredit=-1** : If it have to contains at least a number;
- **maxrepeat=3** : Not contain more than 3 consecutive identical characters;
- **reject_username** : Must not include the name of the user.
- **difok=7** : The password must have at least 7 characters that are not part of the former password.
- **enforce_for_root** : root password has to comply with policy.

#### For old users, there are following commands:
To change maximum days:
```bash
chage -M number username
```
To change minimum days:
```bash
chage -m number username
```
To change warning days:
```bash
chage -W number username
```
To show user configuration:
```bash
chage -l number username
```

References:
- https://www.thegeekdiary.com/understanding-etclogin-defs-file/
- https://ostechnix.com/how-to-set-password-policies-in-linux/
- https://linux.die.net/man/8/pam_pwquality
- https://www.tecmint.com/manage-user-password-expiration-and-aging-in-linux/

## Sudo Rules
We already installed sudo in a preview section.
To change sudo settings we need to open `/etc/sudoers` file.
For this, in addition to writing nano command, we can also use the following:

```
sudo visudo
```
In this file, we need to add some configurations by Default, so under the line that have Defaults, we add:

- **passwd_tries=3** : Authentication using sudo limited to 3 attempts;
- **badpass_message="message"** : A custom message displayed if an error due to a wrong password occurs when using sudo.
- **logfile="/var/log/sudo/sudo.log"**
- **requiretty** : sudo only run when a real user is logged in;
- **secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"** : as determined by subject.

References:
- https://www.todoespacoonline.com/w/2015/10/su-sudo-e-sudoers-no-linux/
- https://man7.org/linux/man-pages/man5/sudoers.5.html


## Users and Groups

### Creating Users

```
sudo useradd <username> -s /bin/bash -d /home/<username> -c <comment> -G <groups> -g <primary group>
```

There are the flags:
- -s : set the standard shell to this user;
- -d : Home directory for this user;
- -c : Ser a Comment, usually is the name of the user;
- -G : the groups that user belong, separated by a comma;
- -g : set the primary group of this user

To set to user a password:
```
sudo passwd <username>
```

### Modifying Users

If is necessary to change some user information could use the following command:

```
sudo usermod [flags] <username>
```

for the flags, use the same flag as creating the user.


### Groups

To add a group, use this command:

```
sudo groupadd <groupname>
```

To change a groupname:

```
sudo groupadd -n <oldname> <newname>
```

References:
- https://alexandrebbarbosa.wordpress.com/2014/05/26/criando-usuario-e-grupos-no-linux/
- https://linux.die.net/man/8/usermod

## Monitoring Script

It is all based in shell commands, so I gonna list bellow links that I used to create my script.

- https://stackoverflow.com/questions/8967902/why-do-you-need-to-put-bin-bash-at-the-beginning-of-a-script-file#:~:text=Adding%20%23!%2Fbin%2Fbash%20as,or%20%22sha%2Dbang%22.
- https://www.tecmint.com/find-out-linux-system-is-32-bit-or-64-bit/#:~:text=1.,all%20Linux%2FUnix%20operating%20systems.
- https://www.cyberciti.biz/faq/check-how-many-cpus-are-there-in-linux-system/
- https://askubuntu.com/questions/442914/calculating-the-number-of-lines-in-a-file
- https://www.cyberciti.biz/faq/linux-ram-info-command/
- https://guialinux.uniriotec.br/awk/
- https://phoenixnap.com/kb/linux-check-disk-space
- https://www.thegeekstuff.com/2011/10/linux-reboot-date-and-time/
- https://www.geeksforgeeks.org/conditional-statements-shell-script/
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/4/html/cluster_logical_volume_manager/lv_display
- https://www.howtogeek.com/681468/how-to-use-the-ss-command-on-linux/
- https://www.computerhope.com/issues/ch001649.htm
- 

## CRON
