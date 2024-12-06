//
//  CheckmarkSelectedView.swift
//  glide Demo
//


import YAEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class CheckmarkSelectedView: ImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = Image(named: "check")
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
