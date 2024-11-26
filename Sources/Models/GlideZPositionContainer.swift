//
//  GlideZPositionContainer.swift
//  YAEngine
//

import Foundation

/// Definitions for default z position container nodes recognized by a `GlideScene`.
public enum GlideZPositionContainer: String, ZPositionContainer {
    case `default`
    case camera
    #if DEBUG
    case debug
    #endif
}
