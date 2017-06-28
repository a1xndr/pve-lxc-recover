### pve configuration recovery from lxc configs and raw disk images

## how to use
`pvelxcrecover.sh /path/containing/raw/disk/images /path/containing/lxc/configs/`

## what works
 * detecting raw image size
 * re-assembling most pve ct config variables from lxc configs. these include
   hostname, cpu units, memory, arch

## what doesnt work
 * automatically re-creating mount points defined within pve
 * restoring the "autostart" status of containers

## what can work but doesnt work
 * ostype detection
 * hostname detection from raw disk image
 * mac detection 

## example
make sure to back up any lxc configs and raw images

`./pvelxcrecover.sh /var/vz/images/ /var/lib/lxc/`

example output
```
Found disk image vm-106-disk-1.raw - Size: 24G
Found lxconf at /tmp/tmpmnt/var/lib/lxc/106/config  Extracting container properties...
        arch: amd64
        hostname: bos-sql01
        memory: 1024
        cpu units: 1024

Found disk image vm-121-disk-1.raw - Size: 8.0G
Found lxconf at /tmp/tmpmnt/var/lib/lxc/121/config  Extracting container properties...
        arch: amd64
        hostname: bos-nfs01
        memory: 512
        cpu units: 1024

Found disk image vm-100-disk-1.raw - Size: 8.0G
Found lxconf at /tmp/tmpmnt/var/lib/lxc/100/config  Extracting container properties...
        arch: amd64
        hostname: bos-dns01
        memory: 512
        cpu units: 1024

Found disk image vm-103-disk-1.raw - Size: 12G
Found lxconf at /tmp/tmpmnt/var/lib/lxc/103/config  Extracting container properties...
        arch: amd64
        hostname: bos-rtr01
        memory: 12288
        cpu units: 1024
```
