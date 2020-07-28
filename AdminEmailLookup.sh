#!/bin/bash

read -p 'Admin contact file: ' adminList

#Update LDAP server URL/IP and port #, and ADUSERNAME and ADPASSWORD
for i in `cat $adminList`
	do ADMINCONTACT=`ldapsearch -H ldaps://LDAPSERVER:LDAPPORT -x -D ADUSERNAME -b dc=comcast,dc=com -w 'ADPASSWORD' sAMAccountName=$i | grep -e mail: | awk '{print $2}'`
	if [ -z "$ADMINCONTACT" ]
	then
		echo "NULL"
	else 
    		echo "$ADMINCONTACT"
	fi
done 
