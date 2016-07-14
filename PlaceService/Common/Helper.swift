//
//  Helper.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - Data To Json
extension Data {
    func convertData() -> [String: AnyObject]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: AnyObject] {
            return json
        }
        return nil
    }
}


// MARK: - Convert character set to string
func convertCharacterSetToString(_ characterSet: NSCharacterSet) -> String{
    var array      = [String]()
    for plane: UInt8 in 0...16 where characterSet.hasMemberInPlane(plane) {
        autoreleasepool({ () -> () in
            for character: UTF32Char in UInt32(plane) << 16...(UInt32(plane) + 1) << 16 where characterSet.longCharacterIsMember(character) {
                
                var endian = character.littleEndian
                guard let string = String(bytesNoCopy: &endian, length: 4, encoding: String.Encoding.utf32LittleEndian, freeWhenDone: false) else {
                    continue
                }
                
                array.append(string)
            }
        })
    }
    
    return array.joined(separator: "")
}

// MARK: UIImageView
extension UIImageView {
    func setImageFromURL(URLpath url:URL) {
        let _ = CacheImage.sharedInstance.download(fromURL: url) { [weak self](result) in
            switch result{
            case .Success(let image):
                DispatchQueue.main.async(execute: { 
                    self?.image = image
                })
                
            case .Fail(let error):
                print(error.localizedDescription)
            }
        }
    }
}

func getImageWithColor(fromColor color: UIColor, size: CGSize) -> UIImage? {
    let rect = CGRect(origin: CGPoint.zero, size: size)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

// MARK: Location
extension CLLocationCoordinate2D: Equatable {
}
public func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool{
    return left.latitude == right.latitude && left.longitude == right.longitude
}

