//
//  ALGeocodingInteractor.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBook

typealias ALGeocodingCompletion = (address: String?, error: NSError?) -> Void

class ALGeocodingInteractor {
   
    var coordinate: CLLocationCoordinate2D?
    var completion: ALGeocodingCompletion?
    
    func setCoordinate(coordinate: CLLocationCoordinate2D) -> Self {
        self.coordinate = coordinate
        return self
    }

    func onCompletion(completion: ALGeocodingCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    func start() -> Self {
        if let c = coordinate {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: c.latitude, longitude: c.longitude)) { places, error in
                if let e = error {
                    self.completion?(address: nil, error: e)
                } else if let place = places.first as? CLPlacemark {
                    if let lines = place.addressDictionary["FormattedAddressLines"] as? [String] {
                        let address = join(", ", lines)
                        self.completion?(address: address, error: nil)
                    }
                }
            }
        } else {
            assert(false, "ALGeocodingInteractor needs a coordinate")
        }
        
        return self
    }
    
    
}
