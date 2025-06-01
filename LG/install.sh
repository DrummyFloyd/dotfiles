#/bin/bash

# made for test purpose at some point will have to make trhu ansible for reperatbility and maintane
#
#

echo " cloning loogin galsss repo"

git clone --recursive https://github.com/gnif/LookingGlass.git && cd $_

# build client
mkdir client/build
cd client/build
cmake ../
make -DENABLE_LIBDECOR=ON ../ # use for wayland ? (gnome might be not needed with hyprland)

# build host
mkdir host/build
cd host/build
cmake -DCMAKE_TOOLCHAIN_FILE=../toolchain-mingw64.cmake ..
make

# install IVSHMEM with the KVMFR module
sudo pacman dkms linux-header --nodeps

# INFO: IVSHMEM with the KVMFR module
modprobe kvmfr static_size_mb=32
