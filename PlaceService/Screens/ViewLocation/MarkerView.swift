//
//  MarkerView.swift
//  PlaceService
//
//  Created by Dung Vu on 7/18/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MarkerPlace: GMSMarker {
    var data: PlaceDetail?
}

class MarkerView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    var url: URL? {
        didSet{
            guard let url = self.url else {
                return
            }
            imageView.setImageFromURL(URLpath: url)
        }
    }
}
