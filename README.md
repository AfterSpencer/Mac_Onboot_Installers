Mac Onboot Installers
=====================

For use with installers that don't like being installed in base images or DeploStudio workflows.

Each section of code has a check for a marker file which, if it exists will skip the section. The script is self removing as long as all of the previously defined tasks have completed successfully. The script will keep trying on each and every boot, even if it gets interrupted in the middle of running.

Usage:

Edit onboot.sh to match the things you want it to install or do on first boot.

Build a package that installs com.onboot.plist in /Library/LaunchDaemons and the rest in /usr/local/onboot
