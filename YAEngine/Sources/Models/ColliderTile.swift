//
//  ColliderTile.swift
//  YAEngine
//

import SpriteKit

/// Tile types that are recognized as collidable.
/// Use those type values in the `Type` fields of the tiles of your Tiled Map Editor tile sets.
/// If you are using SpriteKit(or a .sks file) to create `SKTileMapNodes`s, use those type
/// values as the names of your `SKTileDefinition`s
/// - ground
/// - one_way
/// - jump_wall_right
/// - jump_wall_left
/// - slope_0_3, slope_4_7, slope_8_11, slope_12_15
/// - slope_15_12, slope_11_8, slope_7_4, slope_3_0
/// - slope_15_8, slope_7_0
/// - slope_0_7, slope_8_15
/// - slope_0_15
/// - slope_15_0
enum ColliderTile: Equatable {
    case ground
    case oneWay
    case slope(fullValue: String)
}

extension ColliderTile {
    static var slopePrefix: String = "slope"
    
    init?(_ value: String) {
        switch value {
        case "ground": self = .ground
        case "one_way": self = .oneWay
        case _ where value.hasPrefix(ColliderTile.slopePrefix): self = .slope(fullValue: value)
        default: return nil
        }
    }
    
    var value: String {
        switch self {
        case .ground:
            return "ground"
        case .oneWay:
            return "one_way"
        case let .slope(fullValue):
            return fullValue
        }
    }
    
    var isGroundOrOneWay: Bool {
        switch self {
        case .ground:
            return true
        case .oneWay:
            return true
        default:
            return false
        }
    }
    
    var isSlope: Bool {
        switch self {
        case .slope:
            return true
        default:
            return false
        }
    }
    
    /// How many empty pixel points there are on the left side of the slope.
    var slopeLeftValue: Int {
        switch self {
        case let .slope(fullValue):
            return Int(fullValue.split(separator: "_")[1]) ?? 0
        default:
            return 0
        }
    }
    
    /// How many empty pixel points there are on the right side of the slope.
    var slopeRightValue: Int {
        switch self {
        case let .slope(fullValue):
            return Int(fullValue.split(separator: "_")[2]) ?? 0
        default:
            return 0
        }
    }
    
    /// Inclination of the slope
    var slopeInclination: Int {
        switch self {
        case let .slope(fullValue):
            switch fullValue {
            case "slope_15_12", "slope_11_8", "slope_7_4", "slope_3_0":
                return 4
            case "slope_12_15", "slope_8_11", "slope_4_7", "slope_0_3":
                return 4
            case "slope_15_8", "slope_7_0":
                return 2
            case "slope_8_15", "slope_0_7":
                return 2
            case "slope_15_0", "slope_0_15":
                return 1
            default:
                return 0
            }
        default:
            return 0
        }
    }
}
