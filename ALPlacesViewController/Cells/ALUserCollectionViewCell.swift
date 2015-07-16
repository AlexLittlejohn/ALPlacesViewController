//
//  ALUserCollectionViewCell.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ALUserCollectionViewCell: ALCollectionViewCell {

    let pulsingView = UIView()
    let pulsingViewSize = CGSizeMake(30, 30)
    
    override func commonInit() {
        nameLabel.font = ALCollectionViewCell.nameFont
        addressLabel.font = ALCollectionViewCell.addressFont
        
        nameLabel.textColor = UIColor(white: 0.2, alpha: 1)
        addressLabel.textColor = UIColor(white: 0.4, alpha: 1)
        
        nameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addressLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(pulsingView)
        addSubview(divider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        
        let pulseX = ALCollectionViewCell.horizontalPadding
        let pulseY = size.height/2 - pulsingViewSize.height/2
        
        pulsingView.frame = CGRectMake(pulseX, pulseY, pulsingViewSize.width, pulsingViewSize.height)
        
        let nameX = pulseX + pulsingViewSize.width + ALCollectionViewCell.horizontalSpacing
        let nameY = ALCollectionViewCell.verticalPadding
        let nameWidth = size.width - ALCollectionViewCell.horizontalPadding * 2
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
