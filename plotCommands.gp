set output "results/".folder."/".nb_client_sec."x".time_experiment."_graph.png"
set xlabel 'number of WebSocket communication'
set ylabel 'processor load [%]'
set title "Process load in function of the number of WebSocket communication \n"
plot for [file in fileNames] "results/".folder.file every ::4 title columnheader(1) with linespoints
