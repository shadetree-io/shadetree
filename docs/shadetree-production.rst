for Ubuntu 18.04 LTS

# setup logging
sudo mkdir /var/log/shadetree
sudo chown ubuntu /var/log/shadetree
sudo chgrp ubuntu /var/log/shadetree

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
sudo apt-get install nginx mysql-server python3-pip python3-dev ufw python3-paramiko python3-venv curl libpq-dev npm 
sudo apt update
sudo apt-get install libmysqlclient-dev
sudo apt-get install libssl-dev swig gcc



# MySQL setup
# =================================================

mysql -h wordpress-sql.cp6gb73qx6d7.us-west-2.rds.amazonaws.com -u root -p
pwd:	67#s[P7(eG2,>9

CREATE DATABASE shadetree CHARACTER SET 'utf8';
CREATE USER shadetree;
GRANT ALL ON shadetree.* TO 'shadetree'@'%' IDENTIFIED BY '6xD!cu@Ntz64BDP!bZo*CLsV';

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
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn


# collect static and store in AWS S3
python manage.py collectstatic
./manage.py makemigrations
./manage.py migrate
./manage.py createsuperuser


# Gunicorn setup
# =================================================
# test if it works
gunicorn --bind 0.0.0.0:8000 config.wsgi:application

sudo ln -s /home/ubuntu/shadetrees.io/shadetree/etc/systemd/system/gunicorn.socket /etc/systemd/system/
sudo ln -s /home/ubuntu/shadetrees.io/shadetree/etc/systemd/system/gunicorn.service /etc/systemd/system/

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket


# to restart Gunicorn service
sudo systemctl daemon-reload
sudo systemctl restart gunicorn.socket
sudo systemctl restart gunicorn
curl --unix-socket /run/gunicorn.sock localhost
sudo systemctl status gunicorn
file /run/gunicorn.sock
namei -l /run/gunicorn.sock


# nginx setup
# =================================================
sudo ln -s /home/ubuntu/shadetrees.io/shadetree/etc/nginx/shadetrees.io /etc/nginx/sites-available
sudo ln -s /home/ubuntu/shadetrees.io/shadetree/etc/nginx/shadetrees.io /etc/nginx/sites-enabled
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

sudo nginx -t && sudo systemctl restart nginx

sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'

# Nginx trouble shooting
sudo tail -F /var/log/nginx/error.log
sudo tail -F /var/log/nginx/access.log

# better way to restart nginx
sudo nginx -t && sudo systemctl restart nginx


# Letsencrypt
# =================================================
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx 

sudo certbot --authenticator standalone --installer nginx --pre-hook "service nginx stop" --post-hook "service nginx start"
