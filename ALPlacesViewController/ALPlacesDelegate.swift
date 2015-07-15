//
//  ALPlacesDelegate.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/13.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import GoogleMaps

typealias ScrollViewDidScrollCallback = (offset: CGPoint) -> Void
typealias PlaceDetailsCallback = (placeID: String) -> GMSPlace

class ALPlacesDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var places: [GMSPlace]?
    var userLocation: ALUserLocation?
    var headerView: ALPlacesHeaderView?
    var predictions: [GMSAutocompletePrediction]?
    var onHeaderView: (() -> Void)?
    var onScroll: ScrollViewDidScrollCallback?
    var onLocationPicked: ALPlacesPickerCallback?

    func scrollViewDidScroll(scrollView: UIScrollView) {
        onScroll?(offset: scrollView.contentOffset)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var offset = 0
        
        if userLocation != nil {
            offset = 1
        }
        
        if userLocation != nil && indexPath.row == 0 {
            onLocationPicked?(address: userLocation?.address, coordinate: userLocation!.location?.coordinate)
        } else if places != nil {
            let place = places![indexPath.row - offset]
            onLocationPicked?(address: place.name, coordinate: place.coordinate)
        } else if predictions != nil {
            let prediction = predictions![indexPath.row]
            GMSPlacesClient.sharedClient().lookUpPlaceID(prediction.placeID) { place, error in
                if let p = place {
                    self.onLocationPicked?(address: p.formattedAddress, coordinate: p.coordinate)
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        
        if userLocation != nil {
            count += 1
        }
        
        if places != nil {
            count += places!.count
        }
        
        if predictions != nil {
            count = predictions!.count
        }
        
        return count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return ALPlaceCollectionViewCell.cellSize()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ALPlaceCollectionViewCellIdentifier, forIndexPath: indexPath) as! ALPlaceCollectionViewCell
        
        var offset = 0
        
        if userLocation != nil {
            offset = 1
        }
        
        if indexPath.row == 0 && userLocation != nil {
            cell.configureWithLocation(userLocation!)
        } else if places != nil {
            cell.configureWithPlace(places![indexPath.row - offset])
        } else {
            cell.configureWithAutocompletePrediction(predictions![indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            if headerView == nil {
                headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ALPlaceCollectionViewHeaderIdentifier, forIndexPath: indexPath) as? ALPlacesHeaderView
                
                onHeaderView?()
            }
        }
        
        return headerView!
    }
}
