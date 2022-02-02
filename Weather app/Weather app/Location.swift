////
////  Location.swift
////  Weather app
////
////  Created by Kevin Lagat on 02/02/2022.
////
//
//import Foundation
//import MapKit
//
//
//class CurrentLocation {
//
//    let locationManager = CLLocationManager()
//
//
//    func getUserLocation() {
//
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//
//    }
//}
//
//extension CurrentLocation: CLLocationManagerDelegate {
//    func isEqual(_ object: Any?) -> Bool {
//        <#code#>
//    }
//
//    var hash: Int {
//        <#code#>
//    }
//
//    var superclass: AnyClass? {
//        <#code#>
//    }
//
//    func `self`() -> Self {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func isProxy() -> Bool {
//        <#code#>
//    }
//
//    func isKind(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//
//    func isMember(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//
//    func conforms(to aProtocol: Protocol) -> Bool {
//        <#code#>
//    }
//
//    func responds(to aSelector: Selector!) -> Bool {
//        <#code#>
//    }
//
//    var description: String {
//        <#code#>
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locationValue.latitude) \(locationValue.latitude)")
//    }
//}
