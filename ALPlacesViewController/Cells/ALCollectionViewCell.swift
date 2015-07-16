//
//  ALCollectionViewCell.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/15.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ALCollectionViewCell: UICollectionViewCell {
    static let horizontalPadding: CGFloat = 14
    static let horizontalSpacing: CGFloat = 10
    static let verticalPadding: CGFloat = 8
    static let verticalSpacing: CGFloat = 2
    
    static let nameFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)!
    static let addressFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!
    
    static func cellSize() -> CGSize {
        let height = verticalPadding + nameFont.lineHeight + verticalSpacing + addressFont.lineHeight + verticalPadding
        let width = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(width, height)
    }
    
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let divider = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
    }
}
