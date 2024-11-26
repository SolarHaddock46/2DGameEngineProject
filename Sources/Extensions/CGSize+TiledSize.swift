//
//  CGSize+TiledSize.swift
//  YAEngine
//

import CoreGraphics
import SpriteKit

extension CGSize {
    
    /// Returns the tiled size equivalent of the current size
    /// calculated with given tile size.
    public func tiledSize(with tileSize: CGSize) -> TiledSize {
        return TiledSize(width: Int(width / tileSize.width),
                         height: Int(height / tileSize.height))
    }
}
