IPV4_DNS_SERVERS=$(cat /etc/resolv.conf | grep -E "nameserver [0-9]+\." | cut -d ' ' -f 2)
IPV6_DNS_SERVERS=$(cat /etc/resolv.conf | grep -E "nameserver [0-9]+:" | cut -d ' ' -f 2)

echo Found IPv4 DNS servers: 
for SERVER in ${IPV4_DNS_SERVERS} 
do
	echo ${SERVER}
done

echo
echo Found IPv6 DNS servers: 
for SERVER in ${IPV6_DNS_SERVERS} 
do
	echo ${SERVER}
done
echo

BKUP_FOLDER='./iptables-config-backup'
TIMESTAMP=$(date +'%F-%k%M%S')
IP4_RULES_BKUP=${BKUP_FOLDER}/iptables-save-res-${TIMESTAMP}.txt
IP6_RULES_BKUP=${BKUP_FOLDER}/ip6tables-save-res-${TIMESTAMP}.txt
mkdir -p ${BKUP_FOLDER}
sudo iptables-save > ${IP4_RULES_BKUP}
sudo ip6tables-save > ${IP6_RULES_BKUP}
echo iptables-save result saved to ${IP4_RULES_BKUP}
echo ip6tables-save result saved to ${IP6_RULES_BKUP}

