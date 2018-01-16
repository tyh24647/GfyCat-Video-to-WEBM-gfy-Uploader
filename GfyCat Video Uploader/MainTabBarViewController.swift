//
//  MainTabBarViewController.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/15/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.selectedIndex = 2  // TODO consider changing and make into default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        /*
        var tabBarItems = self.tabBarController?.toolbarItems
        for var tBItem! in tabBarItems {
            
        }
        */
        
        self.selectedIndex = 2
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination.view != nil {
            
        } else {
            #if DEBUG
                print("ERROR: Unable to perform segue with identifier \"\(String(describing: segue.identifier?.debugDescription))\"")
                print("Skipping procedure")
            #endif
        }
    }

}
