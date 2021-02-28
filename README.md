# BroadcastWriter
Simple wrapper for `AVFoundation` `AVAssetWriter`; for writing asset during Broadcast Extension activity

Usage:

1. Add `Broadcast Extension` target
2. Use Swift Package Manager to add dependency to your `Broadcast Extension` target
3. Add `App Groups` capability into main and `Broadcast Extension` targets
4. Call appropriate methods in your `RPBroadcastSampleHandler` instance in `Broadcast Extension` target (see Example project in repo)
5. When `BroadcastWriter` finished, don't forget to move Broadcast Writer output file to your AppGroup container directory, to have access from main target, see [Example](https://github.com/romiroma/BroadcastWriter/blob/75a0b43bd0d17521a2226aed77d43654b921db01/BroadcastUpload/SampleHandler.swift#L73-L113) 
6. Pay Attention to use your own `App Group` identifiers when using `Example` project

![IMG_AD267582BFF1-1](https://user-images.githubusercontent.com/25149401/109422414-182c6880-79e4-11eb-8a47-422e71345191.jpeg)
