//
//  Log.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/18/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import Foundation

public class Log {
    @discardableResult init(_ message: String!, isErrorMsg: Bool = false, sender: Any? = nil) {
        let senderTag: String = sender == nil ? String() : "[\(NSStringFromClass(type(of: sender) as! AnyClass))]"
        let errFlag: String = isErrorMsg ? "ERROR: " : String()
        let tmpMsg: String = message == nil || message.isEmpty ? "" : message
        let printMsg: String = "TESTTTTTT!!!! \(senderTag) \(errFlag) \(tmpMsg)"
        /*
         TODO - write messages to log files
         */
        
        #if DEBUG
            NSLog(printMsg)
        #endif
    }
    
}

public class Print {
    @discardableResult init(_ message: String!, isErrorMsg: Bool = false, sender: Any? = nil) {
        #if DEBUG
            let senderTag: String = sender == nil ? String() : "[\(NSStringFromClass(type(of: sender) as! AnyClass))]"
            let errFlag: String = isErrorMsg ? "ERROR: " : String()
            let tmpMsg: String = message == nil || message.isEmpty ? "" : message
            let printMsg: String = "TESTTTTT!!!! \(senderTag) \(errFlag) \(tmpMsg)"
            print(printMsg)
        #endif
    }
}
