//
//  GlideEntity+TouchInput.swift
//  YAEngine
//

#if os(iOS)
import GameplayKit
import UIKit

extension GlideEntity {
    
    private typealias TouchReceiver = TouchReceiverComponent & GlideComponent & GKComponent
    
    func touchesBegan(_ touches: Set<UITouch>) {
        sortedComponents.forEach {
            if let touchReceiver = $0 as? TouchReceiver {
                touchReceiver.touchesBegan(touches)
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>) {
        sortedComponents.forEach {
            if let touchReceiver = $0 as? TouchReceiver {
                touchReceiver.touchesMoved(touches)
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, isCancelled: Bool) {
        sortedComponents.forEach {
            if let touchReceiver = $0 as? TouchReceiver {
                touchReceiver.touchesEnded(touches, isCancelled: isCancelled)
            }
        }
    }
}
#endif
