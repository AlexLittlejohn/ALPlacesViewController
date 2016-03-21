//
//  ALSearchBar.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/14.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal typealias SearchTextDidChangeCallback = (text: String) -> Void
internal typealias DoneButtonCallback = () -> Void

internal class ALSearchBar: UIView {

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
    
    required init?(coder aDecoder: NSCoder) {
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
        
        doneButton.setTitle(LocalizedString("search.done"), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "doneTapped", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        doneButton.backgroundColor = UIColor(red: 52.0/255.0, green: 183.0/255.0, blue: 250.0/255.0, alpha: 1)
        doneButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 6, 10)
        
        doneButton.layer.cornerRadius = 4
        doneButton.layer.shadowOffset = CGSizeMake(0, 2)
        doneButton.layer.shadowColor = UIColor(red: 41.0/255.0, green: 146.0/255.0, blue: 200.0/255.0, alpha: 1).CGColor
        doneButton.layer.shadowOpacity = 1
        doneButton.layer.shadowRadius = 0
        
        doneButton.sizeToFit()
        
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
        let textWidth = searchWidth - searchTextHorizontalPadding * 2 - doneButton.frame.size.width - searchTextHorizontalPadding/2
        let textX = searchPadding + searchTextHorizontalPadding
        let textY = statusHeight + searchPadding + searchTextVerticalPadding + 1
        
        searchField.frame = CGRectMake(textX, textY, textWidth, textHeight)
        searchField.alpha = 1
        
        let doneX = textX + textWidth + searchTextHorizontalPadding
        let doneY = textY + (textHeight/2 - doneButton.frame.size.height/2) - 1
        doneButton.frame.origin = CGPointMake(doneX, doneY)
        
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
        searchField.resignFirstResponder()
        
        shadowOff()
        
        frame.size.height = textX + textHeight
    }
    
    internal func doneTapped() {
        onDoneButton?()
    }
    
    internal func textFieldDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            if textField == searchField {
                onSearch?(text: textField.text)
            }
        }
    }
    
}
