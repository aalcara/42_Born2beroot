# 42_Born2beroot
Introduction to the wonderful world of virtualization, creating my first machine in VirtualBox

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
```bash
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
```bash
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
hostnamectl set-hostname <new_name>
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
- PASS_MAX_DAYS	<Maximum number of days a password may be used>
- PASS_MIN_DAYS	<Minimum number of days aallowed between password changes>
- PASS_WARN_AGE <Number of days warning given before a password expires>

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

`
password	requisite	pam_pwquality.so ...
`
put the following settings:
- minlen=10 : 10 characters long;
- ucredit=-1 : If it have to contains at least a uppercase letter;
- dcredit=-1 : If it have to contains at least a number;
- maxrepeat=3 : Not contain more than 3 consecutive identical characters;
- reject_username : Must not include the name of the user.
- difok=7 : The password must have at least 7 characters that are not part of the former password.
- enforce_for_root : root password has to comply with policy.

#### For old users, there are following commands:
To change maximum days:
```bash
chage -M <username>
```
To change minimum days:
```bash
chage -m <username>
```
To change warning days:
```bash
chage -W <username>
```
To show user configuration:
```bash
chage -I <username>
```


References:
- https://www.thegeekdiary.com/understanding-etclogin-defs-file/
- https://ostechnix.com/how-to-set-password-policies-in-linux/
- https://linux.die.net/man/8/pam_pwquality
- https://www.tecmint.com/manage-user-password-expiration-and-aging-in-linux/

## Sudo Rules

## Configure Users and Groups

## Monitoring Script

## CRON
