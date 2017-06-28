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
`./pvelxcrecover.sh /var/vz/images/ /var/lib/lxc/`
