sudo rm -r /var/lib/apt/lists/*
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo ansible-playbook /home/ubuntu/lec-playbook.yml
