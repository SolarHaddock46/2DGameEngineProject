//
//  CGRect+TiledRect.swift
//  YAEngine
//

import CoreGraphics

extension CGRect {
    
    /// Returns the tiled rect equivalent of the current rect
    /// calculated with given tile size.
    public func tiledRect(with tileSize: CGSize) -> TiledRect {
        return TiledRect(origin: origin.tiledPoint(with: tileSize),
                         size: size.tiledSize(with: tileSize))
    }
}
