echo "##############################################"
echo "STOP AND EDIT  /etc/openvpn/easy-rsa/2.0/vars"
echo "EDIT THE EXPORT lines at end of file"
echo "#############################################"
echo " "

echo "export KEY_COUNTRY="
echo "export KEY_PROVINCE="
echo "export KEY_CITY="
echo "export KEY_ORG="
echo "export KEY_EMAIL="
chkconfig openvpn on
