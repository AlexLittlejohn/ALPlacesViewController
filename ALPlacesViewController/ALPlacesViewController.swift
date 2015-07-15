//
//  ALPlacesViewController.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/10.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import GoogleMaps

let ALPlaceCollectionViewCellIdentifier = "ALPlaceCollectionViewCell"
let ALPlaceCollectionViewHeaderIdentifier = "ALPlaceCollectionViewHeader"

typealias ALPlacesPickerCallback = (address: String?, coordinate: CLLocationCoordinate2D?) -> Void

public class ALPlacesViewController: UIViewController {

    lazy var placesClient = GMSPlacesClient.sharedClient()
    var headerView: ALPlacesHeaderView!
    let searchView = ALSearchBar()
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ALStickyHeaderFlowLayout())

    let placesDelegate = ALPlacesDelegate()
    let keyboardObserver = ALKeyboardObservingView()
    
    let minimumHeaderHeight: CGFloat = 20 + 15 + 44 + 15
    
    var markers = [GMSMarker]()
    var places = [GMSPlace]()
    var userLocation: ALUserLocation?
    
    var onLocationPicked: ALPlacesPickerCallback?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        GMSServices.provideAPIKey("AIzaSyBHfzZJchyfOBvwmAacHn8gP3WdaJGaUeI")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        collectionView.registerClass(ALPlaceCollectionViewCell.self, forCellWithReuseIdentifier: ALPlaceCollectionViewCellIdentifier)
        collectionView.registerClass(ALPlacesHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ALPlaceCollectionViewHeaderIdentifier)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
            self.onLocationPicked?(address: nil, coordinate: nil)
        }
        
        view.addSubview(collectionView)
        view.addSubview(searchView)
        
        placesDelegate.onLocationPicked = onLocationPicked
        
        placesDelegate.onHeaderView = {
            self.headerView = self.placesDelegate.headerView
            self.headerView.onUserLocation = self.populateWithLocation
            self.populatePlaces()
        }
        
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
    
    func keyboardDidShow(notification: NSNotification) {

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            layout.headerReferenceSize.height = self.minimumHeaderHeight
        })
    }
    
    func keyboardDidHide(notification: NSNotification) {
        let newHeight = view.bounds.size.height/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            layout.headerReferenceSize.height = newHeight
        })
    }
    
    func populatePlaces() {
        placesClient.currentPlaceWithCallback { result, error in
            
            if let r = result, results = r.likelihoods as? [GMSPlaceLikelihood] {
                let data = results.map({ r in
                    return r.place!
                })
                
                self.places = data
                self.populateMap(data)
                self.placesDelegate.places = data
                self.collectionView.reloadData()
            }
        }
    }
    
    func populateWithLocation(location: CLLocation) {
        
        GMSGeocoder().reverseGeocodeCoordinate(location.coordinate) { response, error in
            self.userLocation = ALUserLocation()
            
            self.userLocation!.location = location
            if let address = response.firstResult() {
                self.userLocation!.address = ", ".join(address.lines as! [String])
            }
            
            self.placesDelegate.userLocation = self.userLocation
            self.collectionView.reloadData()
        }
    }

    func populateMap(places: [GMSPlace]) {
        headerView.mapView.clear()
        markers.removeAll(keepCapacity: true)
        for place in places {
            let marker = GMSMarker(position: place.coordinate)
            marker.title = place.name
            marker.snippet = place.formattedAddress
            marker.map = headerView.mapView
            marker.icon = UIImage(named: "marker", inBundle: NSBundle(forClass: ALPlacesViewController.self), compatibleWithTraitCollection: nil)
        }
    }
    
    func autocomplete(text: String) {
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 3 {
            
            var didChange = false
            var indexCount = 0
            
            if placesDelegate.places == nil && places.count > 0 {
                placesDelegate.places = places
                populateMap(places)
                
                indexCount += places.count
                didChange = true
            }
            
            if placesDelegate.userLocation == nil && userLocation != nil {
                placesDelegate.userLocation = userLocation
                indexCount++
                didChange = true
            }
            
            placesDelegate.predictions = nil
            
            if didChange {
                let currentCount = collectionView.numberOfItemsInSection(0)
                
                collectionView.performBatchUpdates({
                    self.collectionView.deleteItemsAtIndexPaths(self.generateIndexPaths(currentCount))
                    self.collectionView.insertItemsAtIndexPaths(self.generateIndexPaths(indexCount))
                }, completion: nil)
            }
        } else {
            
            let currentLocation = userLocation!.location
            let topLeftCoordinate = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude - 1, longitude: currentLocation!.coordinate.longitude - 1)
            let bottomRightCoordinate = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude + 1, longitude: currentLocation!.coordinate.longitude + 1)
            let bounds = GMSCoordinateBounds(coordinate: topLeftCoordinate, coordinate: bottomRightCoordinate)
            
            placesClient.autocompleteQuery(text, bounds: nil, filter: nil) { (results, error) -> Void in
                
                var data = [GMSAutocompletePrediction]()
                
                if let predictions = results {
                    for prediction in predictions {
                        if let prediction = prediction as? GMSAutocompletePrediction {
                            data.append(prediction)
                        }
                    }
                }
                
                if data.count > 0 {
                    self.headerView.mapView.clear()
                    self.placesDelegate.places = nil
                    self.placesDelegate.userLocation = nil
                    self.placesDelegate.predictions = data
                    
                    let currentCount = self.collectionView.numberOfItemsInSection(0)
                    
                    self.collectionView.performBatchUpdates({
                        self.collectionView.deleteItemsAtIndexPaths(self.generateIndexPaths(currentCount))
                        self.collectionView.insertItemsAtIndexPaths(self.generateIndexPaths(data.count))
                    }, completion: nil)
                }
            }
        }
    }
    
    func generateIndexPaths(count: Int) -> [NSIndexPath] {
        
        var indexPaths = [NSIndexPath]()
        for i in 0..<count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        return indexPaths
    }
}
