//
//  ALSettingsInteractor.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ALSettingsInteractor: NSObject {
   
    func showSettings(title: String, message: String, inViewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let settingsAction = UIAlertAction(title: LocalizedString("settings.button"), style: .Default) { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: LocalizedString("settings.cancel"), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        inViewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
