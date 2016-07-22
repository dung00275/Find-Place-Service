//
//  ViewController.swift
//  PlaceService
//
//  Created by Dung Vu on 7/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var myLocation: CLLocationCoordinate2D!
    lazy var transition = AnimationAlertDelegate()
    private lazy var imageClearColor = getImageWithColor(fromColor: UIColor.clear(), size: CGSize(width: 20, height: 20)) ?? UIImage()
    private var currentMarker: GMSMarker?
    private var routePolyline: GMSPolyline?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUpdateLocation(notification:)), name: LocationNotification.ReadyLocationUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUpdateLocation(notification:)), name: LocationNotification.ErrorUpdateLocationUpdate, object: nil)
        
        LocationService.sharedInstance.startUpdateLocation()
    }

    
    func handleUpdateLocation(notification: Notification){
        guard let location = notification.object as? CLLocation else {
            return
        }
        print(location)
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude , longitude: location.coordinate.longitude, zoom: 17)
        mapView.camera = camera
        myLocation = location.coordinate
//        if myLocation == nil {
//            myLocation = GMSMarker(position: location.coordinate)
//            myLocation.icon = GMSMarker.markerImage(with: UIColor.blue())
//            myLocation.title = "Your Location"
//            myLocation.map = mapView
//        }else {
//            // Update if needed
//            myLocation.position = location.coordinate
//        }
        
        // Find Location Places nearby
        requestPlaces(location: location.coordinate)
    }
    
    func requestPlaces(location: CLLocationCoordinate2D) {
        ServiceManager.sharedInstance.request(URLRequest: Router.NearBySearch(location: location, type: .Cafe).request) { [weak self](result, response) in
            
            switch result {
            case .Success(let json):
                let obj = JSONTransfer<PlaceResponse>.mapToObject(fromResponse: json)
                DispatchQueue.main.async(execute: { 
                    self?.displayPlaces(fromPlaceResponse: obj)
                })
                
            case .Fail(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func handleErrorUpdateLocation(notification: Notification){
        
    }
    
    func makeMarker(place detail:PlaceDetail) {
        guard let location = detail.geometry?.location else {
            return
        }
        
        let marker = MarkerPlace(position: location.coordinate)
//        marker.data = detail
        marker.title = detail.name
        marker.snippet = detail.vicinity
        marker.icon = imageClearColor
//        if let view = Bundle.main.loadNibNamed("MarkerView", owner: nil, options: nil).first as? MarkerView{
//            view.url = detail.icon as? URL
//            marker.iconView = view
//        }
        
        
        
        if let url = detail.icon as? URL{
            if let lastPath = url.lastPathComponent {
                if let image = CacheImage.sharedInstance.cache.object(forKey: lastPath) as? UIImage {
                    marker.icon = image
                }else {
                    let _ = CacheImage.sharedInstance.download(fromURL: url) { (result) in
                        switch result{
                        case .Success:
                            print("complete")
                        case .Fail(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }else {
                let _ = CacheImage.sharedInstance.download(fromURL: url) { (result) in
                    switch result{
                    case .Success:
                        print("complete")
                    case .Fail(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            
        }
        marker.tracksViewChanges = true
        marker.map = mapView
    }
    
    
    func displayPlaces(fromPlaceResponse response: PlaceResponse?) {
        guard let response = response else {
            return
        }
//        mapView.clear()
        
        response.results?.forEach({self.makeMarker(place: $0)})
    }
    
    func trackRouteForPlace() {
        guard let currentMarker = currentMarker else {
            return
        }
        
        let destination = currentMarker.position
        ServiceManager.sharedInstance.request(URLRequest: Router.FindRoute(originLocation: myLocation, destinationLocation: destination, mode: TravelModes.driving).request) { [weak self](result, response) in
            
            switch result {
            case .Success(let json):
                
                let obj = JSONTransfer<DirectionResponse>.mapToObject(fromResponse: json)
                DispatchQueue.main.async(execute: { 
                    self?.drawRoute(fromResponse: obj)
                })
                
            case .Fail(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func resetRoute() {
        routePolyline?.map = nil
        routePolyline = nil
    }
    
    func drawRoute(fromResponse response:DirectionResponse?) {
        // Reset First
        resetRoute()
        guard let route = response?.routes?.first?.points else {
            return
        }
        
        let path = GMSPath(fromEncodedPath: route)
        routePolyline = GMSPolyline(path: path)
        routePolyline?.strokeWidth = 5
        routePolyline?.strokeColor = #colorLiteral(red: 0.1991284192, green: 0.6028449535, blue: 0.9592232704, alpha: 1)
        routePolyline?.map = mapView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

// MARK: Mapview delegate
extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // Move on map view
        guard myLocation != nil else {
            return
        }
        
        if position.target != myLocation{
            requestPlaces(location: position.target)
        }
    }

    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "showConfirm", sender: nil)
        currentMarker = marker
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        LocationService.sharedInstance.startUpdateLocation()
        return true
    }
}

extension ViewController: AlertConfirmDelegate {
    func alertFindRoute(_ alert: UIViewController) {
        alert.dismiss(animated: true) { 
            self.trackRouteForPlace()
        }
        
    }
    
    
    func alertCancel(_ alert: UIViewController) {
        alert.dismiss(animated: true, completion: nil)
        currentMarker = nil
    }
}



