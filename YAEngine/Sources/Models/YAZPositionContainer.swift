//
//  GlideZPositionContainer.swift
//  YAEngine
//

import Foundation

/// Definitions for default z position container nodes recognized by a `GlideScene`.
public enum YAZPositionContainer: String, ZPositionContainer {
    case `default`
    case camera
    #if DEBUG
    case debug
    #endif
}
