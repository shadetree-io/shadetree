Running Locally
===============

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
