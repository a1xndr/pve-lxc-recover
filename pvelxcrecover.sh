#!/bin/bash
#Tested with PVE 5.0-10B2

imgdir=$1
lxcdir=$2

# Cycle over found raw disk images
for img in $(find $imgdir -iname "vm-*.raw"); do
	imgname=$(basename $img)
	ctid=$(echo $imgname | grep -oP '\d+' | head -1)
	lxconf=""
	size=$(qemu-img info $img | grep "virtual size" | awk '{print $3}');
	echo "Found disk image $(basename $img) - Size: $size";
	lxconf=$(find $lxcdir -ipath "*$ctid*" | grep config )
	if [[ $lxconf ]]; then
		# Extract and format variables for the pve ct configs
		echo "Found lxconf at $lxconf  Extracting container properties..."
		lxconf_arch=$(grep "lxc.arch" $lxconf | awk '{ print $NF }')
		lxconf_hostname=$(grep "lxc.utsname" $lxconf | awk '{ print $NF }')
		lxconf_memory=$(grep "lxc.cgroup.memory.limit_in_bytes" $lxconf |\
			awk '{ print $NF }' | awk '{ byte =$1 /1024/1024 ; print byte }')
		lxconf_cpushares=$(grep "lxc.cgroup.cpu.shares" $lxconf |\
			awk '{ print $NF }')
		lxconf_cpus=$(grep "lxc.cgroup.cpuset.cpus" $lxconf |\
			awk '{ print $NF }')
		echo -e "\tarch: $lxconf_arch"
		echo -e "\thostname: $lxconf_hostname"
		echo -e "\tmemory: $lxconf_memory"
		echo -e "\tcpu units: $lxconf_cpushares"
	else
		echo "Did not find lxconf - skipping"
		echo ""
		continue
	fi;

	# Copy the raw disk image to the proper location if its not there already
	if [ ! -f /var/lib/vz/images/$ctid/vm-$ctid-disk-1.raw ]; then
		mkdir /var/lib/vz/images/$ctid/
		cp $img /var/lib/vz/images/$ctid/vm-$ctid-disk-1.raw
	fi;

	export lxconf_cpushares
	export lxconf_arch
	export lxconf_hostname
	export lxconf_memory
	export size
	export ctid

	# Apply the discovered variables to the template and store it in the right
	# dir
	if [ ! -f /etc/pve/lxc/$ctid.conf ]; then
		envsubst < pve-ct.conf.template > /etc/pve/lxc/$ctid.conf
		echo ""
	fi;
done;
