#!/bin/bash
folder="$(ls -t results | head -1)/"
fileNames=$(ls results/$folder/) 

gnuplot -e "fileNames='$fileNames'; folder='$folder'" plotCommands.gp 
eog results/$folder/*.png
