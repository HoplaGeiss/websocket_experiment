set output "results/".folder."/graph.png"
set xlabel 'time [s]'
set ylabel 'processor load [%]'
set title 'Processor load in function of the time'
plot for [file in fileNames] "results/".folder.file every ::4 title columnheader(1) with linespoints
