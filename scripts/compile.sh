#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       apr-2021
#
# usage:      Compile static assets
#
#---------------------------------------------------------  # collect static and store in AWS S3

cd ~
cd shadetrees.io
source venv/bin/activate
cd shadetree
python manage.py collectstatic
deactivate


