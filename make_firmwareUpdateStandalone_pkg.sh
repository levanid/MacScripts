#!/bin/sh
# Based on investigations and work by Pepijn Bruienne
# Updated by Levanid to support Mojave
# Expects a single /Applications/Install macOS Mojave.app on disk

#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

IDENTIFIER="com.foo.FirmwareUpdateStandalone"
VERSION=1.01

# find the Install macOS Mojave.app and mount the embedded InstallESD disk image
echo "Mounting Mojave ESD disk image..."
/usr/bin/hdiutil mount /Applications/Install macOS Mojave.app/Contents/SharedSupport/InstallESD.dmg

# expand the FirmwareUpdate.pkg to copy resources from it
echo "Expanding FirmwareUpdate.pkg"
/usr/sbin/pkgutil --expand /Volumes/InstallESD/Packages/FirmwareUpdate.pkg /tmp/FirmwareUpdate

# Eject disk image as we don't need it any more
echo "Ejecting disk image..."
/usr/bin/hdiutil eject /Volumes/InstallESD

# make a place to stage our pkg resources
/bin/mkdir -p /tmp/FirmwareUpdateStandalone/scripts

# copy the needed resources
echo "Copying package resources..."
/bin/cp /tmp/FirmwareUpdate/Scripts/postinstall_actions/update /tmp/FirmwareUpdateStandalone/scripts/postinstall
# add an exit 0 at the end of the script
echo "" >> /tmp/FirmwareUpdateStandalone/scripts/postinstall
echo "" >> /tmp/FirmwareUpdateStandalone/scripts/postinstall
echo "exit 0" >> /tmp/FirmwareUpdateStandalone/scripts/postinstall
/bin/cp -R /tmp/FirmwareUpdate/Scripts/Tools /tmp/FirmwareUpdateStandalone/scripts/

# build the package
echo "Building standalone package..."
/usr/bin/pkgbuild --nopayload --scripts /tmp/FirmwareUpdateStandalone/scripts --identifier "$IDENTIFIER" --version "$VERSION" /tmp/FirmwareUpdateStandalone/FirmwareUpdateStandalone.pkg

# clean up
/bin/rm -r /tmp/FirmwareUpdate
/bin/rm -r /tmp/FirmwareUpdateStandalone/scripts
