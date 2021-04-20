#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       apr-2021
#
# usage:      Production Elasticsearch configuration
#             
#---------------------------------------------------------

# copy config files from repository to production locations
sudo cp ~/shadetrees.io/etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/

# restart the celery service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl restart elasticsearch

