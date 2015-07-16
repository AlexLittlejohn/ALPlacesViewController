//
//  ALPlacesSearchInteractor.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

typealias ALPlacesSearchCompletion = (places: [ALPlace]?, error: NSError?) -> Void
let placesSearchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

class ALPlacesSearchInteractor {
    
    private let errorDomain = "ALPlacesSearchInteractor"
    
    private var APIkey: String?
    private var radius: Meters?
    private var coordinate: CLLocationCoordinate2D?
    private var completion: ALPlacesSearchCompletion?
    
    func setRadius(radius: Meters) -> Self {
        self.radius = radius
        return self
    }
    
    func setCoordinate(coordinate: CLLocationCoordinate2D) -> Self {
        self.coordinate = coordinate
        return self
    }
    
    func setAPIkey(APIkey: String) -> Self {
        self.APIkey = APIkey
        return self
    }
    
    func onCompletion(completion: ALPlacesSearchCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    func search() -> Self {
        
        if let r = radius, c = coordinate, a = APIkey {
            var parameters = [
                "radius": "\(r.distance)",
                "key": a,
                "location": "\(c.latitude),\(c.longitude)"
            ]
            
            Alamofire
                .request(.GET, placesSearchURL, parameters: parameters)
                .responseJSON { request, response, JSON, error in
                    if let e = error {
                        self.completion?(places: nil, error: e)
                    } else if let result = JSON as? [String: AnyObject], status = result["status"] as? String {
                        
                        switch status {
                        case PlaceStatusCodes.OK.rawValue:
                            
                            if let results = result["results"] as? [[String: AnyObject]] {
                                
                                var places = [ALPlace]()
                                
                                for place in results {
                                    
                                    var dictPlace = place as NSDictionary
                                    
                                    
                                    if let name = place["name"] as? String,
                                        address = place["vicinity"] as? String,
                                        lat = dictPlace.valueForKeyPath("geometry.location.lat") as? Double,
                                        lon = dictPlace.valueForKeyPath("geometry.location.lng") as? Double {
                                            
                                            var p = ALPlace()
                                            
                                            p.name = name
                                            p.address = address
                                            p.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                            places.append(p)
                                            
                                    }
                                }
                                
                                self.completion?(places: places, error: nil)
                            }
                            
                            break
                        case PlaceStatusCodes.ZERO_RESULTS.rawValue:
                            self.completion?(places: [ALPlace](), error: nil)
                            break
                        default:
                            let e = NSError(domain: self.errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : status])
                            self.completion?(places: nil, error: e)
                            break
                            
                        }
                    }
            }
        } else {
            assert(false, "ALPlacesSearchInteractor requires a radius, location and an APIKey")
        }
        
        
        return self
    }
}
