# GfyCat-Video-to-WEBM-gfy-Uploader
Allows for iPhone users to convert video from their photo library or cloud drives to a full-bitrate/lossless HD gif in gfy format

How this is done:
In order to get the highest quality gifs, the gfy format is preferred, using gfycat.com as a hosting site. Although uploading videos directly from the iPhone to gfycat already works, when a video file is submitted on gfycat the site automatically compresses the video to a smaller size, and then converts it into multiple formats internally for its own hosting. This can be avoided, however, by first converting the video to a .WEBM file format.

When a .webm file is uploaded to gfycat, the site recognizes that it's already in the correct video format, and skips the video compression before encoding it to the .gif, .gifv, and .mp4 formats. This means that when viewing the full webm link on gfycat, it will be 100% of the video quality--the same as the original source video. These videos can also be uploaded in 60fps if desired.

This app provides the full video to .webm conversion done through either the hardware-accellerated conversion process (doesn't need internet connection) or by using the file conversion services through https://www.online-convert.com/ using their APIs, and then redirected to the gfycat API for the file upload.

This app also allows the user to edit the video duration and choose the desired section of the video to create a gif from.

Maximum file upload size: 100MB
Maximum video clip duration: 50s

Supported file import formats:
  - .mp4
  - .mov
  - .MPEG-4
  - .avi
  - .gif
  
File output formats:
  - .gif
  - .webm (highest quality/lossless, not supported by iOS natively--use the VLC app to view)
  - .mp4
  - .mov

- Video import options - supports the following sources:
  - Built-in web browser (prompt for download when valid video is tapped)
  - Camera roll/internal photo albums
  - iCloud Drive
  - Google Drive
  - Mega.nz
  - Dropbox
  - OneDrive
  
