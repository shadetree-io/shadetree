#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       apr-2021
#
# usage:      Restart the application
#
#---------------------------------------------------------
sudo systemctl daemon-reload
sudo systemctl restart gunicorn.socket
sudo systemctl restart gunicorn