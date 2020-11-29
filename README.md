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

### Get HPotter

    git clone https://github.com/drsjb80/HPotter.git
    cd HPotter
    git checkout 2a5a3d0 # instructions for this version
    sudo pip3 install -r requirements.txt

### Install Docker
Based on the [Docker Debian Install Instructions](https://docs.docker.com/engine/install/debian/)

- Add Docker repository to the apt sources list:

    `sudo vi /etc/apt/sources.list`
    
    append

    `deb [arch=armhf] https://download.docker.com/linux/raspbian buster stable`

    and save the file
- Install docker tools:

    ```
    curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io
    ```

Note that the Pi Zero W has arm32v6 architecture so the test hello-world container will not work since no image for this architecture is currently available.

### Get Docker Containers

Special containers that work on the Pi Zero W's arm32v6 architecture are required. You can search the HPotter code to see which images are currently required.

```
grep -rnw . -e 'arm32v6' # in HPotter directory

HPotter/hpotter/env.py:21:machine = 'arm32v6/' if platform.machine() == 'armv6l' else ''
HPotter/hpotter/plugins/httpipe.py:29:            container = 'arm32v6/httpd:alpine'
HPotter/hpotter/plugins/mariadb.py:29:            container = 'apcheamitru/arm32v6-mariadb:latest'
```

Get the required containers locally
```
sudo docker pull arm32v6/httpd:alpine
sudo docker pull apcheamitru/arm32v6-mariadb:latest
```

### Run HPotter
- Add the httpipe module to the plugins list to run
  ```
  # in HPotter directory
  echo "__all__ = ['mariadb', 'httpipe']" > ./hpotter/plugins/__init__.py
  ```

- Run HPotter
  `python3 -m hpotter`