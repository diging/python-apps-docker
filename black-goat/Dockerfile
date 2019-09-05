FROM python:2

WORKDIR /usr/src/app

RUN mkdir run
RUN mkdir logs/
RUN mkdir bin

RUN apt-get -y update
RUN apt-get install -y git-all
RUN apt-get install -y redis-server
RUN apt-get install -y supervisor

COPY scripts/goat-celery.sh bin/
COPY scripts/goat-gunicorn.sh bin/
COPY scripts/goat-supervisord.conf /etc/supervisor/conf.d/

RUN chmod u+x bin/goat-celery.sh
RUN chmod u+x bin/goat-gunicorn.sh

RUN git clone https://github.com/diging/black-goat.git
WORKDIR black-goat
RUN pip install -r requirements.txt

COPY env_secrets .
RUN /bin/bash -c "source env_secrets; python manage.py migrate; python manage.py collectstatic --noinput"

EXPOSE 8000
CMD /bin/bash -c "service redis-server start; service supervisor start; tail -f /dev/null"
