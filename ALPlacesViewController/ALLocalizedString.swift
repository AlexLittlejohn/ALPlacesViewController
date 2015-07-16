//
//  ALLocalizedString.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal func LocalizedString(string: String) -> String {
    return NSLocalizedString(string, tableName: "ALPlacesStrings", bundle: NSBundle(forClass: ALPlacesViewController.self), comment: string)
}
