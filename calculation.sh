#!/bin/bash
declare ids=''
declare cmdLines=''
let communication=$1*$3
folder="$5"
# Creates a new folder for each experiments
date=$(date +%Y-%m-%d)
# If we are on the remote machine the print $4
if [ "$6" -ge 1 ] 
then
  remote_server=true
  if [ "$9" -ge 1 ]
  then
    remote_serverIsClient=true
  else
    remote_serverIsClient=false
  fi
else
  remote_server=false
fi
# Checks if we want to use SocketCluster
if [ "$4" -ge 1 ]
then
  isSocketCluster=true
else
  isSocketCluster=false
fi

mkdir "results/$folder"
cd "results/$folder"
mkdir server
mkdir local_machine
mkdir client
cd ../..

pkill node

# Stores values in a file for later use
echo $1 > results/$folder/conf.txt
echo $2 >> results/$folder/conf.txt

top -b -d 1 > results/$folder/top.txt & # Starts top and saves raw data in top.txt

# Starts the clients and the servers scripts
if $isSocketCluster 
then
  if $remote_server && ! $remote_serverIsClient 
  then
    node serverScript $7 $8 &
  elif $remote_server && $remote_serverIsClient
  then 
    node clientJon $1 $2 $3 ${10} &
  elif ! $remote_server  
  then
    node serverScript $7 $8 & 
    node clientJon $1 $2 $3 localhost &
  fi
else
  if $remote_server && ! $remote_serverIsClient 
  then
    node serverSocket &
  elif $remote_server && $remote_serverIsClient
  then 
    node clientSocket $1 $2 $3 ${10} &
  elif ! $remote_server  
  then
    node serverSocket & 
    node clientSocket $1 $2 $3 localhost &
  fi
fi

# Stops the recording after the "time_experiment" is over
sleep $2 
pkill top

grep node results/$folder/top.txt > results/$folder/node.txt # Saves raw data concerning node process in node.txt
grep node results/$folder/top.txt | cut -c 1-6 > results/$folder/id.txt
rm results/$folder/top.txt

# Saves the process ids in ids 
while read line
do
  if [[ ! $ids =~ $line ]]
  then
    ids="$ids $line"
  fi 
done < results/$folder/id.txt 

# Remove unwanted ids
if $isSocketCluster
then
  if $remote_server && ! $remote_serverIsClient 
  then
    ids=$(echo $ids | cut -d " " -f3-)
  elif $remote_server && $remote_serverIsClient
  then
    ids=$(echo $ids | cut -d " " -f2-)
  elif ! $remote_server 
  then
    ids=$(echo $ids | cut -d " " -f4-)
  fi
else
  if $remote_server && $remote_serverIsClient
  then
    ids=$(echo $ids | awk '{$NF = ""; print}')
  fi
fi


# Creates a folder storing the data of each processus
for id in $ids
do
  # saves the command line used for each node_process
  rawCmdLine=$(cat /proc/$id/cmdline) # Looks into /proc to find the name of the command line
  cmdLine="${rawCmdLine##*/}" # supresses confusing path at the begenning of the process name 
  cmdLine="${cmdLine%%.js*}" # Supresses confusing details at the end of the process name 
  cmdLine="${cmdLine%%[0-9]*}" # Supresses confusing details at the end of the process name 
  cmdLines="$cmdLines $cmdLine" # Saves the process names in an array

  # Write measurements in files 
  if $remote_server && ! $remote_serverIsClient 
  then
    echo $cmdLine > results/$folder/server/"$cmdLine":"$id".txt 
  elif $remote_server && $remote_serverIsClient
  then
    echo $cmdLine > results/$folder/client/"$cmdLine":"$id".txt 
  elif ! $remote_server 
  then
    echo $cmdLine > results/$folder/local_machine/"$cmdLine":"$id".txt 
  fi

  if $remote_server && ! $remote_serverIsClient 
  then
    grep $id results/$folder/node.txt |cut -c 48-51 | nl | awk -v communication="$communication" '{printf "%d %d \n", communication*$1 , $2}' >> results/$folder/server/"$cmdLine":"$id".txt 
    # grep $id results/$folder/node.txt |cut -c 48-51 | nl >> results/$folder/server/"$cmdLine":"$id".txt # greps all the lines in node.txt corresponding to the current id and prints it in a file 
  elif $remote_server && $remote_serverIsClient
  then
    grep $id results/$folder/node.txt |cut -c 48-51 | nl | awk -v communication="$communication" '{printf "%d %d \n", communication*$1 , $2}' >> results/$folder/client/"$cmdLine":"$id".txt 
  elif ! $remote_server 
  then
    grep $id results/$folder/node.txt |cut -c 49-52 | nl | awk -v communication="$communication" '{printf "%d %d \n", communication*$1 , $2}' >> results/$folder/local_machine/"$cmdLine":"$id".txt # greps all the lines in node.txt corresponding to the current id and prints it in a file 
  fi
done
sleep 5

# We gathered all the informations on the node process, they can be killed
pkill node 

# Cleans the directory
# rm results/$folder/id.txt
# rm results/$folder/node.txt

