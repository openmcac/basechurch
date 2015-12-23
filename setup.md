Disable root login with password
https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2

Update /etc/ssh/sshd_config:

```
PermitRootLogin without-password
```

Put the changes in effect:

```
reload ssh
```

Install UFW:
https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server

```
sudo apt-get install ufw
```

Enable IPV6 in /etc/default/ufw

```
IPV6=yes
```

Restart firewall

```
sudo ufw disable
sudo ufw enable
```

Configuring firewall

```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow www
```
