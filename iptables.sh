# the iptables ruleset I'm using

# good doco: https://www.booleanworld.com/depth-guide-iptables-linux-firewall/

DNS_SERVER='192.168.0.1'
HPOTTER_PORTS='23'
PRIVATE_IPS='192.168.0.0/24 172.16.0.0/12 10.0.0.0/8'

# this assume there aren't any rules we need to save
    iptables --flush INPUT
    iptables --flush OUTPUT

# duh
    iptables --policy INPUT DROP

# headed towards an HPotter port
    for PORT in ${HPOTTER_PORTS}
    do
        iptables --append INPUT --protocol tcp --dport ${PORT} --jump ACCEPT
    done

# if we initiated
    iptables --append INPUT --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT

# this gets a little tricky as DNS queries go through on localhost
    iptables --append INPUT --protocol udp --destination 127.0.0.53 --dport 53 --jump ACCEPT

#duh
    iptables --policy OUTPUT DROP

# headed from an HPotter port
    for PORT in ${HPOTTER_PORTS}
    do
        iptables --append OUTPUT --protocol tcp --sport ${PORT} --jump ACCEPT
    done

# allow DNS queries to server
    iptables --append OUTPUT --protocol udp --destination ${DNS_SERVER} --dport 53 --jump ACCEPT

# don't allow access to private IP address LANs. if HPotter is on a
# non-private-IP LAN, block that too.
    for RANGE in ${PRIVATE_IPS}
    do
        iptables --append OUTPUT --destination ${RANGE} --jump DROP
    done

# we want to initiate to keep OS up to date etc.
    iptables --append OUTPUT --match conntrack --ctstate NEW,ESTABLISHED,RELATED --jump ACCEPT
