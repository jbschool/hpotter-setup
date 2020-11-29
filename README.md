# Install [HPotter](https://github.com/drsjb80/HPotter) On A [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w)

These instructions demonstrate how to configure [HPotter](https://github.com/drsjb80/HPotter) to run on a Raspberry Pi Zero W and how to expose the honeypot to the internet.

## Particulars

- Targets commi [2a5a3d0](https://github.com/drsjb80/HPotter/tree/2a5a3d014c33da3fb024febc46617d08d307fb60) on master: 
- Uses [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w) purchased in Jan 2020 with
    - Raspberry Pi OS (32-bit) (aka Raspbian Buster)
    - A port of Debian with the Raspberry Pi Desktop 
    - Released: 2020-08-20
    - Flashed using [Raspberry Pi Imager v.14](https://www.raspberrypi.org/software/)

## Raspberry Pi Zero W Setup

### Add New User and Delete User Known to Attackers

Make the Pi a little more secure following advice from [Securing your Raspberry Pi](https://www.raspberrypi.org/documentation/configuration/security.md)

    sudo adduser alice # use your own username and strong password
    sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video, \
        plugdev,games,users,input,netdev,gpio,i2c,spi alice
    sudo su - alice
    sudo pkill -u pi # logs out; log back in as newly created user
    sudo deluser pi
    sudo deluser -remove-home pi
    sudo rm /etc/sudoers.d/010_pi-nopasswd

### Update Software

Per [Updating and upgrading Raspberry Pi OS](https://www.raspberrypi.org/documentation/raspbian/updating.md):

    sudo apt update
    sudo apt full-upgrade

### Install Docker
Based on the [Docker Debian Install Instructions](https://docs.docker.com/engine/install/debian/)

- Add Docker repository to the apt sources list:

    `sudo vi /etc/apt/sources.list`
    
    append

    `deb [arch=armhf] https://download.docker.com/linux/raspbian buster stable`

    and save the file. Then install

    `sudo apt install docker-ce docker-ce-cli containerd.io`