//
//  FormatPropertiesToJSON.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/18/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import Foundation

/*
public extension Collection {
    //@objc var TAG = NSStringFromClass(classForCoder()).components(separatedBy: ".").last! as String
    
    func toJSON() -> String {
        do {
            #if DEBUG
                NSLog("[\(self.TAG)] Attempting to format object to JSON...")
            #endif
            let jsonData = try JSONSerialization.data(
                withJSONObject: obj,
                options: [.prettyPrinted]
            )
            #if DEBUG
                NSLog("[\(self.TAG)] JSON object created")
            #endif
            
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                NSLog("[\(self.TAG)] Can't create string with data.")
                return "{}"
            }
            
            return jsonString
        } catch let parseError {
            print("[\(self.TAG)] JSON serialization error: \(parseError)")
            return "{}"
        }
    }
}
 */

public extension Dictionary {
    var jsonValue: String {
        get {
            var v = ""
            for (key, value) in self {
                v += ("\(key) = \(value)\n")
            }
            
            return v
        }
    }
    
    public func toJSON() {
        for (key,value) in self {
            print("\(key) = \(value)")
        }
    }
}

public extension Dictionary where Key: CustomDebugStringConvertible, Value: CustomDebugStringConvertible {
    
    func toJSON() {
        for (key,value) in self {
            print("\(key) = \(value)")
        }
    }
}


/*
public class JSONFormatter {
    
    @objc var TAG = NSStringFromClass(classForCoder()).components(separatedBy: ".").last! as String
    
    required init(objectToJSON obj: Any?) -> String {
    do {
    #if DEBUG
    NSLog("[\(self.TAG)] Attempting to format object to JSON...")
    #endif
    let jsonData = try JSONSerialization.data(
    withJSONObject: obj,
    options: [.prettyPrinted]
    )
    #if DEBUG
    NSLog("[\(self.TAG)] JSON object created")
    #endif
    
    guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
    NSLog("[\(self.TAG)] Can't create string with data.")
    return "{}"
    }
    
    return jsonString
    } catch let parseError {
    print("[\(self.TAG)] JSON serialization error: \(parseError)")
    return "{}"
    }
    
    }
    
    /// Convert self to JSON String.
    /// - Returns: Returns the JSON as String or empty string if error while parsing.
    public func toJSON(objectToJSON obj: Any?) -> String {
        
    }
}*/

