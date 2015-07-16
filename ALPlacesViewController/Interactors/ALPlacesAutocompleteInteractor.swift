//
//  ALPlacesAutocompleteInteractor.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

struct Meters {
    var distance = 0
}

enum PlaceStatusCodes: String {
    case OK = "OK"
    case ZERO_RESULTS = "ZERO_RESULTS"
    case OVER_QUERY_LIMIT = "OVER_QUERY_LIMIT"
    case REQUEST_DENIED = "REQUEST_DENIED"
    case INVALID_REQUEST = "INVALID_REQUEST"
    case UNKNOWN_ERROR = "UNKNOWN_ERROR"
    case NOT_FOUND = "NOT_FOUND"
}

typealias ALPlacesAutocompleteCompletion = (predictions: [ALPrediction]?, error: NSError?) -> Void
let placesAutocompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

class ALPlacesAutocompleteInteractor {
    
    private let errorDomain = "ALPlacesAutocompleteInteractor"
    
    private var input: String?
    private var APIkey: String?
    private var radius: Meters?
    private var coordinate: CLLocationCoordinate2D?
    private var completion: ALPlacesAutocompleteCompletion?
    
    func setInput(input: String) -> Self {
        self.input = input
        return self
    }
    
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
    
    func onCompletion(completion: ALPlacesAutocompleteCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    func autocomplete() -> Self {
        if let i = input, a = APIkey {
            
            var parameters = ["input": i, "key": a]
            
            if let r = radius {
                parameters["radius"] = "\(r.distance)"
            }
            
            if let c = coordinate {
                parameters["location"] = "\(c.latitude),\(c.longitude)"
            }
            
            Alamofire
                .request(.GET, placesAutocompleteURL, parameters: parameters)
                .responseJSON { request, response, JSON, error in
                
                    if let e = error {
                        self.completion?(predictions: nil, error: e)
                    } else if let result = JSON as? [String: AnyObject], status = result["status"] as? String {
                        
                        if status == PlaceStatusCodes.ZERO_RESULTS.rawValue {
                            self.completion?(predictions: [ALPrediction](), error: nil)
                        } else if status == PlaceStatusCodes.OK.rawValue, let results = result["predictions"] as? [[String: AnyObject]] {
                            var predictions = [ALPrediction]()
                            for r in results {
                                if let name = r["description"] as? String, id = r["place_id"] as? String {
                                    predictions.append(ALPrediction(id: id, name: name))
                                }
                            }
                            self.completion?(predictions: predictions, error: nil)
                            
                        } else {
                            let e = NSError(domain: self.errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : status])
                            self.completion?(predictions: nil, error: e)
                        }
                        
                    }
                }
        } else {
            assert(false, "ALPlacesAutocompleteInteractor has nil text input and/or APIkey \n • input:\(input) \n • key:\(APIkey)")
        }
        
        return self
    }
    
    
}
