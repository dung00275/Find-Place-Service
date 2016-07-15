//
//  DirectionResponse.swift
//  PlaceService
//
//  Created by Dung Vu on 7/15/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation

class DirectionRouteInfor: JSONMapProtocol {
    var distance: Double? //meter
    var duration: Double? //Seconds
    var startAddress: String?
    var endAddress: String?
    
    required init(_ mapItem: JSONSubscript) {
    }
    
    func map(_ mapItem: JSONSubscript) {
        distance <- mapItem["distance.value"]
        duration <- mapItem["duration.value"]
        startAddress <- mapItem["start_address"]
        endAddress <- mapItem["end_address"]
    }
}


class DirectionRoute: JSONMapProtocol{
    
    var points: String?
    var legs: [DirectionRouteInfor]?
    required init(_ mapItem: JSONSubscript) {
        
    }
    
    func map(_ mapItem: JSONSubscript) {
        points <- mapItem["overview_polyline.points"]
        legs <- mapItem["legs"]
    }
}

class DirectionResponse: JSONMapProtocol {
    var routes: [DirectionRoute]?
    required init(_ mapItem: JSONSubscript) {
        
    }
    
    func map(_ mapItem: JSONSubscript) {
        routes <- mapItem["routes"]
    }
}
