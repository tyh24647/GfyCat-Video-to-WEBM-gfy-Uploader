//
//  NSObject+ClassName.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 3/16/18.
//  Copyright © 2018 Tyler hostager. All rights reserved.

import Foundation

extension NSObject {
    
    open var className : String {
        let className = String(describing: type(of: self))
        if className.contains(".") {
            let namesArray = className.components(separatedBy: ".")
            return namesArray.last ?? className
        } else {
            return String(describing: type(of: self))
        }
    }
    
}
