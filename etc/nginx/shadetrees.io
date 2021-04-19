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
       alias /home/ubuntu/shadetrees.io/shadetree/shadetree/static;
   }

    # Django static
   location /static {
       alias /home/ubuntu/shadetrees.io/shadetree/shadetree/static;
   }

   # Finally, send all non-media requests to the Django server.
   location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
   }



    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/shadetrees.io/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/shadetrees.io/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = shadetrees.io) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80 default;
   server_name shadetrees.io;
    return 404; # managed by Certbot


}