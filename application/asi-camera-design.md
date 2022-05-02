# ZwoAsiCamera

Class structure directly associated with the ZWO ASI Camera.

```mermaid
classDiagram
  direction TB

  IImageAcquisitionBehavior <|-- ZwoAsiCamera

  ZwoAsiCamera "1" --> "*" IPostProcessingBehavior
  ZwoAsiCamera "1" --> "1" ZwoAsiCameraDataRepository
  ZwoAsiCamera "1" --> "1" IImageAcquisitionBehaviorLogger


  class IImageAcquisitionBehavior{
    + bytes get_processed_frame_as_jpg()
  }

  class IImageAcquisitionBehaviorLogger{
    + void log_frame_acquisition(info: string)
    + void log_frame_acquisition_wait(info: string)
    + void log_post_processor_run(info: string)
  }

  class ZwoAsiCameraDataRepository{
    - _configuration:Dict~str,Any~

    + ZwoAsiCameraDataRepository(configuration:Dict~str,Any~)

    + Dict< str, Any > current_state()
    + Dict< str, Any > default_configuration()
  }

  class ZwoAsiCamera {
    - _repository: ZwoAsiCameraDataRepository
    - _automatically_run_post_processing_behaviors : List~IPostProcessingBehavior~
    - _logger : IImageAcquisitionBehaviorLogger
    - _last_image: cv2.Mat

    + ZwoAsiCamera(configuration:Dict~str,Any~, automatically_run_post_processing_behaviors : List~IPostProcessingBehavior~, logger: IImageAcquisitionBehaviorLogger)

    + Dict< str, Any > current_state()
    + Dict< str, Any > default_configuration()

    + bytes get_processed_frame_as_jpg()
  }

  class IPostProcessingBehavior{
    + cv2.Mat process_image(image : cv2.Mat)
  }
```

Classes associated with the ZWO ASI Camera that can be used to optionally extend the functionality of the ZWO ASI Camera.

```mermaid
classDiagram
  direction TB

  IImageAcquisitionBehavior <|-- ZwoAsiCamera

  ZwoAsiCamera "1" --> "*" IPostProcessingBehavior

  IPostProcessingBehavior <|-- SaveDark
  SaveDark "1" --> "1" LastImageAsFits : _storage_format
  IPostProcessingBehavior <|-- SaveBias
  SaveBias "1" --> "1" LastImageAsFits : _storage_format
  IPostProcessingBehavior <|-- SaveFlat
  SaveFlat "1" --> "1" LastImageAsFits : _storage_format
  IPostProcessingBehavior <|-- StoreInDataLake
  StoreInDataLake "1" --> "1" LastImageAsFits : _storage_format
  IPostProcessingBehavior <|-- LastImageAsFits
  IPostProcessingBehavior <|-- ApplyOverlay
  IPostProcessingBehavior <|-- CorrectImage

  class IImageAcquisitionBehavior{
    + bytes get_processed_frame_as_jpg()
  }

  class ZwoAsiCamera {
    - _repository: ZwoAsiCameraDataRepository
    - _automatically_run_post_processing_behaviors : List~IPostProcessingBehavior~
    - _logger : IImageAcquisitionBehaviorLogger
    - _last_image: cv2.Mat
    
    + ZwoAsiCamera(configuration:Dict~str,Any~, automatically_run_post_processing_behaviors : List~IPostProcessingBehavior~, logger: IImageAcquisitionBehaviorLogger)

    + Dict< str, Any >  current_state()
    + Dict< str, Any >  default_configuration()

    + bytes get_processed_frame_as_jpg()
  }

  class IPostProcessingBehavior{
    + cv2.Mat process_image(image : cv2.Mat)
  }

  class ApplyOverlay{
    + cv2.Mat process_image(image : cv2.Mat)
  }

  class StoreInDataLake{
    + cv2.Mat process_image(image : cv2.Mat)
  }

  class LastImageAsFits{
    + cv2.Mat process_image(image : cv2.Mat)
  }

  class SaveDark{
    + cv2.Mat process_image(image : cv2.Mat)
  }

  class SaveBias{
    + cv2.Mat process_image(image : cv2.Mat)
  }

  class SaveFlat{
    + cv2.Mat process_image(image : cv2.Mat)
  }
```

## Camera Initialization

This section goes through the recommended sequence of steps to initialize a camera instance assuming no other camera is running on the same port.

