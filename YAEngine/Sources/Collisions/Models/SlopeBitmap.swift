//
//  SlopeBitmap.swift
//  YAEngine
//

import CoreGraphics

/// Functions for calculations on slope bitmap data.
class SlopeBitmap {
    
    /// Returns how many vertical bits there are starting from a given point on slope
    /// to the top of the slope.
    static func slopeContactOffset(for bitmapIntersection: TiledPoint,
                                   slopeValue: (left: Int, right: Int)) -> CGFloat {
        guard let bitmap = bitmapFor(slopeValues: (left: slopeValue.left, right: slopeValue.right)) else {
            return 0
        }
        let pointWithMaxY = slopePointWithMaxY(at: bitmapIntersection.x, in: bitmap)
        let offset = pointWithMaxY.y - bitmapIntersection.y
        return CGFloat(offset)
    }
    
    /// Returns the y position at topmost corresponding to a given x value on a slope.
    static func slopePointWithMaxY(at xPosition: Int, in bitmap: [TiledPoint]) -> TiledPoint {
        return bitmap.filter { $0.x == xPosition }.sorted { (point1, point2) -> Bool in
            if point1.y > point2.y {
                return true
            }
            return false
            }.first ?? TiledPoint(0, 0)
    }
    
    /// Returns bitmap data for given left and right values of a slope.
    // swiftlint:disable:next cyclomatic_complexity
    static func bitmapFor(slopeValues: (left: Int, right: Int)) -> [TiledPoint]? {
        switch slopeValues {
        case (15, 0):
            return slope15And0Bitmap
        case (0, 15):
            return slope0And15Bitmap
        case (15, 12):
            return slope15And12Bitmap
        case (11, 8):
            return slope11And8Bitmap
        case (7, 4):
            return slope7And4Bitmap
        case (3, 0):
            return slope3And0Bitmap
        case (12, 15):
            return slope12And15Bitmap
        case (8, 11):
            return slope8And11Bitmap
        case (4, 7):
            return slope4And7Bitmap
        case (0, 3):
            return slope0And3Bitmap
        case (15, 8):
            return slope15And8Bitmap
        case (7, 0):
            return slope7And0Bitmap
        case (8, 15):
            return slope8And15Bitmap
        case (0, 7):
            return slope0And7Bitmap
        default:
            return nil
        }
    }
}
