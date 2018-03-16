//
//  AppDelegate.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/14/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit
import AVKit
import AssetsLibrary
import Photos
import MediaPlayer
import UserNotifications
import Firebase
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    @objc var TAG = NSStringFromClass(classForCoder()).components(separatedBy: ".").last! as String
    
    public var serverURL : String? = "https://gfycat.com/upload"
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            NSLog("[\(self.TAG)] Aapplication launched")
            #endif
        // Override point for customization after application launch.
        
        
        #if DEBUG
            NSLog("Requesting access to \"AVCaptureDevice\"...")
        #endif
        
        // request to gain access to camera upon first launch
        
        AVCaptureDevice.requestAccess(
            for: .video,
            completionHandler: { response in
                if response {
                    NSLog("\"AVCaptureDevice\" access granted")
                } else {
                    NSLog("\"AVCaptureDevice\" access denied")
                }
        })
        
        // request access to camera roll contents upon first launch
        #if DEBUG
            NSLog("[\(self.TAG)] Determing access permissions to device \"Camera Roll\"")
        #endif
        let photosAuthStatus = PHPhotoLibrary.authorizationStatus()
        if photosAuthStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({photosAuthStatus in
                if photosAuthStatus == .authorized {
                    #if DEBUG
                        NSLog("[\(self.TAG)] User authorized camera roll access")
                    #endif
                } else {
                    #if DEBUG
                        NSLog("[\(self.TAG)] User denied camera roll access")
                    #endif
                }
            })
        }
        
        //NotificationCenter.default.addObserver(self, selector: Selector(willEnterFullScreen(_:)), name: "ShouldEnterFullScreen", object: nil)
        application.applicationSupportsShakeToEdit = true
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    // MARK: Inherited methods
    func willEnterFullScreen(_ notification: Notification) -> Void {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

/*
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        print("Step : 12");
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]{
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        //let url = userInfo[AnyHashable("url")] as! String;
        //load_url(server_url: url);
        load_url(server_url: self.serverURL)

        
        // Change this to your preferred presentation option
        completionHandler([])
    }
 
    func load_url(server_url: String!) {
        serverURL = server_url
        let notificationName = Notification.Name("updateWebView")
        NotificationCenter.default.post(name: notificationName, object: nil)
 
 
        //guard let url = URL(string: self.serverURL ?? server_url ?? "https://gfycat.com/upload") else {
        //    print("Invalid URL")
        //    return
        //}
 
        //let request = URLRequest(url: url)
        //WebViewController.instance.webView.load(request)
    }
 
}
*/



