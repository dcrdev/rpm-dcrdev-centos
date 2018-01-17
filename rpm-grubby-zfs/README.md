# rpm-grubby-zfs
This script patches the grubby package in RHEL/CentOS 7 to cater for having your root filesystem on ZFS. By default grubby does not understand ZFS and you will likely see "unable to find suitable template" messages on every Kernel upgrade, resulting in having to manually regenerate the grub menu; this will fix that.

Additionally if your ZFS root filesystem is on a dm-crypt container, grub2-mkconfig won't know how to handle that - by default it will look for the block device in /dev whereas it should be looking in /dev/mapper. Traditionally people have solved this by creating symlinks, but this patch will remove the problem entirely.

After running the resultant script and building the package, you will be left with the grubby-zfs package - the package both obsoletes grubby and provides it at the same time; so is effectively a straight swap in.

This work brings together several peoples efforts:
 * [Grubby Patch](https://bugzilla.redhat.com/show_bug.cgi?id=1410591)
 * [grub-zfs-fixer](https://github.com/Rudd-O/zfs-fedora-installer/tree/master/grub-zfs-fixer)

Usage:

```
./grab.sh
```

### Building
To build the package, I reccomend using the [Brimstone](https://github.com/dcrdev/brimstone) tool or mock ; although there's nothing special about the resultant spec, so rpmbuild will be fine also.

### Issues
The script amongst other things downloads all the sources for you: the CentOS package source, grubby and all patches. In order to download grubby the script is intended to parse Source0 from the spec file, unfortunately the CentOS package has an invalid url. For now I'm including the grubby tarball in this repo - but as and when this is fixed, you can just uncomment lines 88-90.
