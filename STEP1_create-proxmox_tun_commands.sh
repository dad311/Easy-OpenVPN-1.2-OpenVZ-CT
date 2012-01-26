echo "Please enter VMID"
echo "Example: 101"
read ct
clear
echo " "
echo " "
echo "Please enter these command into you Proxmox server:"
echo "vzctl set $ct --devices c:10:200:rw --save"
echo "vzctl set $ct --capability net_admin:on --save"
echo "vzctl exec $ct mkdir -p /dev/net"
echo "vzctl exec $ct mknod /dev/net/tun c 10 200"
echo "vzctl exec $ct chmod 600 /dev/net/tun"
echo "vzctl set $ct --devnodes net/tun:rw --save"

