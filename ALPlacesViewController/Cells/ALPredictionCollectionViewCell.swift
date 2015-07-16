//
//  ALPredictionCollectionViewCell.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/16.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ALPredictionCollectionViewCell: UICollectionViewCell {

    static let horizontalPadding: CGFloat = 14
    static let verticalPadding: CGFloat = 14
    
    static let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)!
    
    static func cellSize() -> CGSize {
        
        let height = verticalPadding + font.lineHeight + verticalPadding
        let width = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(width, height)
    }
    
    let predictionLabel = UILabel()
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
        
        predictionLabel.font = ALPredictionCollectionViewCell.font
        predictionLabel.textColor = UIColor(white: 0.2, alpha: 1)
        predictionLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        addSubview(predictionLabel)
        addSubview(divider)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        
        let labelX = ALPredictionCollectionViewCell.horizontalPadding
        let labelY = ALPredictionCollectionViewCell.verticalPadding
        let labelWidth = size.width - ALPredictionCollectionViewCell.horizontalPadding * 2
        let labelHeight = size.height - ALPredictionCollectionViewCell.verticalPadding * 2
        
        predictionLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight)
        
        let dividerX = labelX
        let dividerY = size.height - 1
        let dividerWidth = labelWidth
        let dividerHeight: CGFloat = 1
        
        divider.frame = CGRectMake(dividerX, dividerY, dividerWidth, dividerHeight)
    }
    
    func configureWithPrediction(prediction: ALPrediction) {
        predictionLabel.text = prediction.name
        setNeedsLayout()
    }

    
}
