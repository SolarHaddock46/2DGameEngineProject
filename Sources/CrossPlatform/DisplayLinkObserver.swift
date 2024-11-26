//
//  DisplayLinkObserver.swift
//  YAEngine
//

import Foundation
import QuartzCore

#if os(OSX)
private func displayLinkCallback(displayLink: CVDisplayLink,
                                 _ now: UnsafePointer<CVTimeStamp>,
                                 _ outputTime: UnsafePointer<CVTimeStamp>,
                                 _ flagsIn: CVOptionFlags,
                                 _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                                 _ displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn {
    unsafeBitCast(displayLinkContext, to: DisplayLinkObserver.self).update()
    return kCVReturnSuccess
}
#endif

class DisplayLinkObserver {
    
    var updateHandler: () -> Void = {}
    
    func start() {
        stop()
        #if os(OSX)
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        
        guard let displayLink = displayLink else {
            return
        }
        
        let opaqueSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CVDisplayLinkSetOutputCallback(displayLink, displayLinkCallback, opaqueSelf)
        CVDisplayLinkStart(displayLink)
        #else
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
        #endif
    }
    
    func stop() {
        guard let displayLink = displayLink else {
            return
        }
        
        #if os(OSX)
        CVDisplayLinkStop(displayLink)
        self.displayLink = nil
        #else
        displayLink.remove(from: .main, forMode: .common)
        self.displayLink = nil
        #endif
    }
    
    @objc func update() {
        #if os(OSX)
        DispatchQueue.main.async(execute: updateHandler)
        #else
        updateHandler()
        #endif
    }
    
    // MARK: - Private
    
    #if os(OSX)
    private var displayLink: CVDisplayLink?
    #else
    private var displayLink: CADisplayLink?
    #endif
    
    deinit {
        guard let displayLink = displayLink else { return }
        #if os(OSX)
        CVDisplayLinkStop(displayLink)
        #else
        displayLink.remove(from: .main, forMode: .common)
        #endif
    }
}
