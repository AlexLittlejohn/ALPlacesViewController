//
//  ALUserCollectionViewCell.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ALUserCollectionViewCell: ALCollectionViewCell {

    let iconView = UIImageView()
    let iconViewSize = CGSizeMake(30, 30)
    let pulsingLayer = ALPulsingHalo()
    
    override func commonInit() {
        nameLabel.font = ALCollectionViewCell.nameFont
        addressLabel.font = ALCollectionViewCell.addressFont
        
        nameLabel.textColor = UIColor(white: 0.2, alpha: 1)
        addressLabel.textColor = UIColor(white: 0.4, alpha: 1)
        
        nameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addressLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        iconView.contentMode = UIViewContentMode.Center
        iconView.image = UIImage(named: "userMarker", inBundle: NSBundle(forClass: ALPlacesViewController.self), compatibleWithTraitCollection: nil)
        
        pulsingLayer.radius = 22
        

        layer.insertSublayer(pulsingLayer, atIndex: 0)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(iconView)
        addSubview(divider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        
        let pulseX = ALCollectionViewCell.horizontalPadding
        let pulseY = size.height/2 - iconViewSize.height/2
        
        iconView.frame = CGRectMake(pulseX, pulseY, iconViewSize.width, iconViewSize.height)
        
        let pulseSize = pulsingLayer.frame.size
        let pulseLayerX = pulseX + (iconViewSize.width/2 - pulseSize.width/2)
        let pulseLayerY = pulseY + (iconViewSize.height/2 - pulseSize.height/2)
        
        pulsingLayer.frame.origin = CGPointMake(pulseLayerX, pulseLayerY)
        
        let nameX = pulseX + iconViewSize.width + ALCollectionViewCell.horizontalSpacing
        let nameY = ALCollectionViewCell.verticalPadding
        let nameWidth = size.width - (ALCollectionViewCell.horizontalPadding * 3 + iconViewSize.width)
        let nameHeight = nameLabel.font.lineHeight
        
        nameLabel.frame = CGRectMake(nameX, nameY, nameWidth, nameHeight)
        
        let addressX = nameX
        let addressY = nameY + nameHeight + ALCollectionViewCell.verticalSpacing
        let addressWidth = nameWidth
        let addressHeight = addressLabel.font.lineHeight
        
        addressLabel.frame = CGRectMake(addressX, addressY, addressWidth, addressHeight)
        
        let dividerX = nameX
        let dividerY = size.height - 1
        let dividerWidth = nameWidth
        let dividerHeight: CGFloat = 1
        
        divider.frame = CGRectMake(dividerX, dividerY, dividerWidth, dividerHeight)
    }
    
    func configureWithLocation(location: ALLocation) {
        nameLabel.text = "Current location"
        addressLabel.text = location.address
        setNeedsLayout()
    }


}
