//
//  WebViewController.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/15/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate, UINavigationBarDelegate {
    @IBOutlet var webView: WKWebView!
    
    var webKitConfigs: WKWebViewConfiguration!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // do setup before loading the view
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureWebView()
    }
    
    func configureWebView() -> Void {
        if self.webView == nil {
            self.webView = WKWebView(frame: self.view.frame)
        }
        
        self.webView.allowsLinkPreview = true
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.customUserAgent = "Mozilla"    // TODO maybe change back to mobile safari
        
        let gfyCatURLRequest = URLRequest(
            url: URL(string: "https://gfycat.com/upload")!
        )
        
        self.webView.load(gfyCatURLRequest)
        
        
        // set custom configs--can be changed from the user's settings
        wk_allowPictureInPicturePlayback(true)
    }
    
    @discardableResult func wk_setImmutableValue(_ value: Any?, forKey key: String?) -> Bool! {
        var didSetWithoutErrors: Bool!
        
        #if DEBUG
            print("Checking for webkit view value for key \"\(String(describing: key))\"")
        #endif
        if let keyVal = key as String!, let valVar = value as Any! {
            if self.webView.value(forKey: keyVal) != nil {
                #if DEBUG
                    print(
                        """
                        Webkit configuration setting for key \"\(String(describing: keyVal))\" has been found.\"
                        \nAssigning value of \"\(String(describing: (valVar as AnyObject).debugDescription))\"
                        """
                    )
                #endif
                self.webView.setValue(valVar, forKey: keyVal)
                #if DEBUG
                    print("Value assigned successfully")
                #endif
                didSetWithoutErrors = true
            } else {
                #if DEBUG
                    print(
                        """
                        ERROR: Unable to assign the specified value \"\(String(describing: value))\"
                        to the given key: \"\(String(describing: keyVal))\"
                        """
                    )
                #endif
                
                didSetWithoutErrors = false
            }
        }
        
        return didSetWithoutErrors
    }
    
    
    func wk_allowPictureInPicturePlayback(_ shouldAllow: Bool?) -> Void {
        self.webView.configuration.allowsPictureInPictureMediaPlayback = shouldAllow!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
