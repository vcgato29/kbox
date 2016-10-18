#!/bin/bash

#  update macOS clients
#

#
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${DIR}"/functions.sh

# get App's Resources folder
res_folder=$(cat ~/kube-solo/.env/resouces_path)

# get VM IP
vm_ip=$(~/bin/corectl q -i k8solo-01)

# path to the bin folder where we store our binary files
export PATH=${HOME}/kube-solo/bin:$PATH
# docker daemon
export DOCKER_HOST=tcp://$vm_ip:2375

# copy files to ~/kube-solo/bin
cp -f "${res_folder}"/bin/* ~/kube-solo/bin
chmod 755 ~/kube-solo/bin/*

# download docker latest version
download_docker_client

# download latest version of deis and helmc clients
download_osx_clients
#

echo " "
echo "Update has finished !!!"
pause 'Press [Enter] key to continue...'

