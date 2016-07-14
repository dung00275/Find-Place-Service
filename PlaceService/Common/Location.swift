//
//  Location.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct LocationNotification {
    static let ReadyLocationUpdate = NSNotification.Name(rawValue: "ReadyLocationUpdate")
    static let ErrorUpdateLocationUpdate = NSNotification.Name(rawValue: "ErrorUpdateLocationUpdate")
}


public class LocationService: NSObject {
    static let sharedInstance = LocationService()
    
    private lazy var manager: CLLocationManager = {
        $0.desiredAccuracy = kCLLocationAccuracyHundredMeters
        $0.delegate = self
        return $0
    }(CLLocationManager())
    
    private var isReadyUpdateLocation = false {
        didSet{
            isUpdating = !isReadyUpdateLocation
        }
    }
    private var isUpdating = false
    private var currentLocation: CLLocation?
    
    func startUpdateLocation() {
        if !isUpdating {
            if CLLocationManager.locationServicesEnabled() {
                isReadyUpdateLocation = false
                manager.startUpdatingLocation()
            }
        } else {
            print("Already Updating....")
        }
    }
    
    func stopUpdateLocation() {
        manager.stopUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            startUpdateLocation()
        case .authorizedWhenInUse, .restricted, .denied:
            let alert = UIAlertController(title: "Background Location Access Disabled",
                                          message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared().open(url, completionHandler: nil)
                    } else {
                         UIApplication.shared().openURL(url)
                    }
                }
            }
            alert.addAction(openAction)
            let rootController = UIApplication.shared().keyWindow?.rootViewController
            rootController?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating Location....")
        if !isReadyUpdateLocation {
            isReadyUpdateLocation = true
            currentLocation = locations.last
            NotificationCenter.default.post(name: LocationNotification.ReadyLocationUpdate, object: currentLocation)
            self.stopUpdateLocation()
        }
        
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        isReadyUpdateLocation = true
        NotificationCenter.default.post(name: LocationNotification.ErrorUpdateLocationUpdate, object: nil)
        self.stopUpdateLocation()
        
    }
    
    
}
