"""
The MIT License (MIT)

Copyright (c) 2022 mgrandau

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

from typing import Dict

import cv2
from asi_camera import ASICamera


class FinderCamera(ASICamera):

    _overlay_image = None
    _overlay_image_height = 0
    _overlay_image_width = 0

    def __init__(self, config: Dict[str, any]):

        super().__init__(config)

        self._overlay_image = cv2.imread(config["Overlay_Filename"])
        (
            self._overlay_image_height,
            self._overlay_image_width,
            channels,
        ) = self._overlay_image.shape
        # print(f'Overlay Image (height,weight):
        # ({self._overlay_image_height},{self._overlay_image_width})')

    def __del__(self):

        super().__del__()

    def clip_camera_to_overlay_and_merge(self):

        clip_height_start = (
            int((self._config["Height"] - self._overlay_image_height) / 2)
            - self._config["Overly_Height_Offset"]
        )
        clip_height_end = clip_height_start + self._overlay_image_height

        clip_width_start = (
            int((self._config["Width"] - self._overlay_image_width) / 2)
            - self._config["Overly_Width_Offset"]
        )
        clip_width_end = clip_width_start + self._overlay_image_width

        clipped_image = self.last_image[
            clip_height_start:clip_height_end, clip_width_start:clip_width_end
        ]

        self.last_image = cv2.addWeighted(
            clipped_image, 1, self._overlay_image, 1, 0, dtype=cv2.CV_32F
        )

    def get_frame(self) -> bytes:

        super().get_frame()

        self.clip_camera_to_overlay_and_merge()

        ret, jpeg = cv2.imencode(".jpg", self.last_image)
        return jpeg.tobytes()
