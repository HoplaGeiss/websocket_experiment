#!/bin/bash
declare ids=''
declare fileNames=''

if [ $# -ne 2 ]
then 
  echo "Verify usage: plot.sh <nb_client_sec> <time_experiment>"
  exit 1
fi


date=$(date +%Y-%m-%d)
time=$(date | awk '{print$5}')
folder="results/experiment_$date"_"$time"
mkdir "$folder"

top -b -d 1 > "$folder"/top.txt &

node createCluster.js &
node client.js $1 $2 &

sleep $2
pkill node
pkill top

grep node "$folder"/top.txt > "$folder"/node.txt
grep node "$folder"/top.txt | cut -c 2-5 > "$folder"/id.txt
rm "$folder"/top.txt

while read line
do
  if [[ ! $ids =~ $line ]]
  then
    ids="$ids $line"
  fi 
done < "$folder"/id.txt 

for id in $ids
do
  grep $id "$folder"/node.txt |cut -c 49-52 | nl > "$folder"/node_process_"$id".txt
  fileNames="$fileNames node_process_$id"
done

rm "$folder"/id.txt
rm "$folder"/node.txt

gnuplot -e "fileNames='$fileNames'; folder='$folder'" plotCommands.gp 

eog $folder/graph.png &
