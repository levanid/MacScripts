# MacScripts
Some scripts for MacOs

**make_FirmwareUpdateStandalone_pkg.sh**
based on https://github.com/munki/macadmin-scripts

This script extracts firmware updaters from MacOS Mojave installers and makes a standalone installer package that could be used to upgrade Mac firmware in case your firmware was not updated with a fresh Mojave install

You'll need Install macOS Mojave.app in Applications folder

Use `sudo sh make_FirmwareUpdateStandalone_pkg.sh`

The package will be placed to /tmp/FirmwareUpdateStandalone/FirmwareUpdateStandalone.pkg
