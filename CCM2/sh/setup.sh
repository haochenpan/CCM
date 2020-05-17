#!/usr/bin/env sh

copy_key() {
  mkdir -p ~/.ssh/
  cat ~/CCM/CCM2/res/id.pub >>~/.ssh/authorized_keys
}

install_java() {
  sudo add-apt-repository ppa:openjdk-r/ppa -y
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk -y
}

install_basics() {
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y build-essential linux-headers-$(uname -r)
  sudo apt-get install -y make git zip ant python-pip python3-pip
  sudo apt-get update -y
  sudo add-apt-repository ppa:deadsnakes/ppa -y
  sudo apt-get update -y
  sudo apt-get install -y python3.6
  sudo ln -s -f /usr/bin/python3.6 /usr/bin/python3
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
python3 ~/CCM/CCM2/py/setupCass.py "$1"
chmod +x ~/CCM/CCM2/sh/*
chmod +x ~/CCM/bash/*

