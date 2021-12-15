from libcpp.vector cimport vector
import numpy as np
import copy
import time
cimport casi

class ASIException(Exception):
    pass

cdef getASIErrorString(int errorCode):
    if errorCode == casi.ASI_SUCCESS:
        return "No error"
    if errorCode == casi.ASI_ERROR_INVALID_INDEX:
        return "ASI_ERROR_INVALID_INDEX"
    if errorCode == casi.ASI_ERROR_INVALID_ID:
        return "ASI_ERROR_INVALID_ID"
    if errorCode == casi.ASI_ERROR_INVALID_CONTROL_TYPE:
        return "ASI_ERROR_INVALID_CONTROL_TYPE"
    if errorCode == casi.ASI_ERROR_CAMERA_CLOSED:
        return "ASI_ERROR_CAMERA_CLOSED"
    if errorCode == casi.ASI_ERROR_CAMERA_REMOVED:
        return "ASI_ERROR_CAMERA_REMOVED"
    if errorCode == casi.ASI_ERROR_INVALID_PATH:
        return "ASI_ERROR_INVALID_PATH"
    if errorCode == casi.ASI_ERROR_INVALID_FILEFORMAT:
        return "ASI_ERROR_INVALID_FILEFORMAT"
    if errorCode == casi.ASI_ERROR_INVALID_SIZE:
        return "ASI_ERROR_INVALID_SIZE"
    if errorCode == casi.ASI_ERROR_INVALID_IMGTYPE:
        return "ASI_ERROR_INVALID_IMGTYPE"
    if errorCode == casi.ASI_ERROR_OUTOF_BOUNDARY:
        return "ASI_ERROR_OUTOF_BOUNDARY"
    if errorCode == casi.ASI_ERROR_TIMEOUT:
        return "ASI_ERROR_TIMEOUT"
    if errorCode == casi.ASI_ERROR_INVALID_SEQUENCE:
        return "ASI_ERROR_INVALID_SEQUENCE"
    if errorCode == casi.ASI_ERROR_BUFFER_TOO_SMALL:
        return "ASI_ERROR_BUFFER_TOO_SMALL"
    if errorCode == casi.ASI_ERROR_VIDEO_MODE_ACTIVE:
        return "ASI_ERROR_VIDEO_MODE_ACTIVE"
    if errorCode == casi.ASI_ERROR_EXPOSURE_IN_PROGRESS:
        return "ASI_ERROR_EXPOSURE_IN_PROGRESS"
    if errorCode == casi.ASI_ERROR_GENERAL_ERROR:
        return "ASI_ERROR_GENERAL_ERROR"
    return "Unknown error code ".format(errorCode)

cdef getControlTypeString(casi.ASI_CONTROL_TYPE t):
    if t == casi.ASI_GAIN:
        return "ASI_GAIN"
    if t == casi.ASI_EXPOSURE:
        return "ASI_EXPOSURE"
    if t == casi.ASI_GAMMA:
        return "ASI_GAMMA"
    if t == casi.ASI_WB_R:
        return "ASI_WB_R"
    if t == casi.ASI_WB_B:
        return "ASI_WB_B"
    if t == casi.ASI_OFFSET:
        return "ASI_OFFSET"
    if t == casi.ASI_BANDWIDTHOVERLOAD:
        return "ASI_BANDWIDTHOVERLOAD"
    if t == casi.ASI_OVERCLOCK:
        return "ASI_OVERCLOCK"
    if t == casi.ASI_TEMPERATURE:
        return "ASI_TEMPERATURE"
    if t == casi.ASI_FLIP:
        return "ASI_FLIP"
    if t == casi.ASI_AUTO_MAX_GAIN:
        return "ASI_AUTO_MAX_GAIN"
    if t == casi.ASI_AUTO_MAX_EXP:
        return "ASI_AUTO_MAX_EXP"
    if t == casi.ASI_AUTO_MAX_BRIGHTNESS:
        return "ASI_AUTO_MAX_BRIGHTNESS"
    if t == casi.ASI_HARDWARE_BIN:
        return "ASI_HARDWARE_BIN"
    if t == casi.ASI_HIGH_SPEED_MODE:
        return "ASI_HIGH_SPEED_MODE"
    if t == casi.ASI_COOLER_POWER_PERC:
        return "ASI_COOLER_POWER_PERC"
    if t == casi.ASI_TARGET_TEMP:
        return "ASI_TARGET_TEMP"
    if t == casi.ASI_COOLER_ON:
        return "ASI_COOLER_ON"
    if t == casi.ASI_MONO_BIN:
        return "ASI_MONO_BIN"
    if t == casi.ASI_FAN_ON:
        return "ASI_FAN_ON"
    if t == casi.ASI_PATTERN_ADJUST:
        return "ASI_PATTERN_ADJUST"
    if t == casi.ASI_ANTI_DEW_HEATER:
        return "ASI_ANTI_DEW_HEATER"

    return "UNKNOWNCTRLTYPE({})".format(<int>t)

