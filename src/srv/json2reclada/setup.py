#!/usr/bin/env python
from distutils.core import setup
from setuptools import find_namespace_packages 
import os

def create_links(work_dir):
    """
        This function prepares the directory tree structure so
        this package can be installed as a part of reclada namespace
    :param work_dir: directory in which the directory tree structure would be created
    """
    # create reclada directory
    os.mkdir(work_dir+"/reclada")
    # create a symbolic link to src folder
    os.symlink(work_dir+"/src", work_dir+"/reclada/json2reclada", target_is_directory=True)

# get the current directory
cur_dir = os.getcwd()
# create reclada directory and symlink json2reclada to src folder
create_links(cur_dir)

setup(
    name='json2reclada',
    version='1.0',
    description='Hierarchical JSON to Reclada objects converter',
    author='Alexei Dobrov',
    author_email='alexey.dobrov@quantori.com',
    url='https://github.com/reclada/SciNLP/src/srv/json2reclada',
    packages=find_namespace_packages(include=["reclada.*"]),
)
