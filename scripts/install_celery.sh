#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       apr-2021
#
# usage:      Production Celery task worker setup
#             https://dev.to/iamtekson/django-with-celery-in-production-cb5
#---------------------------------------------------------

# add user / group
sudo groupadd celery
sudo useradd -g celery celery

# add service folder locations
if [ ! -d /var/log/celery/ ]; then
  sudo mkdir /var/log/celery/
fi

if [ ! -d /var/run/celery/ ]; then
  sudo mkdir /var/run/celery/
fi

sudo chown -R celery:celery /var/log/celery/
sudo chown -R celery:celery /var/run/celery/

# copy config files from repository to production locations
sudo cp ~/shadetrees.io/etc/systemd/system/celery.service /etc/systemd/system/
sudo cp ~/shadetrees.io/etc/default/celeryd /etc/default/

# restart the celery service
sudo systemctl daemon-reload
sudo systemctl enable celery
sudo systemctl restart celery

