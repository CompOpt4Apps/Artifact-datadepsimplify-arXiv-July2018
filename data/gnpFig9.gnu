set terminal pdf
set output "results/figure9.pdf"
#set title "Figure 9"
set datafile separator ","
set boxwidth 0.9 relative
set ylabel "Number of Relations in each Complexity"
set yrange [0:20]
set xtics rotate #by 45 offset -0.8,-1.8
set style data histograms
set style histogram cluster
set style fill solid 1.0 border lt -1

#plot 'results/figure9.csv' for [i=2:6] using i:xticlabels(1)
#using 2:xtic(1) title columnheader(2), for [i=3:22] '' using i title columnheader(i)

plot 'results/figure9.csv' using 2:xtic(1) title columnheader(2), for [i=3:6] '' using i title columnheader(i)
