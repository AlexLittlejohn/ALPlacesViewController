//
//  ALStickyHeaderFlowLayout.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/13.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal class ALStickyHeaderFlowLayout: UICollectionViewFlowLayout {
    
    override var scrollDirection: UICollectionViewScrollDirection {
        get {
            return UICollectionViewScrollDirection.Vertical
        }
        set(newValue) {
            super.scrollDirection = newValue
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let insets = collectionView!.contentInset
        let offset = collectionView!.contentOffset
        let minY = -insets.top
        
        let attributes = super.layoutAttributesForElementsInRect(rect)!
        
        if offset.y < minY {
            let headerSize = headerReferenceSize
            let deltaY = fabs(offset.y - minY)
            
            for item in attributes {
                if let attribute = item as? UICollectionViewLayoutAttributes, elementKind = attribute.representedElementKind {
                    if elementKind == UICollectionElementKindSectionHeader {
                        attribute.frame.size.height = fmax(minY, headerSize.height + deltaY)
                        attribute.frame.origin.y = attribute.frame.origin.y - deltaY
                        break
                    }
                }
            }
        }
        
        return attributes
    }
    
}
