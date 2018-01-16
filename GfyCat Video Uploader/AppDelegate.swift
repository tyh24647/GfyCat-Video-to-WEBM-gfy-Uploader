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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Requesting access to \"AVCaptureDevice\"...")
        
        // request to gain access to camera upon first launch
        /*
        AVCaptureDevice.requestAccess(
            for: .video,
            completionHandler: { response in
                if response {
                    print("\"AVCaptureDevice\" access granted")
                } else {
                    print("\"AVCaptureDevice\" access denied")
                }
        })
 */

        // request access to camera roll contents upon first launch
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    print("User authorized camera roll access")
                } else {
                    print("User denied camera roll access")
                }
            })
        }
        
        //NotificationCenter.default.addObserver(self, selector: Selector(willEnterFullScreen(_:)), name: "ShouldEnterFullScreen", object: nil)
        application.applicationSupportsShakeToEdit = true
        
        return true
    }
    
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

