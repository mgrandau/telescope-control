# -*- coding: utf-8 -*-
from __future__ import print_function
import asi
import numpy as np
import scipy.misc
from pprint import pprint # pretty print

# List the connected camera's
cameras = asi.getConnectedCameras()
print("Connected camera's:")
pprint(cameras)

# Open the first camera, with ID 0
cam = asi.Camera(0)

# Print the camera info, should be one of the things in 'cameras'
print("Camera information")
camInfo = cam.getInfo()
pprint(camInfo)

print("The current capture format is:")
captureFormat = cam.getCaptureFrameFormat()
pprint(captureFormat)

print("Setting the capture image type to RGB24")
cam.setCaptureFrameFormat(1280, 960, 1, "RGB24")

# For convenience, frames are returned in floating point format, even though
# the camera itself will return 8 bit or 16 bit values. Apart from the frame
# itself, it also returns the binning type used and the image type of the
# frame. 
print("Performing a single exposure of 10000 µs")
frame, binning, imgType = cam.grab(10000)

# This function to save the image automatically scales the floating point
# pixel values to fall in an 8 bit range
scipy.misc.imsave("rgbgrab.png", frame)

# A long exposure can cause the CCD pixels to get saturated, resulting in
# less usefull information in the recorded frame.
print("Performing a single exposure of 1000000 µs")
frame, binning, imgType = cam.grab(1000000)
scipy.misc.imsave("rgbgrab_longexposure.png", frame)

# To avoid these saturated pixels, and still have a longer effective
# exposure time, you can indicate the the same exposure is to be repeated
# a number of times
print("Performing a 100 exposures of 10000 µs")
frame, binning, imgType = cam.grab(10000, 100)
scipy.misc.imsave("rgbgrab_longexposure_inparts.png", frame)

# Such repeated single exposures can be quite slow, in video recording
# mode this may work better. Here, 100 frames are recorded and summed,
# which should have a similar behavior as the previous 'grab' call.
print("Using video recording mode to sum 100 exposures of 10000 µs")
frame, binning, imgType = cam.recordVideoFrames(10000, 100, sumFrames = True)
scipy.misc.imsave("rgbgrab_summedvideoframes.png", frame)

# To simply record a number of frames for a number of seconds, you
# can set the number of frames to something large, and limit the number
# of seconds
print("Recording frames for 0.5 seconds")
frames, binning, imgType = cam.recordVideoFrames(10000, 99999, maxRecordTime = 0.5)
print("{} frames recorded".format(len(frames)))

# There are several controls that can be changed or read. This lists all of
# them with their properties:
print("Available controls on this camera:")
ctrls = cam.getControls()
pprint(ctrls)

# For each control, we can get the current settings:
print("Current control settings:")
for ctrl in cam.getControls():
    print("    {}: {}".format(ctrl, cam.getControlValue(ctrl)))

# Controls can be set to a manual value, or to an auto setting (if supported)
# The function returns the control setting after the change
newSetting = cam.setControlValueManual("ASI_GAIN", 50)
print("New value for ASI_GAIN: {}".format(newSetting))
newSetting = cam.setControlValueAuto("ASI_GAIN")
print("New value for ASI_GAIN: {}".format(newSetting))


