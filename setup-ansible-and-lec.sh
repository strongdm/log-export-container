apt update
apt install --yes software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install --yes ansible
ansible-playbook lec-playbook.yml