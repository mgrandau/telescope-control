from dataclasses import dataclass
from time import sleep, time_ns
import asi
import cv2
from abc import ABC
from typing import Dict, List, Any 

class IImageAcquisitionBehavior(ABC):

    def get_processed_frame_as_jpg(self) -> bytes:
        pass

class IPostProcessingBehavior(ABC):

    def process_image(self, image: cv2.Mat) -> cv2.Mat:
        pass

class IImageAcquisitionBehaviorLogger(ABC):

    def log_frame_acquisition(self, info: str) -> None:
        pass

    def log_frame_acquisition_wait(self, info: str) -> None:
        pass

    def log_post_processor_run(self, info: str) -> None:
        pass

@dataclass
class  ZwoAsiCameraDataRepository(object):
    _configuration : Dict[ str, Any ]

    def __init__(self, configuration : Dict[str,Any]):
        self._configuration = configuration

    @property
    def index(self) -> int:
        return self._configuration["index"]

    @property
    def use_hardware(self) -> bool:
        return self._configuration["override_filename"] == ""

    @property
    def override_filename(self) -> str:
        return self._configuration["override_filename"]

    @property
    def width(self) -> int:
        return self._configuration["width"]

    @property
    def height(self) -> int:
        return self._configuration["height"]

    @property
    def exposure_time(self) -> int:
        return self._configuration["exposure_time"]

    @property
    def time_to_get_next_frame(self) -> int:
        return self._configuration["time_to_get_next_frame"]

    @time_to_get_next_frame.setter
    def time_to_get_next_frame(self, val: int ) -> None:
        self._configuration["time_to_get_next_frame"] = val

    @property
    def mode(self) -> str:
        return self._configuration["mode"]

    @property
    def gain(self) -> int:
        return self._configuration["gain"]

    @property
    def white_balance_red(self) -> int:
        return self._configuration["white_balance_red"]

    @property
    def white_balance_blue(self) -> int:
        return self._configuration["white_balance_blue"]

    def current_state(self) -> Dict[str, Any]:
        return self._configuration

    @staticmethod
    def default_configuration() -> Dict[str, Any]:
        return {
            "index": 0,
            "override_filename": "",
            "width": 1280,
            "height": 960,
            "exposure_time": 22000000,
            "fps": 22.0,
            "mode": "RGB24",
            "gain": 82,
            "white_balance_red": 55,
            "white_balance_blue": 77,
            "time_to_get_next_frame": 0
        }
      

class ZwoAsiCamera(IImageAcquisitionBehavior):

    _repository: ZwoAsiCameraDataRepository = None
    _automatically_run_post_processing_behaviors : List[IPostProcessingBehavior] = None
    _logger : IImageAcquisitionBehaviorLogger = None
    _last_image: cv2.Mat = None
    _video: asi.Camera = None

    def __init__(self, configuration : Dict[str,Any] = None, automatically_run_post_processing_behaviors : List[IPostProcessingBehavior] = None, logger: IImageAcquisitionBehaviorLogger = None):
        self._repository = ZwoAsiCameraDataRepository(configuration)
        self._automatically_run_post_processing_behaviors = automatically_run_post_processing_behaviors
        self._logger = logger

        if self._repository.use_hardware:
            self._video = asi.Camera(self._repository.index)
            self._video.setCaptureFrameFormat(self._repository.width, self._repository.height, 1, self._repository.mode)
            self._video.setControlValueManual("ASI_GAIN", self._repository.gain)
            self._video.setControlValueManual("ASI_WB_R", self._repository.white_balance_red)
            self._video.setControlValueManual("ASI_WB_B", self._repository.white_balance_blue)

    def __del__(self):
        if self._video is not None:
            del self._video

    def _wait_for_next_frame(self) -> None:
        wait_time: float = (self._repository.time_to_get_next_frame - time_ns()) / 1e9
        if wait_time > 0:
            if self._logger is not None:
                self._logger.log_frame_acquisition_wait(f"Waiting for next frame: {wait_time}")
            sleep(wait_time)

    def _capture_frame_from_camera(self) -> cv2.Mat:
        last_image, bin, success = self._video.grab(self._repository.exposure_time)

        b,g,r = cv2.split(last_image)
        return cv2.merge ( (r, g, b) )

    def _get_frame(self)-> None:
        if self._repository.use_hardware:
            self._last_image = self._capture_frame_from_camera()
            if self._logger is not None:
                self._logger.log_frame_acquisition(f"Acquired frame from camera({self._repository.index})")
        else:
            self._last_image = cv2.imread(self._repository.override_filename)
            if self._logger is not None:
                self._logger.log_frame_acquisition(f"Acquired frame from file : {self._repository.override_filename}")

        self._repository.time_to_get_next_frame = time_ns() + int((1 / self._repository.fps) * 1e9)

    def _run_post_processing_behaviors(self) -> None:
        for behavior in self._repository.automatically_run_post_processing_behaviors:
            if self._logger is not None:
                self._logger.log_post_processor_run(f"Before post processor: {type(behavior)}")

            self._last_image = behavior.process_image(self._last_image)

            if self._logger is not None:
                self._logger.log_post_processor_run(f"After post processor: {type(behavior)}")

    def get_processed_frame_frame_as_jpg(self) -> bytes:

        self._wait_for_next_frame()
        self._get_frame()
        self._run_post_processing_behaviors()

        ret, jpeg = cv2.imencode('.jpg', self._last_image)
        return jpeg.tobytes()
