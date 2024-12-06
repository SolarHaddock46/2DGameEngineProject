//
//  Font+DemoFonts.swift
//  glide Demo
//


import YAEngine
import CoreGraphics
#if os(iOS)
import UIKit
#endif

extension Font {
    static func headerTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "ExpressionPro", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
    
    static func subheaderTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "m5x7", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
    
    static func descriptionBodyTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "Awake", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
    
    static func actionButtonTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "MatchupPro", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
    
    static func speechBubbleTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "Awake", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
    
    static func gameplayTipTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "EquipmentPro", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
    
    static func gemCountTextFont(ofSize: CGFloat) -> Font {
        return Font(name: "EquipmentPro", size: ofSize) ?? Font.systemFont(ofSize: ofSize)
    }
}

var menuHeaderFontSize: CGFloat {
    #if os(OSX)
    return 52.0
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 48.0
    }
    return 24.0
    #elseif os(tvOS)
    return 64.0
    #endif
}

var levelTitleFontSize: CGFloat {
    #if os(OSX)
    return 32.0
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 32.0
    }
    return 16.0
    #elseif os(tvOS)
    return 64.0
    #endif
}

var actionButtonFontSize: CGFloat {
    #if os(OSX)
    return 64.0
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 48.0
    }
    return 24.0
    #elseif os(tvOS)
    return 64.0
    #endif
}

var descriptionBodyFontSize: CGFloat {
    #if os(OSX)
    return 48.0
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 32.0
    }
    return 24.0
    #elseif os(tvOS)
    return 48.0
    #endif
}

var speechBubbleTextFontSize: CGFloat {
    #if os(OSX)
    return 48.0
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 32.0
    }
    return 24.0
    #elseif os(tvOS)
    return 48.0
    #endif
}

var gameplayTipTextFontSize: CGFloat {
    #if os(OSX)
    return 24.0
    #elseif os(iOS)
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 24.0
    }
    return 16.0
    #elseif os(tvOS)
    return 48.0
    #endif
}

var gemCountTextFontSize: CGFloat {
    return 30.0
}
