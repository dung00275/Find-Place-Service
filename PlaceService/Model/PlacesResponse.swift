//
//  PlacesResponse.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceLocation: JSONMapProtocol {
    var lat: Double?
    var lng: Double?
    
    lazy var coordinate: CLLocationCoordinate2D = {
        guard let lat = self.lat, let lng = self.lng  else {
            return CLLocationCoordinate2D()
        }
        
       let newCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        return newCoordinate
    }()
    
    required init(_ mapItem: JSONSubscript) {
        
    }
    
    func map(_ mapItem: JSONSubscript) {
        lat <- mapItem["lat"]
        lng <- mapItem["lng"]
    }
    
}

class PlaceGeometry: JSONMapProtocol {
    var location: PlaceLocation?
    
    required init(_ mapItem: JSONSubscript) {
        
    }
    
    func map(_ mapItem: JSONSubscript) {
        location <- mapItem["location"]
    }
}

class PlaceDetail: JSONMapProtocol {
    var geometry: PlaceGeometry?
    var icon: NSURL?
    var id: String?
    var name: String?
    var place_id: String?
    var reference: String?
    var vicinity: String?
    
    required init(_ mapItem: JSONSubscript) {
        
    }
    
    func map(_ mapItem: JSONSubscript) {
        geometry <- mapItem["geometry"]
        icon <- mapItem["icon"]
        id <- mapItem["id"]
        name <- mapItem["name"]
        place_id <- mapItem["place_id"]
        reference <- mapItem["reference"]
        vicinity <- mapItem["vicinity"]
    }
}

class PlaceResponse: JSONMapProtocol {
    var status: String?
    var results: [PlaceDetail]?
    var next_page_token: String?
    
    required init(_ mapItem: JSONSubscript) {
        
    }
    
    func map(_ mapItem: JSONSubscript) {
        status <- mapItem["status"]
        results <- mapItem["results"]
        next_page_token <- mapItem["next_page_token"]
    }
}
