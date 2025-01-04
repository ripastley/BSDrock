#!/bin/sh
set -e

	read -p "Enter jail container directory (default: /usr/local/jails/containers):" JAILDIR
	read -p "Enter static IP for jail: " STATIC_IP
	read -p "Enter network device name (ex: em0): " IFACE
	read -p "Configure SMB (Y/N): " CONFIG_SMB
	read -p "Enable SSH (Y/N): " SSH_ENABLE

# If JAILDIR is empty, assign new value. otherwise assign default value	
	if test -z "$JAILDIR"; then
		JAILDIR="/usr/local/jails/containers"
	fi

# Determine whether to configure SMB
	if [ $CONFIG_SMB = "Y" -o $CONFIG_SMB = "y" ]; then
		CONFIG_SMB=1
	else
		CONFIG_SMB=0
	fi

# Determine whether to configure SSH
	if [ $SSH_ENABLE = "Y" -o $SSH_ENABLE = "y" ]; then
		SSH_ENABLE=1
	else
		SSH_ENABLE=0
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
	if [ $SSH_ENABLE -eq 1 ]; then
		echo "Enable SSH: Yes"
	else
		echo "Enable SSH: No"
	fi

# Determine if we are going to install	
	read -p "Y: Proceed to install | N: Abort install " INSTALL_JAIL
	if [ $INSTALL_JAIL = "Y" -o $INSTALL_JAIL = "y" ]; then
                INSTALL_JAIL=1
        else
                INSTALL_JAIL=0
        fi

	#### FUNCTION BEGIN	
	# Installs container files
	install_bsdrock () {	#installation process
		echo "Starting install"
		if [ -d $JAILDIR ];  then		#check if the jail directory exists. 
			tar xjvf ./bedrock.jail.tar.bz2 -C $JAILDIR	#extract jail into the jail directory
		else
			read -p "Jail directory ${JAILDIR} does not exist. Create it? Y/N: "  CREATE_DIR
			if [ $CREATE_DIR="Y" -o $CREATE_DIR="y" ]; then
				echo "Creating ${JAILDIR}"
				mkdir -p $JAILDIR		
				tar xjvf ./bedrock.jail.tar.bz2 -C $JAILDIR	#extract jail into the jail directory
			else
				echo "No jail installation directory available. Exiting."
				exit 1
			fi
		fi

		cp /etc/resolv.conf $JAILDIR/bedrock/etc/resolv.conf	#copy your resolv.conf into jail
		cp /etc/localtime $JAILDIR/bedrock/etc/localtime 	#copy localtime into jail
	### Modify the jail configuration file with user specified params (ipv4.addr and interface)
		cat ./bedrock.conf | sed -r "s/ip4.addr =/ip4.addr = ${STATIC_IP};/g" | sed -r "s/interface =/interface = ${IFACE};/g" > /etc/jail.conf.d/bedrock.conf
		service jail start bedrock	#start jail for running bins to finish install
		jexec bedrock passwd root	#set root password for the jail
		jexec bedrock passwd bedrock	#set bedrock password for the jail
		if [ $CONFIG_SMB -eq 1 ]; then
			jexec bedrock smbpasswd -a bedrock 	#add bedrock to SMB passwd file and enter password
		fi
		if [ $SSH_ENABLE -eq 1 ]; then
			jexec bedrock sysrc sshd_enable="YES"
		fi
		# Check if SSH or Samba are enabled and restart jail to restart daemons
		if [ $SSH_ENABLE -eq 1 -o $CONFIG_SMB -eq 1 ]; then
			service jail restart bedrock
		fi
	}
	#### FUNCTION END

	if [ $INSTALL_JAIL -eq 1 ]; then
		echo "Installing bedrock"
		install_bsdrock
		echo "Installation complete"
		exit 0
	else
		echo "Aborting install"
		exit 1
	fi
