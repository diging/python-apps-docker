#!/bin/bash
NAME=“vogon-celery-beat”                       # Name of the application
DJANGODIR=/usr/src/app/vogon-web         # Django project directory
DJANGO_SETTINGS_MODULE=vogon.settings             # which settings file should Django use
DJANGO_CELERY_MODULE=vogon.celery                 # WSGI module name
echo “Starting $NAME as whoami”
# Activate the virtual environment
cd $DJANGODIR
source env_secrets
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
exec celery --app=${DJANGO_CELERY_MODULE}:app beat --pidfile=“/usr/src/app/run/celery-beat.pid”