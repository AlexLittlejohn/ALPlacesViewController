//
//  ALPlacesDelegate.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/13.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal typealias ScrollViewDidScrollCallback = (offset: CGPoint) -> Void

internal class ALPlacesDelegate: ALCollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var places: [ALPlace]?
    var userLocation: ALLocation?
    
    var onScroll: ScrollViewDidScrollCallback?
    var onLocationPicked: ALPlacesPickerCallback?
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        onScroll?(offset: scrollView.contentOffset)
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> ALLocation {
        
        var item = ALLocation()
        var offset = 0
        
        if userLocation != nil {
            offset = 1
        }
        
        if userLocation != nil && indexPath.row == 0 {
            item = userLocation!
        } else if places != nil {
            item = places![indexPath.row - offset]
        }
        
        return item
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let item = itemAtIndexPath(indexPath)
        
        if let place = item as? ALPlace {
            onLocationPicked?(address: place.name, coordinate: place.coordinate, error: nil)
        } else {
            onLocationPicked?(address: item.address, coordinate: item.coordinate, error: nil)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        
        if userLocation != nil {
            count += 1
        }
        
        if places != nil {
            count += places!.count
        }
        
        return count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let item = itemAtIndexPath(indexPath)
        
        if let place = item as? ALPlace {
            return ALPlaceCollectionViewCell.cellSize()
        } else {
            return ALUserCollectionViewCell.cellSize()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell
        
        let item = itemAtIndexPath(indexPath)
        
        if let place = item as? ALPlace {
            let placeCell = collectionView.dequeueReusableCellWithReuseIdentifier(ALPlaceCollectionViewCellIdentifier, forIndexPath: indexPath) as! ALPlaceCollectionViewCell
            
            placeCell.configureWithPlace(place)
            cell = placeCell
        } else {
            let locationCell = collectionView.dequeueReusableCellWithReuseIdentifier(ALUserCollectionViewCellIdentifier, forIndexPath: indexPath) as! ALUserCollectionViewCell
            locationCell.configureWithLocation(item)
            cell = locationCell
        }
        
        return cell
    }
}
