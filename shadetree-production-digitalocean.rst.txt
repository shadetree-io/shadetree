Digital Ocean instructions



# this should work, but withouth CSS styling in the django admin console
gunicorn --bind 0.0.0.0:8000 config.wsgi:application

# I. the socket
sudo vim /etc/systemd/system/gunicorn.socket
   see vs codefile

# II. the service
sudo vim /etc/systemd/system/gunicorn.service
   see vs codefile

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


sudo nano /etc/nginx/sites-available/myproject
  see vs code file


sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'

# Nginx trouble shooting
sudo tail -F /var/log/nginx/error.log
sudo tail -F /var/log/nginx/access.log

# better way to restart nginx
sudo nginx -t && sudo systemctl restart nginx



http://shadetrees.io/static/css/project.min.css
