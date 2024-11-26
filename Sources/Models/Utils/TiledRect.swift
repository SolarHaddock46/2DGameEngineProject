//
//  TiledRect.swift
//  YAEngine
//

import CoreGraphics

/// Rectangle in tile units.
public struct TiledRect: Equatable {
    public var origin: TiledPoint
    public var size: TiledSize
    
    public init(origin: TiledPoint, size: TiledSize) {
        self.origin = origin
        self.size = size
    }
}

extension TiledRect: CustomStringConvertible {
    public var description: String {
        return "origin: \(origin), size: \(size)"
    }
}

extension TiledRect {
    
    /// Returns the CGRect equivalent of the current rect
    /// calculated with given tile size.
    public func rect(with tileSize: CGSize) -> CGRect {
        return CGRect(x: CGFloat(origin.x) * tileSize.width,
                      y: CGFloat(origin.y) * tileSize.height,
                      width: CGFloat(size.width) * tileSize.width,
                      height: CGFloat(size.height) * tileSize.height)
    }
}
