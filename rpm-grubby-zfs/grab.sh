#!/bin/bash
# ----------------------------------------------------------------------
# Grubby ZFS Patcher v0.0.1
# ----------------------------------------------------------------------
# Copyright (C) 2015, 2016 Dominic Robinson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------

GRUB_ZFS_FIXER="https://raw.githubusercontent.com/Rudd-O/zfs-fedora-installer/master/grub-zfs-fixer/fix-grub-mkconfig";
SPEC_SOURCE0="https://raw.githubusercontent.com/DCRDevRepo/rpm-grubby-zfs/master/grubby-8.28-1.tar.bz2";
GRUBBY_PATCH="https://raw.githubusercontent.com/DCRDevRepo/rpm-grubby-zfs/master/Fix-ZFS-root-pool.patch";
SPEC_PATCH="https://raw.githubusercontent.com/DCRDevRepo/rpm-grubby-zfs/master/grubby-zfs.patch";

# ----------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ----------------------------------------------------------------------

LATEST_PATCH=0;
NEW_PATCH=0;

function Cleanup {
	
	find . ! -name 'grab.sh' ! -name 'README.md' ! -name 'LICENSE' ! -path './.git/*' -type f -exec rm -f {} +
	
}

function GetSpecSource {
	
	specName=`sed -n -e '/^Name:/p' ./grubby.spec | sed -e 's/Name://g' | xargs`
	specVersion=`sed -n -e '/^Version:/p' ./grubby.spec | sed -e 's/Version://g' | xargs`
	specSource0=`sed -n -e '/^Source0:/p' ./grubby.spec | sed -e 's/Source0://g' | xargs`
	specSource0=`echo $specSource0 | sed -e "s/%{name}/$specName/g"`
	
	SPEC_SOURCE0=`echo $specSource0 | sed -e "s/%{version}/$specVersion/g"`
	
}

function DownloadSources {

	mkdir ./.tmp
	curl "https://git.centos.org/zip/?r=rpms/grubby.git&h=c7&format=gz" > ./.tmp/grubby-c7.tar.gz
	tar xvf ./.tmp/grubby-c7.tar.gz -C ./.tmp
	mv ./.tmp/{SOURCES,SPECS}/* .
	rm -rf ./.tmp
	
	curl "$GRUBBY_PATCH" > ./Fix-ZFS-root-pool.patch
	curl "$SPEC_PATCH" > ./grubby-zfs.patch
	curl "$GRUB_ZFS_FIXER" > ./fix-grub-mkconfig
	wget -P ./ "$SPEC_SOURCE0"
	
	md5sum ./*.tar.* > ./sources
	
}

function GetPatchVersion {
	
	LATEST_PATCH=`ls | grep '^[0-9]' | sort -t= -nr -k3 | head -1 | cut -c1-4`
	NEW_PATCH=`printf "%04g" $(( ${LATEST_PATCH#00} +1 ))`
	
	mv ./Fix-ZFS-root-pool.patch ./$NEW_PATCH-Fix-ZFS-root-pool.patch	
	
}

function Patcher {
	
	patch grubby.spec < grubby-zfs.patch
	sed -i "/Patch$LATEST_PATCH:/a Patch$NEW_PATCH: $NEW_PATCH-Fix-ZFS-root-pool.patch" ./grubby.spec
	mv ./grubby.spec ./grubby-zfs.spec
	
}

echo "Cleaning up directory..." && \
Cleanup >/dev/null 2>&1 && \
sleep 3 && \

#echo "Parsing Source0 from spec..." && \
#GetSpecSource >/dev/null 2>&1 && \
#sleep 3 && \

echo "Downloading sources..." && \
DownloadSources >/dev/null 2>&1 && \
sleep 3 && \

echo "Moving to latest patch in series..." && \
GetPatchVersion >/dev/null 2>&1 && \
sleep 3 && \

echo "Applying patches..." && \
Patcher >/dev/null 2>&1 && \
sleep 3 && \

echo "Done."
