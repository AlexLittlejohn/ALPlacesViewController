//
//  ALSearchBar.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/14.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

typealias SearchTextDidChangeCallback = (text: String) -> Void
typealias DoneButtonCallback = () -> Void

class ALSearchBar: UIView {

    let searchField = UITextField()
    let searchBackground = UIView()
    let doneButton = UIButton()
    
    var onSearch: SearchTextDidChangeCallback?
    var onDoneButton: DoneButtonCallback?
    
    let searchPadding: CGFloat = 15
    let searchTextHorizontalPadding: CGFloat = 14
    let searchTextVerticalPadding: CGFloat = 4
    let searchHeight: CGFloat = 44
    let statusHeight: CGFloat = 20
    
    let doneButtonSize = CGSizeMake(44, 44)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        searchBackground.backgroundColor = UIColor.whiteColor()
        
        searchField.placeholder = "Search for places"
        searchField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        searchField.clearButtonMode = UITextFieldViewMode.WhileEditing
        searchField.leftView = UIImageView(image: UIImage(named: "search", inBundle: NSBundle(forClass: ALPlacesViewController.self), compatibleWithTraitCollection: nil))
        searchField.leftViewMode = UITextFieldViewMode.Always
        
        addSubview(searchBackground)
        addSubview(searchField)
        addSubview(doneButton)
        
        doneButton.setImage(UIImage(named: "locationPickerDone", inBundle: NSBundle(forClass: ALPlacesViewController.self), compatibleWithTraitCollection: nil), forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "doneTapped", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 4
        
        layoutSearchableState()
    }
    
    func shadowOn() {
        searchBackground.layer.cornerRadius = 4
        searchBackground.layer.shadowOffset = CGSizeMake(0, 2)
        searchBackground.layer.shadowColor = UIColor(white: 0.8, alpha: 1).CGColor
        searchBackground.layer.shadowOpacity = 1
        searchBackground.layer.shadowRadius = 0
    }
    
    func shadowOff() {
        searchBackground.layer.cornerRadius = 0
        searchBackground.layer.shadowOffset = CGSizeMake(0, 1)
        searchBackground.layer.shadowColor = UIColor(white: 0.9, alpha: 1).CGColor
        searchBackground.layer.shadowOpacity = 1
        searchBackground.layer.shadowRadius = 0
    }
    
    func layoutSearchableState() {
        
        let searchWidth = bounds.size.width - searchPadding * 2
        let searchY = searchPadding + statusHeight
        
        searchBackground.frame = CGRectMake(searchPadding, searchY, searchWidth, searchHeight)
        
        let textHeight = searchHeight - searchTextVerticalPadding * 2
        let textWidth = searchWidth - searchTextHorizontalPadding * 2 - doneButtonSize.width
        let textX = searchPadding + searchTextHorizontalPadding
        let textY = statusHeight + searchPadding + searchTextVerticalPadding + 1
        
        searchField.frame = CGRectMake(textX, textY, textWidth, textHeight)
        searchField.alpha = 1
        
        let doneX = textX + textWidth + searchTextHorizontalPadding
        let doneY = searchY
        doneButton.frame = CGRectMake(doneX, doneY, doneButtonSize.width, doneButtonSize.height)
        
        shadowOn()
        
        frame.size.height = textX + textHeight
    }
    
    func layoutScrollingState() {
        let searchWidth = bounds.size.width
        let searchY: CGFloat = 0
        let searchX: CGFloat = 0
        
        searchBackground.frame = CGRectMake(searchY, searchY, searchWidth, statusHeight)
        
        let textHeight = searchHeight - searchTextVerticalPadding * 2
        let textWidth = searchWidth - searchTextHorizontalPadding * 2
        let textX = searchTextHorizontalPadding
        let textY = searchTextVerticalPadding + 1
        
        searchField.frame = CGRectMake(textX, textY, textWidth, textHeight)
        searchField.alpha = 0
        
        shadowOff()
        
        frame.size.height = textX + textHeight
    }
    
    func doneTapped() {
        onDoneButton?()
    }
    
    func textFieldDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            if textField == searchField {
                onSearch?(text: textField.text)
            }
        }
    }
    
}
