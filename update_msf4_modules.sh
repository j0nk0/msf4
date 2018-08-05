#!/bin/bash
#set -x
cd $(dirname "$0")/.msf4

if [ ! -d modules ];then
 echo "[X] Directory doesnt exist: modules"
 exit
fi

if [ ! -d /$USER/.msf4/modules ];then
 echo "[X] Directory doesnt exist: /$USER/.msf4/modules"
 exit
fi

for i in $(find modules -type f); do
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
