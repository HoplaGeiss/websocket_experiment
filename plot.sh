#!/bin/bash
folder="$(ls -t results | head -1)/"
fileNames=$(ls results/$folder/ -I "conf.txt" -I "*.png") 
time_experiment=$(sed -n "2p" results/$folder/conf.txt)
nb_client_sec=$(sed -n "1p" results/$folder/conf.txt)

gnuplot -e "fileNames='$fileNames'; folder='$folder'; time_experiment='$time_experiment'; nb_client_sec='$nb_client_sec' " plotCommands.gp & 
