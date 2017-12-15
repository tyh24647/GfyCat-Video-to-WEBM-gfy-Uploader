//
//  WebRequestObj.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/14/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import UIKit

class WebRequestObj: NSObject {

    let kDefaultMediaType = "image"
    
    var mediaType: String!
    
    /// Default constructor
    override init() {
        self.mediaType = kDefaultMediaType
    }
    
    
    /// Constructs a web request object using a previously created web request
    ///
    /// - Parameter webRequest: Another web request object in which the current
    ///                         web request should duplicate
    init(withWebRequest webRequest: WebRequestObj!) {
        if webRequest != nil {
            self.mediaType = webRequest!.mediaType
        }
    }
    
    init(withMediaType mediaType: String!, withRequestHeader requestHeader: String!) {
        if mediaType.isEmpty {
            
        }
    }
    
    
}
