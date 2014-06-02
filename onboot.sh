#!/bin/sh

ldapserver=( $(dscl localhost -list /LDAPv3) )
adserver=( $(dscl localhost -list /Active\ Directory) )
host=`/usr/sbin/scutil --get LocalHostName`

# Install Centrify Express for AD binding

if [ -e $3/usr/local/onboot/centrifyinstalled ]
then
echo "Centrify already run"
else
/usr/sbin/installer -pkg $3/usr/local/onboot/Centrify.pkg -target $3/ && /usr/bin/touch $3/usr/local/onboot/centrifyinstalled
fi

# Unbind from any OD

if [ -z $ldapserver ]
then
echo "Not bound to OD"
/usr/bin/touch $3/usr/local/onboot/unbind
else

if [ -e $3/usr/local/onboot/unbind ] 
then
echo "Unbind already run"
else
for ldap in "${ldapserver[@]}"
do
/usr/sbin/dsconfigldap -r "$ldap" && /usr/bin/touch $3/usr/local/onboot/unbind
done
fi
fi

# Unbind from built in AD

if [ -z $adserver ]
then
echo "Not bound to AD"
/usr/bin/touch $3/usr/local/onboot/adunbind
else

if [ -e $3/usr/local/onboot/adunbind ] 
then
echo "AD Unbind already run"
else
for ad in "${adserver[@]}"
do
/usr/sbin/dsconfigad -force -remove -u none -p none "$ad" && /usr/bin/touch $3/usr/local/onboot/adunbind
done
fi
fi

# Install trusted certificate

if [ -e $3/usr/local/onboot/trusted ]
then
echo "Trusted already installed"
else
/usr/bin/security add-trusted-cert -d -r trustRoot -k "$3/Library/Keychains/System.keychain" "$3/usr/local/onboot/trusted.pem" && /usr/bin/touch $3/usr/local/onboot/trusted
fi

# If Smartboard software is installed upgrade it to the new version

if [ -e $3/usr/local/onboot/smart ]
then
echo "SMART installed (or doesn't exist)"
else
if [ -e $3/Applications/SMART\ Technologies ]
then 
/usr/sbin/installer -pkg $3/usr/local/onboot/Education\ Software\ 2013\ December.pkg -target $3/ && /usr/bin/touch $3/usr/local/onboot/smart
else
/usr/bin/touch $3/usr/local/onboot/smart
fi
fi

# Install puppet client

if [ -e $3/usr/local/onboot/puppet ]
then
echo "Puppet already run"
else
/usr/sbin/installer -pkg $3/usr/local/onboot/Mavericks_Puppet.pkg -target $3/ && /usr/bin/touch $3/usr/local/onboot/puppet
fi

# Remove receipts from App Store apps so user can tie them to their own iTunes account

if [ -e $3/usr/local/onboot/receipts ]
then
echo "Receipts already run"
else
$3/usr/local/onboot/ReceiptRemoval.sh && /usr/bin/touch $3/usr/local/onboot/receipts
fi

# Run script to connect to wireless

if [ -e $3/usr/local/onboot/wireless ]
then
echo "Wireless already run"
else
$3/usr/local/onboot/wireless.sh && /usr/bin/touch $3/usr/local/onboot/wireless
fi

# Disable gatekeeper

if [ -e $3/usr/local/onboot/gatekeeper ]
then
echo "Gatekeeper already run"
else
$3/usr/sbin/spctl --master-disable && /usr/bin/touch $3/usr/local/onboot/gatekeeper
fi

# Self cleanup if all of the above has been done successfully

if [ -e $3/usr/local/onboot/centrifyinstalled ] && [ -e $3/usr/local/onboot/unbind ] && [ -e $3/usr/local/onboot/adunbind ]&& [ -e $3/usr/local/onboot/trusted ] && [ -e $3/usr/local/onboot/smart ] && [ -e $3/usr/local/onboot/puppet ] && [ -e $3/usr/local/onboot/receipts ] && [ -e /usr/local/onboot/wireless ] && [ -e /usr/local/onboot/gatekeeper ] 
then

rm $3/Library/LaunchDaemons/com.onboot.plist
rm -r $3/usr/local/onboot
fi
