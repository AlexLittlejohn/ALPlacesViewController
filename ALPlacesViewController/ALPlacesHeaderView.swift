//
//  ALPlacesHeaderView.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/12.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import GoogleMaps

typealias LocationDidChangeCallback = (location: CLLocation) -> Void

class ALPlacesHeaderView: UICollectionReusableView {
   
    var mapView: GMSMapView!
    var firstLocationUpdate = true
    var onUserLocation: LocationDidChangeCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let camera = GMSCameraPosition.cameraWithLatitude(0, longitude: 0, zoom: 12)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        mapView.myLocationEnabled = true

        addSubview(mapView)

    }
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = bounds
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "myLocation" {
            if firstLocationUpdate {
                firstLocationUpdate = false
                let location = change[NSKeyValueChangeNewKey] as! CLLocation
                let camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 16)
                mapView.camera = camera
                onUserLocation?(location: mapView.myLocation)
            }
        }
    }
    
}
