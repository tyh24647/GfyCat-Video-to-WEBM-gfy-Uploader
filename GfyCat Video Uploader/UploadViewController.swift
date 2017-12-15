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
    }
    
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
        //self.scrollView.autoresizesSubviews = true
        self.scrollView.contentMode = .scaleToFill
        
        return self.scrollView
    }
    
    @discardableResult func configureImgView() -> UIImageView! {
        if self.imgView == nil {
            self.imgView = UIImageView()
            self.selectedImg = nil
            self.imgView.autoresizesSubviews = true
            self.imgView.sizeToFit()
        }
        
        self.imgView.contentMode = .scaleAspectFill
        
        //self.imgView.contentMode = UIViewContentMode.scaleAspectFill
        self.imgView.semanticContentAttribute = UISemanticContentAttribute.playback
        
        updateImgView()
        
        return self.imgView
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
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
            
            //self.imgView.image = tmpImg
            self.selectedImg = tmpImg
        } else {
            self.errMsg = "ERROR: Unable to assign image to selection"
        }
        
        if self.errMsg.count > 0 && !self.errMsg.isEmpty {
            print(self.errMsg)
            print("Skipping procedure")
        }
        
        print("Resizing image view frame...")
        self.imgView.frame.size = tmpImgContainerView.frame.size
        
        print("Image frame size changes applied successfully")
        print("Reloading input views...")
        self.imgView.reloadInputViews()
        print("Image view changes applied successfully")
    }
    
    func setImgViewImg(withUIImage newImg: UIImage!) -> Bool {
        var success = false
        
        if let tmpImg: UIImage = newImg {
            success = (
                !(tmpImg.ciImage == nil && tmpImg.cgImage == nil)
                    && (tmpImg.accessibilityIdentifier != nil && !tmpImg.debugDescription.isEmpty)
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
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [ "public.image", "public.movie" ]
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
                    
                    self.imgView.reloadInputViews()
                }
            case SupportedMediaTypes.video:
                let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                #if DEBUG
                    print("\"Video file selected at location: \"\(videoURL)\"")
                #endif
                self.selectedVideoURL = videoURL
                
                if !videoURL.relativeString.isEmpty {
                    //self.imgView.isHidden = true
                    vidPlayerItem = AVPlayerItem(url: videoURL)
                    vidPlayer = AVPlayer(playerItem: vidPlayerItem)
                    let vidPlayerLayer = AVPlayerLayer(player: vidPlayer)
                    let vidPlayerViewController = AVPlayerViewController()
                    
                    // test test test test test test test
                    vidPlayerLayer.frame = CGRect(x:0, y:0, width:10, height:50)
                    
                    //let vidPlayerViewController = AVPlayerViewController()
                    
                    playBtn = UIButton(type: UIButtonType.system) as UIButton
                    let xPos:CGFloat = 50
                    let yPos:CGFloat = 100
                    let buttonWidth:CGFloat = 150
                    let buttonHeight:CGFloat = 45
                    
                    playBtn!.frame = CGRect(x:xPos, y:yPos, width:buttonWidth, height:buttonHeight)
                    playBtn!.backgroundColor = UIColor.lightGray
                    playBtn!.setTitle("Play", for: UIControlState.normal)
                    playBtn!.tintColor = UIColor.black
                    playBtn!.addTarget(self, action: #selector(playBtnPressed(_:)), for: .touchUpInside)
                
                    vidPlayerViewController.player = vidPlayer
                    vidPlayerViewController.entersFullScreenWhenPlaybackBegins = false
                    vidPlayerViewController.showsPlaybackControls = true
                    
                    let videoView: UIView = vidPlayerViewController.view
                    //videoView.frame = scrollView.frame
                    videoView.frame.size = CGSize(width: self.imgView.frame.width, height: vidPlayer.currentItem?.presentationSize.height)
                    //videoView.frame.size = self.imgView.frame.size
                    
                    /*
                    if let vidPlayer = vidPlayerViewController.player {
                        self.scrollView.isHidden = true
                        
                        // self.view.addSubview(videoView)
                    }
                    */
                    
                    vidPlayer.playImmediately(atRate: 1.0)
                    self.view.addSubview(videoView)
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
        var uploadRequestURL = ""
        /*
         TODO: figure out web request to online-convert.com
         */
        print("Upload request: \"\(uploadRequestURL)\"")
        
    }
    
    @objc func playBtnPressed(_ sender: UIButton!) {
        #if DEBUG
            print("Button pressed: \"\(playBtn.title(for: .normal).debugDescription)\"")
        #endif
        vidPlayer.rate == 0 ? vidPlayer.play() : vidPlayer.pause()
        playBtn.setTitle(
            vidPlayer.rate != 0 ?
                ViewConstants.defaultPlayButtonPlayTitle
                : ViewConstants.defaultPlayButtonPauseTitle,
            for: .normal
        )
    }
    
    @discardableResult func playVideo() -> Bool {
        var operationSuccessful = false
        if vidPlayer != nil {
            #if DEBUG
                print("Attempting to play selected video in default player...")
            #endif
            vidPlayer.play()
            operationSuccessful = true
            #if DEBUG
                print("Playing video")
            #endif
            playBtn.setTitle(
                ViewConstants.defaultPlayButtonPauseTitle,
                for: .normal
            )
        }
        
        return operationSuccessful
    }
    
    @discardableResult func pauseVideo() -> Bool {
        var operationSuccessful = false
        if vidPlayer != nil {
            #if DEBUG
                print("Attempting to pause selected video in default player...")
            #endif
            vidPlayer.play()
            operationSuccessful = true
            #if DEBUG
                print("Pausing video")
            #endif
            playBtn.setTitle(
                ViewConstants.defaultPlayButtonPauseTitle,
                for: .normal
            )
        }
        
        return operationSuccessful
    }
}