```mermaid
sequenceDiagram
  participant App
  participant ZwoAsiCamera
  participant PostProcessingBehaviors

  App->>PostProcessingBehaviors: Create List<IPostProcessingBehavior> of automatically run image processing behaviors the camera should run

  App->>ZwoAsiCamera: ZwoAsiCamera(configuration:Dict<str,Any>, automatically_run_post_processing_behaviors : List<IPostProcessingBehavior>)

  loop video_stream
    App->>ZwoAsiCamera: get_processed_frame_as_jpg()
  end
```

### Change Camera Settings

A configuration based approach assumes that settings are not directly modified by the user, once the camera instance is created. The settings may be indirectly modified by the user through operating a function. To apply new settings you create a new instance of the camera and replace the existing instance of the camera (see sequence diagram below).

```mermaid
sequenceDiagram
  participant App
  participant List_of_Automatically_Run_PostProcessingBehaviors
  participant New_Camera
  participant Current_Running_Camera

  loop video_stream
    App->>Current_Running_Camera:get_processed_frame_as_jpg()
  end

  App->>List_of_Automatically_Run_PostProcessingBehaviors: Initialize list of automatically run image processing behaviors the camera should have
  App->>New_Camera: ZwoAsiCamera(configuration:Dict<str,Any>, automatically_run_post_processing_behaviors : List<IPostProcessingBehavior>)

  loop video_stream
    App->>New_Camera: get_processed_frame_as_jpg()
  end

  App->>Current_Running_Camera: delete or cache for future use
```

It is then up to the application to decide to release what was the currently running camera or hold it for later use.

#### Positives of this approach

1. Smaller interface footprint. This helps in keeping the interfaces more stable. This has a direct impact on automated testing.
2. Less issues with intermediary transitions of the settings. This has an impact on special coding checks and automated testing. Less chance of getting into an unexpected state because of issues like assertions.
3. Since changing settings is about bringing a new camera instance into existence, you are also insuring the currently running camera can be halted so the new camera instance can be started. This has an impact in automated testing.

#### Negatives of this approach

1. You must reinitialize a new camera instance to apply new settings. If initialization takes a degree of time, you may want to have a cache of cameras with the various settings and just switch the camera to change the active one. This is similar to multiple buffering of screen buffers used in traditional graphics programming. The classic trade-off of memory vs performance.
2. Because injection of things like post processing behaviors are typically part of the initialization, variations in the post processing behavior requires initialization of a new camera instance.

### Typical Image Processing Flow

This sequence describes a typical image processing flow.  The camera is initialized with a frame rate. The primary purpose of the framerate is to keep a camera from reporting at a faster rate then the one specified, thus controlling the process load on the CPU. A typical framerate of 22 fps appears as realtime to the user.

It is important to note the post processing performance can drive the rate slower. If you need to get it to run at the specified rate you should consider writing the post processor to run asynchronously and prevent running the handler multiple times at once.

The camera will have a last image object that changes only after the entire processing sequence is run. To see intermediate images in the processing sequence have an automated processor export it out.

```mermaid
sequenceDiagram
  participant App
  participant ZwoAsiCamera
  participant AutomaticPostProcessingBehavior

  App->>List_of_Automatically_Run_PostProcessingBehaviors: Initialize list of automatically run image processing behaviors the camera should have
  App->>ZwoAsiCamera: ZwoAsiCamera(configuration:Dict<str,Any>, automatically_run_post_processing_behaviors : List<IPostProcessingBehavior>)

  loop get frames from camera
    
    App->>ZwoAsiCamera: get_processed_frame_as_jpg()

    alt if time to get new frame based on specified framerate
      ZwoAsiCamera->>ZwoAsiCamera: acquire frame from ZWO ASI Camera API
      loop through automatic post processing
        ZwoAsiCamera->>List_of_Automatically_Run_PostProcessingBehaviors: get next post processing behavior

        List_of_Automatically_Run_PostProcessingBehaviors-->>ZwoAsiCamera: return post processing behavior
        
        ZwoAsiCamera->>AutomaticPostProcessingBehavior: process_image(_last_image)
        
        AutomaticPostProcessingBehavior-->>ZwoAsiCamera: update _last_image
      end
    else else
      ZwoAsiCamera->>ZwoAsiCamera: sleep for remainder of time
    end

  end
```
