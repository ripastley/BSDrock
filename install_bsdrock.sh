#!/bin/sh
	read -p "Enter jail container directory (default: /usr/local/jails/containers):" JAILDIR
	read -p "Configure SMB (Y/N):" CONFIG_SMB
	echo $CONFIG_SMB
	
	read -p "Enter static IP for jail:" STATIC_IP
	read -p "Enter network device name (ex: em0)" IFACE

#If JAILDIR is empty, assign new value	
	if test -z "$JAILDIR"; then
		JAILDIR="/usr/local/jails/containers"
	fi

#Determine whether to configure SMB
	if [ $CONFIG_SMB = "Y" -o $CONFIG_SMB = "y" ]; then
		CONFIG_SMB=1
	else
		CONFIG_SMB=0
	fi

	echo "Does this look good?"
	echo -n "Jail directory: "; echo $JAILDIR
	echo -n "Static IP address: "; echo $STATIC_IP
	echo -n "Network device: "; echo $IFACE
	if [ $CONFIG_SMB -eq 1 ]; then
		echo "Enable SMB: Yes"
	else
		echo "Enable SMB: No"
	fi
	read -p "Y: Proceed to install | N: Abort install" INSTALL_YES

	
	install_bsdrock () {	#installation process
		tar xjvf ./bedrock.jail.tar.bz2 -C $JAILDIR	#extract jail into the jail directory
		cp ./bedrock.conf /etc/jail.conf.d
		cp /etc/resolv.conf $JAILDIR/bedrock/etc/resolv.conf
		cp /etc/localtime $JAILDIR/bedrock/etc/localtime 
	#Modify the jail configuration file with user specified params (ipv4.addr and interface)
		cat ./bedrock.conf | sed -r "s/ip4.addr =/ip4.addr = ${STATIC_IP};/g" | sed -r "s/interface =/interface = ${IFACE};/g" > /etc/jail.conf.d/bedrock.conf
		service jail start bedrock	#start jail for running bins to finish install
		jexec bedrock passwd root
		jexec bedrock passwd bedrock
		if [ $CONFIG_SMB -eq 1 ]; then
			jexec bedrock smbpasswd -a bedrock 
		fi
	}
	
	install_bsdrock
	
