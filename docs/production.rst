Production Ubuntu 18.04 LTS
===========================

- See: https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-18-04

- Monitoring

.. code-block:: bash

  # Django
  sudo tail -F /var/log/shadetree/app.log

  # Nginx
  sudo tail -F /var/log/nginx/error.log
  sudo tail -F /var/log/nginx/access.log

  # Gunicorn
  sudo systemctl status gunicorn  


- Nginx

.. code-block:: bash

  # Nginx trouble shooting
  sudo tail -F /var/log/nginx/error.log
  sudo tail -F /var/log/nginx/access.log
  sudo nginx -t && sudo systemctl restart nginx


- ElasticSearch: https://docs.wagtail.io/en/stable/topics/search/backends.html

The Elasticsearch backend is compatible with Amazon Elasticsearch Service, but requires additional configuration to handle IAM based authentication. This can be done with the requests-aws4auth package along with the following configuration:

.. code-block:: python
  from requests_aws4auth import AWS4Auth

  WAGTAILSEARCH_BACKENDS = {
      'default': {
          'BACKEND': 'wagtail.search.backends.elasticsearch5',
          'INDEX': 'wagtail',
          'TIMEOUT': 5,
          'HOSTS': [{
              'host': 'YOURCLUSTER.REGION.es.amazonaws.com',
              'port': 443,
              'use_ssl': True,
              'verify_certs': True,
              'http_auth': AWS4Auth('ACCESS_KEY', 'SECRET_KEY', 'REGION', 'es'),
          }],
          'OPTIONS': {
              'connection_class': RequestsHttpConnection,
          },
      }
  }


- Boto3: anything to do with this?

- MySQL

.. code-block:: mysql

  CREATE DATABASE shadetree CHARACTER SET 'utf8';
  CREATE USER shadetree;
  GRANT ALL ON shadetree.* TO 'shadetree'@'%' IDENTIFIED BY 'strong password';


- Gunicorn 

.. code-block:: bash

  # to restart Gunicorn service
  sudo systemctl daemon-reload
  sudo systemctl restart gunicorn.socket
  sudo systemctl restart gunicorn
  curl --unix-socket /run/gunicorn.sock localhost
  sudo systemctl status gunicorn
  file /run/gunicorn.sock
  namei -l /run/gunicorn.sock

- Letsencrypt

.. code-block:: bash

  ~/shadetrees.io/shadetree/scripts/build.sh


  # Letsencrypt
  # =================================================
  sudo apt-get update
  sudo apt-get install software-properties-common
  sudo add-apt-repository universe
  sudo add-apt-repository ppa:certbot/certbot
  sudo apt-get update
  sudo apt-get install certbot python-certbot-nginx 

  sudo certbot --authenticator standalone --installer nginx --pre-hook "service nginx stop" --post-hook "service nginx start"

- Ubuntu 18.04 LTS

.. code-block:: bash

  ~/shadetrees.io/shadetree/scripts/build.sh

  # add Letsencrypt
  # test db connectivity
  # test Gunicorn
  # test Nginx


