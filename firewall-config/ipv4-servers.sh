
DNS_SERVERS=$(cat /etc/resolv.conf | grep "nameserver [0-9]*\." | cut -d ' ' -f 2)

for SERVER in ${DNS_SERVERS} 
do
	echo ${SERVER}
done

