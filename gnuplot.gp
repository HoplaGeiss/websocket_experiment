set output "graph.png"
set xlabel 'time [s]'
set ylabel 'processor load [%]'
set title 'Processor load in function of the time'
fileNames="balancer:9918.txt nodeclientScript:9884.txt"
plot for [file in fileNames] "results/experiment_2014-06-25_11:40:48/".file every ::4 title columnheader(1) with linespoints
