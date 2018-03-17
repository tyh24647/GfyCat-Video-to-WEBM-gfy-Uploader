//
//  JSONSerializer.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/16/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import Foundation

public class JSONSerializer {
    
    // initialize JSON encoding/decoding objects
    var tJSONDecoder: JSONDecoder!
    var tJSONEncoder: JSONEncoder!
    
    /// Default constructor
    init() {
        //configure JSON encoding objects
        configureJSONDecoder()
        configureJSONEncoder()
        
    }
    
    init(withSerializedJSONData serializedJSON: Data?) {
        configureJSONEncoder()
        configureJSONDecoder()
        
        if let tmpJSONData = serializedJSON {
            //decode(serializedJSON)
        }
    }
    
    struct Todo: Codable {
        
    }
    
    /*
    public func decode(_ jsonData: Data!) -> String? {
        var dataBeforeEncode = jsonData.base64EncodedString()
        #if DEBUG
            print("JSON Data before decoding using the \"JSONSerializer\" object: \"\(dataBeforeEncode)\"")
            #endif
        if let tmpJSON = jsonData {
            
            do {
                let todo = try tJSONDecoder.decode(Todo.self, from: responseData)
                completionHandler(todo, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
    }
 */
    
    func configureJSONEncoder() -> Void {
        if self.tJSONEncoder == nil {
            self.tJSONEncoder = JSONEncoder()
            
            // TODO - add more encoder configurations here
            
            self.tJSONEncoder.dataEncodingStrategy = .base64
        }
    }
    
    func configureJSONDecoder() -> Void {
        if self.tJSONDecoder == nil {
            self.tJSONDecoder = JSONDecoder()
            self.tJSONDecoder.dataDecodingStrategy = .base64
        }
    }
}


