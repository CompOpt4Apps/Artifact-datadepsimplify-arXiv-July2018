This is the artifact that uses CHiLL for data dependence analysis, IEGenLib 
for simplification, and produces results for paper submitted to arXiv in July 2018.

After building the driver and its dependencies (see below) run the following:

```
  ./simplifyDriver list.txt
```

The output will be the results of doing data dependence analysis on all of the
C kernels specified in the list.txt file.  The list.text file includes names of some JSON files. 
Each JSON file contains the relative path of an input kernel that we want to extract its 
dependences and analyze them for partial parallelisim.  The JSON files also contain index 
array properties and analysis information like which loops we want to analyze.

# Specifying index array properties

[FIXME: Show some examples of property specification in JSON files and
 list IEGenLib functions that enable specifying these.]
 


# How to build the artifact:

We have tested the artifact build and execution on the following platform:

+ OS:  Ubuntu 16.04
+ GCC: gcc 5.4.0 (Default on the OS)

**There is an installation bash script that downloads the necessary versions of
the Rose compiler and boost library.  The installation script, install.sh, is 
in the same directory as this README.  The script can build all the dependencies 
and the driver for the artifact. Please note that the installation script must 
be executed with sudo access:**

```
    sudo ./install.sh
```

In case users need to use other platforms or in case the script fails for whatever reason,
users can follow these more detailed instructions to build all the dependencies step by step:

These instructions assume that you are starting from the root directory of the artifact.
To build the driver for the artifact, these instructions indicate how to build and 
locally install the following major components:
(1) Boost library; (2) rose compiler; (3) IEGenLib library; (4) CHILL compiler.
Of these components, the rose compiler, which is a dependency for CHILL, is the most demanding
one in terms of building effort.


## Step 0: Installation prerequisites:

These softwares are prerequisites for installing all the subsequent components:

`sudo apt-get install git wget tar unzip make autoconf automake cmake libtool default-jdk default-jre flex bison python-dev texinfo gnuplot-x11 evince`


## Step 1: Installing boost:

Boost library is a prerequisit for rose compiler:

`mkdir boost`

`export BOOSTHOME=$(pwd)/boost`

`wget http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.gz`

`tar -xvzf boost_1_60_0.tar.gz`

`cd boost_1_60_0/`

`./bootstrap.sh --prefix=$BOOSTHOME --with-libraries=chrono,date_time,filesystem,iostreams,program_options,random,regex,signals,system,thread,wave`

`./b2  --prefix=$BOOSTHOME -sNO_BZIP2=1 install`

`cd ..`



## Step 2: Installing rose compiler:

Detailed insructions for installing rose compiler including some trouble shooting 
information can be found in the official installation guide of rose compiler webpage:

http://rosecompiler.org/ROSE_HTML_Reference/installation.html


The following is a quick installation guide:


+ Setting up the environment
`mkdir rose_build`

`export ROSE_SRC=$(pwd)/rose`

`export ROSEHOME=$(pwd)/rose_build`

`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${BOOSTHOME}/lib`

`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${ROSEHOME}/lib`

`git clone https://github.com/rose-compiler/rose`

`cd rose`


+ Getting the following version instead of the latest version 
  is highly recommended for installing CHILL.

`git checkout 365bb6857c`

`./build`

`cd $ROSEHOME`

+ Excluding JAVA might make things easier.

`${ROSE_SRC}/configure --prefix=$ROSEHOME --enable-languages=c,c++ --with-boost=${BOOSTHOME} --without-java`

+ You can remove -j6 if yopu do not wish to build with multi-threading 
activated, or at least decrease the number of threads by decrease=ing 
the j6 to jX (with X being desired number of threads)

`make -j6 install-rose-library FRONTEND_CXX_VENDOR_AND_VERSION2=gnu-5.3`

`cd ..`



## Step 3: Installing the IEGenLib library:

Consdering that the artifact already have the appropriate IEGenLib version, 
you do not need to get this library from its github repository.
(https://github.com/CompOpt4Apps/IEGenLib)

`export IEGENHOME=$(pwd)/IEGenLib/iegen`

`cd IEGenLib`

`./configure`

`make`

`make install`

`cd ..`



## Step 4: Installing the CHILL compiler:

Considering that the artifact already has the appropriate CHILL version, 
you do not need to get this library from internet. Please note that 
although CHILL is made publicly available as tar balls that are relased 
every once in a while, it does not have a public github repository. 
Use following commands to build the CHILL version that is already available 
in the artifacts root directory:

`cd chill`

`mkdir build`

`cd build`

`cmake .. -DROSEHOME=$ROSEHOME -DBOOSTHOME=$BOOSTHOME -DIEGENHOME=$IEGENHOME`

`make -j6`

`cd ../..`




## Step 5: Building the artifact driver:

Use following command to build the driver for reproducing the result:

`g++ -O3 -o simplifyDriver simplification.cc -I IEGenLib/src IEGenLib/build/src/libiegenlib.a -lisl -std=c++11`



