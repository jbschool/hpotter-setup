# a file to reverse any changes to the input and output chains

iptables --policy INPUT ACCEPT
iptables --policy OUTPUT ACCEPT
iptables --flush INPUT
iptables --flush OUTPUT
