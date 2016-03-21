//
//  ALPlacesHeaderView.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/12.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import MapKit

class ALPlacesHeaderView: UICollectionReusableView {
   
    var mapView: MKMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        mapView = MKMapView(frame: bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        addSubview(mapView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = bounds
    }
}
