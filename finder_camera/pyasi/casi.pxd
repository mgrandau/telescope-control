
cdef extern from "ASICamera2.h":

    cdef enum ASI_BOOL:
        ASI_FALSE,
        ASI_TRUE

    cdef enum ASI_BAYER_PATTERN:
        ASI_BAYER_RG,
        ASI_BAYER_BG,
        ASI_BAYER_GR,
        ASI_BAYER_GB

    cdef enum ASI_IMG_TYPE:
        ASI_IMG_RAW8,
        ASI_IMG_RGB24,
        ASI_IMG_RAW16,
        ASI_IMG_Y8,
        ASI_IMG_END

    cdef enum ASI_EXPOSURE_STATUS:
        ASI_EXP_IDLE,
        ASI_EXP_WORKING,
        ASI_EXP_SUCCESS,
        ASI_EXP_FAILED

    cdef enum ASI_ERROR_CODE:
        ASI_SUCCESS,
        ASI_ERROR_INVALID_INDEX,# //no camera connected or index value out of boundary
        ASI_ERROR_INVALID_ID,# //invalid ID
        ASI_ERROR_INVALID_CONTROL_TYPE, #//invalid control type
        ASI_ERROR_CAMERA_CLOSED, #//camera didn't open
        ASI_ERROR_CAMERA_REMOVED, #//failed to find the camera, maybe the camera has been removed
        ASI_ERROR_INVALID_PATH, #//cannot find the path of the file
        ASI_ERROR_INVALID_FILEFORMAT, #
        ASI_ERROR_INVALID_SIZE, #//wrong video format size
        ASI_ERROR_INVALID_IMGTYPE, #//unsupported image formate
        ASI_ERROR_OUTOF_BOUNDARY, #//the startpos is out of boundary
        ASI_ERROR_TIMEOUT, #//timeout
        ASI_ERROR_INVALID_SEQUENCE,#//stop capture first
        ASI_ERROR_BUFFER_TOO_SMALL, #//buffer size is not big enough
        ASI_ERROR_VIDEO_MODE_ACTIVE,
        ASI_ERROR_EXPOSURE_IN_PROGRESS,
        ASI_ERROR_GENERAL_ERROR,#//general error, eg: value is out of valid range
        ASI_ERROR_END

    cdef enum ASI_CONTROL_TYPE:
        ASI_GAIN,
        ASI_EXPOSURE,
        ASI_GAMMA,
        ASI_WB_R,
        ASI_WB_B,
        ASI_OFFSET,
        ASI_BANDWIDTHOVERLOAD,	
        ASI_OVERCLOCK,
        ASI_TEMPERATURE,
        ASI_FLIP,
        ASI_AUTO_MAX_GAIN,
        ASI_AUTO_MAX_EXP,
        ASI_AUTO_MAX_BRIGHTNESS,
        ASI_HARDWARE_BIN,
        ASI_HIGH_SPEED_MODE,
        ASI_COOLER_POWER_PERC,
        ASI_TARGET_TEMP,
        ASI_COOLER_ON,
        ASI_MONO_BIN,
        ASI_FAN_ON,
        ASI_PATTERN_ADJUST,
        ASI_ANTI_DEW_HEATER

    ctypedef struct ASI_CONTROL_CAPS:
        char Name[64],
        char Description[128],
        long MaxValue,
        long MinValue,
        long DefaultValue,
        ASI_BOOL IsAutoSupported,
        ASI_BOOL IsWritable,
        ASI_CONTROL_TYPE ControlType,
        char Unused[32]

    ctypedef struct ASI_CAMERA_INFO:
        char Name[64],
        int CameraID,
        long MaxHeight,
        long MaxWidth,
        ASI_BOOL IsColorCam,
        ASI_BAYER_PATTERN BayerPattern,
        int SupportedBins[16],
        ASI_IMG_TYPE SupportedVideoFormat[8],
        double PixelSize,
        ASI_BOOL MechanicalShutter,
        ASI_BOOL ST4Port,
        ASI_BOOL IsCoolerCam,
        ASI_BOOL IsUSB3Host,
        ASI_BOOL IsUSB3Camera,
        float ElecPerADU,
        char Unused[24]

    int ASIGetNumOfConnectedCameras()
    ASI_ERROR_CODE ASIGetCameraProperty(ASI_CAMERA_INFO *pASICameraInfo, int iCameraIndex)
    ASI_ERROR_CODE ASIOpenCamera(int iCameraID)
    ASI_ERROR_CODE ASIInitCamera(int iCameraID)
    ASI_ERROR_CODE ASICloseCamera(int iCameraID)

    ASI_ERROR_CODE ASIGetNumOfControls(int camId, int *pNum)
    ASI_ERROR_CODE ASIGetControlCaps(int iCameraID, int iControlIndex, ASI_CONTROL_CAPS * pControlCaps)
    ASI_ERROR_CODE ASIGetControlValue(int iCameraID, ASI_CONTROL_TYPE ControlType, long *plValue, ASI_BOOL *pbAuto)
    ASI_ERROR_CODE ASISetControlValue(int iCameraID, ASI_CONTROL_TYPE ControlType, long lValue, ASI_BOOL bAuto)
    ASI_ERROR_CODE ASISetROIFormat(int iCameraID, int iWidth, int iHeight, int iBin, ASI_IMG_TYPE Img_type)
    ASI_ERROR_CODE ASIGetROIFormat(int iCameraID, int *piWidth, int *piHeight, int *piBin, ASI_IMG_TYPE *pImg_type)
    ASI_ERROR_CODE ASIStartExposure(int iCameraID, ASI_BOOL bIsDark)
    ASI_ERROR_CODE ASIStopExposure(int iCameraID)
    ASI_ERROR_CODE ASIGetExpStatus(int iCameraID, ASI_EXPOSURE_STATUS *pExpStatus)
    ASI_ERROR_CODE ASIGetDataAfterExp(int iCameraID, unsigned char* pBuffer, long lBuffSize)

    ASI_ERROR_CODE ASIStartVideoCapture(int iCameraID)
    ASI_ERROR_CODE ASIStopVideoCapture(int iCameraID)
    ASI_ERROR_CODE ASIGetVideoData(int iCameraID, unsigned char* pBuffer, long lBuffSize, int iWaitms)



