//
//  ContactSide.swift
//  YAEngine
//

import Foundation

/// Value that indicates the side of the contact area for entity's collision box.
public enum ContactSide: CaseIterable {
    case top
    case bottom
    case left
    case right
    case unspecified
    
    public static prefix func ! (side: ContactSide) -> ContactSide {
        switch side {
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .left:
            return .right
        case .right:
            return .left
        case .unspecified:
            return .unspecified
        }
    }
}
