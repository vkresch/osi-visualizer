#!/usr/bin/env bash

echo "
#################################
# Installing OSI 3                                                                    
#################################
"
git submodule update --init
cd open-simulation-interface
git clone https://github.com/OpenSimulationInterface/proto2cpp.git
mkdir -p build
cd build
cmake ..
make -j8
make install
cd ../..


echo "
#################################
# Installing FMI 2.0.2                                                                  
#################################
"
mkdir -p fmi_library
cd fmi_library

fmi_library_include_install_dir=/usr/local/include/fmi-library
fmi_library_lib_install_dir=/usr/local/lib/fmi-library

if ! [ -e ${fmi_library_include_install_dir} -a -e ${fmi_library_lib_install_dir} ]
then
echo "
Downloading FMI library...
"

if [ ! -d FMILibrary-2.0.2 ]
then
  wget --no-parent -nH --cut-dirs=2 -r https://jmodelica.org/FMILibrary/FMILibrary-2.0.2-src.zip
fi

echo "
Building FMI library...
"
  unzip FMILibrary-2.0.2-src.zip
  cd FMILibrary-2.0.2
  mkdir -p build
  cd build
  cmake ../. -DCMAKE_BUILD_TYPE=RELEASE
  make -j8 install
  cd ..
  if [[ -d "install" ]]
  then
    cd install
      mkdir -p ${fmi_library_include_install_dir}
    if [[ -d ${fmi_library_include_install_dir} ]]
    then
      cp -uvrf ./include/* ${fmi_library_include_install_dir}/
    fi
    mkdir -p ${fmi_library_lib_install_dir}
    if [[ -d ${fmi_library_lib_install_dir} ]]
    then
      cp -uvrf ./lib/* ${fmi_library_lib_install_dir}/
    fi
  else
    echo "Could not install the fmi-library into usr/local"
  fi
fi