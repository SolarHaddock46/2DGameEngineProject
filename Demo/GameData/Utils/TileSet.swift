//
//  DemoTileSet.swift
//  YAEngine Demo
//


import SpriteKit

class TileSet {
    static func horizontalPlatformsTileSet() -> SKTileSet {
        var tileGroups: [SKTileGroup] = []
        tileGroups.append(TileSet.tileGroup(with: "plat_left"))
        tileGroups.append(TileSet.tileGroup(with: "plat_middle"))
        tileGroups.append(TileSet.tileGroup(with: "plat_right"))
        return SKTileSet(tileGroups: tileGroups)
    }
    
    static func verticalPlatformsTileSet() -> SKTileSet {
        var tileGroups: [SKTileGroup] = []
        tileGroups.append(TileSet.tileGroup(with: "plat_top"))
        tileGroups.append(TileSet.tileGroup(with: "plat_middle_vertical"))
        tileGroups.append(TileSet.tileGroup(with: "plat_bottom"))
        return SKTileSet(tileGroups: tileGroups)
    }
    
    static func tileGroup(with textureName: String) -> SKTileGroup {
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = .nearest
        let tileDefinition = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        return tileGroup
    }
}
