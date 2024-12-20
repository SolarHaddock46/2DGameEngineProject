//
//  NavigationFocusAnimationView.swift
//  YAEngine Demo
//


import YAEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class NavigationFocusAnimationView: View {
    
    lazy var innerView: View = {
        var view = View()
        view.backgroundColor = Color.clear
        view.wantsLayer = true
        view.borderWidth = innerViewBorderWidth
        return view
    }()
    
    var innerViewBorderWidth: CGFloat {
        #if os(OSX)
        return 5.0
        #elseif os(tvOS)
        return 6.0
        #else
        return 3.0
        #endif
    }
    
    var innerViewBorderWidthIncrease: CGFloat {
        #if os(OSX)
        return 2.0
        #elseif os(tvOS)
        return 3.0
        #else
        return 1.0
        #endif
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        wantsLayer = true
        addSubview(innerView)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animate()
    }
    
    // swiftlint:disable:next function_body_length
    func animate() {
        #if os(OSX)
        guard let innerViewLayer = innerView.layer else {
            return
        }
        #else
        let innerViewLayer = innerView.layer
        #endif
        
        innerView.frame = bounds.insetBy(dx: 3, dy: 3)
        innerViewLayer.removeAllAnimations()
        
        innerView.cornerRadius = 4.0
        innerView.borderWidth = innerViewBorderWidth
        innerView.borderColor = Color.navigationFocusRedBorderColor
        
        let layerBounds = innerViewLayer.bounds
        
        #if os(OSX)
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.autoreverses = true
        
        positionAnimation.fromValue = NSValue(point: innerViewLayer.position)
        positionAnimation.toValue = NSValue(point: innerViewLayer.position + CGPoint(x: -3, y: -3))
        positionAnimation.duration = 0.2
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.fillMode = CAMediaTimingFillMode.forwards
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        #endif
        
        let sizeGrowAnimation = CABasicAnimation(keyPath: "bounds")
        sizeGrowAnimation.autoreverses = true
        #if os(OSX)
        sizeGrowAnimation.fromValue = NSValue(rect: layerBounds)
        sizeGrowAnimation.toValue = NSValue(rect: NSRect(x: layerBounds.origin.x, y: layerBounds.origin.y, width: layerBounds.size.width + 6, height: layerBounds.size.height + 6))
        #else
        sizeGrowAnimation.fromValue = NSValue(cgRect: layerBounds)
        sizeGrowAnimation.toValue = NSValue(cgRect: CGRect(x: layerBounds.origin.x, y: layerBounds.origin.y, width: layerBounds.size.width + 6, height: layerBounds.size.height + 6))
        #endif
        sizeGrowAnimation.duration = 0.2
        sizeGrowAnimation.isRemovedOnCompletion = false
        sizeGrowAnimation.fillMode = CAMediaTimingFillMode.forwards
        sizeGrowAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderAnimation.autoreverses = true
        borderAnimation.fromValue = innerViewBorderWidth
        borderAnimation.toValue = innerViewBorderWidth + innerViewBorderWidthIncrease
        borderAnimation.duration = 0.2
        borderAnimation.isRemovedOnCompletion = false
        borderAnimation.fillMode = CAMediaTimingFillMode.forwards
        borderAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.4
        animationGroup.repeatCount = .infinity
        #if os(OSX)
        animationGroup.animations = [borderAnimation, positionAnimation, sizeGrowAnimation]
        #else
        animationGroup.animations = [borderAnimation, sizeGrowAnimation]
        #endif
        innerViewLayer.add(animationGroup, forKey: "borderWidthAnimation")
    }
    
}
