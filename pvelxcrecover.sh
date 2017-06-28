#!/bin/bash
# qemu-img info /silo/array1/Backup/2017-06-28-bos-hv02/vz/images/101/vm-101-disk-1.raw

imgdir="/silo/array1/Backup/2017-06-28-bos-hv02/vz/images/"
lxcdir="/var/lib/lxc/"

for img in $(find $imgdir -iname "vm-*.raw"); do
	imgname=$(basename $img)
	ctid=$(echo $imgname | grep -oP '\d+' | head -1)
	lxconf=""
	size=$(qemu-img info $img | grep "virtual size" | awk '{print $3}');
	echo "Found disk image $(basename $img) - Size: $size";
	lxconf=$(find $lxcdir -ipath "*$ctid*" | grep config )
	if [[ $lxconf ]]; then
		echo "Found lxconf at $lxconf  Extracting container properties..."
		lxconf_arch=$(grep "lxc.arch" $lxconf | awk '{ print $NF }')
		lxconf_hostname=$(grep "lxc.utsname" $lxconf | awk '{ print $NF }')
		lxconf_memory=$(grep "lxc.cgroup.memory.limit_in_bytes" $lxconf | awk '{ print $NF }' | awk '{ byte =$1 /1024/1024 ; print byte }')
		lxconf_cpushares=$(grep "lxc.cgroup.cpu.shares" $lxconf | awk '{ print $NF }')
		lxconf_cpus=$(grep "lxc.cgroup.cpuset.cpus" $lxconf | awk '{ print $NF }')
		echo -e "\tarch: $lxconf_arch"
		echo -e "\thostname: $lxconf_hostname"
		echo -e "\tmemory: $lxconf_memory"
		echo -e "\tcpu units: $lxconf_cpushares"
	else
		echo "Did not find lxconf - skipping"
		echo ""
		continue
	fi;

	export lxconf_cpushares
	export lxconf_arch
	export lxconf_hostname
	export lxconf_memory
	export size
	export ctid
	if [ ! -f /etc/pve/lxc/$ctid.conf ]; then
		envsubst < pve-ct.conf.template > /etc/pve/lxc/$ctid.conf
		echo ""
	fi;

done;
