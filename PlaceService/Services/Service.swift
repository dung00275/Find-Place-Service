//
//  Service.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

public enum Method: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case UNKNOWN = ""
}

public enum Result {
    case Success(json: [String: AnyObject]?)
    case Fail(error: NSError)
}




public typealias RequestCompletion = (result: Result, response: URLResponse?) -> Void


public class ServiceManager {
    
    public static let sharedInstance = ServiceManager()
    
    // Session For request
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 35
        configuration.allowsCellularAccess = true
        
        let queue = OperationQueue()
        queue.name = "Service.Request"
        queue.qualityOfService = .utility
        
        let newSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        return newSession
    }()
    
    // Excute Request
    public func request(URLRequest request: URLRequest?, completion: RequestCompletion) {
        guard let request = request else {
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey: "No URL!!!"])
            completion(result: .Fail(error: error), response: nil)
            return
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(result: .Fail(error: error), response: response)
            }else {
                completion(result: .Success(json: data?.convertData()), response: response)
            }
        }
        
        dataTask.resume()
    }
    
    // Cancel All Request
    public func cancelAll() {
        session.invalidateAndCancel()
    }
}
