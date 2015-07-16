//
//  ViewController.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/14.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    var placePicker: ALPlacesViewController!
    let button = UIButton()
    let addressLabel = UILabel()
    let coordinateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placePicker = ALPlacesViewController()
        placePicker.onLocationPicked = onLocationPicked
        
        button.setTitle("open picker", forState: UIControlState.Normal)
        button.addTarget(self, action: "openPicker", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        button.sizeToFit()
        button.center = view.center
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(button)
        view.addSubview(addressLabel)
        view.addSubview(coordinateLabel)
    }
    
    func openPicker() {
        presentViewController(placePicker, animated: true, completion: nil)
    }
    
    func onLocationPicked(address: String?, coordinate: CLLocationCoordinate2D?, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
        
        addressLabel.text = address
        addressLabel.sizeToFit()
        
        if let c = coordinate {
            coordinateLabel.text = "\(c.latitude), \(c.longitude)"
            
        }
        coordinateLabel.sizeToFit()
        
        addressLabel.frame.origin.y = 40
        addressLabel.frame.origin.x = 20
        
        coordinateLabel.frame.origin.y = 40 + addressLabel.frame.size.height + 10
        coordinateLabel.frame.origin.x = 20
    }
}
