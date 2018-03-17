//
//  FirstViewController.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/14/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit
import AVKit
import CoreVideo
import Alamofire

private var uploadVC: UploadViewController?

/// FirstViewController displays the view controller allowing the user to select and upload
/// media to http://online-convert.com/ through the use of their photo library or cloud drive(s)
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    @IBOutlet var mainView: UILabel!
    @IBOutlet var selectFileBtn: UIButton!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var convertVideoBtn: UIButton!
    
    @objc var TAG = NSStringFromClass(classForCoder()).components(separatedBy: ".").last! as String
    
    var vidPlayerItem: AVPlayerItem!
    var vidPlayer: AVPlayer!
    var selectedImg: UIImage!
    var playBtn: UIButton!
    var selectedImgFrame: CGRect!
    var selectedVideoURL: URL!
    var selectedImgURL: URL!
    var errMsg: String!
    
    static var instance: UploadViewController {
        guard let vc2 = uploadVC else { fatalError() }
        return vc2
    }
    
    /// Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImgView()
        configureScrollView()
        configureBtns()
        configureTabBarExtras()
    }
    
    /// Configures the tab bar view customizations when the upload view is being loaded
    ///
    /// - Returns: The updated tab bar, if present
    @discardableResult func configureTabBarExtras() -> UITabBar! {
        let tmpBtn = UIButton(type: .custom)
        tmpBtn.backgroundColor = .white
        tmpBtn.isOpaque = true
        
        if let tabBar = self.tabBarController?.tabBar {
            let btnImg = UIImage(named: "Image")!   // TODO - change to a constant and make sure image is part of build target
            
            tmpBtn.frame = CGRect(
                x: 0,
                y: 0,
                width: btnImg.size.width + 20,
                height: btnImg.size.height - 10
            )
            
            tmpBtn.setBackgroundImage(
                btnImg,
                for: .normal
            )
            
            let heightDifference = btnImg.size.height - tabBar.frame.size.height
            
            if heightDifference < 0 {
                tmpBtn.center = tabBar.center
            } else {
                var center = tabBar.center
                center.y -= heightDifference / 2.0
                tmpBtn.center = center
            }
            
            self.view.addSubview(tmpBtn)
            self.view.layoutIfNeeded()
        }
        
        return super.tabBarController?.tabBar
    }
    
    
    /// Configures the scroll view preferences after initialization
    ///
    /// - Returns: The custom scroll view
    @discardableResult func configureScrollView() -> UIScrollView! {
        if self.scrollView == nil {
            self.scrollView = UIScrollView()
            self.scrollView.addSubview(self.imgView == nil ? configureImgView() : self.imgView)
        }
        
        if self.scrollView.delegate == nil {
            self.scrollView.delegate = self
        }
        
        self.scrollView.minimumZoomScale = ViewConstants.defaultMinZoomScale
        self.scrollView.maximumZoomScale = ViewConstants.defaultMaxZoomScale
        self.scrollView.contentMode = .scaleToFill
        
        return self.scrollView
    }
    
    
    /// Configures the image view preferences after initialization
    ///
    /// - Returns: The custom image view
    @discardableResult func configureImgView() -> UIImageView! {
        if self.imgView == nil {
            self.imgView = UIImageView()
            self.selectedImg = nil
            self.imgView.autoresizesSubviews = true
            self.imgView.sizeToFit()
        }
        
        self.imgView.contentMode = .scaleAspectFill
        self.imgView.semanticContentAttribute = .playback
        
        updateImgView()
        
        return self.imgView
    }
    
    
    /// Configures the UI attributes of the buttons
    func configureBtns() -> Void {
        self.playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.playBtn.setTitle("Play", for: .normal)
        self.playBtn.isHidden = true
        self.playBtn.isEnabled = false
        self.selectFileBtn.isHidden = false
        self.selectFileBtn.isEnabled = true
        self.uploadBtn.isHidden = true
        self.uploadBtn.isEnabled = false
    }
    
    
    /// Assigns the specified view to be the primary view in which the
    /// user can use gestures to zoom in/out
    ///
    /// - Parameter scrollView: The scroll view in which to apply the
    ///                         scrolling functionality within the scroll view
    /// - Returns: The appropriate view to be zoomed in/out
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    
    /// Updates and resizes the image view container upon changes
    /// to the selected image file
    func updateImgView() -> Void {
        var tmpImgContainerView = UIView(frame: ViewConstants.defaultContainerRect)
        
        if self.selectedImg != nil {
            if self.imgView.image != nil {
                if let tmpImg = self.selectedImg {
                    if self.selectedImg != tmpImg {
                        #if DEBUG
                            NSLog("[\(self.TAG)] New image selected.\nApplying changes...")
                        #endif
                        self.selectedImg = tmpImg
                    } else {
                        #if DEBUG
                            NSLog("[\(self.TAG)] Same image selected as previously assigned")
                        #endif
                    }
                }
            } else {
                #if DEBUG
                    NSLog("[\(self.TAG)] Resizing image container for the selected image: image \"\(self.selectedImg)\"")
                #endif
                tmpImgContainerView = UIView(
                    frame: CGRect(
                        x: ViewConstants.defaultContainerRect.origin.x,
                        y: ViewConstants.defaultContainerRect.origin.y,
                        width: self.selectedImg.size.width,
                        height: self.selectedImg.size.height
                    )
                )
                
                self.imgView.frame.size = tmpImgContainerView.frame.size
            }
        }
        
        #if DEBUG
            NSLog("[\(self.TAG)] Applying UIImageView size/aspect ratio changes if needed...")
        #endif
        
        // configure and apply new image view height maintaining the correct ratio
        if let tmpImg = self.selectedImg {
            let imgRatio = tmpImg.size.width / tmpImg.size.height
            
            if tmpImgContainerView.frame.width > tmpImgContainerView.frame.height {
                let tmpHeight = tmpImgContainerView.frame.width / imgRatio
                #if DEBUG
                    NSLog("[\(self.TAG)] Adjusting image view rect width to fit image ratio...")
                #endif
                self.imgView.frame.size = CGSize(
                    width: tmpImgContainerView.frame.width,
                    height: tmpHeight
                )
            } else {
                let tmpWidth = tmpImgContainerView.frame.height * imgRatio
                
                #if DEBUG
                    NSLog("[\(self.TAG)] Adjusting image view rect height to fit image ratio...")
                #endif
                self.imgView.frame.size = CGSize(
                    width: tmpWidth,
                    height: tmpImgContainerView.frame.height
                )
            }
            
            self.selectedImg = tmpImg
        } else {
            self.errMsg = "No valid media found to display" //"ERROR: Unable to assign image to selection"
        }
        
        if self.errMsg.count > 0 && !self.errMsg.isEmpty {
            #if DEBUG
                NSLog("[\(self.TAG)] \(self.errMsg!)")
                NSLog("[\(self.TAG)] Skipping procedure")
            #endif
        }
        
        #if DEBUG
            NSLog("[\(self.TAG)] Resizing image view frame...")
        #endif
        self.imgView.frame.size = tmpImgContainerView.frame.size
        #if DEBUG
            NSLog("[\(self.TAG)] Image frame size changes applied successfully")
            NSLog("[\(self.TAG)] Reloading input views...")
        #endif
        self.imgView.reloadInputViews()
        #if DEBUG
            NSLog("[\(self.TAG)] Image view changes applied successfully")
        #endif
    }
    
    
    /// Assigns the ImageView image to the specified image as long as the
    /// image file selected by the user is not null and is a valid image type
    ///
    /// - Parameter newImg: The image selected by the user to display
    /// - Returns: True if the operation was successful, else false
    func setImgViewImg(withUIImage newImg: UIImage!) -> Bool {
        var success = false
        
        if let tmpImg: UIImage = newImg {
            success = (
                !(tmpImg.ciImage == nil && tmpImg.cgImage == nil)
                    && (tmpImg.accessibilityIdentifier != nil && !(String(describing: tmpImg)).isEmpty)
            )
        } else {
            if self.selectedImg != nil {
                return setImgViewImg(withIdentifier: newImg.accessibilityIdentifier)
            }
        }
        
        if !success {
            let pErr: String! = !self.errMsg.isEmpty ? self.errMsg : (
                """
                [\(self.TAG)] ERROR: Unable to locate and assign image to the
                file named: \"\(String(describing: newImg.accessibilityIdentifier))\"
                """
                ) as String
            NSLog(pErr)
            #if DEBUG
                NSLog("[\(self.TAG)] Skipping procedure")
            #endif
        }
        
        return success
    }
    
    func setImgViewImg(withIdentifier newImgIdentifier: String!) -> Bool {
        var success: Bool!
        
        if let tmpIdentifier: String = newImgIdentifier {
            success = !tmpIdentifier.isEmpty && tmpIdentifier.count > 0
        } else {
            self.errMsg = (
                """
                ERROR: Unable to locate and assign image to the
                file named: \"\(newImgIdentifier)\"
                """
            )
        }
        
        return success
    }
    
    @IBAction func selectFileBtnPressed(_ sender: Any) {
        #if DEBUG
            NSLog("[\(self.TAG)] \(TagConstants.buttonPressed) --> \nUIButton: {\n\t\"Type\": \"UIButton\",\n\t\"Name\": \"selectFileBtn\",\n\t\"Instance\": {\n\t\t\(String(describing: sender).replacingOccurrences(of: "; ", with: ",\n").debugDescription)\n\t}\n}\n")
        #endif
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.videoExportPreset = AVAssetExportPresetHighestQuality
        pickerController.videoMaximumDuration = 50      // in seconds
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [ "public.movie", "public.video" ]    // disable image combination for now--only upload gfy files for mov or mp4 files
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        #if DEBUG
            NSLog("[\(self.TAG)] \(TagConstants.buttonPressed) --> Name: \"uploadBtn\"")
        #endif
        
        sendImgUploadRequest()
    }
    
    
    
    @IBAction func convertVideoBtnPressed(_ sender: Any) {
        #if DEBUG
            NSLog("[\(self.TAG)] \(TagConstants.buttonPressed) --> Name: \"convertVideoBtn\"")
        #endif
        
        if let tmpCvtBtn = self.convertVideoBtn {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.uploadBtn.isHidden = false
        self.uploadBtn.isEnabled = true
        self.selectFileBtn.isHidden = true
        self.selectFileBtn.isEnabled = false
        
        // determine media type
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            switch mediaType {
            case SupportedMediaTypes.image:
                if let tmpImg = info[UIImagePickerControllerMediaType] as? UIImage {
                    if tmpImg.size.height > tmpImg.size.width {
                        self.imgView.frame = CGRect(
                            origin: ViewConstants.defaultContainerRect.origin,
                            size: CGSize(
                                width: self.imgView.frame.height,
                                height: self.imgView.frame.width
                            )
                        )
                    }
                    
                    self.selectedImg = tmpImg
                    
                    if let tmpImg = self.selectedImg {
                        #if DEBUG
                            NSLog("[\(self.TAG)] Applying image selection...")
                        #endif
                        self.imgView.image = tmpImg
                        #if DEBUG
                            NSLog("[\(self.TAG)] Image selected successfully")
                            NSLog("[\(self.TAG)] Searching for special image frame size/ratio specifications...")
                        #endif
                        if let tmpImgFrame = self.selectedImgFrame {
                            #if DEBUG
                                NSLog("[\(self.TAG)] Specifications found.\nApplying frame for selected image")
                            #endif
                            self.imgView.frame = tmpImgFrame
                            #if DEBUG
                                NSLog("[\(self.TAG)] Specifications applied successfully")
                            #endif
                        }
                    }
                    
                    self.imgView.reloadInputViews()
                }
            case SupportedMediaTypes.video:
                let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                #if DEBUG
                    NSLog("[\(self.TAG)] Video file selected at location: \"%@\"", videoURL.absoluteString)
                #endif
                self.selectedVideoURL = videoURL
                
                self.vidPlayerItem = nil
                self.vidPlayer = nil
                self.selectedImg = nil
                self.selectedVideoURL = nil
                self.selectedImgFrame = nil
                
                if !videoURL.relativeString.isEmpty {
                    #if DEBUG
                        NSLog("[\(self.TAG)] Initializing video player item with the selected file...")
                    #endif
                    self.vidPlayerItem = AVPlayerItem(url: videoURL)
                    #if DEBUG
                        NSLog("[\(self.TAG)] Video player item initialized succesfully --> AVPlayerItem: \"%@\"", self.vidPlayerItem.description)
                        NSLog("[\(self.TAG)] Initializing video plauyer with item \"self.vidPlayerItem\"...")
                    #endif
                    self.vidPlayer = AVPlayer(playerItem: self.vidPlayerItem)
                    #if DEBUG
                        NSLog("[\(self.TAG)] Video player initialized successfully --> AVPlayer: \"%@\"\nObject as JSON: \"\(JSONStringify(value: self.vidPlayer.currentItem?.automaticallyLoadedAssetKeys as AnyObject, prettyPrinted: true))\"", self.vidPlayer.description)
                    #endif
                    let vidPlayerLayer = AVPlayerLayer(player: self.vidPlayer)
                    let vidPlayerViewController = AVPlayerViewController()
                    
                    #if DEBUG
                        NSLog("[\(self.TAG)] Resizing video player frame to fit desired area")
                    #endif
                    
                    let tmpFrame = CGRect(
                        x: 0,
                        y: 0,
                        width: 10,
                        height: 50
                    )
                    
                    vidPlayerLayer.frame = tmpFrame
                    #if DEBUG
                        NSLog("[\(self.TAG)] Video successfully resized and origin changed to value: --> CGRect: \"%@\"\nAttributes: \"\(JSONStringify(value: tmpFrame.dictionaryRepresentation, prettyPrinted: true) )\"", tmpFrame.debugDescription)
                    #endif
                    
                    if self.playBtn == nil {
                        self.playBtn = UIButton(type: .custom)
                    }
                    
                    self.playBtn.addTarget(
                        self,
                        action: #selector(playBtnPressed(_:)),
                        for: .touchUpInside
                    )
                    
                    vidPlayerViewController.player = vidPlayer
                    vidPlayerViewController.entersFullScreenWhenPlaybackBegins = false
                    vidPlayerViewController.showsPlaybackControls = true
                    
                    let videoView: UIView = vidPlayerViewController.view
                    videoView.contentMode = .scaleAspectFit
                    videoView.frame.size = self.imgView.frame.size
                    
                    // add observer to repeat the selected video if playing
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: self.vidPlayer.currentItem,
                        queue: .main) { _ in
                            self.vidPlayer?.seek(to: kCMTimeZero)
                            self.vidPlayer?.play()
                    }
                    
                    // add video controller as a child subview
                    self.addChildViewController(vidPlayerViewController)
                    self.view.addSubview(vidPlayerViewController.view)
                    vidPlayerViewController.view.frame = self.imgView.frame
                    
                    self.view.addSubview(playBtn)
                }
            default:
                break
            }
            
            /*
            if let tmpImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if tmpImg.size.height > tmpImg.size.width {
                    self.imgView.frame = CGRect(
                        origin: ViewConstants.defaultContainerRect.origin,
                        size: CGSize(
                            width: self.imgView.frame.height,
                            height: self.imgView.frame.width
                        )
                    )
                }
                
                self.selectedImg = tmpImg
                
                if let tmpImg = self.selectedImg {
                    #if DEBUG
                        NSLog("Applying image selection...")
                    #endif
                    self.imgView.image = tmpImg
                    #if DEBUG
                        NSLog("Image selected successfully")
                    #endif
                    
                    #if DEBUG
                        NSLog("Searching for special image frame size/ratio specifications...")
                    #endif
                    if let tmpImgFrame = self.selectedImgFrame {
                        #if DEBUG
                            NSLog("Specifications found.\nApplying frame for selected image")
                        #endif
                        self.imgView.frame = tmpImgFrame
                        #if DEBUG
                            NSLog("Specifications applied successfully")
                        #endif
                    }
                }
                
                self.imgView.image = tmpImg
                updateImgView()
            }
 */
        }
        
        configureImgView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if self.selectedImg != nil {
            self.imgView.image = self.selectedImg
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendImgUploadRequest() -> Void {
        let uploadRequestURL = ""
        
        
        let headers = [
            "x-oc-api-key": "27880a46eed96e8cfb04d866230c6b90",
            "content-type": "application/json",
            //"cache-control": "no-cache"
            "cache-control": "no-cache"
            //"postman-token": "f428dfb6147a3fef5bbb356c6df59094" //"6760006c-e9c6-f597-11d7-be56474018ba"
    
        ]
        
        let parameters = "[\"input\": [{\"type\": \"remote\",\"source\": \"https://static.online-convert.com/example-file/video/mov/example.mov\"}],\"conversion\": [{\"target\": \"mp4\",\"options\": {\"width\": 640,\"height\": 480},},{\"target\": \"webm\",\"options\": {\"width\": 320,\"height\": 240},},{\"target\": \"ogv\",\"options\": {\"width\": 800,\"height\": 600}}]}"
        
        var postData: Data!
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters.data(using: String.Encoding.utf8)!, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            postData = nil
        }
        
        /*
        let postData = NSData(data: "{\"input\": [{\"type\": \"remote\",\"source\": \"https://static.online-convert.com/example-file/video/mov/example.mov\"}],\"conversion\": [{\"target\": \"mp4\",\"options\": {\"width\": 640,\"height\": 480}},{\"target\": \"webm\",\"options\": {\"width\": 320,\"height\": 240}},{\"target\": \"ogv\",\"options\": {\"width\": 800,\"height\": 600}}]}".data(using: String.Encoding.utf8)!)
        */
        
        var request = URLRequest( // NSMutableURLRequest(
            url: URL(string: "https://api2.online-convert.com/jobs")!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
        })
        
        
        dataTask.resume()
        
        
        /*
         /*
         TODO: figure out web request to online-convert.com
         */
         
        #if DEBUG
            NSLog("[\(self.TAG)] Sending upload request for the selected video file...")
        #endif
        
        Alamofire.request("https://api.gfycat.com/v1/users").responseJSON { response in
            #if DEBUG
                NSLog("[\(self.TAG)] Request: \(String(describing: response.request))")    // original url
                NSLog("[\(self.TAG)] Response: \(String(describing: response.response))")     // http response
                NSLog("[\(self.TAG)] Result: \(response.result)")                     // serialized result
            #endif
            
            if let json = response.result.value {
                #if DEBUG
                    NSLog("[\(self.TAG)] JSON: \"\(String(describing: json))\"")  // serialized json response
                #endif
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                #if DEBUG
                    NSLog("[\(self.TAG)] Data: \"\(String(describing: utf8Text))\"") // original server data as UTF8 string
                #endif
            }
        }
        */
        #if DEBUG
            NSLog("[\(self.TAG)] Upload request: \"\(String(describing: uploadRequestURL))\"")
        #endif
        
    }
    
    @objc func playBtnPressed(_ sender: UIButton!) {
        #if DEBUG
            NSLog("[\(self.TAG)] Button pressed: \"\(String(describing: self.playBtn.title(for: .normal)))")
        #endif
        self.vidPlayer.rate == 0 ? self.vidPlayer.play() : self.vidPlayer.pause()
    }
    
    @discardableResult func playVideo() -> Bool {
        var operationSuccessful = false
        if self.vidPlayer != nil {
            #if DEBUG
                NSLog("[\(self.TAG)] Attempting to play selected video in default player...")
            #endif
            self.vidPlayer.play()
            operationSuccessful = true
            #if DEBUG
                NSLog("[\(self.TAG)] Playing video")
            #endif
        }
        
        return operationSuccessful
    }
    
    @discardableResult func pauseVideo() -> Bool {
        var operationSuccessful = false
        if self.vidPlayer != nil {
            #if DEBUG
                NSLog("[\(self.TAG)] Attempting to pause selected video in default player...")
            #endif
            self.vidPlayer.play()
            operationSuccessful = true
            #if DEBUG
                NSLog("[\(self.TAG)] Pausing video")
            #endif
        }
        
        return operationSuccessful
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options!)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                NSLog("[\(self.TAG)] ERROR: ")
            }
            
        }
        
        return ""
    }
}

