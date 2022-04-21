apt update
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata
dpkg-reconfigure --frontend noninteractive tzdata
