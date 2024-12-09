//
//  Color+DemoColors.swift
//  YAEngine Demo
//


import YAEngine

extension Color {
    static var defaultTextColor: Color {
        return Color.black
    }
    
    static var mainBackgroundColor: Color {
        return Color(red: 178/255, green: 220/255, blue: 239/255, alpha: 1.0)
    }
    
    static var hudBackgroundColor: Color {
        return Color(red: 178/255, green: 220/255, blue: 239/255, alpha: 1.0)
    }
    
    static var levelThumbBackgroundColor: Color {
        return Color(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
    }
    
    static var touchHighlightColor: Color {
        return Color(red: 41/255, green: 112/255, blue: 164/255, alpha: 1.00)
    }
    
    static var selectionAnimationBlueColor: Color {
        return Color(red: 49/255, green: 162/255, blue: 242/255, alpha: 1.00)
    }
    
    static var selectionAnimationDarkerBlueColor: Color {
        return Color(red: 41/255, green: 112/255, blue: 164/255, alpha: 1.00)
    }
    
    static var navigationFocusRedBorderColor: Color {
        return Color(red: 0, green: 73/255, blue: 132/255, alpha: 1.00)
    }
    
    static var backButtonTextColor: Color {
        return Color.white
    }
    
    static var backButtonBackgroundColor: Color {
        return Color.clear
    }
}
