//
//  SlopeContext.swift
//  YAEngine
//

import CoreGraphics

/// Represents information about the member tiles of a slope.
public struct SlopeContext: Equatable {
    
    /// Positions of the tiles which compose a slope.
    public let tilePositions: [TiledPoint]
    
    /// `true` if the slope is declining from left to right.
    public var isInverse: Bool
    
    /// Inclination of the slope.
    public var inclination: Int {
        return tilePositions.count
    }
    
    // MARK: - Initialize
    
    /// Create a slope context with given tile positions.
    ///
    /// - Parameters:
    ///     - tilePositions: Positions of the tiles that compose this slope.
    ///     - isInverse: `true` if the slope is declining from left to right.
    public init?(tilePositions: [TiledPoint], isInverse: Bool) {
        guard
            let leftmostTilePosition = tilePositions.first,
            let rightmostTilePosition = tilePositions.last
            else {
                return nil
        }
        self.leftmostTilePosition = leftmostTilePosition
        self.rightmostTilePosition = rightmostTilePosition
        self.tilePositions = tilePositions
        self.isInverse = isInverse
    }
    
    public static func == (lhs: SlopeContext, rhs: SlopeContext) -> Bool {
        return lhs.leftmostTilePosition == rhs.leftmostTilePosition &&
            lhs.rightmostTilePosition == rhs.rightmostTilePosition &&
            lhs.tilePositions == rhs.tilePositions &&
            lhs.isInverse == rhs.isInverse && lhs.inclination == rhs.inclination
    }
    
    // MARK: - Private
    
    let leftmostTilePosition: TiledPoint
    let rightmostTilePosition: TiledPoint
}
