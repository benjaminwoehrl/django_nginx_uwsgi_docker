#!/bin/bash

MODULE=${MODULE:-website}

sed -i "s#module=website.wsgi:application#module=${MODULE}.wsgi:application#g" /sites/django/uwsgi.ini

if [ ! -f "/sites/django/app/manage.py" ]
then
	echo "creating basic django project (module: ${MODULE})"
	django-admin.py startproject ${MODULE} /sites/django/app/
fi

/usr/bin/supervisord
