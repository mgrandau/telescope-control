#***************************************************************************************************************
# Copyright 2022 Mark Grandau
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions 
# of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
# DEALINGS IN THE SOFTWARE.
#
#***************************************************************************************************************

import asi
import cv2
from typing import Optional, Dict

class ASICamera():
    _video: Optional[asi.Camera] = None
    last_image: Optional[bytes] = None
    
    _config : Dict[str, any] = { 
        'Camera ID': 1, 
        'Exposure_Time_In_us': 2 * 1000 * 1000, 
        'Gain': 82, 
        'WhiteBalance_Red': 55, 
        'WhiteBalance_Blue': 80,
        'Height': 1080,
        'Width': 1920,
        'Mode': 'RGB24'
    }

    def __init__(self, config : Dict[str, any]):
        self._config = config

        self._video = asi.Camera(self._config['Camera ID'])
        
        self._video.setCaptureFrameFormat( self._config['Width'], self._config['Height'], 1, self._config['Mode'] )
        self._video.setControlValueManual( "ASI_GAIN", self._config['Gain'] )
        self._video.setControlValueManual( "ASI_WB_R", self._config['WhiteBalance_Red'] )
        self._video.setControlValueManual( "ASI_WB_B", self._config['WhiteBalance_Blue'] )

    def __del__(self):
        del self._video

    def get_frame(self) -> bytes:
        self.last_image, bin, success = self._video.grab(self._exposure)
        b,g,r = cv2.split(self.last_image)
        self.last_image = cv2.merge ( (r, g, b) )
        
        ret, jpeg = cv2.imencode('.jpg', self.last_image)
        return jpeg.tobytes()
