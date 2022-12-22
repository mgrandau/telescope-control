#!/usr/bin/env python

import os

from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

sdk = "ASI_linux_mac_SDK_V1.27"
versionStr = "1.27.0"

extraFlags = []
extraIncludes = [f"{sdk}/include"]
extraDefines = []
libDirs = [f"{sdk}/lib64"]
libraries = ["ASICamera2"]

if "CC" in os.environ and os.environ["CC"].startswith("ccache"):
    del os.environ["CC"]
if "CXX" in os.environ and os.environ["CXX"].startswith("ccache"):
    del os.environ["CXX"]

extensions = [
    Extension(
        "asi",
        [f"{os.path.dirname(os.path.abspath(__file__))}/pyasi/asi.pyx"],
        include_dirs=extraIncludes,
        libraries=libraries,
        library_dirs=libDirs,
        language="c++",
        define_macros=[] + extraDefines,
        extra_compile_args=extraFlags,
    ),
]

pyMods = []
setup(
    name="asi", version=versionStr, ext_modules=cythonize(extensions), py_modules=pyMods
)
