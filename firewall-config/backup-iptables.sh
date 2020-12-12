BKUP_FOLDER='./iptables-config-backup'
TIMESTAMP=$(date +'%F-%k%M%S')
IP4_RULES_BKUP=${BKUP_FOLDER}/iptables-save-res-${TIMESTAMP}.txt
IP6_RULES_BKUP=${BKUP_FOLDER}/ip6tables-save-res-${TIMESTAMP}.txt

mkdir -p ${BKUP_FOLDER}
sudo iptables-save > ${IP4_RULES_BKUP}
sudo ip6tables-save > ${IP6_RULES_BKUP}
echo \'sudo iptables-save\' result saved to ${IP4_RULES_BKUP}
echo \'sudo ip6tables-save\' result saved to ${IP6_RULES_BKUP}

unset BKUP_FOLDER
unset TIMESTAMP
unset IP4_RULES_BKUP
unset IP6_RULES_BKUP

