//
//  FirstViewController.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/14/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var mainView: UILabel!
    @IBOutlet var selectFileBtn: UIButton!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func selectFileBtnPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    func imgUploadRequest() -> Void {
        var uploadRequestURL = ""
        /*
         TODO: figure out web request to online-convert.com
         */
        print("Upload request: \"\(uploadRequestURL)\"")
        
        
    }
}

