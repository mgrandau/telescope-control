import asi
import cv2
from typing import Optional
import uvicorn
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import threading

class VideoCamera(object):
    _video = None
    _exposure = 22000000
    _offset_cross = (-12,-8)
    _gain = 82
    last_image: Optional[bytes] = None

    def __init__(self):
        self._video = asi.Camera(0)
        self._video.setCaptureFrameFormat(1280, 960, 1, "RGB24")
        self._video.setControlValueManual("ASI_GAIN", self._gain)
        self._video.setControlValueManual("ASI_WB_R", 55)
        self._video.setControlValueManual("ASI_WB_B", 77)

    def __del__(self):
        del self._video

    def get_frame(self) -> bytes:
        self.last_image, bin, success = self._video.grab(self._exposure)
        b,g,r = cv2.split(self.last_image)
        corrected_image = cv2.merge ( (r, g, b) )
        #print(self.last_image.shape)
        png = corrected_image[80-self._offset_cross[0]:880-self._offset_cross[0],240-self._offset_cross[1]:1040-self._offset_cross[1]]
        #print(png.shape)
        #ret, png = cv2.imencode('.png', self.last_image)

        cross = cv2.imread('overlays/alignment-cross-hair.png')
        #print(cross.shape)
        #overlay = cv2.imencode('.png',cv2.imread('cross-hair.png'))
        added_image = cv2.addWeighted(png,1,cross,1,0,dtype = cv2.CV_32F)
        
        ret, jpeg = cv2.imencode('.jpg', added_image)
        return jpeg.tobytes()


app = FastAPI()

def run():
    uvicorn.run(app, host="0.0.0.0", port=80)
      
def start_api():
    _api_thread = threading.Thread(target=run)
    _api_thread.start()
    
def create_stream(): 
    camera: VideoCamera  = VideoCamera()    
    while True:
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + bytearray(camera.get_frame()) + b'\r\n\r\n')
      
@app.get("/")
def get_video_stream():
    return StreamingResponse(create_stream(), media_type='multipart/x-mixed-replace; boundary=frame')

start_api()