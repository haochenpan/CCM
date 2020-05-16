#!/usr/bin/env bash

ccm2_path=~/CCM/ccm2

copy_key() {
  mkdir -p ~/.ssh/
  cat $ccm2_path/res/id.pub >>~/.ssh/authorized_keys
}

install_java() {
  sudo add-apt-repository ppa:openjdk-r/ppa -y
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk -y
}

install_basics() {
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y build-essential linux-headers-$(uname -r)
  sudo apt-get install -y make git zip ant python-pip
  sudo apt-get install -y vnstat
  cd
}

install_ycsb() {
  cd
  curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.15.0/ycsb-0.15.0.tar.gz
  tar xfvz ycsb-0.15.0.tar.gz
  rm -rf ycsb-0.15.0.tar.gz
}

install() {
  case "$1" in
  abd | abdOpt)
    #    git clone https://github.com/ZezhiWang/cassandra.git
    git clone https://github.com/Dariusrussellkish/cassandra.git
    ;;

  # 0d464cd25ffbb5734f96c3082f9cc35011de3667
  0d4* | treasErasure | ErasureMemory | charTreas | treasWithLog | OreasNoLog)
    #    git clone https://github.com/yingjianwu199868/cassandra.git
    git clone https://github.com/Dariusrussellkish/cassandra.git
    ;;

  bsr | abd-machine-time)
    git clone https://github.com/Dariusrussellkish/cassandra.git
    ;;

  esac
  cd cassandra && git checkout $1 && ant build && git status

}

copy_key
install_java
install_basics
install_ycsb
install "$1"
chmod +x $ccm2_path/bash/*
