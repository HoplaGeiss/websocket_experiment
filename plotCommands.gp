set output "results/".folder."/".nb_client_sec."x".time_experiment."_graph.png"
set xlabel 'time [s]'
set ylabel 'processor load [%]'
set title "Processor load in function of the time \n".nb_client_sec." clients are spawned every seconds for ".time_experiment." seconds"
plot for [file in fileNames] "results/".folder.file every ::4 title columnheader(1) with linespoints
