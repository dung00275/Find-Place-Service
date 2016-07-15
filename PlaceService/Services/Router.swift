//
//  Router.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import CoreLocation

enum TravelModes: Int, CustomStringConvertible {
    case driving
    case walking
    case bicycling
    
    var description: String {
        switch self {
        case .driving:
            return "driving"
        case .walking:
            return "walking"
        case .bicycling:
            return "bicycling"
        }
    }
}


enum Router {
    case NearBySearch(location: CLLocationCoordinate2D, type: ServiceType)
    case FindRoute(originLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D, mode: TravelModes)
    
    
    var request: URLRequest? {
        var urlComponent: URLComponents?
        
        switch self {
        case .NearBySearch(let location, let type):
            var params: [String: AnyObject] = [:]
            params["key"] = API.keyPlaces
            params["location"] = "\(location.latitude),\(location.longitude)"
            params["type"] = type.rawValue
            params["rankby"] = "distance"
            
            urlComponent = URLComponents(string: API.placeBaseUrl)
            urlComponent?.queryItems = params.convertToURLQuery()
        case .FindRoute(let originLocation, let destinationLocation, let mode):
            var params: [String: AnyObject] = [:]
            params["origin"] = "\(originLocation.latitude),\(originLocation.longitude)"
            params["destination"] = "\(destinationLocation.latitude),\(destinationLocation.longitude)"
            params["sensor"] = "true"
            params["key"] = API.keyPlaces
            params["mode"] = mode.description
            
            
            urlComponent = URLComponents(string: API.directionBaseUrl)
            urlComponent?.queryItems = params.convertToURLQuery()
        }
        
        
        guard let url = urlComponent?.url else {
            return nil
        }
        print(url)
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
