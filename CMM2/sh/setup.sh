#!/usr/bin/env sh

copy_key() {
  mkdir -p ~/.ssh/
  cat ~/CCM2/res/id.pub >>~/.ssh/authorized_keys
}

install_java() {
  sudo add-apt-repository ppa:openjdk-r/ppa -y
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk -y
}

install_basics() {
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y build-essential linux-headers-$(uname -r)
  sudo add-apt-repository ppa:deadsnakes/ppa --yes
  sudo apt-get install -y python3.8
  sudo apt-get install -y make git zip ant python-pip python3-pip

  cd
}

install_ycsb() {
  cd
  curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.15.0/ycsb-0.15.0.tar.gz
  tar xfvz ycsb-0.15.0.tar.gz
  rm -rf ycsb-0.15.0.tar.gz
}

copy_key
install_java
install_basics
install_ycsb
python3 ~/CCM2/py/setupCass.py "$1"
chmod +x ~/CCM2/sh/*
