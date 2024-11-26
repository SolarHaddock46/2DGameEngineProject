//
//  ShakerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that adds an entity the ability to reposition its transform
/// with a shake animation. Transform is reset to its original position
/// after shake is done.
/// It is required that transform of the entity of this component has
/// `usesProposedPosition` set to `false`.
public final class ShakerComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 620
    
    /// `true` if there was a shake in the last frame.
    public private(set) var didShake: Bool = false
    
    /// Set to `true` to start shaking in the current frame.
    public var shakes: Bool = false
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Bigger value means that the distance between the subsequent random
        /// positions used for the shake is bigger.
        public var shakeIntensity: CGFloat = 10.0
        
        /// Speed used while approaching the nexst random position used for the shake.
        public var shakeSpeed: CGFloat = 400.0
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a shaker component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = ShakerComponent.sharedConfiguration) {
        self.configuration = configuration
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        performShake(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var originalPosition: CGPoint = .zero
    private var nextShakePosition: CGPoint = .zero
    
    private var randomPosition: CGPoint {
        let shakeIntensity = configuration.shakeIntensity
        let randomX = (CGFloat(GKRandomSource.sharedRandom().nextUniform()) * 2 * shakeIntensity) - shakeIntensity
        let randomY = (CGFloat(GKRandomSource.sharedRandom().nextUniform()) * 2 * shakeIntensity) - shakeIntensity
        return originalPosition + CGPoint(x: randomX, y: randomY)
    }
    
    private func performShake(deltaTime seconds: TimeInterval) {
        guard let transform = transform else {
            return
        }
        guard transform.usesProposedPosition == false else {
            return
        }
        
        if shakes {
            if didShake == false {
                originalPosition = transform.currentPosition
                nextShakePosition = randomPosition
            }
            
            let maximumDelta = configuration.shakeSpeed * CGFloat(seconds)
            
            let currentPosition = transform.currentPosition
            transform.currentPosition = currentPosition.approach(destination: nextShakePosition,
                                                                 maximumDelta: maximumDelta)
            
            let minimumDistanceToChangeShakePosition = configuration.shakeIntensity / 5
            
            if transform.currentPosition.distanceTo(nextShakePosition) < minimumDistanceToChangeShakePosition {
                nextShakePosition = randomPosition
            }
        } else if shakes == false && didShake {
            transform.currentPosition = originalPosition
        }
    }
}

extension ShakerComponent: StateResettingComponent {
    public func resetStates() {
        didShake = shakes
    }
}
