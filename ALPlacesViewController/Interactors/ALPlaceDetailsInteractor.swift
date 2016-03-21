//
//  ALPlaceDetailsInteractor.swift
//  Places
//
//  Created by Alex Littlejohn on 2015/07/16.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

typealias ALPlaceDetailsCompletion = (place: ALPlace?, error: NSError?) -> Void
let placeDetailsURL = "https://maps.googleapis.com/maps/api/place/details/json"

class ALPlaceDetailsInteractor {
    
    private let errorDomain = "ALPlaceDetailsInteractor"
    
    private var placeID: String?
    private var APIkey: String?
    private var completion: ALPlaceDetailsCompletion?
   
    func setPlaceID(placeID: String) -> Self {
        self.placeID = placeID
        return self
    }
    
    func setAPIkey(APIkey: String) -> Self {
        self.APIkey = APIkey
        return self
    }
    
    func onCompletion(completion: ALPlaceDetailsCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    func details() -> Self {
        
        if let id = placeID, a = APIkey {
            
            let parameters = ["placeid": id, "key": a]
            Alamofire
                .request(.GET, placeDetailsURL, parameters: parameters)
                .responseJSON { request, response, JSON, error in
                    if let e = error {
                        self.completion?(place: nil, error: e)
                    } else if let result = JSON as? [String: AnyObject], status = result["status"] as? String {
                        
                        switch status {
                        case PlaceStatusCodes.OK.rawValue:
                            
                            if let place = result["result"] as? NSDictionary,
                                name = place["name"] as? String,
                                address = place["formatted_address"] as? String,
                                lat = place.valueForKeyPath("geometry.location.lat") as? Double,
                                lon = place.valueForKeyPath("geometry.location.lng") as? Double {
                                    
                                    var p = ALPlace()
                                    
                                    p.name = name
                                    p.address = address
                                    p.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                    
                                    self.completion?(place: p, error: nil)
                            }
                            
                            break
                        default:
                            let e = NSError(domain: self.errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : status])
                            self.completion?(place: nil, error: e)
                            break
                        }
                        
                    }
            }
        } else {
            assert(false, "ALPlaceDetailsInteractor requires a place id and an APIKey \n • id:\(placeID) \n • key:\(APIkey)")
        }
        
        return self
    }
}
