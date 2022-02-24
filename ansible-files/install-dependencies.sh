apt update
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata
dpkg-reconfigure --frontend noninteractive tzdata
apt install --yes build-essential ruby-dev zlib1g
gem install bundler -v '~> 2.3.3'
bundle install

apt update
apt install --yes curl
curl -J -O -L https://app.strongdm.com/releases/cli/linux

unzip -x sdm*.zip
rm sdm*.zip
mv sdm /home/fluent