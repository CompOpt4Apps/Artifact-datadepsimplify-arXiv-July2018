Artifact that uses CHiLL for data dependence analysis, IEGenLib for simplification, and produces results for paper submitted to arXiv in July 2018.




How to builld the artifact:

We have developed our artifact on a platform with following software:

OS:  Ubuntu 16.04
GCC: gcc 5.4.0 (Default on the OS)

We have prepared an installation bash script that we have successfully on the above platform.
The installation script, install.sh, can be found in the same directory as this README. 
The script can build all the dependencies and the driver for the arrifact. 
Please note that the installation script must be executed with sudo access:

sudo ./install.sh

In case users need to use other platforms or in case the script fails for whatever reason,
users can follow more detailed instructions to build all the dependencies step by step:

We are are going to assume that we are starting from the root directory of the artifact.
To build the driver for the artifact, we need to install following major components:
(1) Boost library; (2) rose compiler; (3) IEGenLib library; (4) CHILL compiler.
Of these components rose compiler, which is a dependency for CHILL, is the most demanding
one in terms of building effort.


Step 0: Installing prerequisits:

These softwares are prerequisits for installing all the subsequent components:

sudo apt-get install git wget tar unzip make autoconf automake cmake libtool default-jdk default-jre flex bison python-dev texinfo gnuplot-x11


Step 1: Installing boost:

Boost library is a prerequisit for rose compiler:

mkdir boost
export BOOSTHOME=$(pwd)/boost
wget http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.gz
tar -xvzf boost_1_60_0.tar.gz
cd boost_1_60_0/
./bootstrap.sh --prefix=$BOOSTHOME --with-libraries=chrono,date_time,filesystem,iostreams,program_options,random,regex,signals,system,thread,wave
./b2  --prefix=$BOOSTHOME -sNO_BZIP2=1 install
cd ..



Step 2: Installing rose compiler:

Detailed insructions for installing rose compiler including some truble shooting information can be found in the official installation guide of rose compiler webpage:

http://rosecompiler.org/ROSE_HTML_Reference/installation.html


Following is a quick installation guid:


% Setting up the environment
mkdir rose_build
export ROSE_SRC=$(pwd)/rose
export ROSEHOME=$(pwd)/rose_build
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${BOOSTHOME}/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${ROSEHOME}/lib
git clone https://github.com/rose-compiler/rose
cd rose

% Getting following version instead of the latest version is highly recommended for installing CHILL
git checkout 365bb6857c
./build
cd $ROSEHOME

% Excluding JAVA might make things easier
${ROSE_SRC}/configure --prefix=$ROSEHOME --enable-languages=c,c++ --with-boost=${BOOSTHOME} --without-java

% You can remove -j6 if yopu do not wish to build with multi-threading activated, or at least decrease 
% the number of threads by decrease=ing the j6 to jX (with X being desired number of threads)  
make -j6 install-rose-library FRONTEND_CXX_VENDOR_AND_VERSION2=gnu-5.3
cd ..



Step 3: Installing IEGenLib library:

Consdering that the artifact already have the appropriate IEGenLib version, 
you do not need to get this library from its github repository.

export IEGENHOME=$(pwd)/IEGenLib/iegen
cd IEGenLib
./configure
make
make install
cd ..



Step 4: Installing CHILL compiler:

Consdering that the artifact already have the appropriate CHILL version, 
you do not need to get this library from internet. Please note that 
although CHILL is made publicly available as tar balls that are relased 
every once in a while, it does not have a public github repository. 
Use following commands to build the CHILL version that is already available 
in the artifacts root directory:


cd chill
mkdir build
cd build
cmake .. -DROSEHOME=$ROSEHOME -DBOOSTHOME=$BOOSTHOME -DIEGENHOME=$IEGENHOME
make -j6
cd ../..




Step 5: Building the artifact driver:

use following command to build the driver for reproducing the result:

g++ -O3 -o simplifyDriver simplification.cc -I IEGenLib/src IEGenLib/build/src/libiegenlib.a -lisl -std=c++11



