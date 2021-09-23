#!/usr/bin/env python

from distutils.core import setup

setup(
    name='json2reclada',
    version='1.0',
    description='Hierarchical JSON to Reclada objects converter',
    author='Alexei Dobrov',
    author_email='alexey.dobrov@quantori.com',
    url='https://github.com/reclada/SciNLP/src/srv/json2reclada',
    packages=['json2reclada'],
    package_dir={'json2reclada': 'src'}
)
