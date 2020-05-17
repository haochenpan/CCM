#!/usr/bin/env sh

install() {
  cd
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
  cd cassandra
  git checkout $1
  cp ~/CCM2/res/build.xml ~/cassandra
  cp ~/CCM2/res/build.properties.default ~/cassandra
  ant build
  git status

}

rm ~/cassandra
install "$1"
