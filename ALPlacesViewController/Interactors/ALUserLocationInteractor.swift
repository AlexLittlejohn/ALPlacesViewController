//
//  ALUserLocationInteractor.swift
//  Places
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import CoreLocation

typealias ALUserLocationCompletion = (location: CLLocation?, error: NSError?) -> Void

class ALUserLocationInteractor: NSObject, CLLocationManagerDelegate {
   
    private let errorDomain = "ALUserLocationInteractor"
    private let locationManager = CLLocationManager()
    private var completion: ALUserLocationCompletion?
    
    func onCompletion(completion: ALUserLocationCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    func start() -> Self {
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.Denied || status == CLAuthorizationStatus.Restricted {
            let errorArgs = [NSLocalizedDescriptionKey: LocalizedString("location.notauthorized.message")]
            let error = NSError(domain: errorDomain, code: 1, userInfo: errorArgs)
            locationManager.stopUpdatingLocation()
            completion?(location: nil, error: error)
        } else {
            completion?(location: locationManager.location, error: nil)
        }
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations[0] as? CLLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            completion?(location: location, error: nil)
        }
    }
}
