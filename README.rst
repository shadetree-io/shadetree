Shade Trees
============

Classy, Elegant, Fun!

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

  # 1. start a PostgreSQL daemon in a new terminal window
  pg_ctl -D /usr/local/var/postgres/data -l logfile start

  # 2. start a redis server in a new terminal window
  redis-server /usr/local/etc/redis.conf

  # 3. start a celery worker in a separate terminal window
  cd /Users/mcdaniel/github/lpm0073/shadetrees.io/
  source venv/bin/activate
  cd shadetrees
  #export CELERY_BROKER_URL=redis://localhost:6379/0
  celery -A config.celery_app worker --loglevel=info
  # alternate startup method for Celery
  #python manage.py celeryd -l info

  # 4. launch a local web server in a new window at http://0.0.0.0:8000
  cd /Users/mcdaniel/github/lpm0073/shadetrees.io/
  source venv/bin/activate
  cd shadetrees
  uvicorn config.asgi:application --host 0.0.0.0 --reload

  # in the event of problems check if anything is already on port 8000
  sudo lsof -i:8000

  # run manage.py
  cd /Users/mcdaniel/github/lpm0073/shadetrees.io/
  source venv/bin/activate
  cd shadetrees
  ./manage.py -h

Pages
-----

http://0.0.0.0:8000/

http://0.0.0.0:8000/admin/

http://0.0.0.0:8000/cms_admin/


Production
----------

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

  git clone git@github-admin:lpm0073/shadetrees.io.git

  # setup app logging
  sudo mkdir /var/log/shadetrees.io
  sudo chown ubuntu /var/log/shadetrees.io
  sudo chgrp ubuntu /var/log/shadetrees.io


  # Python / Django installation
  cd ~
  sudo rm -r ./shadetrees.io
  git clone git@github-admin:lpm0073/shadetrees.io.git

  python3 -m venv ~/shadetrees.io/venv
  source ~/shadetrees.io/venv/bin/activate
  pip3 install -r ~/shadetrees.io/djangoproject/requirements/production.txt

  # create and install .env file

  # Prepare Django
  $ cd ~/shadetrees.io
  $ source ~/shadetrees.io/venv/bin/activate
  (env) $ python djangoproject/manage.py createsuperuser
  (env) $ python djangoproject/manage.py makemigrations
  (env) $ python djangoproject/manage.py migrate
  (env) $ python djangoproject/manage.py collectstatic
  (env) $ python djangoproject/manage.py runserver
  (env) $ deactivate


  # Test Gunicorn service
  $ cd ~/shadetrees.io
  $ source ~/shadetrees.io/venv/bin/activate
  (env) $ cd ~/shadetrees.io/djangoproject/
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

  $ mypy shadetrees

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

    cd shadetrees
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
