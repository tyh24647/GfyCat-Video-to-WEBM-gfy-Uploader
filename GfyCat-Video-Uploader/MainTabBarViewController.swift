//
//  MainTabBarViewController.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/15/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit

private var tabBarVC: MainTabBarViewController?

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    @IBOutlet var mainTabBar: UITabBar!
    
    @objc var TAG = NSStringFromClass(classForCoder()).components(separatedBy: ".").last! as String
    //MainTabBarViewController.instance.className //AppDelegate.classForCoder().className(for: MainTabBarViewController.self) as String?
    
    static var instance: MainTabBarViewController {
        guard let vc2 = tabBarVC else { fatalError() }
        return vc2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log_dbg(sender: self, "View loaded successfully")

        // Do any additional setup after loading the view.
        
        // change the color of the non-highlighted UITSabBar text to be less difficult to see
//        //let tabBarItems = self.tabBarController!.tabBar.items
//        let tabBarItems = self.tabBar.items
//        for var tbItem in tabBarItems! {
//            //TODO set disabled color
//        }
        
        self.selectedIndex = 1 //2  //  <--                  start at default tab being center
        
        for _ in self.tabBar.items! {
            ///if tabBarItem 
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func select(_ sender: Any?) {
        // todo
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.view != nil && !segue.identifier!.isEmpty {
            
        } else {
            #if DEBUG
                log_dbg("ERROR: Unable to perform segue with identifier \"\(segue.identifier!))\"")
                log_dbg("Skipping procedure")
            #endif
        }
    }
}

