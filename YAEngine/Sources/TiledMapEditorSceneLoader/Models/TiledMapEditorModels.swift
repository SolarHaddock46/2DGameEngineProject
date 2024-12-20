//
//  TiledMapEditorLayer.swift
//  YAEngine
//

import SpriteKit

extension TiledMapEditorSceneLoader {
    /// Represents elements of a map file.
    struct Map: Codable {
        let layers: [Layer]
        let tilesets: [TileSetReference]
        let width: Int
        let height: Int
        let tilewidth: Int
        let tileheight: Int
    }
}

extension TiledMapEditorSceneLoader.Map {
    /// Represents a tile map layer in a map file.
    /// Collision tile map should be named `Ground`.
    class Layer: Codable {
        let name: String
        let type: String
        var data: [Int]?
        let properties: [Property]?
        // Tiles
        var width: Int?
        var height: Int?
        // Objects
        let objects: [Object]?
    }
}

extension TiledMapEditorSceneLoader.Map.Layer {
    /// Represents a property of a tile map layer in a map file.
    class Property: Codable {
        let name: String
        let type: String
        let value: Int
    }
    
    /// Represents an object of tile map layer in a map file.
    /// Reserved for future use.
    class Object: Codable {
        let type: String?
        let x: CGFloat
        let y: CGFloat
        let width: Int
        let height: Int
        let properties: [String: String]?
    }
}

extension TiledMapEditorSceneLoader.Map {
    /// Reference in the map file pointing to a tile set file.
    struct TileSetReference: Codable, Equatable {
        
        let source: String
        let firstgid: Int
        
        static func == (lhs: TileSetReference, rhs: TileSetReference) -> Bool {
            return lhs.source == rhs.source
        }
    }
}

extension TiledMapEditorSceneLoader {
    /// Represents a tile set file.
    struct TileSet: Codable {
        let tiles: [Tile]
        var firstGid: Int?
        var source: String?
    }
}

extension TiledMapEditorSceneLoader.TileSet {
    /// Represents a tile in a tile set file.
    struct Tile: Codable {
        let id: Int
        let image: String
        let type: String?
        let properties: [TileProperty]?
    }
}

extension TiledMapEditorSceneLoader.TileSet.Tile {
    /// Represents property of a tile in a tile set file.
    /// Reserved for future use.
    struct TileProperty: Codable {
        let name: String
        let value: Int
    }
}

extension TiledMapEditorSceneLoader {
    /// Represents a tile set that's loaded into a `SKTileSet`
    /// together with additional information about that tile set.
    struct LoadedTileSet {
        let tileSet: SKTileSet
        let tileIdToTileGroupIndex: [Int: Int]
        let range: Range<Int>
        let firstGid: Int
        let source: String?
    }
}
