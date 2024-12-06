//
//  OverlayView.swift
//  glide Demo
//


import YAEngine
import CoreGraphics
import Foundation
#if os(OSX)
import AppKit
#endif

class OverlayView: View {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.black.withAlphaComponent(0.5)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        
    }
    #endif
}
