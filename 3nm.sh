#!/bin/sh

#create namespaces
sudo ip netns add n1
sudo ip netns add n2
sudo ip netns add n3

#create veth pairs
sudo ip link add n12 type veth peer name n21
sudo ip link add n13 type veth peer name n31
sudo ip link add n23 type veth peer name n32

#assign veth pairs to each namespace
sudo ip link set n12 netns n1
sudo ip link set n13 netns n1
sudo ip link set n21 netns n2
sudo ip link set n23 netns n2
sudo ip link set n31 netns n3
sudo ip link set n32 netns n3

#add ip adresses
sudo ip netns exec n1 ip addr add 198.51.100.1/24 dev n12
sudo ip netns exec n2 ip addr add 198.51.100.2/24 dev n21
sudo ip netns exec n3 ip addr add 198.51.101.1/24 dev n31
sudo ip netns exec n1 ip addr add 198.51.101.2/24 dev n13
sudo ip netns exec n2 ip addr add 198.51.102.1/24 dev n23
sudo ip netns exec n3 ip addr add 198.51.102.2/24 dev n32

#up all interfaces
sudo ip netns exec n1 ip link set dev n12 up
sudo ip netns exec n1 ip link set dev n13 up
sudo ip netns exec n1 ip link set dev lo up
sudo ip netns exec n2 ip link set dev n21 up
sudo ip netns exec n2 ip link set dev n23 up
sudo ip netns exec n2 ip link set dev lo up
sudo ip netns exec n3 ip link set dev n31 up
sudo ip netns exec n3 ip link set dev n32 up
sudo ip netns exec n3 ip link set dev lo up

#enable ip forwarding
sudo ip netns exec n1 echo 1 > /proc/sys/net/ipv4/ip_forward
sudo ip netns exec n2 echo 1 > /proc/sys/net/ipv4/ip_forward
sudo ip netns exec n3 echo 1 > /proc/sys/net/ipv4/ip_forward

#add routes
sudo ip netns exec n1 ip route add 198.51.102.0/24 dev n12 via 198.51.100.2
sido ip netns exec n2 ip route add 198.51.101.0/24 dev n21 via 198.51.100.1
sudo ip netns exec n3 ip route add 198.51.100.0/24 dev n31 via 198.51.101.2



