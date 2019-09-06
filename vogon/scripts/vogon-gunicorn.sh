#!/bin/bash

NAME="vogon-web"                                  # Name of the application
DJANGODIR=/usr/src/app/vogon-web             # Django project directory
SOCKFILE=/usr/src/app/run/vogon.sock  # we will communicte using this unix socket
NUM_WORKERS=3                                     # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=vogon.settings             # which settings file should Django use
DJANGO_WSGI_MODULE=vogon.wsgi                     # WSGI module name

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source env_secrets
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --bind=0.0.0.0:8000 \
  --log-level=debug \
  --log-file=-