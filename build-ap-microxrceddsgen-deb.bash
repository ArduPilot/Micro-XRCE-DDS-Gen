#!/bin/bash

set -euf -o pipefail

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION="$1"

echo "Updating control file with version $VERSION"
sed -i "s/^Version: .*/Version: $VERSION/" ap-microxrceddsgen/DEBIAN/control

echo "Copying launcher"
cp scripts/microxrceddsgen ap-microxrceddsgen/opt/ardupilot/Micro-XRCE-DDS-Gen/bin/microxrceddsgen

echo "Setting permissions for the launcher"
chmod 755 ap-microxrceddsgen/opt/ardupilot/Micro-XRCE-DDS-Gen/bin/microxrceddsgen

echo "Copying jar"
cp share/microxrceddsgen/java/microxrceddsgen.jar ap-microxrceddsgen/opt/ardupilot/Micro-XRCE-DDS-Gen/share/microxrceddsgen/java

echo "Setting permissions for the jar"
chmod 644 ap-microxrceddsgen/opt/ardupilot/Micro-XRCE-DDS-Gen/share/microxrceddsgen/java/microxrceddsgen.jar

echo "Generating .deb"
dpkg-deb --root-owner-group --build ap-microxrceddsgen "ap_microxrceddsgen_${VERSION}_all.deb"

echo "Package information:"
dpkg-deb --info "ap_microxrceddsgen_${VERSION}_all.deb"

echo "Package contents:"
dpkg-deb --contents "ap_microxrceddsgen_${VERSION}_all.deb"
