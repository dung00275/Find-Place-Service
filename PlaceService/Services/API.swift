//
//  API.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation

struct API {
    static let keyPlaces = "AIzaSyDWFH-1dl5uwYGCNPZ64oT_e2mSuItrk_0"
    static let keyMap = "AIzaSyC7el_3yUX8FQttFI2kJ-zHElwZrwe5cfk"
    static let placeBaseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    static let directionBaseUrl = "https://maps.googleapis.com/maps/api/directions/json"
}

enum ServiceType: String {
    case Restaurant = "restaurant"
    case Police = "police"
    case School = "school"
    case Bank = "bank"
    case NightClub = "night_club"
    case Pharmacy = "pharmacy"
    case Atm = "atm"
    case Laundry = "laundry"
    case Cafe = "cafe"
    case Museum = "museum"
}

