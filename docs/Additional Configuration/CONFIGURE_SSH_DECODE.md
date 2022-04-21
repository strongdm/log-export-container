---
layout: default
title: Additional Configuration
parent: SSH Decode
nav_order: 9
---
# Configuring SSH Decoding 

If you want the LEC to decode SSH parameters, you need to add **LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS=true** to your container. 

To run the container manually as an example to log to s3, see here:

```
docker run -d -p 5140:5140   -e LOG_EXPORT_CONTAINER_INPUT=syslog-json -e LOG_EXPORT_CONTAINER_OUTPUT=s3  -e LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS=true public.ecr.aws/strongdm/log-export-container
```

Your syslog configuration in the SDM Admin UI should be set to use syslog with json.  There is no reason to use csv when using the LEC as it will translate the logs to json anyhow. It is a requirement for SSH decoding, though, to set it as json in the UI.

The SSH logs in json have 4 kinds of log messages for each session.

1. class.start
1. class.chunk
1. class.postStart
1. class.complete

When using this option, the class.chunk log line will have the decoded events embedded.  With json, the entire SSH session data will be in a single log line unlike csv output where SSH sessions are split among potentially multiple log lines.  Anyhow, if you want to split out the decoded events in a slightly more readable form, you can do something like the below.  You can see that this captured a login session with a couple other commands.


```
>grep class.chunk logfileWithOneSession.log | awk '{$1=$2=""; print $0}' | jq -r .decodedEvents[].data | sed 's/^\[$//g' | sed 's/^\]$//g' | sed 's/^\[\]$//g' | sed '/^$/d' | sed '/^ *"",$/d'
"Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-1020-aws x86_64)",
  " * Documentation: https://help.ubuntu.com"
  " * Management: https://landscape.canonical.com"
  " * Support: https://ubuntu.com/advantage"
  " System information as of Mon Dec 13 16:41:53 UTC 2021"
  " System load: 0.45"
  " Usage of /: 87.6% of 7.69GB"
  " Memory usage: 58%",
  " Swap usage: 0%"
  " Processes: 138"
  " Users logged in: 1"
  " IPv4 address for br-384f11f310fd: 172.18.0.1",
  " IPv4 address for docker0: 172.17.0.1"
  " IPv4 address for eth0: 172.31.26.254"
  " => / is using 87.6% of 7.69GB"
  " * Ubuntu Pro delivers the most comprehensive open source security and",
  " compliance features."
  " https://ubuntu.com/aws/pro"
  "16 updates can be applied immediately.",
  "To see these additional updates run: apt list --upgradable"
  "*** System restart required ***"
  "Last login: Mon Dec 13 16:41:53 2021 from 172.31.28.187"
  "\u001b]1337;RemoteHost=ubuntu@ACE-AWS-SSH2\u0007\u001b]1337;CurrentDir=/home/ubuntu\u0007\u001b]1337;ShellIntegrationVersion=16;shell=bash\u0007\u001b]133;C;\u0007\u001b]1337;RemoteHost=ubuntu@ACE-AWS-SSH2\u0007\u001b]1337;CurrentDir=/home/ubuntu\u0007\u001b]133;D;0\u0007\u001b]133;A\u0007\u001b]0;ubuntu@ACE-AWS-SSH2: ~\u0007ubuntu@ACE-AWS-SSH2:~$ \u001b]133;B\u0007echo \"test after upgr\b\u001b[K\b\u001b[Kdating the base image\""
  "\u001b]133;C;\u0007test after updating the base image"
  "\u001b]1337;RemoteHost=ubuntu@ACE-AWS-SSH2\u0007\u001b]1337;CurrentDir=/home/ubuntu\u0007\u001b]133;D;0\u0007\u001b]133;A\u0007\u001b]0;ubuntu@ACE-AWS-SSH2: ~\u0007ubuntu@ACE-AWS-SSH2:~$ \u001b]133;B\u0007exit"
  "\u001b]133;C;\u0007logout"
```