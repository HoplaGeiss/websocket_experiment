#!/bin/bash
dir=$(pwd)
date=$(date +%Y-%m-%d)
time=$(date | awk '{print $5}')
folder="experiment_$date"_"$time"

echo ""
echo ""

# Verifies the scripts as the correct number of parameters
if [ $# -ne 4 ]
then 
  echo "Verify usage: run_experiment.sh <num_client_sec> <time_experiment> <num_client_processor> <socketCluster>"
  exit 1
fi

# Gets the parameters for the serverScript from configuration file
numWorker=$(sed -n "11p" confFile.txt)
numLoadBalancer=$(sed -n "13p" confFile.txt)

# Asks if the local runs the code in local or on a remote server
while true 
do
  read -p "Do you want to run your experiment on a remote host? [yn] " yn
  case $yn in
    [Yy]* ) 
      remote_server=true
      break;;
    [Nn]* ) 
      remote_server=false
      break;;
    * ) 
      echo "Please answer yes or no.";;
  esac
done

# if the job is executed on a distant server   
if $remote_server 
then

  # Try to use the configuration file, if one has been provided 
  while true 
  do
    read -p "Did you make a configuration file? [y/n] " yesno
    case $yesno in
      [Yy]* ) 
        confFile=true
        break;;
      [Nn]* ) 
        confFile=false
        break;;
      * ) 
        echo "Please answer yes or no.";;
    esac
  done
 
  echo ""
  echo ""

  # If the configuration file is set up
  if $confile 
  then
    remote_server_ip=$(sed -n "2p" confFile.txt)
    remote_server_login=$(sed -n "4p" confFile.txt)
    remote_client_ip=$(sed -n "6p" confFile.txt)
    remote_client_login=$(sed -n "8p" confFile.txt)

    #Checks the informations
    if ssh -o connectTimeout=5 $remote_server_login@$remote_server_ip 'exit' 
    then 
      echo "ssh connection successful to the server"
    else 
      echo "ERROR: server can not be reached" 
      exit 1
    fi
    if ssh -o connectTimeout=5 $remote_client_login@$remote_client_ip 'exit' 
    then 
      echo "ssh connection successful to the client"
    else 
      echo "ERROR: client can not be reached" 
      exit 1
    fi
  # If the configuration file is not set up
  elif ! $confFile
  then
    # SERVER infos
    while true; do
      # Asks for ssh infos
      echo ""
      echo "## SERVER script ##"
      read -p "Please type in your ip: " remote_server_ip 
      read -p "Please type your login: " remote_server_login
      # Checks if ssh is possible
      if ssh -o connectTimeout=5 $remote_server_login@$remote_server_ip 'exit' 
      then 
        echo "ssh connection successful to the SERVER"
        break
      else 
        echo "ERROR: this IP can not be reached" 
      fi
    done
    
    # CLIENT infos
    while true; do
      # Asks for ssh infos
      echo ""
      echo "## CLIENT script ##"
      read -p "Please type in your ip: " remote_client_ip 
      read -p "Please type your login: " remote_client_login
      # Checks if ssh is possible
      if ssh -o connectTimeout=5 $remote_client_login@$remote_client_ip 'exit' 
      then 
        echo "ssh connection successful to the client"
        echo ""
        echo ""
        break
      else 
        echo "ERROR: this IP can not be reached" 
      fi
    done
  fi
fi

echo ""
echo ""
if $remote_server 
then

  # Creates folders on the local machine
  mkdir results/$folder
  mkdir results/$folder/server
  mkdir results/$folder/client

  # Executes the calculation
  ssh $remote_server_login@$remote_server_ip 'cd experiment; ./calculation.sh ' $1 $2 $3 $4 $folder 1 $numWorker $numLoadBalancer 0 & 
  ssh $remote_client_login@$remote_client_ip 'cd experiment; ./calculation.sh ' $1 $2 $3 $4 $folder 1 $numWorker $numLoadBalancer 1 $remote_server_ip 
  echo ""
  echo "Data has been generated"

  # Sends the data back on the local machines
  scp -r -q $remote_client_login@$remote_client_ip:experiment/results/$folder/* $dir/results/$folder/ &
  scp -r -q $remote_server_login@$remote_server_ip:experiment/results/$folder/server/* $dir/results/$folder/server/ 
  sleep 5
  echo "data sent to the local machine"

# If the job is local
else
  if /bin/bash ./calculation.sh $1 $2 $3 $4 $folder 0 $numWorker $numLoadBalancer  
  then
    echo ""
    echo "Data has been generated"
  else
    echo "Error: Problem in calculation"
    exit 1
  fi
fi

# Once the calculation is done and all the data is gathered. Plot the graph
if /bin/bash ./plot.sh
then  
  echo "Graph plotted"
else
  echo "ERROR: unable to plot the graph"
  exit 1
fi

sleep 3

find results/$folder -name '*.png' | xargs eog & 




