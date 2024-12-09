//
//  Font+DemoFonts.swift
//  YAEngine Demo
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
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 48.0
    }
    return 24.0
}

var levelTitleFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 32.0
    }
    return 16.0
}

var actionButtonFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 48.0
    }
    return 24.0
}

var descriptionBodyFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 32.0
    }
    return 24.0
}

var speechBubbleTextFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 32.0
    }
    return 24.0
}

var gameplayTipTextFontSize: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 24.0
    }
    return 16.0
}

var gemCountTextFontSize: CGFloat {
    return 30.0
}
