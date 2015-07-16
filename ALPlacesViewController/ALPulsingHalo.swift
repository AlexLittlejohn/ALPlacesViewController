//
//  ALPulsingHalo.swift
//  ALPlacesViewController
//
//  Created by Alex Littlejohn on 2015/07/16.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

internal class ALPulsingHalo: CALayer {
   
    internal var radius: CGFloat = 60 {
        didSet {
            didSetRadius()
        }
    }
    internal var fromValueForRadius: CGFloat = 0
    internal var fromValueForAlpha: CGFloat = 0.45
    internal var animationDuration: CFTimeInterval = 3
    internal var keyTimeForHalfOpacity: CGFloat = 0.2
    
    private var animationGroup: CAAnimationGroup!
    
    override init() {
        super.init()
        commonInit()
    }

    override init!(layer: AnyObject!) {
        super.init(layer: layer)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(red: 52.0/255.0, green: 183.0/255.0, blue: 250.0/255.0, alpha: 1).CGColor
        contentsScale = UIScreen.mainScreen().scale
        
        didSetRadius()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.setupAnimation()
            dispatch_async(dispatch_get_main_queue()) {
                self.addAnimation(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    func didSetRadius() {
        let temppos = position
        let diameter = radius * 2
        bounds = CGRectMake(0, 0, diameter, diameter)
        cornerRadius = radius
        position = temppos
    }
    
    private func setupAnimation() {
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = Float.infinity
        animationGroup.removedOnCompletion = false
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        var scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = fromValueForRadius
        scaleAnimation.toValue = 1
        scaleAnimation.duration = animationDuration
        
        var opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [fromValueForAlpha, CGFloat(0.45), CGFloat(0)]
        opacityAnimation.keyTimes = [CGFloat(0), keyTimeForHalfOpacity, CGFloat(1)]
        opacityAnimation.removedOnCompletion = false
        
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.delegate = self
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if flag {
            removeAllAnimations()
            removeFromSuperlayer()
        }
    }
}
