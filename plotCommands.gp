set terminal png
set output folder."/graph.png"
unset key
set xlabel 'time (in sec)'
set ylabel 'processor load (in pourcentage)'
set title 'processor load in function of the time'
plot for [file in fileNames] folder."/".file.".txt" with lines
