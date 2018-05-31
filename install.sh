#!/bin/sh

set -e

# check prerequisite

# copy to /usr/local/share/mintcast
sudo mkdir -p /usr/local/share/mintcast
sudo cp -r ./bin /usr/local/share/mintcast/
sudo cp -r ./lib /usr/local/share/mintcast/
sudo cp -r ./python /usr/local/share/mintcast/

# link mintcast
sudo mkdir -p /usr/local/bin
sudo ln -fs /usr/local/share/mintcast/bin/mintcast.sh /usr/local/bin/mintcast
sudo chmod +x /usr/local/bin/mintcast

# create man page for mintcast
install -g 0 -o 0 -m 0644 ./man/man1/mintcast.1 /usr/local/man/man1/
gzip /usr/local/man/man1/mintcast.1

CHECK_PATH="$(echo $PATH | grep -E ':*/usr/local/bin:*' | wc -l | tr  -d ' ')"
if [[ $CHECK_PATH = "0" ]]; then
	echo "Please put \033[40m\033[1m\033[97mexport PATH=\$PATH:/usr/local/bin\033[0m to your shell configuration file like ~/.bashrc or ~/.zshrc"
else
	echo "All set!\nTry \033[40m\033[1m\033[97mmintcast"
fi
