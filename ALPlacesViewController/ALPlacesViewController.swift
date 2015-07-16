//
//  ALPlacesViewController.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/10.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

internal let ALPlaceCollectionViewCellIdentifier = "ALPlaceCollectionViewCell"
internal let ALUserCollectionViewCellIdentifier = "ALUserCollectionViewCell"
internal let ALPredictionCollectionViewCellIdentifier = "ALPredictionCollectionViewCell"
internal let ALPlaceCollectionViewHeaderIdentifier = "ALPlaceCollectionViewHeader"

public typealias ALPlacesPickerCallback = (address: String?, coordinate: CLLocationCoordinate2D?, error: NSError?) -> Void

public class ALPlacesViewController: UIViewController {

    private let searchView = ALSearchBar()
    private let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ALStickyHeaderFlowLayout())

    private let placesDelegate = ALPlacesDelegate()
    private var predictionsDelegate: ALPredictionsDelegate?
    private let keyboardObserver = ALKeyboardObservingView()
    
    private var userLocation: ALLocation?
    private var userLocationInteractor: ALUserLocationInteractor?
    private var onLocationPicked: ALPlacesPickerCallback?
    
    /// Your Google API key
    /// Throws an exception if this is not set when doing web service calls to google apis
    public var APIKey: String!
    
    required public init(APIKey: String, completion: ALPlacesPickerCallback?) {
        super.init(nibName: nil, bundle: nil)
        self.APIKey = APIKey
        self.onLocationPicked = completion
        commonInit()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        onLocationPicked = nil
        userLocationInteractor = nil
        userLocation = nil
        predictionsDelegate = nil
    }
    
    internal func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        collectionView.registerClass(ALPlaceCollectionViewCell.self, forCellWithReuseIdentifier: ALPlaceCollectionViewCellIdentifier)
        collectionView.registerClass(ALUserCollectionViewCell.self, forCellWithReuseIdentifier: ALUserCollectionViewCellIdentifier)
        collectionView.registerClass(ALPredictionCollectionViewCell.self, forCellWithReuseIdentifier: ALPredictionCollectionViewCellIdentifier)
        collectionView.registerClass(ALPlacesHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ALPlaceCollectionViewHeaderIdentifier)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let headerFrame = CGRectMake(0, 0, view.bounds.width, view.bounds.height/2)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.headerReferenceSize = headerFrame.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.frame = view.bounds
        collectionView.delegate = placesDelegate
        collectionView.dataSource = placesDelegate
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive

        searchView.onSearch = autocomplete
        searchView.frame = CGRectMake(0, 0, view.bounds.size.width, 0)
        searchView.layoutSearchableState()
        searchView.onDoneButton = {
            self.onLocationPicked?(address: self.userLocation?.address, coordinate: self.userLocation?.coordinate, error: nil)
        }
        
        view.addSubview(collectionView)
        view.addSubview(searchView)
        
        userLocationInteractor = ALUserLocationInteractor()
            .onCompletion { location, error in
                if let l = location {
                    self.populateWithLocation(l)
                    self.populatePlaces(l)
                }
            }.start()
        
        placesDelegate.onLocationPicked = onLocationPicked
        
        placesDelegate.onScroll = { offset in
            if offset.y > self.view.bounds.size.height/4 {
                UIView.animateWithDuration(0.2, animations: {
                    self.searchView.layoutScrollingState()
                })
            } else {
                UIView.animateWithDuration(0.2, animations: {
                    self.searchView.layoutSearchableState()
                })
            }
        }
    }
    
    internal func keyboardDidShow(notification: NSNotification) {

        let minimumHeaderHeight = searchView.statusHeight + searchView.searchPadding + searchView.searchHeight + searchView.searchPadding
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            layout.headerReferenceSize.height = minimumHeaderHeight
        })
    }
    
    internal func keyboardDidHide(notification: NSNotification) {
        let newHeight = view.bounds.size.height/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            layout.headerReferenceSize.height = newHeight
        })
    }
    
    private func populatePlaces(location: CLLocation) {
        
        ALPlacesSearchInteractor()
            .setCoordinate(location.coordinate)
            .setAPIkey(APIKey)
            .setRadius(Meters(distance: 5000))
            .onCompletion { places, error in
                
                if let p = places {
                    self.placesDelegate.places = p
                    self.collectionView.reloadData()
                }
                
            }.search()
    }
    
    private func populateWithLocation(location: CLLocation) {
        userLocation = ALLocation()
        userLocation?.address = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        userLocation?.coordinate = location.coordinate
        
        placesDelegate.userLocation = userLocation
        collectionView.reloadData()
        
        ALGeocodingInteractor()
            .setCoordinate(location.coordinate)
            .onCompletion { (address, error) -> Void in
                self.userLocation?.address = address
                self.collectionView.reloadData()
            }
            .start()
    }
    
    internal func autocomplete(text: String) {
        
        collectionView.userInteractionEnabled = true
        
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 3 {
            
            if (collectionView.delegate as! NSObject) != placesDelegate {
                collectionView.delegate = placesDelegate
                collectionView.dataSource = placesDelegate
                collectionView.reloadData()
            }
            
        } else {
            let inter = ALPlacesAutocompleteInteractor()
                .setAPIkey(APIKey)
                .setInput(text)
            
            if let l = userLocation, c = l.coordinate {
                inter.setRadius(Meters(distance: 5000))
                    .setCoordinate(c)
                
            }
            
            inter.onCompletion { predictions, error in
                var results = [ALPrediction]()
                
                if let p = predictions {
                    results = p
                }
                
                self.predictionsDelegate = ALPredictionsDelegate(predictions: results, APIkey: self.APIKey, onLocationPicked: self.onLocationPicked)
                self.collectionView.delegate = self.predictionsDelegate
                self.collectionView.dataSource = self.predictionsDelegate
                self.collectionView.reloadData()
            }.autocomplete()
        }
    }
}
