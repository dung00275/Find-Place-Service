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
            currentValue = findValueWithArrayString(fromComponents: key.components(separatedBy: "."))
            return self
        }
    }
    
    private func findValueWithArrayString(fromComponents components: [String]) -> AnyObject? {
        guard let lastKey = components.last else {
            return nil
        }
        var dict: [String: AnyObject]? = self.dictionary
        for component in components{
            if component != lastKey {
                if dict == nil {return nil}
                dict = dict?[component] as? [String: AnyObject]
            }else {
                return dict?[component]
            }
            
        }
        return nil
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
