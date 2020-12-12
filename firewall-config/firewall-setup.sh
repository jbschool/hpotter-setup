# Configure system firewall for running HPotter

# good doco: https://www.booleanworld.com/depth-guide-iptables-linux-firewall/

if [ $(id -u) -ne 0 ]
    then echo run with sudo \(iptables command required root privileges\)
    exit
fi


source backup-iptables.sh

# Sets vars
# IPV4_DNS_SERVERS
# IPV6_DNS_SERVERS
source get-dns-servers.sh

HPOTTER_PORTS='23'
PRIVATE_IPS='10.0.0.0/8 172.16.0.0/12 192.168.0.0/16'
# doco for private IPv4 addrs: https://en.wikipedia.org/wiki/Private_network

# clear all rules
# current iptables config backed up above
    iptables --flush INPUT
    iptables --flush OUTPUT

# *** INPUT chain rules
# drop all incoming requests in the default (filter) table 
    iptables --policy INPUT DROP

# headed to an HPotter port
    for PORT in ${HPOTTER_PORTS}
    do
        iptables --append INPUT --protocol tcp --dport ${PORT} --jump ACCEPT
    done

# if we initiated
    iptables --append INPUT --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT

# this gets a little tricky as DNS queries go through on localhost
    iptables --append INPUT --protocol udp --destination 127.0.0.53 --dport 53 --jump ACCEPT


# *** OUTPUT chain rules
# drop all outgoing request in the default (filter) table
    iptables --policy OUTPUT DROP

# headed from an HPotter port
    for PORT in ${HPOTTER_PORTS}
    do
        iptables --append OUTPUT --protocol tcp --sport ${PORT} --jump ACCEPT
    done

# allow DNS queries to server
	for DNS_SERVER in ${IPV4_DNS_SERVERS}
	do
		iptables --append OUTPUT --protocol udp --destination ${DNS_SERVER} --dport 53 --jump ACCEPT
	done

# don't allow access to private IP address LANs. if HPotter is on a
# non-private-IP LAN, block that too.
    for RANGE in ${PRIVATE_IPS}
    do
        iptables --append OUTPUT --destination ${RANGE} --jump DROP
    done

# we want to initiate to keep OS up to date etc.
    iptables --append OUTPUT --match conntrack --ctstate NEW,ESTABLISHED,RELATED --jump ACCEPT

