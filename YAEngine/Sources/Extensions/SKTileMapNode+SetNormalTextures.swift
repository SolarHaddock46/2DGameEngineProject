//
//  SKTileMapNode+SetNormalTextures.swift
//  YAEngine
//

import SpriteKit

public extension SKTileMapNode {
    
    /// Sets generated normal maps for a tile map node.
    /// This is useful to be able to light tile map nodes with entities with a light component.
    func setNormalTextures() {
        for tileGroup in tileSet.tileGroups {
            for rule in tileGroup.rules {
                for definition in rule.tileDefinitions {
                    var normalTextures = [SKTexture]()
                    for texture in definition.textures {
                        let normalTexture = texture.generatingNormalMap(withSmoothness: 0.1, contrast: 0.1)
                        normalTextures.append(normalTexture)
                    }
                    definition.normalTextures = normalTextures
                }
            }
        }
    }
}
