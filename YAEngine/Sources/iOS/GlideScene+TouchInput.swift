//
//  GlideScene+TouchInput.swift
//  YAEngine
//

#if os(iOS)
import UIKit

extension GlideScene {
    // MARK: - Touches
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        entities.forEach { $0.touchesBegan(touches) }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        entities.forEach { $0.touchesMoved(touches) }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        entities.forEach { $0.touchesEnded(touches, isCancelled: true) }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        entities.forEach { $0.touchesEnded(touches, isCancelled: false) }
    }
}
#endif
