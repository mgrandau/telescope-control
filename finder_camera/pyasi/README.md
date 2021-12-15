PyASI
=====

This is a Python wrapper around some ASI SDK functions. You'll need to
download the SDK from https://astronomy-imaging-camera.com/software/
and install the library (e.g. `libASICamera2.so.0.7.0118`) and header
file (`ASICamera2.h`) so that your compiler can find it.

Dependencies
------------
The wrapper uses [Cython](http://cython.org/) to create the Python module,
and will return captured frames as [NumPy](http://www.numpy.org/) arrays.
