//
//  PageIndicatorView.swift
//  glide Demo
//


import YAEngine
import CoreGraphics
import Foundation
import QuartzCore
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class PageIndicatorView: View {
    
    enum Direction {
        case left
        case right
        case up
        case down
        
        var angle: CGFloat {
            var result: CGFloat
            switch self {
            case .left:
                #if os(OSX)
                result = 90
                #else
                result = -90
                #endif
            case .right:
                #if os(OSX)
                result = -90
                #else
                result = 90
                #endif
            case .up:
                result = 0
            case .down:
                result = 180
            }
            return result * CGFloat.pi / 180
        }
    }
    
    let direction: Direction
    
    let images = [Image(imageLiteralResourceName: "arrow_up"), Image(imageLiteralResourceName: "arrow_up_small")]
    #if os(OSX)
    lazy var imageLayer: CALayer = {
        let layer = CALayer()
        let layerImage = Image(imageLiteralResourceName: "arrow_up")
        layer.frame = CGRect(x: 0, y: 0, width: layerImage.size.width, height: layerImage.size.height)
        return layer
    }()
    #else
    lazy var imageView: ImageView = {
        let view = ImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    #endif
    
    init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
        wantsLayer = true
        
        #if os(OSX)
        imageLayer.transform = CATransform3DMakeRotation(direction.angle, 0, 0, 1)
        layer?.addSublayer(imageLayer)
        #else
        imageView.layer.transform = CATransform3DMakeRotation(direction.angle, 0, 0, 1)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        #endif
        
        updateAnimation()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isAnimating: Bool = false {
        didSet {
            updateAnimation()
        }
    }
    
    #if os(OSX)
    override func layoutSubviews() {
        imageLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    #endif
    
    func updateAnimation() {
        if isAnimating {
            #if os(OSX)
            guard imageLayer.animation(forKey: "image") == nil else {
                return
            }
            
            let imageAnimation = CAKeyframeAnimation(keyPath: "contents")
            imageAnimation.values = images
            imageAnimation.calculationMode = .discrete
            imageAnimation.fillMode = .forwards
            imageAnimation.duration = 0.4
            imageAnimation.repeatCount = .infinity
            imageAnimation.autoreverses = false
            imageAnimation.isRemovedOnCompletion = false
            imageAnimation.beginTime = 0.0
            
            imageLayer.add(imageAnimation, forKey: "image")
            #else
            guard imageView.isAnimating == false else {
                return
            }
            
            imageView.animationImages = images
            imageView.animationDuration = 0.4
            imageView.animationRepeatCount = 0
            imageView.startAnimating()
            #endif
        } else {
            #if os(OSX)
            imageLayer.removeAllAnimations()
            #else
            imageView.stopAnimating()
            #endif
        }
    }
    
    func animateSelect() {
        removeAllAnimationsFromLayer()
        let animation = CAAnimation.backgroundColorAnimation(from: backgroundColor ?? .clear,
                                                             to: Color.selectionAnimationDarkerBlueColor,
                                                             middleColor: Color.selectionAnimationBlueColor,
                                                             repeatCount: 2)
        animation.isRemovedOnCompletion = true
        addAnimationToLayer(animation, forKey: "bgColor")
    }
    
}
