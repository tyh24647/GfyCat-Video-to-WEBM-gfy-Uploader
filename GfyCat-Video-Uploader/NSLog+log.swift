//
//  Print+ClassInfo.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 3/16/18.
//  Copyright © 2018 Tyler hostager. All rights reserved.
//

import Foundation

public func log_dbg(sender: AnyObject? = nil, _ printStr: String?) {
    var className: String = ""
    let msg = printStr ?? ""
    
    let callingMethodInfo = CallStackAnalyzer.getCallingClassAndMethodInScope(includeImmediateParentClass: true)
    
    if sender != nil {
        className = (sender as! NSObject).className
    } else {
        if let callingMethodInfo = callingMethodInfo {
            className = callingMethodInfo.0
        }
    }
    
    NSLog(String(format: "%@%@", className == "" || className == String(describing: "[]") ? "" : "[\(className)] ", msg))
}

