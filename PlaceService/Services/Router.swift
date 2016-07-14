//
//  Router.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import CoreLocation

enum Router {
    case NearBySearch(location: CLLocationCoordinate2D, type: ServiceType)
    
    var request: URLRequest? {
        var urlComponent: URLComponents?
        
        switch self {
        case .NearBySearch(let location, let type):
            var params: [String: AnyObject] = [:]
            params["key"] = API.key
            params["location"] = "\(location.latitude),\(location.longitude)"
            params["type"] = type.rawValue
            params["rankby"] = "distance"
            
            urlComponent = URLComponents(string: API.placeBaseUrl)
            urlComponent?.queryItems = params.convertToURLQuery()
            
        }
        
        guard let url = urlComponent?.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
}

extension Dictionary {
    func convertToURLQuery() -> [URLQueryItem] {
        var result = [URLQueryItem]()
        autoreleasepool { () -> () in
            for (key,element) in self {
                if let key = key as? String {
                    let item = URLQueryItem(name: key, value: element as? String)
                    result.append(item)
                }
                
            }
        }
        
        return result
    }
}
