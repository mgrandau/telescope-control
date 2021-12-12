# telescope-finder-camera

Use an ASICamera with an all sky lens as a finder for the main telescope camera. This is critical to remotely controlling the telescope for observation. The app will run on the computer connected top the instrument. I'm assuming that you can remote connect to the computer.

This approach allows me to:

* Set the cameras gain and exposure time so that I can draw the primary navigation stars out in the nights sky. Better than the human eye.
* Capture an image of the night sky to document where I'm observing.
* Control where the cross-hair is placed via configuration so that it can be aligned with the telescopes sees through the eye piece. The camera is mounted on the optical tube assembly (OTA) but not angled pysically to allign with what is seen through the eyepeice. This will be prinmarily be used to identify the offset. 

I will recreate an overlay with the appropriate offset custom to my setup and use it. The reasoning is to reduce the image manipulation and gige a full camera view of the brightfield area.  

This approach of overlays may be useful in laying out custom markers. For example:

* Telerad equivalent circles for star hoping.
* Arcs that fit various equitorial star Dec tracks. This may be usefull in understanding the star motion to pre-plan observtions.  

## How is the camera mounted?

I looked for a solid mounting place. I wanted it to be stable, so not to play with allignment constantly. I also wanted to be able to fix the rotation of the camera. 

My solution? I use a Telarad for eye sighting. It has a 3 inch extension. The extension are fins that form a stable beam structure. My approach is to use a 1/4-20 x 1 1/2 bolt (standard tripod threading) with a few washers and a nut. The nut goes on first with the washers and camera sandwiching the fins of the telerad support. The camera and nut provide for a tight fit that should not move. The tape is just to limit camera rotation.

<image src="finder-camera-mount.jpg" height=400>

## Using the ASI120MC-S

I'm not really concerned on a physically aligning the camera to what the telescope sees. It should be firmly mounted. The software will allow for configuration to position the targeting cross-hairs, tellerad circles or whatever the overlay is depicting.

## Running the prototype

I've prototyped the code and its usage in finder-camera.ipynb

## Dependencies

* [ASICamera2 SDK](https://download.astronomy-imaging-camera.com/download/asi-camera-sdk-linux-mac/?wpdmdl=381) - Linux SDK
* [pyasi](https://github.com/j0r1/pyasi) - a [Cython](https://cython.org/) wrapper around some ASI SDK. This should allow direct calls from python.
