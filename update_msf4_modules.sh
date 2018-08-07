#!/bin/bash
#set -x
cd $(dirname "$0")/.msf4

#Tag the name in module to easy find custom modules
edit_(){
if ! grep "Name'          => 'j0nk0 " "$@"
 then
  echo "Modifying file: $@"
  sed -i "s/Name'          => '/Name'          => 'j0nk0\ /g"  $@
 else
  echo "Not modifying file: $@"
fi
}

#Check if command exists/is installed
is_installed(){
if ! which $1 &>/dev/null; then
  echo "[!] Error: $1 is not installed"
  echo "[!] Installing missing package: $1"
  apt install $1
   if [ $? -ne 0 ]; then
     echo "[!] Installed package: $1"
   else
     echo "[!] Error Installing package: $1"
    exit
   fi
 exit 1
else
  echo "[*] $1 is installed"
fi
}

is_installed meld
is_installed diff
is_installed msfconsole

#Check if directorys exist
if [ ! -d modules ];then
 echo "[X] Directory doesnt exist: modules"
 exit
fi

if [ ! -d /$USER/.msf4/modules ];then
 echo "[X] Directory doesnt exist: /$USER/.msf4/modules"
 exit
fi
for i in $(find */ -type f)
 do
  edit_ $i
done

for i in $(find modules -type f); do
  edit_="$i"
  if [ -f /$USER/.msf4/$i ];then
    echo "File exists: /$USER/.msf4/$i"
     diff "$i" "/$USER/.msf4/$i" &>/dev/null
     if ! [ $? -eq 0 ];then
       meld "$i" "/$USER/.msf4/$i"
     fi
  else
   cp --verbose "$i" "/$USER/.msf4/$i"
  fi
done

echo "Done"

#Reload msf database
read -p "Press enter to reload metasploit database?(ctrl-c to abort)" ans
echo "service postgresql start"
  service postgresql start
echo "msfdb reinit"
  msfdb reinit
echo "msfconsole -q -x 'db_status; reload_all'"
  msfconsole -q -x 'db_status; reload_all'

echo "Done, exiting"
exit
