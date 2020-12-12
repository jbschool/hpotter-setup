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

