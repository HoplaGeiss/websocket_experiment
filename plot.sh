#!/bin/bash
recentFolder="$(ls -t results | head -1)/"
cd results/$recentFolder
folderList="$(ls -d */)"

# Checks if the folder is empty
for folder in $folderList
do
  if [ "$(ls -A $folder)" ]
  then
    dataFolder="$dataFolder $folder"
  fi
done

cd ../../

for folder in $dataFolder
do
  fileNames=$(ls results/$recentFolder/$folder/  -I "*.png") 
  time_experiment=$(sed -n "2p" results/$recentFolder/conf.txt)
  nb_client_sec=$(sed -n "1p" results/$recentFolder/conf.txt)
  
  gnuplot -e "fileNames='$fileNames'; folder='$recentFolder/$folder'; time_experiment='$time_experiment'; nb_client_sec='$nb_client_sec' " plotCommands.gp & 
done
