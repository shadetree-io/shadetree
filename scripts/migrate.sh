#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       apr-2021
#
# usage:      Django db migrations
#
#---------------------------------------------------------  # collect static and store in AWS S3

cd ~
cd shadetrees.io
source venv/bin/activate
cd shadetree
./manage.py makemigrations
./manage.py migrate
deactivate