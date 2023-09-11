apt install resolvconf
echo 'nameserver 8.8.8.8' >> /etc/resolvconf/resolv.conf.d/head
resolvconf --enable-updates
resolvconf -u
systemctl restart resolvconf.service