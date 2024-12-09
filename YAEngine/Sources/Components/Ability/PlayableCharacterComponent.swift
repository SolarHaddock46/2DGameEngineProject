//
//  PlayableCharacterComponent.swift
//  YAEngine
//

import GameplayKit

/// Coordinates the transfer of input profile values to different ability
/// components based on given player index.
///
/// Controlled components:
/// - `JumpComponent`
/// - `WallJumpComponent`
/// - `HorizontalMovementComponent`
/// - `ProjectileShooterComponent`
/// - `LadderClimberComponent`
/// - `SwingHolderComponent`
/// - `DasherComponent`
/// - `ColliderComponent`
/// - `ParagliderComponent`
/// - `CroucherComponent`
/// - `JetpackOperatorComponent`
/// - `SwingHolderComponent`
public final class PlayableCharacterComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 640
    
    /// Index of the player to be used to pair the component with input profiles.
    public let playerIndex: Int
    
    // CameraFocusingComponent
    public var focusOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a playable character component.
    ///
    /// - Parameters:
    ///     - playerIndex: Index of the player to be used to pair the component with
    /// input profiles.
    public init(playerIndex: Int) {
        self.playerIndex = playerIndex
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        handleProjectileShooting()
        handleHeadingDirection()
        handleVerticalMove()
        handleHorizontalMove()
    }
    
    // MARK: - Private
    
    /// Value of when the input jump button was pressed the last time.
    /// Used to control serial jumps.
    private var lastJumpPressTime: TimeInterval = 0
    
    /// `true` if jump input profile is being continuously captured since the last frame.
    /// Used to control early jump release for faster falling.
    private var holdingDownInitialJumpPress: Bool = false
    
    private var shouldGroundJump: Bool {
        guard let jumpComponent = entity?.component(ofType: JumpComponent.self) else {
            return false
        }
        return isButtonPressed(for: "Jump") && jumpComponent.canJump
    }
    
    private func shouldSerialGroundJump(at currentTime: TimeInterval) -> Bool {
        guard let jumpComponent = entity?.component(ofType: JumpComponent.self) else {
            return false
        }
        return isButtonHoldDown(for: "Jump") &&
            jumpComponent.canJump &&
            holdingDownInitialJumpPress == false &&
            currentTime - lastJumpPressTime <= jumpComponent.configuration.serialJumpThreshold
    }
    
    private func handleJumping() {
        if isButtonPressed(for: "Jump") {
            lastJumpPressTime = currentTime ?? 0
        }
        
        let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self)
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        
        let shouldJump = shouldGroundJump || shouldSerialGroundJump(at: currentTime ?? 0)
        
        if shouldJump {
            jumpComponent?.jumps = true
        }
    }
    
    private func handleVerticalMove() {
        let verticalProfile = profile(for: "Vertical")
        
        if let verticalMovement = entity?.component(ofType: VerticalMovementComponent.self) {
            if verticalProfile < 0 {
                verticalMovement.movementDirection = .negative
            } else if verticalProfile > 0 {
                verticalMovement.movementDirection = .positive
            } else {
                verticalMovement.movementDirection = .stationary
            }
        }
        
        handleJumping()
    }
    
    private func handleProjectileShooting() {
        if isButtonPressed(for: "Shoot") {
            entity?.component(ofType: ProjectileShooterComponent.self)?.shoots = true
        }
    }
    
    private func handleHeadingDirection() {
        let horizontalProfile = profile(for: "Horizontal")
        if horizontalProfile < 0 {
            transform?.headingDirection = .left
        } else if horizontalProfile > 0 {
            transform?.headingDirection = .right
        }
    }
    
    private func handleHorizontalMove() {
        guard let horizontalMovement = entity?.component(ofType: HorizontalMovementComponent.self) else {
            return
        }
        
        let horizontalProfile = profile(for: "Horizontal")
        
        if horizontalProfile < 0 {
            horizontalMovement.movementDirection = .negative
        } else if horizontalProfile > 0 {
            horizontalMovement.movementDirection = .positive
        } else {
            horizontalMovement.movementDirection = .stationary
        }
    }

    
    // MARK: - Input
    
    private func playerInputProfileName(_ baseProfileName: String) -> String {
        return "Player\((playerIndex + 1))_" + baseProfileName
    }
    
    private func isButtonPressed(for baseProfileName: String) -> Bool {
        guard (entity as? YAEntity)?.shouldBlockInputs == false else {
            return false
        }
        
        return Input.shared.isButtonPressed(playerInputProfileName(baseProfileName))
    }
    
    private func isButtonHoldDown(for baseProfileName: String) -> Bool {
        guard (entity as? YAEntity)?.shouldBlockInputs == false else {
            return false
        }
        
        return Input.shared.isButtonHoldDown(playerInputProfileName(baseProfileName))
    }
    
    private func isButtonReleased(for baseProfileName: String) -> Bool {
        guard (entity as? YAEntity)?.shouldBlockInputs == false else {
            return false
        }
        
        return Input.shared.isButtonReleased(playerInputProfileName(baseProfileName))
    }
    
    private func profile(for baseProfileName: String) -> CGFloat {
        guard (entity as? YAEntity)?.shouldBlockInputs == false else {
            return 0.0
        }
        
        return Input.shared.profileValue(playerInputProfileName(baseProfileName))
    }
}

extension PlayableCharacterComponent: CameraFocusingComponent {}
