//
//  JSONMapper.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
// Protocol
public protocol JSONMapProtocol {
    init(_ mapItem: JSONSubscript)
    mutating func map(_ mapItem: JSONSubscript)
}

// Class hold json
public class JSONSubscript{
    var dictionary: [String: AnyObject]?
    
    init(object: AnyObject?) {
        if let dictionary = object as? [String: AnyObject] {
            self.dictionary = dictionary
        }
    }
    
    init(json: [String: AnyObject]?) {
        dictionary = json
    }
    var nestedKey: String?
    var currentValue: AnyObject?
    
    subscript(key: String) -> JSONSubscript {
        get{
            nestedKey = key
            currentValue = dictionary?[key]
            return self
        }
        
        set{
            dictionary?[key] = newValue.dictionary?[key]
        }
    }
}

// Transfer object
public class JSONTransfer<T: JSONMapProtocol> {
    class func mapToObject(fromResponse response: AnyObject?) -> T? {
        guard let response = response as? [String: AnyObject] else {
            return nil
        }
        
        let jsonSubscript = JSONSubscript(json: response)
        var obj = T(jsonSubscript)
        obj.map(jsonSubscript)
        
        return obj
    }
}
