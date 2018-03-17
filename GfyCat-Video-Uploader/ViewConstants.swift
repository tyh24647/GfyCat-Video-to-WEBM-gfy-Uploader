//
//  ViewConstants.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/15/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import Foundation
import UIKit

public struct ViewConstants {
    public static var defaultContainerRect: CGRect {
        get {
            return CGRect(
                x: 0,
                y: 0,
                width: 240,
                height: 128
            )
        }
    }
    
    public static var defaultMinZoomScale: CGFloat { get { return 1.0 } }
    public static var defaultMaxZoomScale: CGFloat { get { return 6.0 } }
    
    public static var defaultPlayButtonPlayTitle: String { get { return "Play" } }
    public static var defaultPlayButtonPauseTitle: String { get { return "Pause" } }
    public static var defaultPlayButton: UIButton {
        get {
            var btn = UIButton(type: .system)
            
            /*
             TODO: add actual play.pause button
             */
            return btn
        }
    }
}
