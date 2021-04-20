ShadeTree
============

Everything you ever wanted to know about an open source configuration parameter.

.. image:: https://img.shields.io/badge/hack.d-Lawrence%20McDaniel-orange.svg
     :target: https://lawrencemcdaniel.com
     :alt: Hack.d Lawrence McDaniel
.. image:: https://img.shields.io/badge/built%20with-Cookiecutter%20Django-ff69b4.svg?logo=cookiecutter
     :target: https://github.com/pydanny/cookiecutter-django/
     :alt: Built with Cookiecutter Django
.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
     :target: https://github.com/ambv/black
     :alt: Black code style

Running Locally
---------------

.. code-block:: bash

  # global packages on your macOS dev machine.
  brew update
  brew upgrade

  #Python requirements
  pip3 install -r /Users/mcdaniel/github/lpm0073/shadetree/shadetree/requirements/local.txt

  # front-end requirements
  # note that gulp-sass requires XCode
  npm install

  # compile static assets
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  npm run build
  cat <(echo "yes") - | python manage.py collectstatic

  # 1. start a PostgreSQL daemon in a new terminal window
  pg_ctl -D /usr/local/var/postgres/data -l logfile start

  # 2. start a redis server in a new terminal window
  redis-server /usr/local/etc/redis.conf

  # 3. start a celery worker in a separate terminal window
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  celery -A config.celery_app worker --loglevel=info
  
  # 4. launch a local web server in a new window at http://127.0.0.1:8000
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  python manage.py runserver

  # 5. setup watches / auto browser reload
  npm run dev

  # run manage.py
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  ./manage.py -h

Pages
-----

/admin/
/cms_admin/


Theme Source & Origin
---------------------

PrettyDocs: https://themes.3rdwavemedia.com/bootstrap-templates/startup/prettydocs-free-bootstrap-theme-for-developers-and-startups/
live demo: https://themes.3rdwavemedia.com/demo/prettydocs/
cool t-shirts: https://made4dev.com/


Setting up AWS Cloudfront
-------------------------

https://blog.impress.ai/index.php/2020/02/19/how-to-serve-static-files-via-cloudfront-private-media-files-via-s3-in-django/


Production
----------

Monitoring

.. code-block:: bash

  # Django
  sudo tail -F /var/log/shadetree/app.log

  # Nginx
  sudo tail -F /var/log/nginx/error.log
  sudo tail -F /var/log/nginx/access.log

  # Gunicorn
  sudo systemctl status gunicorn  

See: https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-18-04

- Nginx

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

.. code-block:: bash

  # setup logging
  sudo mkdir /var/log/shadetree
  sudo chown ubuntu /var/log/shadetree
  sudo chgrp ubuntu /var/log/shadetree
  sudo chmod 664 /var/log/shadetree

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
  sudo apt-get install nginx mysql-server python3-pip python3-dev python3-paramiko python3-venv curl libpq-dev npm libmysqlclient-dev


  # MySQL setup
  # =================================================

  CREATE DATABASE shadetree CHARACTER SET 'utf8';
  CREATE USER shadetree;
  GRANT ALL ON shadetree.* TO 'shadetree'@'%' IDENTIFIED BY '6xD!cu@Ntz64BDP!bZo*CLsV';

  # ElasticSearch (EC2 large only)
  # =================================================
  curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
  sudo apt update
  sudo apt install elasticsearch
  # copy elasticsearch.yml once we have this ready.
  sudo systemctl start elasticsearch
  sudo systemctl enable elasticsearch

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


Settings
--------

Moved to settings_.

.. _settings: http://cookiecutter-django.readthedocs.io/en/latest/settings.html

Basic Commands
--------------

Setting Up Your Users
^^^^^^^^^^^^^^^^^^^^^

* To create a **normal user account**, just go to Sign Up and fill out the form. Once you submit it, you'll see a "Verify Your E-mail Address" page. Go to your console to see a simulated email verification message. Copy the link into your browser. Now the user's email should be verified and ready to go.

* To create an **superuser account**, use this command::

    $ python manage.py createsuperuser

For convenience, you can keep your normal user logged in on Chrome and your superuser logged in on Firefox (or similar), so that you can see how the site behaves for both kinds of users.

Type checks
^^^^^^^^^^^

Running type checks with mypy:

::

  $ mypy shadetree

Test coverage
^^^^^^^^^^^^^

To run the tests, check your test coverage, and generate an HTML coverage report::

    $ coverage run -m pytest
    $ coverage html
    $ open htmlcov/index.html

Running tests with py.test
~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  $ pytest

Live reloading and Sass CSS compilation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Moved to `Live reloading and SASS compilation`_.

.. _`Live reloading and SASS compilation`: http://cookiecutter-django.readthedocs.io/en/latest/live-reloading-and-sass-compilation.html



Celery
^^^^^^

This app comes with Celery.

To run a celery worker:

.. code-block:: bash

    cd shadetree
    celery -A config.celery_app worker -l info

Please note: For Celery's import magic to work, it is important *where* the celery commands are run. If you are in the same folder with *manage.py*, you should be right.





Sentry
^^^^^^

Sentry is an error logging aggregator service. You can sign up for a free account at  https://sentry.io/signup/?code=cookiecutter  or download and host it yourself.
The system is setup with reasonable defaults, including 404 logging and integration with the WSGI application.

You must set the DSN url in production.

https://sentry.io/onboarding/lawrencemcdanielcom/get-started/



Deployment
----------

The following details how to deploy this application.




Custom Bootstrap Compilation
^^^^^^

The generated CSS is set up with automatic Bootstrap recompilation with variables of your choice.
Bootstrap v4 is installed using npm and customised by tweaking your variables in ``static/sass/custom_bootstrap_vars``.

You can find a list of available variables `in the bootstrap source`_, or get explanations on them in the `Bootstrap docs`_.


Bootstrap's javascript as well as its dependencies is concatenated into a single file: ``static/js/vendors.js``.


.. _in the bootstrap source: https://github.com/twbs/bootstrap/blob/v4-dev/scss/_variables.scss
.. _Bootstrap docs: https://getbootstrap.com/docs/4.1/getting-started/theming/
