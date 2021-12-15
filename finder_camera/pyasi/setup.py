#!/usr/bin/env python

from distutils import sysconfig
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import platform
import glob
import sys
import os
import pprint

extraFlags = [ ]
extraIncludes = [ ]
extraDefines = [ ]
libDirs = [ ]
libraries = [ "ASICamera2" ]

if "CC" in os.environ and os.environ["CC"].startswith("ccache"):
    del os.environ["CC"]
if "CXX" in os.environ and os.environ["CXX"].startswith("ccache"):
    del os.environ["CXX"]

if "CONDA_BUILD" in os.environ or "CONDA_PREFIX" in os.environ:
    prefix = None
    if "PREFIX" in os.environ:
        prefix = os.environ["PREFIX"]
    elif "CONDA_PREFIX" in os.environ:
        prefix = os.environ["CONDA_PREFIX"]

    l = glob.glob(os.path.join(prefix,"lib","python*","site-packages","numpy","core","include"))
    if len(l) > 0:
        extraIncludes += [ l[0] ]
    l = glob.glob(os.path.join(prefix,"lib","site-packages","numpy","core","include"))
    if len(l) > 0:
        extraIncludes += [ l[0] ]

extensions = [
    Extension("asi", 
        [ "asi.pyx" ],
        include_dirs = extraIncludes,
        libraries = libraries,
        library_dirs = libDirs,
        language = "c++",
        define_macros = [ ] + extraDefines,
        extra_compile_args = extraFlags
    ),
]

versionStr = "0.0.1"

pyMods = [ ]
setup(name = "asi", version = versionStr, ext_modules = cythonize(extensions), py_modules = pyMods)

