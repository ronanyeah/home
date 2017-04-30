// From https://github.com/dwyl/learn-elm/blob/master/circle-dependencies.sh.
export INSTALL_PATH="$HOME/dependencies"

if [ ! -d $INSTALL_PATH/sysconfcpus/bin ]; then
  git clone https://github.com/obmarg/libsysconfcpus.git
  cd libsysconfcpus
  ./configure --prefix=$INSTALL_PATH/sysconfcpus
  make && make install
  cd ..
fi
