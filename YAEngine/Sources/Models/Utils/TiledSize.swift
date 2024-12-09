//
//  TiledSize.swift
//  YAEngine
//

import SpriteKit

/// Size in tile units.
public struct TiledSize: Equatable {
    public var width: Int
    public var height: Int
    
    public init(_ width: Int, _ height: Int) {
        self.init(width: width, height: height)
    }
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

extension TiledSize: CustomStringConvertible {
    public var description: String {
        return "width: \(width), height: \(height)"
    }
}

extension TiledSize {
    
    /// Returns the CGSize equivalent of the current size
    /// calculated with given tile size.
    public func size(with tileSize: CGSize) -> CGSize {
        return CGSize(width: CGFloat(width) * tileSize.width,
                      height: CGFloat(height) * tileSize.height)
    }
    
    /// Returns the CGPoint equivalent of the current size
    /// calculated with given tile size.
    public func toPoint(with tileSize: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(width) * tileSize.width,
                       y: CGFloat(height) * tileSize.height)
    }
}
