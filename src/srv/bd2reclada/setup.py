#!/usr/bin/env python

from distutils.core import setup

setup(
    name='bd2reclada',
    version='1.0',
    description='BadgerDoc JSON to Reclada objects converter',
    author='Alexei Dobrov',
    author_email='alexey.dobrov@quantori.com',
    url='https://github.com/reclada/SciNLP/src/srv/bd2reclada',
    packages=['bd2reclada'],
    package_dir={'bd2reclada': 'src'}
)
