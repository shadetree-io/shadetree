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

See: https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-18-04

- Nginx

- ElasticSearch: https://www.elastic.co/downloads/elasticsearch

- Elasticsearch: The Elasticsearch backend is compatible with Amazon Elasticsearch Service,
but requires additional configuration to handle IAM based authentication. This can be done with the requests-aws4auth package along with the following configuration: https://docs.wagtail.io/en/stable/topics/search/backends.html#wagtailsearch-backends-elasticsearch

- Boto3: anything to do with this?

.. code-block:: bash

  sudo apt-get update

  # https://phoenixnap.com/kb/how-to-install-python-3-ubuntu
  sudo apt install software-properties-common
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt update
  sudo apt install python3.9

  sudo apt-get install nginx mysql-server python3-pip python3.6-dev libmysqlclient-dev ufw python3-paramiko python3-venv curl libpq-dev boto3

  git clone git@github-admin:lpm0073/shadetree.git

  # setup app logging
  sudo mkdir /var/log/shadetree
  sudo chown ubuntu /var/log/shadetree
  sudo chgrp ubuntu /var/log/shadetree


  # Python / Django installation
  cd ~
  sudo rm -r ./shadetree
  git clone git@github-admin:lpm0073/shadetree.git

  python3 -m venv ~/shadetree/venv
  source ~/shadetree/venv/bin/activate
  pip3 install -r ~/shadetree/djangoproject/requirements/production.txt

  # create and install .env file

  # Prepare Django
  $ cd ~/shadetree
  $ source ~/shadetree/venv/bin/activate
  (env) $ python djangoproject/manage.py createsuperuser
  (env) $ python djangoproject/manage.py makemigrations
  (env) $ python djangoproject/manage.py migrate
  (env) $ python djangoproject/manage.py collectstatic
  (env) $ python djangoproject/manage.py runserver
  (env) $ deactivate


  # Test Gunicorn service
  $ cd ~/shadetree
  $ source ~/shadetree/venv/bin/activate
  (env) $ cd ~/shadetree/djangoproject/
  (env) $ gunicorn --bind 0.0.0.0:8000 config.wsgi:application
  (env) $ deactivate

  # Install and configure Nginx

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
