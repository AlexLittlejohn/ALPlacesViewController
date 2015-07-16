//
//  ALPlaceCollectionViewCell.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/13.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal class ALPlaceCollectionViewCell: ALCollectionViewCell {
    
    let iconView = UIImageView()
    let iconViewSize = CGSizeMake(30, 30)
    
    override func commonInit() {
        nameLabel.font = ALCollectionViewCell.nameFont
        addressLabel.font = ALCollectionViewCell.addressFont
        
        nameLabel.textColor = UIColor(white: 0.2, alpha: 1)
        addressLabel.textColor = UIColor(white: 0.4, alpha: 1)
        
        nameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addressLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        iconView.contentMode = UIViewContentMode.Center
        iconView.image = UIImage(named: "marker", inBundle: NSBundle(forClass: ALPlacesViewController.self), compatibleWithTraitCollection: nil)
        
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(iconView)
        addSubview(divider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        
        let iconX = ALCollectionViewCell.horizontalPadding
        let iconY = size.height/2 - iconViewSize.height/2
        
        iconView.frame = CGRectMake(iconX, iconY, iconViewSize.width, iconViewSize.height)
        
        let nameX = iconX + iconViewSize.width + ALCollectionViewCell.horizontalSpacing
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
    
    func configureWithPlace(place: ALPlace) {
        nameLabel.text = place.name
        addressLabel.text = place.address
        setNeedsLayout()
    }
}
