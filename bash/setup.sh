#!/usr/bin/env bash

copy_key() {
    mkdir -p ~/.ssh/
#    cat ~/CCM/setup/id.pub >> ~/.ssh/authorized_keys
    echo  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2UTPtT0vygLTgKHqfcLbrTJzhTOzy7b9MSp60xHWRasqsFzdyhciNLvX7+SNwDHzwo3QpZWZqS+RmKvxW/ZobArURmKczFsPlaLQlDtStyqz+pi3Sb6KKemp0KCCSnGn6FnCjxSksplusDxPiFHZxrSawAsfocJdIxHSSZYNfZE/lTizf8CTPkbuQgjd6wUfVTHu6OKH4KenJbsUefUSH20BqacixLcuk+ZZKczq09gcA2ApEDDmGyEBKEzhOscVrb98dEIA2VcS39MXURXkmnY9MadBAbbw6UUFNIEJniiScyP5yUf3HPVdeJdCipKLKKZ8s4+IH7zxElM86N+39 root" >> ~/.ssh/authorized_keys
}

install_java() {
    sudo add-apt-repository ppa:openjdk-r/ppa -y
    sudo apt-get update
    sudo apt-get install openjdk-8-jdk -y
}

install_basics() {
    install_java
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y build-essential linux-headers-$(uname -r)
    sudo apt-get install -y make git zip ant python-pip
    sudo apt-get install -y vnstat
    cd && git clone https://github.com/haochenpan/Syrupy.git && cd Syrupy && sudo python setup.py install

    cd

}

install_ycsb() {
    cd
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.15.0/ycsb-0.15.0.tar.gz
    tar xfvz ycsb-0.15.0.tar.gz
    rm -rf ycsb-0.15.0.tar.gz
}

install_cass() {
    cd
    case "$1" in
        ycsb)
            install_ycsb
            return
            ;;
        abd | abdOpt)
            git clone https://github.com/ZezhiWang/cassandra.git
            ;;
        0d4* | treasErasure | ErasureMemory | charTreas | treasWithLog | OreasNoLog | treasWithLog)  # 0d464cd25ffbb5734f96c3082f9cc35011de3667
            git clone https://github.com/yingjianwu199868/cassandra.git
            ;;
    esac

    cd cassandra && git checkout $1 && ant build && git status
    cd
}


copy_key
install_basics
install_cass $1


