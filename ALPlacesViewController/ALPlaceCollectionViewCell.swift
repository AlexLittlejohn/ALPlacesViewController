//
//  ALPlaceCollectionViewCell.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/13.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit
import GoogleMaps

internal class ALPlaceCollectionViewCell: UICollectionViewCell {

    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let divider = UIView()
    
    static let verticalPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 14
    static let verticalSpacing: CGFloat = 2
    
    static let nameFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)!
    static let boldNameFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)!
    static let addressFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!
    
    var showsAddressLine = true
    
    static func cellSize() -> CGSize {
        
        let height = verticalPadding + nameFont.lineHeight + verticalSpacing + addressFont.lineHeight + verticalPadding
        let width = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(width, height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        nameLabel.font = ALPlaceCollectionViewCell.nameFont
        addressLabel.font = ALPlaceCollectionViewCell.addressFont
        
        nameLabel.textColor = UIColor(white: 0.2, alpha: 1)
        addressLabel.textColor = UIColor(white: 0.4, alpha: 1)
        
        nameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addressLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(divider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        let nameX = ALPlaceCollectionViewCell.horizontalPadding
        let nameY = ALPlaceCollectionViewCell.verticalPadding
        let nameWidth = size.width - ALPlaceCollectionViewCell.horizontalPadding * 2
        let nameHeight = nameLabel.font.lineHeight
        
        nameLabel.frame = CGRectMake(nameX, nameY, nameWidth, nameHeight)
        
        let addressX = nameX
        let addressY = nameY + nameHeight + ALPlaceCollectionViewCell.verticalSpacing
        let addressWidth = nameWidth
        let addressHeight = addressLabel.font.lineHeight
        
        addressLabel.frame = CGRectMake(addressX, addressY, addressWidth, addressHeight)
        
        let dividerX = nameX
        let dividerY = size.height - 1
        let dividerWidth = nameWidth
        let dividerHeight: CGFloat = 1
        
        divider.frame = CGRectMake(dividerX, dividerY, dividerWidth, dividerHeight)
        
        
        if showsAddressLine == false {
            let newNameY = size.height/2 - nameHeight/2
            
            nameLabel.frame.origin.y = newNameY
            addressLabel.hidden = true
        } else {
            addressLabel.hidden = false
        }
    }
    
    func configureWithPlace(place: GMSPlace) {
        showsAddressLine = true
        nameLabel.text = place.name
        addressLabel.text = place.formattedAddress
        setNeedsLayout()
    }
    
    func configureWithLocation(location: ALUserLocation) {
        showsAddressLine = true
        nameLabel.text = "Current location"
        addressLabel.text = location.address
        setNeedsLayout()
    }
    
    func configureWithAutocompletePrediction(prediction: GMSAutocompletePrediction) {
        showsAddressLine = false
        
        var attributedString = NSMutableAttributedString(attributedString: prediction.attributedFullText)
        
        attributedString.enumerateAttribute(kGMSAutocompleteMatchAttribute, inRange: NSMakeRange(0, attributedString.length), options: NSAttributedStringEnumerationOptions.Reverse) { value, range, stop in
            attributedString.addAttribute(NSFontAttributeName, value: ALPlaceCollectionViewCell.boldNameFont, range: range)
        }
        
        nameLabel.attributedText = attributedString
        addressLabel.text = ""
        
        setNeedsLayout()
    }
}
