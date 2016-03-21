//
//  ALPredictionsDelegate.swift
//  Places
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal class ALPredictionsDelegate: ALCollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    let predictions: [ALPrediction]
    let APIkey: String
    var onLocationPicked: ALPlacesPickerCallback?
    
    init(predictions: [ALPrediction], APIkey: String, onLocationPicked: ALPlacesPickerCallback?) {
        self.APIkey = APIkey
        self.predictions = predictions
        super.init()
        self.onLocationPicked = onLocationPicked
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let item = predictions[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ALPredictionCollectionViewCell
        
        collectionView.userInteractionEnabled = false
        cell.working = true
        
        ALPlaceDetailsInteractor()
            .setPlaceID(item.id)
            .setAPIkey(APIkey)
            .onCompletion { place, error in
                
                collectionView.userInteractionEnabled = true
                cell.working = false
                
                if let e = error {
                    self.onLocationPicked?(address: nil, coordinate: nil, error: e)
                } else if let p = place {
                    self.onLocationPicked?(address: p.name, coordinate: p.coordinate, error: nil)
                }
        }.details()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return predictions.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return ALPredictionCollectionViewCell.cellSize()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ALPredictionCollectionViewCellIdentifier, forIndexPath: indexPath) as! ALPredictionCollectionViewCell
        
        let item = predictions[indexPath.row]
        
        cell.configureWithPrediction(item)
        
        return cell
    }
}
