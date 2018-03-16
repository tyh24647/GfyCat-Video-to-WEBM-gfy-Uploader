//
//  WebViewController.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/15/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit
import WebKit

private var webVC: WebViewController? // Will hold the static WebViewController instance.

class WebViewController: UIViewController, UINavigationBarDelegate, WKNavigationDelegate {
    @objc var TAG = NSStringFromClass(classForCoder()).components(separatedBy: ".").last! as String
    @IBOutlet var webView: WKWebView!
    
    var webKitConfigs: WKWebViewConfiguration!
    
    static var instance: WebViewController {
        guard let vc2 = webVC else { fatalError() }
        return vc2
    }
    
    /// Do any setup before loading the view
    ///
    /// - Parameter animated: Whether or not the view will be animated when appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // do setup before loading the view
        let notificationName = Notification.Name("updateWebView")
        NotificationCenter.default.addObserver(self, selector: #selector(WebViewController.updateWebView), name: notificationName, object: nil)
        updateWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        webVC = self // Set the property to self.
        configureWebView()
        //configureNavBarItems()    //    <-- TODO: Fix me--not working
        
        self.webView.navigationDelegate = self
        
        
    }
    
    func configureWebView() -> Void {
        if self.webView == nil {
            self.webView = WKWebView(frame: self.view.frame)
        }
        
        self.webView.allowsLinkPreview = true
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.customUserAgent = "Mozilla"    // TODO maybe change back to mobile safari
        
        
        
        // set custom configs--can be changed from the user's settings
        wk_allowPictureInPicturePlayback(true)
        
        //reloadInputViews()
    }
    
    func load_url(server_url: String) -> Void {
        guard let url = URL(string: server_url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    @objc func updateWebView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let serverURL = appDelegate.serverURL!
        load_url(server_url: serverURL)
    }
    
    func configureNavBarItems() -> Void {
        let logo = UIImage(named: "IMG_6370")
        
        if let titleImg = logo {
            let navBar = self.navigationController!.navigationBar
            var navTitleItemView = self.navigationItem.titleView
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.titleView = navTitleItemView
            
            if self.navigationController != nil {
                self.navigationController?.navigationBar.items![0].titleView!.frame = CGRect(
                    x: navBar.center.x,
                    y: navBar.center.y,
                    width: navBar.frame.size.width / 4,
                    height: navBar.frame.size.height / 4
                )
                
                navTitleItemView = UIImageView(image: titleImg)
            }
            
            self.navigationItem.titleView = navTitleItemView
        }
    }
    
    
    /// Sets immutable WebKit values for the built-in web browser
    ///
    /// - Parameters:
    ///   - value: The value in which the key should be set
    ///   - key: The key/identifier to be set
    /// - Returns: True if the value was set without errors, else false
    @discardableResult func wk_setImmutableValue(_ value: Any?, forKey key: String?) -> Bool! {
        var didSetWithoutErrors: Bool!
        
        #if DEBUG
            NSLog("[\(self.TAG)] Checking for webkit view value for key \"\(String(describing: key))\"")
        #endif
        if let keyVal = key as String?, let valVar = value as Any? {
            if self.webView.value(forKey: keyVal) != nil {
                #if DEBUG
                    NSLog(
                        """
                        [\(self.TAG)] Webkit configuration setting for key \"\(String(describing: keyVal))\" has been found.\"
                        \nAssigning value of \"\(String(describing: (valVar as AnyObject)))\"
                        """
                    )
                #endif
                self.webView.setValue(valVar, forKey: keyVal)
                #if DEBUG
                    NSLog("[\(self.TAG)] Value assigned successfully")
                #endif
                didSetWithoutErrors = true
            } else {
                #if DEBUG
                    NSLog(
                        """
                        [\(self.TAG)] ERROR: Unable to assign the specified value \"\(String(describing: value))\"
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
    
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    /// Perform preparations for the destination view before executing the
    /// segue, as long as the destination view is valid.
    ///
    /// - Note: The destination view controller is retrieved by calling
    ///   'segue.destinationViewController', and you can pass objects
    ///   from the current view controller to the destination through
    ///   this method.
    /// - Parameters:
    ///   - segue: The segue in which to be performed
    ///   - sender: The object sending the request to perform a segue 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}



