//
//  CameraFocusAreaComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity trigger its scene's camera to zoom on a specified area
/// when contacted with other entities which have `CameraFocusAreaRecognizerComponent`.
public final class CameraFocusAreaComponent: GKComponent, GlideComponent {
    
    /// Frame of the zoom area that will be zoomed when this `CameraFocusAreaComponent`
    /// is triggered.
    public let zoomArea: TiledRect
    
    // MARK: - Initialize
    
    /// Create a camera focus area component.
    ///
    /// - Parameters:
    ///     - zoomArea: Frame of the zoom area that will be zoomed when this
    /// `CameraFocusAreaComponent` is triggered.
    public init(zoomArea: TiledRect) {
        self.zoomArea = zoomArea
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraFocusAreaComponent {
    public func handleNewContact(_ contact: Contact) {
        if contact.otherObject.colliderComponent?.entity?.component(ofType: CameraFocusAreaRecognizerComponent.self) != nil {
            scene?.focusCamera(onFrame: zoomArea)
        }
    }
    
    public func handleFinishedContact(_ contact: Contact) {
        if contact.otherObject.colliderComponent?.entity?.component(ofType: CameraFocusAreaRecognizerComponent.self) != nil {
            scene?.focusCamera(onFrame: nil)
        }
    }
}
