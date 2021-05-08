#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       apr-2021
#
# usage:      Production build procedure on Ubuntu 18.04 LTS
#
#---------------------------------------------------------

  # setup logging
  sudo mkdir /var/log/shadetree
  sudo chown ubuntu /var/log/shadetree
  sudo chgrp ubuntu /var/log/shadetree
  sudo chmod 664 /var/log/shadetree

  # Ubuntu setup
  # =================================================
  # https://phoenixnap.com/kb/how-to-install-python-3-ubuntu
  sudo apt update
  sudo apt upgrade -y
  sudo apt install software-properties-common
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt update
  sudo apt install python3.9
  sudo apt update
  sudo apt-get install nginx mysql-server python3-pip python3-dev python3-paramiko python3-venv curl libpq-dev npm libmysqlclient-dev libssl-dev swig


  # ElasticSearch (EC2 large only)
  # =================================================
  curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
  sudo apt update
  sudo apt install elasticsearch
  ~/shadetrees.io/scripts/install_elasticsearch.sh
  # copy elasticsearch.yml once we have this ready.
  #sudo systemctl start elasticsearch
  #sudo systemctl enable elasticsearch

  # Celery
  # =================================================
  ~/shadetrees.io/scripts/install_celery.sh

  # Django environment
  # =================================================
  mkdir shadetrees.io
  cd /home/ubuntu/shadetrees.io/
  python3 -m venv venv
  source venv/bin/activate
  git clone https://github.com/shadetree-io/shadetree.git
  cd shadetree
  pip install --upgrade pip
  pip3 install wheel
  pip3 install -r requirements/production.txt

  # node stuff
  # see https://linuxize.com/post/how-to-install-node-js-on-ubuntu-18.04/
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo apt-get install gcc g++ make
  npm install
  npm run build

  ## To install the Yarn package manager (optional)
  #curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
  #echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  #sudo apt-get update && sudo apt-get install yarn

  # Gunicorn setup
  # =================================================
  # test if it works
  gunicorn --bind 0.0.0.0:8000 config.wsgi:application

  sudo ln -s /home/ubuntu/shadetrees.io/shadetree/etc/systemd/system/gunicorn.socket /etc/systemd/system/
  sudo ln -s /home/ubuntu/shadetrees.io/shadetree/etc/systemd/system/gunicorn.service /etc/systemd/system/

  sudo systemctl start gunicorn.socket
  sudo systemctl enable gunicorn.socket
