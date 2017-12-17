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

/// FirstViewController displays the view controller allowing the user to select and upload
/// media to http://online-convert.com/ through the use of their photo library or cloud drive(s)
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    @IBOutlet var mainView: UILabel!
    @IBOutlet var selectFileBtn: UIButton!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var vidPlayerItem: AVPlayerItem!
    var vidPlayer: AVPlayer!
    var selectedImg: UIImage!
    var playBtn: UIButton!
    var selectedImgFrame: CGRect!
    var selectedVideoURL: URL!
    var selectedImgURL: URL!
    var errMsg: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureImgView()
        configureScrollView()
        self.playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.playBtn.setTitle("Play", for: .normal)
        self.playBtn.isHidden = true
        self.playBtn.isEnabled = false
        self.selectFileBtn.isHidden = false
        self.selectFileBtn.isEnabled = true
        self.uploadBtn.isHidden = true
        self.uploadBtn.isEnabled = false
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
                        print("New image selected.\nApplying changes...")
                        self.selectedImg = tmpImg
                    } else {
                        print("Same image selected as previously assigned")
                    }
                }
            } else {
                print("Resizing image container for the selected image: image \"\(self.selectedImg)\"")
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
        
        
        print("Applying image view size/aspect ratio changes if needed...")
        
        // configure and apply new image view height maintaining the correct ratio
        if let tmpImg = self.selectedImg {
            let imgRatio = tmpImg.size.width / tmpImg.size.height
            
            if tmpImgContainerView.frame.width > tmpImgContainerView.frame.height {
                let tmpHeight = tmpImgContainerView.frame.width / imgRatio
                
                print("Adjusting image view rect width to fit image ratio...")
                self.imgView.frame.size = CGSize(
                    width: tmpImgContainerView.frame.width,
                    height: tmpHeight
                )
            } else {
                let tmpWidth = tmpImgContainerView.frame.height * imgRatio
                
                print("Adjusting image view rect height to fit image ratio...")
                self.imgView.frame.size = CGSize(
                    width: tmpWidth,
                    height: tmpImgContainerView.frame.height
                )
            }
            
            self.selectedImg = tmpImg
        } else {
            self.errMsg = "ERROR: Unable to assign image to selection"
        }
        
        if self.errMsg.count > 0 && !self.errMsg.isEmpty {
            #if DEBUG
                print(self.errMsg)
                print("Skipping procedure")
            #endif
        }
        
        #if DEBUG
            print("Resizing image view frame...")
        #endif
        self.imgView.frame.size = tmpImgContainerView.frame.size
        #if DEBUG
            print("Image frame size changes applied successfully")
            print("Reloading input views...")
        #endif
        self.imgView.reloadInputViews()
        #if DEBUG
            print("Image view changes applied successfully")
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
                ERROR: Unable to locate and assign image to the
                file named: \"\(String(describing: newImg.accessibilityIdentifier))\"
                """
                ) as String
            
            print(pErr)
            print("Skipping procedure")
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
        //let pickerController = UIDocumentPickerViewController(documentTypes: ["public.movie", "public.video", UIImagePickerControllerPHAsset, UIImagePickerControllerMediaType], in: .import)
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
        sendImgUploadRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            print("Applying image selection...")
                        #endif
                        self.imgView.image = tmpImg
                        #if DEBUG
                            print("Image selected successfully")
                            print("Searching for special image frame size/ratio specifications...")
                        #endif
                        if let tmpImgFrame = self.selectedImgFrame {
                            #if DEBUG
                                print("Specifications found.\nApplying frame for selected image")
                            #endif
                            self.imgView.frame = tmpImgFrame
                            #if DEBUG
                                print("Specifications applied successfully")
                            #endif
                        }
                    }
                    
                    self.imgView.reloadInputViews()
                }
            case SupportedMediaTypes.video:
                let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                #if DEBUG
                    print("\"Video file selected at location: \"\(videoURL)\"")
                #endif
                self.selectedVideoURL = videoURL
                
                self.vidPlayerItem = nil
                self.vidPlayer = nil
                self.selectedImg = nil
                self.selectedVideoURL = nil
                self.selectedImgFrame = nil
                
                if !videoURL.relativeString.isEmpty {
                    self.vidPlayerItem = AVPlayerItem(url: videoURL)
                    self.vidPlayer = AVPlayer(playerItem: self.vidPlayerItem)
                    let vidPlayerLayer = AVPlayerLayer(player: self.vidPlayer)
                    let vidPlayerViewController = AVPlayerViewController()
                    
                    vidPlayerLayer.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: 10,
                        height: 50
                    )
                    
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
                    object: self.vidPlayer.currentItem, queue: .main) { _ in
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
                    print("Applying image selection...")
                    self.imgView.image = tmpImg
                    print("Image selected successfully")
                    
                    print("Searching for special image frame size/ratio specifications...")
                    if let tmpImgFrame = self.selectedImgFrame {
                        print("Specifications found.\nApplying frame for selected image")
                        self.imgView.frame = tmpImgFrame
                        print("Specifications applied successfully")
                    }
                }
                
                self.imgView.image = tmpImg
                updateImgView()
            }
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
        /*
         TODO: figure out web request to online-convert.com
         */
        
        // TEST TEST ETST TEST ETS TEST EST
        /*
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
         
        }
        */
        
        Alamofire.request("https://api.gfycat.com/v1/users").responseJSON { response in
            print("Request: \(String(describing: response.request))")    // original url
            print("Response: \(String(describing: response.response))")     // http response
            print("Result: \(response.result)")                     // serialized result
            
            if let json = response.result.value {
                print("JSON: \(json)")  // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        
        print("Upload request: \"\(uploadRequestURL)\"")
        
    }
    
    @objc func playBtnPressed(_ sender: UIButton!) {
        #if DEBUG
            print("Button pressed: \"\(String(describing: self.playBtn.title(for: .normal)))\"")
        #endif
        self.vidPlayer.rate == 0 ? self.vidPlayer.play() : self.vidPlayer.pause()
    }
    
    @discardableResult func playVideo() -> Bool {
        var operationSuccessful = false
        if self.vidPlayer != nil {
            #if DEBUG
                print("Attempting to play selected video in default player...")
            #endif
            self.vidPlayer.play()
            operationSuccessful = true
            #if DEBUG
                print("Playing video")
            #endif
        }
        
        return operationSuccessful
    }
    
    @discardableResult func pauseVideo() -> Bool {
        var operationSuccessful = false
        if self.vidPlayer != nil {
            #if DEBUG
                print("Attempting to pause selected video in default player...")
            #endif
            self.vidPlayer.play()
            operationSuccessful = true
            #if DEBUG
                print("Pausing video")
            #endif
        }
        
        return operationSuccessful
    }
}