cdef getImageFormatString(casi.ASI_IMG_TYPE t):
    if t == casi.ASI_IMG_RAW8:
        return "ASI_IMG_RAW8"
    if t == casi.ASI_IMG_RGB24:
        return "ASI_IMG_RGB24"
    if t == casi.ASI_IMG_RAW16:
        return "ASI_IMG_RAW16"
    if t == casi.ASI_IMG_Y8:
        return "ASI_IMG_Y8"
    return "UnknownFormat({})".format(<int>t)

cdef casi.ASI_CONTROL_TYPE getControlTypeFromString(s):
    if s == "ASI_GAIN":
        return casi.ASI_GAIN
    if s == "ASI_EXPOSURE":
        return casi.ASI_EXPOSURE
    if s == "ASI_GAMMA":
        return casi.ASI_GAMMA
    if s == "ASI_WB_R":
        return casi.ASI_WB_R
    if s == "ASI_WB_B":
        return casi.ASI_WB_B
    if s == "ASI_OFFSET":
        return casi.ASI_OFFSET
    if s == "ASI_BANDWIDTHOVERLOAD":
        return casi.ASI_BANDWIDTHOVERLOAD
    if s == "ASI_OVERCLOCK":
        return casi.ASI_OVERCLOCK
    if s == "ASI_TEMPERATURE":
        return casi.ASI_TEMPERATURE
    if s == "ASI_FLIP":
        return casi.ASI_FLIP
    if s == "ASI_AUTO_MAX_GAIN":
        return casi.ASI_AUTO_MAX_GAIN
    if s == "ASI_AUTO_MAX_EXP":
        return casi.ASI_AUTO_MAX_EXP
    if s == "ASI_AUTO_MAX_BRIGHTNESS":
        return casi.ASI_AUTO_MAX_BRIGHTNESS
    if s == "ASI_HARDWARE_BIN":
        return casi.ASI_HARDWARE_BIN
    if s == "ASI_HIGH_SPEED_MODE":
        return casi.ASI_HIGH_SPEED_MODE
    if s == "ASI_COOLER_POWER_PERC":
        return casi.ASI_COOLER_POWER_PERC
    if s == "ASI_TARGET_TEMP":
        return casi.ASI_TARGET_TEMP
    if s == "ASI_COOLER_ON":
        return casi.ASI_COOLER_ON
    if s == "ASI_MONO_BIN":
        return casi.ASI_MONO_BIN
    if s == "ASI_FAN_ON":
        return casi.ASI_FAN_ON
    if s == "ASI_PATTERN_ADJUST":
        return casi.ASI_PATTERN_ADJUST
    if s == "ASI_ANTI_DEW_HEATER":
        return casi.ASI_ANTI_DEW_HEATER

    raise ASIException("Internal error: unexpected control type '{}', no internal type can be associated".format(s))

