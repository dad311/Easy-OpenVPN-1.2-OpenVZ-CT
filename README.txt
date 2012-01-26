You will need the following:

You will need a static public IP address OR a domain name with a dynamic DNS.  Basically some way to to connect to your network from the outside.

This script will open port UDP port 1194 to you VM.


Create a VM using the Easy OpenVPN template.



Make sure to use a bridge veth Ethernet!



After install edit eth0 information for you network.



cat /etc/network-scripts/ifcfg-eth0


Example:
# Primary network interface

DEVICE=eth0

ONBOOT=yes

IPADDR=192.168.100.250

NETMASK=255.255.255.0

GATEWAY=192.168.100.1



Type: service network restart



Type: ifconfig


If your interface looks correct, try pinging  google.com.

If your interface is working continue.................



There are 4 scripts located in “/root/EasyOpenVPN”:



STEP1_create-proxmox_tun_commands.sh

STEP2_install-EasyOpenVPN_part1.sh

STEP3_install-EasyOpenVPN_part2.sh

create-EasyOpenVPN_client.sh


Next run the  script (STEP1_create-proxmox_tun_commands.sh).  This script will create several commands that YOU WILL NEED TO MANUALLY CUT AND PASTE INTO YOUR PROXMOX SERVER.  These command will enable your VM to create a tun device for your VPN interface.



Script output:

Please enter VMID

Example: 101

101


 

Please enter these command into you Proxmox server:

vzctl set 101 --devices c:10:200:rw --save

vzctl set 101 --capability net_admin:on --save

vzctl exec 101 mkdir -p /dev/net

vzctl exec 101 mknod /dev/net/tun c 10 200

vzctl exec 101 chmod 600 /dev/net/tun

vzctl set 101 --devnodes net/tun:rw --save





Run the  second script (STEP2_install-EasyOpenVPN_part1.sh). This script does nothing but tell you what file to edit for your certificate, all software is already installed. Enter your information. 




Run the  script (STEP3_install-EasyOpenVPN_part2.sh), the script will ask for more address info for your certificate and then create your certificates.  MAKE SURE EACH QUESTION is answered with some text and except ALL defaults answers.  Most default answers are from the file edited in step1. 


Do not change the "common name" when ask.  The script expects to see the name "server".






Type ifconfig and see if you have a tun0 interface as below.



root@pbx:~ $ ifconfig





tun0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  

          inet addr:10.8.0.1  P-t-P:10.8.0.2  Mask:255.255.255.255

          UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:1500  Metric:1

          RX packets:0 errors:0 dropped:0 overruns:0 frame:0

          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0

          collisions:0 txqueuelen:100 

          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)






The forth script (create-EasyOpenVPN-client.sh) creates your Openvpn client config files.  Run the create-openvpn-client.sh script and answer the questions (client name, server ip/fqdn address, etc.



The client config files will be placed into a dir “/root/key/<client-name>”.  Repeat this script for each client giving each client a NEW NAME.



After creating the client configs, place the <client-name>.tar file on your client.  



./create-EasyOpenVPN-client.sh

Please enter name for cert

Example: Desktop

Remote-PBX

Please enter your FQDN

Example: mypbx.homelinux.com

mypbx.homelinux.com

NOTE: If you run ./clean-all, I will be doing a rm -rf on /etc/openvpn/easy-rsa/keys

Generating a 1024 bit RSA private key

......................................++++++

.............++++++

writing new private key to 'Remote-PBX.key'

-----

Using configuration from /etc/openvpn/easy-rsa/openssl.cnf

Check that the request matches the signature

Signature ok

The Subject's Distinguished Name is as follows

countryName           :PRINTABLE:'US'

stateOrProvinceName   :PRINTABLE:'NY'

localityName          :PRINTABLE:'SanFrancisco'

organizationName      :PRINTABLE:'Fort-Funston'

commonName            :PRINTABLE:'Remote-PBX'

emailAddress          :IA5STRING:'me@myhost.mydomain'

Certificate is to be certified until Dec 19 15:47:54 2020 GMT (3650 days)



Write out database with 1 new entries

Data Base Updated

rm: cannot remove `/etc/openvpn/client.conf.tmp*': No such file or directory

tar: ./Remote-PBX.tar: file is the archive; not dumped

Client config files saved to /root/keys/Remote-PBX

Copy the tar file to the new client









NOTE(s):  

1) The below steps will allow the 10.x.x.x network to communicate with the 192.x.x.x network.


To enable ip forwarding type "iptables -t nat -A PREROUTING -i tun0 -j DNAT --to VM.ip"



To configure a CentOS or Fedora Linux host to forward IPv4 traffic, you can set the “net.ipv4.ip_forward” sysctl to 1 in /etc/sysctl.conf:

net.ipv4.ip_forward = 1

Once the sysctl is added to /etc/sysctl.conf, you can enable it by running sysctl with the “-w” (change a specific sysctl value) option:
$ /sbin/sysctl -w net.ipv4.ip_forward=1
net.ipv4.ip_forward = 1

If routing is configured correctly on the router, packets should start flowing between the interfaces on the server.
