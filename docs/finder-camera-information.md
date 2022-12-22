# Finder Camera Information

Using the [ZWO ASI120MC-S](https://astronomy-imaging-camera.com/product/asi120mc-s) with the [ZWO 1/3″ 2.1mm 150 degree len](https://astronomy-imaging-camera.com/product/zwo-13-2-1mm-150-degree-lens) (all sky len) as a finder for the telescope. This is critical to remotely controlling the telescope for observation.

<image src="doc_images/finder-camera-mount.jpg" height=400>

The telescope control application will run on a computer connected top the instrument. I can remote connect to the computer to control the telescope.

By using a camera as a finder scope, it allows me to:

* Set the cameras gain and exposure time so that I can draw the primary navigation stars out in the nights sky. Better than the human eye.
* Capture an image of the night sky to document where I'm observing.
* Build a horizon mask for [Stellarium](https://stellarium.org/).
* Align the cross-hair image seen in the finder camera so that it can be aligned with what the telescopes sees through the eye piece (see _..\jupyter-notebooks\camera_alignment.ipynb_). The main camera ([ZWO ASI482MC](https://astronomy-imaging-camera.com/product/asi482mc)) is mounted on the optical tube assembly (OTA). The 2 cameras are not angled to align. Because the relationship of the finder camera and the main camera mounted to the OTA does not change; it should be possible to position a cross-hair in the finder cameras view, with some offset from center, to know what the OTA is pointed at within some error. That error is field of view of a single pixel in the finder camera.

I will position a sighting overlay with the appropriate offset based on the OTA and finder camera positions.

This approach of overlays may be useful in laying out custom markers. For example:

* [Telrad Reflex Sight Finder](https://optcorp.com/products/telrad-finder-scope) equivalent circles for star hoping.
* Arcs that fit various equatorial star Dec tracks. This may be useful in understanding the star motion to pre-plan observation.

## How is the camera mounted?

I looked for a solid mounting place. I wanted it to be stable, so not to play with alignment constantly. I also wanted to be able to fix the rotation of the camera.

My solution? I usually a Telrad for eye sighting the OTA. It has a 3 inch extension. The extension are fins that form a stable beam structure. My approach is to use a 1/4-20 x 1 1/2 bolt (standard tripod threading) with a few washers and a nut. The nut goes on first with the washers and camera sandwiching the fins of the Telrad support. The camera and nut provide for a tight fit that should not move. The tape is just to limit camera rotation.

## Using the ASI120MC-S

I'm not relying on a physical alignment of the finder camera to what the telescope sees (OTA). It should be firmly mounted. The software will allow for configuration to position the targeting cross-hairs, telrad circles or whatever the overlay is being used.

## Running the prototype

I've prototyped the code and its usage in _finder-camera.ipynb_.

## Dependencies

* [ASICamera2 SDK](https://download.astronomy-imaging-camera.com/download/asi-camera-sdk-linux-mac/?wpdmdl=381) - Linux SDK
* [pyasi](https://github.com/j0r1/pyasi) - a [Cython](https://cython.org/) wrapper around some ASI SDK. This should allow direct calls from python.
