//
//  CAAnimation+BackgroundColorAnimation.swift
//  glide Demo
//


import YAEngine
import QuartzCore

extension CAAnimation {
    static func backgroundColorAnimation(from startColor: Color, to destinationColor: Color, middleColor: Color, repeatCount: Int) -> CAAnimation {
        let firstColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        firstColorAnimation.fromValue = startColor.cgColor
        firstColorAnimation.toValue = middleColor.cgColor
        firstColorAnimation.beginTime = 0.0
        firstColorAnimation.duration = 0.03
        firstColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        firstColorAnimation.isRemovedOnCompletion = false
        firstColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let secondColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        secondColorAnimation.fromValue = middleColor.cgColor
        secondColorAnimation.toValue = destinationColor.cgColor
        secondColorAnimation.beginTime = 0.03
        secondColorAnimation.duration = 0.03
        secondColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        secondColorAnimation.isRemovedOnCompletion = false
        secondColorAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let group = CAAnimationGroup()
        group.repeatCount = Float(repeatCount)
        group.animations = [firstColorAnimation, secondColorAnimation]
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        
        return group
    }
}
