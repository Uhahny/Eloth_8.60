#!/bin/bash

IP_OTS=65.21.84.59
IP_WWW=65.21.84.59
IP_PROXY_1=91.99.157.67
IP_PROXY_2=157.90.245.28
IP_PROXY_3=138.199.208.234
IP_PROXY_4=157.90.246.74

if [ $# -eq 0 ]; then
    echo "Parameter required! Value: ots, www, otswww or proxy"
    exit
fi

if [ $1 != "ots" ] && [ $1 != "www" ] && [ $1 != "otswww" ] && [ $1 != "proxy" ]; then
    echo "Invalid parameter issue! Value: ots, www, otswww or proxy"
    exit
fi

# ALL: czyszczenie iptables
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# ALL: nie banowanie lokalnych polaczen
iptables -A INPUT -s 127.0.0.1/8 -j ACCEPT

# ALL: nie banowanie wlasnych serwerow
iptables -A INPUT -s $IP_OTS/32 -j ACCEPT
iptables -A INPUT -s $IP_WWW/32 -j ACCEPT
iptables -A INPUT -s $IP_PROXY_1/32 -j ACCEPT
iptables -A INPUT -s $IP_PROXY_2/32 -j ACCEPT
iptables -A INPUT -s $IP_PROXY_3/32 -j ACCEPT
iptables -A INPUT -s $IP_PROXY_4/32 -j ACCEPT

if [ $1 = "www" ]; then
  # WWW: dostep do www tylko z cloudflare
  for i in `curl https://www.cloudflare.com/ips-v4`; do iptables -I INPUT -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
  for i in `curl https://www.cloudflare.com/ips-v6`; do ip6tables -I INPUT -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
  iptables -A INPUT -p tcp -m multiport --dports http,https -j DROP
  ip6tables -A INPUT -p tcp -m multiport --dports http,https -j DROP
fi

if [ $1 = "ots" ]; then
  # OTS: blokada dostepu do mysql
  iptables -A INPUT -p tcp --dport 3306 -j DROP

  # OTS: zezwolenie tylko na polaczenia z IP_PROXY_1 na porty OTS
  iptables -A INPUT -p tcp -s $IP_PROXY_1 --dport 7171 -j ACCEPT
  iptables -A INPUT -p tcp -s $IP_PROXY_1 --dport 7172 -j ACCEPT
  iptables -A INPUT -p tcp -s $IP_PROXY_1 --dport 7173 -j ACCEPT

  # Wszystko inne na portach OTS: DROP
  iptables -A INPUT -p tcp --dport 7171 -j DROP
  iptables -A INPUT -p tcp --dport 7172 -j DROP
  iptables -A INPUT -p tcp --dport 7173 -j DROP
fi

if [ $1 = "otswww" ]; then
  # OTS: blokada dostepu do mysql
  iptables -A INPUT -p tcp -m multiport --dports 3306 -j DROP
  # OTS: dostep do proxy tylko z IP serwerow proxy i www
  iptables -A INPUT -p tcp -m multiport --dports 6000:6999 -j DROP
  # OTS: dostep do ots tylko z IP serwerow proxy i www
  iptables -A INPUT -p tcp -m multiport --dports 7100:7300 -j DROP

  # WWW: dostep do www tylko z cloudflare
  for i in `curl https://www.cloudflare.com/ips-v4`; do iptables -I INPUT -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
  for i in `curl https://www.cloudflare.com/ips-v6`; do ip6tables -I INPUT -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
  iptables -A INPUT -p tcp -m multiport --dports http,https -j DROP
  ip6tables -A INPUT -p tcp -m multiport --dports http,https -j DROP

fi

if [ $1 = "proxy" ]; then
  # PROXY: limity dla polaczen z zewnatrz do portow proxy 6000:6999
  # 10 polaczen na 1 IP
  iptables -A INPUT -p tcp --syn --dport 6000:6999 -m connlimit --connlimit-above 10 --connlimit-mask 32 -j REJECT --reject-with tcp-reset
  # 40 nowych polaczen na minute na 1 IP
  iptables -A INPUT -p tcp --dport 6000:6999 -m state --state NEW -m hashlimit --hashlimit-mode srcip --hashlimit-above 40/min --hashlimit-burst 40 --hashlimit-name conn_proxy_rate_min -j REJECT --reject-with tcp-reset
  # 5 nowych polaczenia na sekunde na 1 IP
  iptables -A INPUT -p tcp --dport 6000:6999 -m state --state NEW -m hashlimit --hashlimit-mode srcip --hashlimit-above 5/sec --hashlimit-burst 5 --hashlimit-name conn_proxy_rate_sec -j REJECT --reject-with tcp-reset
  # 450 pakietow przychodzacych na sekunde na 1 IP (449 i 450 sa specjalnie, bo iptables ma jakis problem jak obie wartosci sa takie same)
  iptables -A INPUT -p tcp --dport 6000:6999 -m hashlimit --hashlimit-mode srcip --hashlimit-above 449/sec --hashlimit-burst 450 --hashlimit-name conn_proxy_rate_packets_sec -j REJECT --reject-with tcp-reset
  # 10 kb transferu przychodzacego na sekunde na 1 IP
  iptables -A INPUT -p tcp --dport 6000:6999 -m hashlimit --hashlimit-above 10kb/s --hashlimit-mode srcip --hashlimit-name bandwidth_proxy_sec -j REJECT --reject-with tcp-reset

  # PROXY: limity dla polaczen z zewnatrz do portow OTS 7100:7300
  # 5 polaczen na 1 IP
  iptables -A INPUT -p tcp --syn --dport 7100:7300 -m connlimit --connlimit-above 5 --connlimit-mask 32 -j REJECT --reject-with tcp-reset
  # 10 nowych polaczen na minute na 1 IP
  iptables -A INPUT -p tcp --dport 7100:7300 -m state --state NEW -m hashlimit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 10 --hashlimit-name conn_ots_rate_min -j REJECT --reject-with tcp-reset
  # 2 nowe polaczenia na sekunde na 1 IP
  iptables -A INPUT -p tcp --dport 7100:7300 -m state --state NEW -m hashlimit --hashlimit-mode srcip --hashlimit-above 2/sec --hashlimit-burst 2 --hashlimit-name conn_ots_rate_sec -j REJECT --reject-with tcp-reset
  # 150 pakietow przychodzacych na sekunde na 1 IP (149 i 150 sa specjalnie, bo iptables ma jakis problem jak obie wartosci sa takie same)
  iptables -A INPUT -p tcp --dport 7100:7300 -m hashlimit --hashlimit-mode srcip --hashlimit-above 149/sec --hashlimit-burst 150 --hashlimit-name conn_ots_rate_packets_sec -j REJECT --reject-with tcp-reset
  # 10 kb transferu przychodzacego na sekunde na 1 IP
  iptables -A INPUT -p tcp --dport 7100:7300 -m hashlimit --hashlimit-above 10kb/s --hashlimit-mode srcip --hashlimit-name bandwidth_ots_sec -j REJECT --reject-with tcp-reset
fi

systemctl restart fail2ban