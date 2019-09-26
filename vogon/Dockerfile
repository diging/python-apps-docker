FROM python:3.6

WORKDIR /usr/src/app

RUN mkdir run
RUN mkdir logs/
RUN mkdir bin

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
# most of these are for lxml which needs a bunch of dependancies installed
RUN apt-get install -y \
    libffi-dev \
    libssl-dev \
    default-libmysqlclient-dev \
    libxml2-dev \
    libxslt-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    net-tools \
    git-all \
    supervisor \
	redis-server\
    vim

COPY scripts/vogon-gunicorn.sh bin/
COPY scripts/vogon-celery.sh bin/
COPY scripts/vogon-supervisord.conf /etc/supervisor/conf.d/

RUN chmod u+x bin/vogon-gunicorn.sh
# TODO: This should be changed to master once we are done testing
RUN git clone -b story/VGNWB-259-5  https://github.com/diging/vogon-web.git
WORKDIR /usr/src/app/vogon-web
RUN pip install -r requirements.txt

COPY env_secrets .
RUN /bin/bash -c "source env_secrets; python manage.py migrate; python manage.py collectstatic --noinput"

EXPOSE 8000
CMD /bin/bash -c "service redis-server start; service supervisor start; tail -f /dev/null"


