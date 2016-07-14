//
//  Parameter.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation

// MARK: - Make Request
public struct EncodingParameterRequest {
    // Remove Character Not Expect
    private static func escape(_ string: String) -> String {
        
        let strSet = convertCharacterSetToString(NSCharacterSet.urlQueryAllowed)
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSMutableCharacterSet(charactersIn: strSet)
        allowedCharacterSet.removeCharacters(in: generalDelimitersToEncode + subDelimitersToEncode)
        
        let escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet) ?? string
        
        return escaped
    }
    
    // Create String Request
    private static func queryComponents(_ key: String, value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value: value)
            }
        }else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value: value)
            }
        }else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    // Exchange parameter To String
    private static func queryParameters(fromParams parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(isOrderedBefore: { $0 < $1}) {
            guard let value = parameters[key] else {continue}
            components += queryComponents(key, value: value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    
    // Make Request From Params
    public static func makeRequest(_ params: [String: AnyObject],
                                   url: URL,
                                   method: Method ,
                                   headers: [String: String]? = nil) -> URLRequest
    {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if request.allHTTPHeaderFields?["Content-Type"] == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
        }
        
        let body = queryParameters(fromParams: params).data(using: String.Encoding.utf8)
        request.httpBody = body
        
        return request
    }
    
}
