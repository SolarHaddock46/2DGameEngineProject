//
//  SKAction+TextureAnimation.swift
//  YAEngine
//

import SpriteKit

public extension SKAction {
    
    /// Creates an `SKAction` with given animation values.
    ///
    /// - Parameters:
    ///     - textureFormat: Common format for the names of the texture image files. This
    /// format should allow placing an integer in the texture name.
    ///     - numberOfFrames: Number of texture images to be indexed from 0 to this value. Or in
    /// reverse order if `isReverse` is `true`.
    ///     - timePerFrame: Time per frame of animation in seconds.
    ///     - loops: `true` if the animation should repeat forever.
    ///     - isReverse: `true` if the textures should be placed in reverse order.
    ///     - textureAtlas: Texture atlas in which to look for texture images. Default value is `nil`.
    class func textureAnimation(textureFormat: String,
                                numberOfFrames: Int,
                                timePerFrame: TimeInterval,
                                loops: Bool,
                                isReverse: Bool = false,
                                textureAtlas: SKTextureAtlas? = nil,
                                shouldGenerateNormalMaps: Bool = false) -> SKAction {
        var textures: [SKTexture] = []
        var strided = stride(from: 0, through: numberOfFrames - 1, by: 1)
        if isReverse {
            strided = stride(from: numberOfFrames - 1, through: 0, by: -1)
        }
        for index in strided {
            let textureName = String(format: textureFormat, index)
            var texture: SKTexture
            if let textureAtlas = textureAtlas {
                texture = textureAtlas.textureNamed(textureName)
            } else {
                texture = SKTexture(imageNamed: textureName)
            }
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        return textureAnimation(textures: textures,
                                timePerFrame: timePerFrame,
                                loops: loops,
                                shouldGenerateNormalMaps: shouldGenerateNormalMaps)
    }
    
    /// Creates an `SKAction` with given animation values.
    ///
    /// - Parameters:
    ///     - textureFormat: Common format for the names of the texture image files. This
    /// format should allow placing an integer in the texture name.
    ///     - range: Range of the indices to be used with the given texture format.
    ///     - timePerFrame: Time per frame of animation in seconds.
    ///     - loops: `true` if the animation should repeat forever.
    ///     - textureAtlas: Texture atlas in which to look for texture images. Default value is `nil`.
    class func textureAnimation(textureFormat: String,
                                range: NSRange,
                                timePerFrame: TimeInterval,
                                loops: Bool,
                                textureAtlas: SKTextureAtlas? = nil,
                                shouldGenerateNormalMaps: Bool = false) -> SKAction {
        var textures: [SKTexture] = []
        var strided = stride(from: range.location, through: range.location + range.length - 1, by: 1)
        if range.length < 0 {
            strided = stride(from: range.location, through: range.location + range.length + 1, by: -1)
        }
        for index in strided {
            let textureName = String(format: textureFormat, index)
            var texture: SKTexture
            if let textureAtlas = textureAtlas {
                texture = textureAtlas.textureNamed(textureName)
            } else {
                texture = SKTexture(imageNamed: textureName)
            }
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        
        return textureAnimation(textures: textures,
                                timePerFrame: timePerFrame,
                                loops: loops,
                                shouldGenerateNormalMaps: shouldGenerateNormalMaps)
    }
    
    /// Creates an `SKAction` with given animation values.
    ///
    /// - Parameters:
    ///     - textureFormat: Common format for the names of the texture image files. This
    /// format should allow placing an integer in the texture name.
    ///     - indexSet: Indices to be used with the given texture format.
    ///     - timePerFrame: Time per frame of animation in seconds.
    ///     - loops: `true` if the animation should repeat forever.
    ///     - textureAtlas: Texture atlas in which to look for texture images. Default value is `nil`.
    class func textureAnimation(textureFormat: String,
                                indexSet: [Int],
                                timePerFrame: TimeInterval,
                                loops: Bool,
                                textureAtlas: SKTextureAtlas? = nil,
                                shouldGenerateNormalMaps: Bool = false) -> SKAction {
        var textures: [SKTexture] = []
        for index in indexSet {
            let textureName = String(format: textureFormat, index)
            var texture: SKTexture
            if let textureAtlas = textureAtlas {
                texture = textureAtlas.textureNamed(textureName)
            } else {
                texture = SKTexture(imageNamed: textureName)
            }
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        
        return textureAnimation(textures: textures,
                                timePerFrame: timePerFrame,
                                loops: loops,
                                shouldGenerateNormalMaps: shouldGenerateNormalMaps)
    }
    
    /// Creates an `SKAction` with given animation values.
    private class func textureAnimation(textures: [SKTexture],
                                        timePerFrame: TimeInterval,
                                        loops: Bool,
                                        textureAtlas: SKTextureAtlas? = nil,
                                        shouldGenerateNormalMaps: Bool = false) -> SKAction {
        let action: SKAction
        if shouldGenerateNormalMaps {
            let normalTextures = textures.map { $0.generatingNormalMap(withSmoothness: 0.1, contrast: 0.1) }
            action = SKAction.group([SKAction.animate(with: textures, timePerFrame: timePerFrame), SKAction.animate(withNormalTextures: normalTextures, timePerFrame: timePerFrame)])
        } else {
            action = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        }
        
        if loops {
            return SKAction.repeatForever(action)
        } else {
            return action
        }
    }
}
