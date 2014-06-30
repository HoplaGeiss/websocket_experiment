#!/bin/bash
declare ids=''
declare cmdLines=''
declare fileNames=''

# Verifies the scripts as the correct number of parameters
if [ $# -ne 2 ]
then 
  echo "Verify usage: experiment.sh <nb_client_sec> <time_experiment>"
  exit 1
fi

# Asks if the local runs the code in local or on a remote server
echo "To plot the experiment, the script needs to be run on a server enabling graphical output"
while true 
do
  read -p "Does your server enable it? [Y/N] " yn
  case $yn in
    [Yy]* ) 
      remote_server=false
      break;;
    [Nn]* ) 
      remote_server=true
      break;;
    * ) 
      echo "Please answer yes or no.";;
  esac
done

# Asks the user for it's local ip, so as to plot the graph from its computer
if $remote_server 
then
  while true; do
    read -p "Please type in your ip: " local_ip 
    read -p "Please type your login: " local_login
    if ssh -o connectTimeout=5 $local_login@$local_ip 'exit' 
    then 
      break
    else 
      echo "this IP can not be reached" 
    fi
  done
fi

# Creates a new folder for each experiments
date=$(date +%Y-%m-%d)
if $remote_server 
then
  time=$(date | awk '{print $4}')
else
  time=$(date | awk '{print $5}')
fi
folder="results/experiment_$date"_"$time"
mkdir "$folder"

# Stores values in a file for later use
echo $1 > $folder/conf.txt
echo $2 >> $folder/conf.txt

top -b -d 1 > "$folder"/top.txt & # Starts top and saves raw data in top.txt

# Starts the clients and the servers scripts
node serverScript.js &
node clientScript.js $1 $2 &

# Stops the recording after the "time_experiment" is over
sleep $2 
pkill top

grep node "$folder"/top.txt > "$folder"/node.txt # Saves raw data concerning node process in node.txt
grep node "$folder"/top.txt | cut -c 1-5 > "$folder"/id.txt
rm "$folder"/top.txt

# Saves the process ids in ids 
while read line
do
  if [[ ! $ids =~ $line ]]
  then
    ids="$ids $line"
  fi 
done < "$folder"/id.txt 


# Creates a folder storing the data of each processus
for id in $ids
do
  # saves the command line used for each node_process
  rawCmdLine=$(cat /proc/$id/cmdline) # Looks into /proc to find the name of the command line
  almostGoodCmdLine="${rawCmdLine##*/}" # supresses confusing path at the begenning of the process name 
  cmdLine="${almostGoodCmdLine%%.js*}" # Supresses confusing details at the end of the process name 
  cmdLines="$cmdLines $cmdLine" # Saves the process names in an array
  fileNames="$fileNames $cmdLine:$id" # Saves the fileNames in an array
  
  # Write measurements in files 
  echo $cmdLine > "$folder"/"$cmdLine":"$id".txt # writes the name of the command line used, so as to use it as label in gnuplot
  grep $id "$folder"/node.txt |cut -c 49-52 | nl >> "$folder"/"$cmdLine":"$id".txt # greps all the lines in node.txt corresponding to the current id and prints it in a file 
done

# We gathered all the informations on the node process, they can be killed
pkill node 

# Cleans the directory
rm "$folder"/id.txt
rm "$folder"/node.txt

# Plots the graph
if $remote_server 
then
  # Sends the results folder to the client 
  if scp -r -q $folder hopla@$local_ip:project/experiment/results
  then 
    echo "Data sent to localhost"
  else
    echo "Problem with sending the data"
  fi
else
  /bin/bash plot.sh & 
fi



