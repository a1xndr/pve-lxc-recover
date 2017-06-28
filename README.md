### PVE LXC Recovery

## What works
 * Detecting raw image size
 * Re-assembling most PVE ct config variables from LXC configs. These include
   hostname, cpu units, memory, arch

## What doesnt work
 * Automatically re-creating mount points defined within PVE
