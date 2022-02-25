apt update
apt install --yes curl
curl -J -O -L https://app.strongdm.com/releases/cli/linux

unzip -x sdm*.zip
rm sdm*.zip
mkdir /home/fluent
mv sdm /home/fluent/