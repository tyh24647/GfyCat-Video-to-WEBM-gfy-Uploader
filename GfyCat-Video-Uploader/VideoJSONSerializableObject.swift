//
//  VideoJSONSerializableObject.swift
//  GfyCat Video Uploader
//
//  Created by Tyler hostager on 12/16/17.
//  Copyright © 2017 Tyler hostager. All rights reserved.
//

import Foundation
import Alamofire
//import GfycatKit
//import Pods_GfyCat_Video_Uploader

public class VideoJSONSerializableObject : NSObject {
    fileprivate static var kOCVDummyURLForCredentials = "https://www13.online-convert.com/dl/web2/upload-file"
    fileprivate static var kOCVBaseURL = "http://www.online-convert.com/"
    fileprivate static var kGFYCatBaseURL = "http://gfycat.com/"
    
    
    var parsedWebRequestURLStr: String!
    var baseURL: String!
    
    public var parameters: Parameters! = [:]
    
    override init() {
        
    }
    
    init(withJSONString jsonString: String?) {
        
    }
    
    init(with parameters: [String : Parameters?]) {
        
    }
    
    init(withBaseURL baseURL: String?) {
        if baseURL != nil && baseURL!.isEmpty {
            self.baseURL = VideoJSONSerializableObject.kGFYCatBaseURL
        } else {
            self.baseURL = baseURL!
        }
        
        /* TODO */
    }
    
    public func createDummyWebRequestForJSONData() -> Void {
        //Alamofire.request(URL(VideoJSONSerializableObject.kOCVDummyURLForCredentials), method: .get, parameters: <#T##Parameters?#>, encoding: UTF8, headers: <#T##HTTPHeaders?#>)
    }
    
    public func esubmitWebRequestWithData() -> Void {
        if self.parameters == nil {
            #if DEBUG
                print(
                    """
                    ERROR: The value for the \"Parameters\" attribute cannot be null in
                    the following web request: \"\(String(describing: parsedWebRequestURLStr))\"
                    """
                )
            #endif
        }
        
        /*
        TODO - fill in web request submission!
        */
    }
    
    public func submitWebRequestWithData(_ completionHandler:@escaping (_ receivedHTTPResponse: Bool) -> ()) -> Void {
        
    }
}



