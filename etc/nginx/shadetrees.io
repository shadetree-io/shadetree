server {
   # the port your site will be served on
   # the domain name it will serve for
   server_name shadetrees.io;
   charset     utf-8;

   # max upload size
   client_max_body_size 75M;   # adjust to taste

   location = /favicon.ico {
      access_log off;
      log_not_found off;
   }

   # Django media
   location /media  {
       alias /home/ubuntu/admin.roverbyopenstax.org/djangoproject/media;
   }

   location /static {
       alias /home/ubuntu/admin.roverbyopenstax.org/djangoproject/staticfiles;
   }

   # Finally, send all non-media requests to the Django server.
   location / {
        include proxy_params;
        #proxy_pass http://unix:/run/gunicorn.sock;
        #
        # mcdaniel
        # i ran into problems getting the gunicorn socket to create itself in /run/gunicorn.sock
        # the problem seemed to be permissions related but i wasn't able to resolve. however, it seems
        # that the socket can be placed anywhere, so ....
        proxy_pass http://unix:/home/ubuntu/shadetrees.io/shadetree/etc/systemd/system/gunicorn.sock;
   }

    listen 80;

}

