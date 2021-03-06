#!/usr/bin/env bash

sudo apt-add-repository ppa:nginx/stable -y
sudo apt-get update -y
sudo apt-get install -y nginx
sudo apt-get install python-pip -y
sudo apt-get install git -y

sudo cp /vagrant/provision/dev/nginx_site.conf /etc/nginx/sites-enabled/default
sudo service nginx restart

sudo apt-get install libevent-dev -y
sudo apt-get install libpq-dev -y
sudo apt-get install python-virtualenv -y
sudo apt-get install python-dev -y
sudo apt-get install libbz2-dev -y
sudo apt-get install libsqlite3-dev -y
sudo apt-get install libreadline-dev -y
sudo apt-get install libmemcached-dev -y

sudo su vagrant <<'EOF'
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
. ~/.bash_profile
pyenv install 3.4.1
pyenv rehash
pyenv virtualenv 3.4.1 peacecorps-site
pyenv rehash
pyenv activate peacecorps-site
pip install -r /vagrant/requirements.txt
pip install -r /vagrant/requirements-dev.txt
cd /vagrant/peacecorps
python manage.py migrate
python manage.py loaddata countries issues global-general

EOF