//
//  Lerping.swift
//  YAEngine
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    /// Returns interpolated points from current point to the given destination.
    /// maximumDelta specifies maximum distance between each interpolated point.
    func interpolatedPoints(to destination: CGPoint, maximumDelta: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        let steps = self.numberOfInterpolatedPoints(to: destination, maximumDelta: maximumDelta)
        if steps == 0 {
            return [destination]
        }
        var time: CGFloat = 1.0 / CGFloat(steps)
        for _ in 0..<steps {
            points.append(self.lerp(destination: destination, time: time))
            time += CGFloat(1.0 / CGFloat(steps))
        }
        return points
    }
    
    /// Performs a linear interpolation from current point to the given point.
    func lerp(destination: CGPoint, time: CGFloat) -> CGPoint {
        return self + ((destination - self) * time)
    }
    
    // MARK: - Private
    
    private func numberOfInterpolatedPoints(to destination: CGPoint, maximumDelta: CGFloat) -> Int {
        let yDiff = abs(destination.y - self.y)
        let xDiff = abs(destination.x - self.x)
        var numberOfSteps: Int = 0
        
        if yDiff > xDiff {
            if abs(yDiff) > maximumDelta {
                numberOfSteps = Int(ceil(abs(yDiff) / maximumDelta))
            }
        } else {
            if abs(xDiff) > maximumDelta {
                numberOfSteps = Int(ceil(abs(xDiff) / maximumDelta))
            }
        }
        
        return numberOfSteps
    }
}
