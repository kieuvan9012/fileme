//
//  LocationInstance.swift
//  MiBook
//
//  Created by Lê Dũng on 5/7/18.
//  Copyright © 2018 Ledung. All rights reserved.
//
import CoreLocation
import UIKit
let  locationInstance = LocationInstance.sharedInstance()
import GoogleMaps
import GooglePlaces
class LocationInstance: NSObject , CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    var myLocation : CLLocation?
    
    static var instance: LocationInstance!
    class func sharedInstance() -> LocationInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? LocationInstance())
        }
        return self.instance
    }
    
    func requestAuthorization()
    {
        self.myLocation = nil;
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self ;
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(self.myLocation == nil)
        {
            if(locations.count > 0)
            {
                self.myLocation = locations.last;
                notifyInstance.post(.updateLocation, self.myLocation)
                locationManager.stopUpdatingLocation()
            }
        }
    }
}
