#!/bin/bash
apt install --yes curl
curl -O https://raw.githubusercontent.com/strongdm/log-export-container/feat/ansible/setup-ansible-and-lec.sh
chmod +x setup-ansible-and-lec.sh
curl -O https://raw.githubusercontent.com/strongdm/log-export-container/feat/ansible/lec-playbook.yml
curl -o env-file https://raw.githubusercontent.com/strongdm/log-export-container/feat/ansible/env-file.example
./setup-ansible-and-lec.sh
