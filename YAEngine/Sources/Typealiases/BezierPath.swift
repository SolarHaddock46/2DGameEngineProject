//
//  BezierPath.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSBezierPath
public typealias BezierPathType = NSBezierPath
#else
import UIKit.UIBezierPath
public typealias BezierPathType = UIBezierPath
#endif

open class BezierPath: BezierPathType {
    #if os(OSX)
    open func addCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    open func addLine(to point: CGPoint) {
        line(to: point)
    }
    #endif
}