cdef _getCameraInfo(cameraId):
    cdef casi.ASI_CAMERA_INFO info
    cdef casi.ASI_ERROR_CODE err

    err = casi.ASIGetCameraProperty(&info, cameraId)
    if err != casi.ASI_SUCCESS:
        raise ASIException("Unable to get camera info for ID {}, error is {}".format(cameraId, getASIErrorString(err)))

    obj = { 
        "Name": info.Name,
        "MaxHeight": info.MaxHeight,
        "MaxWidth": info.MaxWidth,
        "IsColorCam": True if info.IsColorCam == casi.ASI_TRUE else False,
        #"BayerPattern": below
        #"SupportedBins": below
        #"SupportedVideoFormat": below
        "PixelSize": info.PixelSize,
        "MechanicalShutter": info.MechanicalShutter,
        "ST4Port": info.ST4Port,
        "IsCoolerCam": info.IsCoolerCam,
        "IsUSB3Host": info.IsUSB3Host,
        "IsUSB3Camera": info.IsUSB3Camera,
        "ElecPerADU": info.ElecPerADU
    }

    bayer = "Unknown"
    if info.BayerPattern == casi.ASI_BAYER_RG:
        bayer = "RG"
    elif info.BayerPattern == casi.ASI_BAYER_BG:
        bayer = "BG"
    elif info.BayerPattern == casi.ASI_BAYER_GR:
        bayer = "GR"
    elif info.BayerPattern == casi.ASI_BAYER_GB:
        bayer = "GB"

    obj["BayerPattern"] = bayer

    bins = []
    for i in range(16):
        if info.SupportedBins[i] == 0:
            break
        bins.append(info.SupportedBins[i])

    obj["SupportedBins"] = bins

    fmts = []
    for i in range(8):
        if info.SupportedVideoFormat[i] == casi.ASI_IMG_END:
            break
        fmts.append(getImageFormatString(info.SupportedVideoFormat[i]))

    obj["SupportedVideoFormat"] = fmts

    return obj

