sed -i 's/#PermitRootLogin.\+/PermitRootLogin without-password/g' /etc/ssh/sshd_config
passwd -l root
shred -u /etc/ssh/*_key /etc/ssh/*_key.pub
sed -i 's/#UseDNS.\+/UseDNS no/g' /etc/ssh/sshd_config
rm /root/.ssh/authorized_keys
