

Running Locally
---------------

.. code-block:: bash

  # 1. start a PostgreSQL daemon in a new terminal window
  pg_ctl -D /usr/local/var/postgres/data -l logfile start

  # 2. start a redis server in a new terminal window
  redis-server /usr/local/etc/redis.conf

  # 3. start a celery worker in a separate terminal window
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  #export CELERY_BROKER_URL=redis://localhost:6379/0
  celery -A config.celery_app worker --loglevel=info
  # alternate startup method for Celery
  #python manage.py celeryd -l info

  # 4. launch a local web server in a new window at http://0.0.0.0:8000
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  uvicorn config.asgi:application --host 0.0.0.0 --reload

  # in the event of problems check if anything is already on port 8000
  sudo lsof -i:8000

  # run manage.py
  cd /Users/mcdaniel/github/lpm0073/shadetree/
  source venv/bin/activate
  cd shadetree
  ./manage.py -h



Cookie Cutter Django docs
-------------------------

https://cookiecutter-django.readthedocs.io/en/latest/developing-locally.html

https://cookiecutter-django.readthedocs.io/en/latest/project-generation-options.html

Prerequisite DB Stuff
---------------------

.. code-block:: bash

    brew install psequel
    brew install postgresql
    #brew install openssl       // already installed
    brew install swig

    initdb /usr/local/var/postgres/data -E utf8
    #pg_ctl -D /usr/local/var/postgres start
    pg_ctl -D /usr/local/var/postgres/data -l logfile start

    psql -h localhost -d postgres
    postgres=# create user dev with encrypted password 'SillyPassword$1';
    postgres=# create database shadetree with owner = dev;


Prerequisite Redis / Celery Stuff
---------------------------------

.. code-block:: bash

    brew install redis
    # in a new terminal window
    redis-server /usr/local/etc/redis.conf

    # in another terminal window
    python manage.py celeryd -l info
    export CELERY_BROKER_URL=redis://localhost:6379/0
    celery -A config.celery_app worker --loglevel=info

    # in your working terminal window (a 3rd window)
    redis-cli ping


Project Setup Stuff
-------------------

.. code-block:: bash

    pip3 install virtualenv
    virtualenv venv
    source venv/bin/activate
    pip install "cookiecutter>=1.7.0"
    cookiecutter https://github.com/pydanny/cookiecutter-django

    * git init / push to github

    # Before executing this line
    # run pip3 --version to ensure that the working directory
    # is actually located within venv
    pip3 install -r requirements/local.txt


    pre-commit install

    # add these to config/settings/base.py
    DATABASE_URL=postgres://dev:SillyPassword$1@127.0.0.1:5432/shadetree
    CELERY_BROKER_URL=redis://localhost:6379/0

    python manage.py migrate
