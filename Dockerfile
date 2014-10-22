FROM stackbrew/ubuntu:14.04
MAINTAINER Benjamin Woehrl <hey@benjaminwoehrl.de>
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git python python-dev python-setuptools nginx sqlite3 supervisor
RUN easy_install pip
RUN pip install uwsgi

ADD . /sites/django/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /sites/django/django.conf /etc/nginx/sites-enabled/
RUN ln -s /sites/django/supervisord.conf /etc/supervisor/conf.d/

RUN pip install -r /sites/django/app/requirements.txt
RUN (cd /sites/django/app && submodule init --noinput)
RUN (cd /sites/django/app && submodule update --noinput)
RUN (cd /sites/django/app && python manage.py syncdb --noinput)
RUN (cd /deploy/myblog && python manage.py migrate --noinput)
RUN (cd /deploy/myblog && python manage.py collectstatic --noinput)

VOLUME ["/sites/django/app"]
EXPOSE 80
CMD ["/sites/django/run.sh"]
