apt update
sudo apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install --yes ansible
ansible-playbook lec-playbook.yml