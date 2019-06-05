#!/usr/bin/env bash

copy_key() {
    mkdir -p ~/.ssh/
    cat ~/VMCM/setup/id.pub >> ~/.ssh/authorized_keys
}

install_java() {
    sudo add-apt-repository ppa:openjdk-r/ppa -y
    sudo apt-get update
    sudo apt-get install openjdk-8-jdk -y
}

install_basics() {
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y build-essential linux-headers-$(uname -r)
    sudo apt-get install -y make git zip ant
}

install_ycsb() {
    cd
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.15.0/ycsb-0.15.0.tar.gz
    tar xfvz ycsb-0.15.0.tar.gz
    rm -rf ycsb-0.15.0.tar.gz
}

install_cass() {
    cd
    git clone https://github.com/yingjianwu199868/cassandra.git
    cd cassandra
    git checkout $1
#    git checkout 0d464cd25ffbb5734f96c3082f9cc35011de3667
#    git checkout treasErasure
    ant build
    git status
    cd
}


copy_key
install_java
install_basics
if [ "$1" = "ycsb" ]; then
    echo "install ycsb"
    install_ycsb
else
    echo "install cass"
    install_cass $1
fi


