//
//  SKTexture+NearestFilteringMode.swift
//  YAEngine
//

import SpriteKit

public extension SKTexture {
    
    /// Creates a texture with its `filteringMode` set to `nearest`.
    convenience init(nearestFilteredImageName imageName: String) {
        self.init(imageNamed: imageName)
        self.filteringMode = .nearest
    }
}