cdef class Camera:

    cdef int m_cameraId
    cdef object m_controls
    cdef object m_info

    def __cinit__(self):
        self.m_cameraId = -1
        self.m_controls = None
        self.m_info = None

    def __init__(self, int cameraId):
        cdef casi.ASI_ERROR_CODE err
        cdef int nDev

        if cameraId < 0:
            raise ASIException("Camera ID must be zero or larger, but is {}".format(cameraId))

        nDev = casi.ASIGetNumOfConnectedCameras()
        if cameraId >= nDev:
            raise ASIException("Specified ID {} is not compatible with the number of detected devices {}".format(cameraId, nDev))

        err = casi.ASIOpenCamera(cameraId)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to open camera {}, error is {}".format(cameraId, getASIErrorString(err)))

        self.m_cameraId = cameraId

        err = casi.ASIInitCamera(cameraId)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to initialize opened camera {}, error is {}".format(cameraId, getASIErrorString(err)))

    def __dealloc__(self):
        if self.m_cameraId >= 0:
            casi.ASICloseCamera(self.m_cameraId)

    def _checkControls(self):
        cdef int num,i
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_CONTROL_CAPS caps

        if self.m_controls is not None:
            return
        
        err = casi.ASIGetNumOfControls(self.m_cameraId, &num)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to get number of controls, error is {}".format(getASIErrorString(err)))

        controls = { }

        for i in range(num):
            err = casi.ASIGetControlCaps(self.m_cameraId, i, &caps)
            if err != casi.ASI_SUCCESS:
                raise ASIException("Unable to get control caps for control nr {}, error is {}".format(i, getASIErrorString(err)))

            controls[getControlTypeString(caps.ControlType)] = Camera._controlCapsToDict(&caps)

        self.m_controls = controls

    def _checkInfo(self):

        if self.m_info is not None:
            return

        self.m_info = _getCameraInfo(self.m_cameraId)

    def getInfo(self):
        self._checkInfo()
        return copy.deepcopy(self.m_info)

    def getControls(self):
        self._checkControls()
        return copy.deepcopy(self.m_controls)
        
    @staticmethod
    cdef _controlCapsToDict(casi.ASI_CONTROL_CAPS *caps):
        d = { 
            "Name": caps.Name,
            "Description": caps.Description,
            "MinValue": caps.MinValue,
            "MaxValue": caps.MaxValue,
            "DefaultValue": caps.DefaultValue,
            "IsAutoSupported": True if caps.IsAutoSupported == casi.ASI_TRUE else False,
            "IsWritable": True if caps.IsWritable == casi.ASI_TRUE else False,
        }

        return d

    def setCaptureFrameFormat(self, int width, int height, int binning, imgTypeString):
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_IMG_TYPE imgType

        if imgTypeString == "ASI_IMG_RAW8" or imgTypeString == "RAW8":
            imgType = casi.ASI_IMG_RAW8
        elif imgTypeString == "ASI_IMG_Y8" or imgTypeString == "Y8":
            imgType = casi.ASI_IMG_Y8
        elif imgTypeString == "ASI_IMG_RAW16" or imgTypeString == "RAW16":
            imgType = casi.ASI_IMG_RAW16
        elif imgTypeString == "ASI_IMG_RGB24" or imgTypeString == "RGB24":
            imgType = casi.ASI_IMG_RGB24
        else:
            raise ASIException("Unknown image type '{}', must be one of ASI_IMG_RAW8, RAW8, ASI_IMG_Y8, Y8, ASI_IMG_RAW16, RAW16, ASI_IMG_RGB24, RGB24".format(imgTypeString))

        err = casi.ASISetROIFormat(self.m_cameraId, width, height, binning, imgType)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to set capture frame information, error is {}".format(getASIErrorString(err)))

        return self.getCaptureFrameFormat()

    def getCaptureFrameFormat(self):
        cdef int width, height, binning
        cdef casi.ASI_IMG_TYPE imgType
        cdef casi.ASI_ERROR_CODE err

        err = casi.ASIGetROIFormat(self.m_cameraId, &width, &height, &binning, &imgType)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to get capture frame information, error is {}".format(getASIErrorString(err)))

        obj = {
            "width": width,
            "height": height,
            "binning": binning,
            "type": getImageFormatString(imgType)
        }
        return obj

    def grab(self, int singleExposureTimeMicroSeconds, int repetitions = 1):

        returnFrame = None
        binning = None
        imgTypeStr = None
        for i in range(repetitions):
            f, binning, imgTypeStr = self._grabSingle(singleExposureTimeMicroSeconds)
            if returnFrame is None:
                returnFrame = f
            else:
                returnFrame += f

        return (returnFrame, binning, imgTypeStr)

    def _grabSingle(self, int exposureTimeMicroSeconds):
        cdef int width, height, binning, bytesPerPixel
        cdef casi.ASI_IMG_TYPE imgType
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_EXPOSURE_STATUS expStatus
        cdef vector[unsigned char] buf

        err = casi.ASIGetROIFormat(self.m_cameraId, &width, &height, &binning, &imgType)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to get capture frame information, error is {}".format(getASIErrorString(err)))

        if imgType == casi.ASI_IMG_RAW8 or imgType == casi.ASI_IMG_Y8:
            bytesPerPixel = 1
        elif imgType == casi.ASI_IMG_RAW16:
            bytesPerPixel = 2
        elif imgType == casi.ASI_IMG_RGB24:
            bytesPerPixel = 3
        else:
            raise ASIException("Unhandled image type {}".format(getImageFormatString(imgType)))

        err = casi.ASISetControlValue(self.m_cameraId, casi.ASI_EXPOSURE, <long>exposureTimeMicroSeconds, casi.ASI_FALSE)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to set exposure time, error is {}".format(getASIErrorString(err)))

        err = casi.ASIStartExposure(self.m_cameraId, casi.ASI_FALSE)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable start exposure, error is {}".format(getASIErrorString(err)))

        try:
            time.sleep(0.010)
            while True:
                err = casi.ASIGetExpStatus(self.m_cameraId, &expStatus)
                if err != casi.ASI_SUCCESS:
                    raise ASIException("Unable get exposure status, error is {}".format(getASIErrorString(err)))
    
                if expStatus != casi.ASI_EXP_WORKING:
                    break

            if expStatus != casi.ASI_EXP_SUCCESS:
                raise ASIException("Exposure seems to have failed")

            buf.resize(width*height*bytesPerPixel)
            err = casi.ASIGetDataAfterExp(self.m_cameraId, &buf[0], buf.size())
            if err != casi.ASI_SUCCESS:
                raise ASIException("Unable get data after exposure, error is {}".format(getASIErrorString(err)))

            bufBytes = <bytes>(&buf[0])[:buf.size()]

            if bytesPerPixel == 1:
                npBuffer = np.frombuffer(bufBytes, np.uint8)
                npBuffer = npBuffer.reshape((height, width)).astype(np.double)
            elif bytesPerPixel == 2:
                npBuffer = np.frombuffer(bufBytes, np.uint16)
                npBuffer = npBuffer.reshape((height, width)).astype(np.double)
            elif bytesPerPixel == 3:
                npBuffer = np.frombuffer(bufBytes, np.uint8)
                npBuffer = npBuffer.reshape((height, width, 3)).astype(np.double)
                self._swapRGB(npBuffer)
            else:
                raise ASIException("Internal error: unexpected number of bytes per pixel ({})".format(bytesPerPixel))
            
            return (npBuffer, binning, getImageFormatString(imgType))
        finally:
            casi.ASIStopExposure(self.m_cameraId)


    def getControlValue(self, controlTypeString):
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_CONTROL_TYPE ctrl
        cdef long lval
        cdef casi.ASI_BOOL bval

        self._checkControls()

        if not controlTypeString in self.m_controls:
            allowedControlTypes = [ n for n in self.m_controls ]
            raise ASIException("Control '{}' is not known or not supported by the camera, allowed are {}".format(controlTypeString, allowedControlTypes))

        ctrl = getControlTypeFromString(controlTypeString)
        err = casi.ASIGetControlValue(self.m_cameraId, ctrl, &lval, &bval)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable get settings for control '{}', error is {}".format(controlTypeString, getASIErrorString(err)))

        obj = {
            "value": lval,
            "auto": True if bval == casi.ASI_TRUE else False
        }
        return obj

    def setControlValueManual(self, controlTypeString, long value):
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_CONTROL_TYPE ctrl
        cdef casi.ASI_BOOL bval

        self._checkControls()
        if not controlTypeString in self.m_controls:
            allowedControlTypes = [ n for n in self.m_controls ]
            raise ASIException("Control '{}' is not known or not supported by the camera, allowed are {}".format(controlTypeString, allowedControlTypes))

        ctrl = getControlTypeFromString(controlTypeString)

        caps = self.m_controls[controlTypeString]
        if not caps["IsWritable"]:
            raise ASIException("Control '{}' is not writable")

        if value > caps["MaxValue"] or value < caps["MinValue"]:
            raise ASIException("Specified value is not in bounds {}".format([caps["MinValue"], caps["MaxValue"]]))

        err = casi.ASISetControlValue(self.m_cameraId, ctrl, value, casi.ASI_FALSE)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to set control value, error is {}".format(getASIErrorString(err)))

        return self.getControlValue(controlTypeString)

    def setControlValueAuto(self, controlTypeString):
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_CONTROL_TYPE ctrl
        cdef long currentValue

        # From SDK manual
        # Notes：when setting to auto adjust(bAuto=ASI_TRUE)，the lValue should be the current value
        ret = self.getControlValue(controlTypeString)
        currentValue = ret["value"]

        ctrl = getControlTypeFromString(controlTypeString)

        caps = self.m_controls[controlTypeString]
        if not caps["IsWritable"]:
            raise ASIException("Control '{}' is not writable")

        if not caps["IsAutoSupported"]:
            raise ASIException("Control '{}' does not support auto setting")

        err = casi.ASISetControlValue(self.m_cameraId, ctrl, currentValue, casi.ASI_TRUE)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to set control value, error is {}".format(getASIErrorString(err)))

        return self.getControlValue(controlTypeString)

    @staticmethod
    def _swapRGB(f):
        tmp = f.copy()
        f[:,:,0] = tmp[:,:,2]
        f[:,:,2] = tmp[:,:,0]

    def recordVideoFrames(self, int exposureTimeMicroSeconds, maxFrames = 25, maxRecordTime = None, sumFrames = False):
        cdef int width, height, binning, bytesPerPixel, waitMs
        cdef casi.ASI_IMG_TYPE imgType
        cdef casi.ASI_ERROR_CODE err
        cdef casi.ASI_EXPOSURE_STATUS expStatus
        cdef vector[unsigned char] buf

        err = casi.ASIGetROIFormat(self.m_cameraId, &width, &height, &binning, &imgType)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to get capture frame information, error is {}".format(getASIErrorString(err)))

        if imgType == casi.ASI_IMG_RAW8 or imgType == casi.ASI_IMG_Y8:
            bytesPerPixel = 1
        elif imgType == casi.ASI_IMG_RAW16:
            bytesPerPixel = 2
        elif imgType == casi.ASI_IMG_RGB24:
            bytesPerPixel = 3
        else:
            raise ASIException("Unhandled image type {}".format(getImageFormatString(imgType)))

        err = casi.ASISetControlValue(self.m_cameraId, casi.ASI_EXPOSURE, <long>exposureTimeMicroSeconds, casi.ASI_FALSE)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to set exposure time, error is {}".format(getASIErrorString(err)))

        err = casi.ASIStartVideoCapture(self.m_cameraId)
        if err != casi.ASI_SUCCESS:
            raise ASIException("Unable to start video capture, error is {}".format(getASIErrorString(err)))
        
        # TODO: this will not be correct if there are clock jumps
        startTime = time.time()

        frames = [ ]
        summedFrame = None
        count = 0
        try:
            buf.resize(width*height*bytesPerPixel)
            waitMs = (exposureTimeMicroSeconds/1000)*2 + 500

            while True:
                if maxRecordTime is not None and time.time()-startTime >= maxRecordTime:
                    break

                err = casi.ASIGetVideoData(self.m_cameraId, &buf[0], buf.size(), waitMs)
                if err != casi.ASI_SUCCESS:
                    raise ASIException("Unable to get video frame data, error is {}".format(getASIErrorString(err)))

                bufBytes = <bytes>(&buf[0])[:buf.size()]

                if bytesPerPixel == 1:
                    npBuffer = np.frombuffer(bufBytes, np.uint8)
                    npBuffer = npBuffer.reshape((height, width)).astype(np.double)
                elif bytesPerPixel == 2:
                    npBuffer = np.frombuffer(bufBytes, np.uint16)
                    npBuffer = npBuffer.reshape((height, width)).astype(np.double)
                elif bytesPerPixel == 3:
                    npBuffer = np.frombuffer(bufBytes, np.uint8)
                    npBuffer = npBuffer.reshape((height, width, 3)).astype(np.double)
                else:
                    raise ASIException("Internal error: unexpected number of bytes per pixel ({})".format(bytesPerPixel))

                if sumFrames:
                    if summedFrame is None:
                        summedFrame = npBuffer
                    else:
                        summedFrame += npBuffer
                else:
                    frames.append(npBuffer)

                count += 1
                if count >= maxFrames:
                    break

            if sumFrames:
                if bytesPerPixel == 3:
                    self._swapRGB(summedFrame)
                return (summedFrame, binning, getImageFormatString(imgType))
            else:
                if bytesPerPixel == 3:
                    for f in frames:
                        self._swapRGB(f)
                return (frames, binning, getImageFormatString(imgType))
        finally:
            casi.ASIStopVideoCapture(self.m_cameraId)


def getConnectedCameras():
    cdef int nDev, i
    nDev = casi.ASIGetNumOfConnectedCameras()

    cameras = { }
    for i in range(nDev):
        cameras[i] = _getCameraInfo(i)

    return cameras

