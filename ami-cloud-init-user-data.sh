#!/bin/bash
apt install --yes curl
curl -O https://raw.githubusercontent.com/strongdm/log-export-container/main/setup-ansible-and-lec.sh
chmod +x setup-ansible-and-lec.sh
curl -O https://raw.githubusercontent.com/strongdm/log-export-container/main/lec-playbook.yml
curl -o env-file https://raw.githubusercontent.com/strongdm/log-export-container/main/env-file.example
./setup-ansible-and-lec.sh
