Artifact that uses CHiLL for data dependence analysis, IEGenLib for simplification, and produces results for paper submitted to arXiv in July 2018.



This is a readme for arXiv submission artifact.





Building the driver:
g++ -O3 -o simplifyDriver simplification.cc -I IEGenLib/src IEGenLib/build/src/libiegenlib.a -lisl -std=c++11






--Building CHILL:

mkdir build
cmake .. -DROSEHOME=$ROSEHOME -DBOOSTHOME=$BOOSTHOME -DIEGENHOME=$IEGENHOME
make

