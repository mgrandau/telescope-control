# telescope-finder-camera

Use an ASICamera with an all sky lens as a finder for the main telescope camera. This is critical to remotely controlling the telescope for observation. The app will run on the computer connected top the instrument. I'm assuming that you can remote connect to the computer.

This approach allows me to:

* Set the cameras gain and exposure time so that I can draw the primary navigation stars out in the nights sky
* Capture an image of the night sky to document where I'm observing
* Control where the cross-hair is placed via configuration so that it can be aligned with the telescopes sees through the eye piece

## Using the ASI120MC-S

I'm not really concerned on a physically aligning the camera to what the telescope sees. It should be firmly mounted. The software will allow for configuration to position the targeting cross-hairs.

## Running the prototype

I've prototyped the code and its usage in finder-camera.ipynb

## Dependencies

* [ASICamera2 SDK](https://download.astronomy-imaging-camera.com/download/asi-camera-sdk-linux-mac/?wpdmdl=381) - Linux SDK
* [pyasi](https://github.com/j0r1/pyasi) - a [Cython](https://cython.org/) wrapper around some ASI SDK. This should allow direct calls from python.
