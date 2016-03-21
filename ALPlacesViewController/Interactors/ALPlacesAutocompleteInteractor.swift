//
//  ALPlacesAutocompleteInteractor.swift
//  Places
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

struct Meters: Double {
    let distance: Double
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

typealias PlacesAutocompleteCompletion = (predictions: [ALPrediction]?) -> Void
let placesAutocompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

class ALPlacesAutocompleteInteractor {
    
    private let errorDomain = "PlacesAutocompleteInteractor"
    
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
    
    func onCompletion(completion: PlacesAutocompleteCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    func autocomplete() -> Self {
        
        guard let APIkey = APIkey else {
            fatalError("We need an APIKey to continue")
        }
        
        guard let input = input else {
            return self
        }
        
            
        var parameters = ["input": input, "key": APIkey]
        
        if let radius = radius {
            parameters["radius"] = "\(radius.distance)"
        }
        
        if let coordinate = coordinate {
            parameters["location"] = "\(coordinate.latitude),\(coordinate.longitude)"
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

        
        return self
    }
    
    
}
