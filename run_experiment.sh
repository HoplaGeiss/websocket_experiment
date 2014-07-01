#!/bin/bash
dir=$(pwd)

# Verifies the scripts as the correct number of parameters
if [ $# -ne 2 ]
then 
  echo "Verify usage: experiment.sh <nb_client_sec> <time_experiment>"
  exit 1
fi

# Asks if the local runs the code in local or on a remote server
while true 
do
  read -p "Do you want to run your experiment on a remote host? [Y/N] " yn
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
  while true; do
    # Asks for ssh infos
    read -p "Please type in your ip: " remote_ip 
    read -p "Please type your login: " remote_login
    # Checks if ssh is possible
    if ssh -o connectTimeout=5 $remote_login@$remote_ip 'exit' 
    then 

      # Executes the calculation
      if ssh $remote_login@$remote_ip 'cd experiment; ./calculation.sh ' $1 $2 1
      then
        echo "Calculation finished on the remote server"
      else
        echo "ERROR: unable to do the calculation on the remote server"
        exit 
      fi
      
      # Sends the data back on the local machines
      if scp -r -q $remote_login@$remote_ip:experiment/results/* $dir/results/
      then
        echo "Data sent to the local machine"
      else
        echo "ERROR: unable to sent data back to local server"
        exit
      fi

      # Erases data from server
      ssh $remote_login@$remote_ip 'rm -r experiment/results/*'

      break
    else 
      echo "ERROR: this IP can not be reached" 
    fi
  done
# If the job is local
else
 /bin/bash ./calculation.sh $1 $2 0  
fi

# Once the calculation is done and all the data is gathered. Plot the graph
if /bin/bash ./plot.sh
then  
  echo "Graph plotted"
  folder="$(ls -t results | head -1)/"
  eog results/$folder &
else
  echo "ERROR: unable to plot the graph"
fi






