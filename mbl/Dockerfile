FROM python:3

WORKDIR /usr/src/app

RUN mkdir run
RUN mkdir logs/
RUN mkdir bin

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
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
    vim

COPY scripts/mbl-gunicorn.sh bin/
COPY scripts/mbl-supervisord.conf /etc/supervisor/conf.d/

RUN chmod u+x bin/mbl-gunicorn.sh

RUN git clone -b task/MHDP-25  https://github.com/diging/mbl-browser.git
WORKDIR /usr/src/app/mbl-browser
RUN pip install -r requirements.txt

COPY env_secrets .
RUN /bin/bash -c "source env_secrets; python manage.py migrate; python manage.py collectstatic --noinput"

EXPOSE 8000
CMD /bin/bash -c "service supervisor start; tail -f /dev/null"

