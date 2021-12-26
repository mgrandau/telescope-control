---
id: 5VR0zwmW01KjZYdl5OYZd
title: telescope-control
desc: ''
updated: 1640538856102
created: 1640538424351
---

This project creates a service that will control the telescope remotely.

Components under control:
* [ZWO ASI120MC-S (color) camera](https://astronomy-imaging-camera.com/product/asi120mc-s) with [ZWO 1/3" 2.1mm 150 degree lens](https://astronomy-imaging-camera.com/product/zwo-13-2-1mm-150-degree-lens) as a finder scope.
* [ZWO ASI482MC camera](https://astronomy-imaging-camera.com/product/asi482mc) as the main telescope imaging camera
* [StepperOnline Nema 17 High Temp Stepper Motor 13Ncm/18.4oz.in Insulation Class H 180C](https://www.omc-stepperonline.com/nema-17-high-temp-stepper-motor-13ncm-18-4oz-in-insulation-class-h-180c.html) controlling telescope heading.
* [StepperOnline Nema 17 High Temp Stepper Motor 13Ncm/18.4oz.in Insulation Class H 180C](https://www.omc-stepperonline.com/nema-17-high-temp-stepper-motor-13ncm-18-4oz-in-insulation-class-h-180c.html) controlling telescope azimuth angle.

Telescope Control GUI:

I currently envision this as 2 heads-up displays.

* Finder camera view - used for large motion to objects visible in the night sky.
* Telescope imaging camera view - used for seeing through the the telescope remotely and acquiring images.

## Project

### Phase 1 - Basic remote control of the telescope

The goal is to lay the ground work to do the basics of the control application. Move through the finder heads-up display. Do fine motion through the telescope imaging heads-up display.

Capture image stacks for compositing into a final image.

### Phase 2 - Goto controls

Extend the finder view to goto a specific RA/Dec position. This should allow me to quickly move to things of interest.

### Phase 3 - Star Tracking

### Phase 4 - Satellite Tracking ML

### Phase 5 - Tracking as TinyML

## Source

As the project progresses I will identify the modules.

* _finder_camera_ - Component that encapsulates functionality provided by the finder camera.
* _server_service_ - web server that provides functionality for controlling the telescope.
* _gui_ - GUI for controlling the telescope. Implemented as HTML, Javascript and CSS in a jupyter notebook)
