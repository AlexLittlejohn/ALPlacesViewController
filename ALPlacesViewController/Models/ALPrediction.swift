//
//  ALPrediction.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ALPrediction: NSObject {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
