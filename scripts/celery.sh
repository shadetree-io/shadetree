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



sudo groupadd celery
sudo useradd -g celery celery
sudo mkdir /var/log/celery/
sudo mkdir /var/run/celery/
sudo chown -R celery:celery /var/log/celery/
sudo chown -R celery:celery /var/run/celery/


sudo systemctl daemon-reload
sudo systemctl enable celery
sudo systemctl restart celery