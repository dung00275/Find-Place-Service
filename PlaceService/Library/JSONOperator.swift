//
//  JSONOperator.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation


infix operator <- {}

// MARK:- Objects with Basic types

/// Object of Basic type
public func <- <T>( left: inout T, right: JSONSubscript) {
    if let value = right.currentValue as? T {
        left = value
    }
}

/// Optional object of basic type
public func <- <T>( left: inout T?, right: JSONSubscript) {
    left = right.currentValue as? T
}

// URL
public func <- <T: NSURL>( left: inout T, right: JSONSubscript) {
    if let path = right.currentValue as? String , let url = NSURL(string: path) as? T {
        left = url
    }
}

public func <- <T: NSURL>( left: inout T?, right: JSONSubscript) {
    if let path = right.currentValue as? String , let url = NSURL(string: path) as? T {
        left = url
    }
}

public func <- <T: JSONMapProtocol>( left: inout T?, right: JSONSubscript) {
    let newJsonScript = JSONSubscript(object: right.currentValue)
    left = T(newJsonScript)
    left?.map(newJsonScript)
}

public func <- <T: JSONMapProtocol>( left: inout T, right: JSONSubscript) {
    let newJsonScript = JSONSubscript(object: right.currentValue)
    left = T(newJsonScript)
    left.map(newJsonScript)
}

// Array
public func <- <T>( left: inout [T], right: JSONSubscript) {
    var result = [T]()
    if let items = right.currentValue as? [AnyObject] {
        for obj in items {
            if let value = obj as? T {
                result.append(value)
            }
        }
        
        left = result
    }
}

public func <- <T>( left: inout [T]?, right: JSONSubscript) {
    var result = [T]()
    if let items = right.currentValue as? [AnyObject] {
        for obj in items {
            if let value = obj as? T {
                result.append(value)
            }
        }
        
        left = result
    }
}

public func <- <T: NSURL>( left: inout [T], right: JSONSubscript) {
    var result = [T]()
    if let items = right.currentValue as? [AnyObject] {
        for obj in items {
            if let value = obj as? String, let url = NSURL(string: value) as? T {
                result.append(url)
            }
        }
        
        left = result
    }
}

public func <- <T: NSURL>( left: inout [T]?, right: JSONSubscript) {
    var result = [T]()
    if let items = right.currentValue as? [AnyObject] {
        for obj in items {
            if let value = obj as? String, let url = NSURL(string: value) as? T {
                result.append(url)
            }
        }
        
        left = result
    }
}

public func <- <T: JSONMapProtocol>( left: inout [T]?, right: JSONSubscript) {
    autoreleasepool { () -> () in
        var result = [T]()
        if let items = right.currentValue as? [AnyObject] {
            for obj in items {
                let newJsonScript = JSONSubscript(object: obj)
                var newItem = T(newJsonScript)
                newItem.map(newJsonScript)
                result.append(newItem)
            }
            
            left = result
        }
    }
}

public func <- <T: JSONMapProtocol>( left: inout [T], right: JSONSubscript) {
    autoreleasepool { () -> () in
        var result = [T]()
        if let items = right.currentValue as? [AnyObject] {
            for obj in items {
                let newJsonScript = JSONSubscript(object: obj)
                var newItem = T(newJsonScript)
                newItem.map(newJsonScript)
                result.append(newItem)
            }
            
            left = result
        }
    }
}






