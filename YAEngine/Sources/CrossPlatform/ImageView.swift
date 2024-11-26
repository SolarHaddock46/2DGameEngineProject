//
//  ImageView.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSImageView
public typealias ImageViewType = NSImageView
#else
import UIKit.UIImageView
public typealias ImageViewType = UIImageView
#endif

open class ImageView: ImageViewType {
    #if os(OSX)
    func setSlicedImage(named name: String) {
        imageScaling = .scaleAxesIndependently
        imageAlignment = .alignCenter
        let slicedImage = NSImage(named: NSImage.Name(name))
        slicedImage?.resizingMode = .stretch
        image = slicedImage
    }
    
    #else
    func setSlicedImage(named name: String) {
        image = Image(named: name, in: nil)
    }
    #endif
}
