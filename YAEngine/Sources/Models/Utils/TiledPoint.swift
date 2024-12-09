//
//  TiledPoint.swift
//  YAEngine
//

import CoreGraphics

/// Point in tile units.
public struct TiledPoint: Equatable {
    public var x: Int
    public var y: Int
    
    public init(_ x: Int, _ y: Int) {
        self.init(x: x, y: y)
    }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension TiledPoint {
    public static var zero: TiledPoint {
        return TiledPoint(0, 0)
    }
}

extension TiledPoint: CustomStringConvertible {
    public var description: String {
        return "x: \(x), y: \(y)"
    }
}

extension TiledPoint {
    
    /// Returns the CGPoint equivalent of the current point
    /// calculated with given tile size.
    public func point(with tileSize: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(x) * tileSize.width,
                       y: CGFloat(y) * tileSize.height)
    }
    
    /// Returns a 1x1 tile frame with the current point at its origin
    /// calculated with given tile size.
    public func singleTiledRect(with tileSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(x) * tileSize.width,
                      y: CGFloat(y) * tileSize.height,
                      width: tileSize.width,
                      height: tileSize.height)
    }
}

/// Adds fields of two tiled points and returns new fields as a new tiled point.
public func + (left: TiledPoint, right: TiledPoint) -> TiledPoint {
    return TiledPoint(left.x + right.x, left.y + right.y)
}

/// Substracts the fields of a tiled point from another and returns new fields as
/// a new tiled point.
public func - (left: TiledPoint, right: TiledPoint) -> TiledPoint {
    return TiledPoint(x: left.x - right.x, y: left.y - right.y)
}
