#!/bin/sh
for IFACE in `ifconfig | grep vboxnet | cut -b 1-8`
	do
		echo "Bringing down $IFACE... \c"
		ifconfig $IFACE down
		echo Done
		echo "Bringing up $IFACE... \c"
		ifconfig $IFACE up
		echo Done
	done	

pfctl -evf /etc/pf.anchors/dev
