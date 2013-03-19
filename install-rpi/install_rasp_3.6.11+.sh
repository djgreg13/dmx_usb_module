##fork flubber-hauto and lowlander

##installation headers

sudo wget -O /etc/apt/sources.list.d/jim-raspbian.list http://repo.anconafamily.com/repos/apt/raspbian/jim-raspbian.list
wget -O - http://anconafamily.com/repos/apt/raspbian/jim-raspbian.gpg.key | sudo apt-key add -
sudo aptitude update
sudo aptitude install linux-headers-3.6.11+ g++ gcc


##installation usb_bmx
cd /usr/src/

sudo git clone https://github.com/djgreg13/dmx_usb_module.git -b dev-3.6

cd dmx_usb_module
sudo make
sudo git-clone http://www.erwinrol.com/git/dmx_usb_module/
sudo cp ./dmx_usb.ko /lib/modules/$(uname -r)/kernel/drivers/usb/serial
sudo depmod -a

# add lines to the blacklist file such that the dmx driver can load instead of the ttyUSB
# for Raspberry Pi the filename must have a .conf, not plain blacklist as referenced in ola build doc
# for the dmx adapters I'm using blacklisting just the ftio_sio works

filebase="blacklist.conf"
filename="/etc/modprobe.d/blacklist.conf"
if [! -e $filename ];
then
echo "blacklist file exists, adding to it"
#sed -i '$a blacklist usbserial' $filename
#sed -i '$a blacklist usb-serial' $filename
sed -i '$a blacklist ftdi_sio' $filename
else
echo "blacklist file doesn't exists, creating it"
echo 'blacklist ftdi_sio' > $filebase
#sed -i '$a blacklist usb-serial' $filebase
#sed -i '$a blacklist usbserial' $filebase
sudo mv $filebase $filename
fi

# need to allow all users to rd/wr to the dmx device
echo 'KERNEL=="dmx*" MODE="0666"' > 10-dmx.rules
sudo mv 10-dmx.rules /etc/udev/rules.d

echo "Installation done, please reboot with sudo reboot"