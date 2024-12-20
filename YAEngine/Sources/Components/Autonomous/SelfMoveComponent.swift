//
//  SelfMoveComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity move on its own in the given axes
/// and directions.
/// Has better use cases when combined with another component like
/// `SelfChangeDirectionComponent`.
///
/// Required components (Dependent on the given `movementAxes`)
/// - `HorizontalMovement`
/// - `VerticalMovement`
/// - `CircularMovement`
public final class SelfMoveComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 600
    
    /// Axes on which this component is moving.
    public let movementAxes: MovementAxes
    
    /// Horizontal direction of movement in the last frame.
    public private(set) var previousHorizontalMovementDirection: Direction = .stationary
    
    /// Horizontal direction of movement in the current frame.
    public private(set) var horizontalMovementDirection: Direction = .stationary
    
    /// Vertical direction of movement in the last frame.
    public private(set) var previousVerticalMovementDirection: Direction = .stationary
    
    /// Vertical direction of movement in the current frame.
    public private(set) var verticalMovementDirection: Direction = .stationary
    
    /// Circular direction of movement in the last frame.
    public private(set) var previousCircularDirection: Direction = .stationary
    
    /// Circular direction of movement in the current frame.
    public private(set) var circularDirection: Direction = .stationary
    
    /// Returns the component's movement axes and movement directions in the current
    /// frame.
    public var movementAxesAndDirections: [(MovementAxes, Direction)] {
        var result: [(MovementAxes, Direction)] = []
        for axis in movementAxes {
            if let direction = movementDirection(for: axis) {
                result.append((axis, direction))
            }
        }
        return result
    }
    
    // MARK: - Initialize
    
    /// Create a self move component.
    /// Sets `positive` direction by default for each given axis.
    ///
    /// - Parameters:
    ///     - movementAxes: Axes on which this component is moving.
    public init(movementAxes: MovementAxes) {
        self.movementAxes = movementAxes
        super.init()
        for axis in movementAxes {
            setMovementDirection(.positive, for: axis)
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performMovementIfNeeded()
    }
    
    /// Reverses movement direction on the given axes.
    public func reverseDirection(for axes: MovementAxes) {
        if axes.contains(.horizontal) {
            horizontalMovementDirection = !horizontalMovementDirection
        }
        if axes.contains(.vertical) {
            verticalMovementDirection = !verticalMovementDirection
        }
        if axes.contains(.circular) {
            circularDirection = !circularDirection
        }
    }
    
    /// Movement direction value for the given axes.
    public func movementDirection(for axes: MovementAxes) -> Direction? {
        if axes.contains(.horizontal) {
            return horizontalMovementDirection
        }
        if axes.contains(.vertical) {
            return verticalMovementDirection
        }
        if axes.contains(.circular) {
            return circularDirection
        }
        return nil
    }
    
    /// Sets movement direction to given value for given movement axes.
    public func setMovementDirection(_ direction: Direction, for axes: MovementAxes) {
        if axes.contains(.horizontal) && movementAxes.contains(.horizontal) {
            horizontalMovementDirection = direction
        }
        if axes.contains(.vertical) && movementAxes.contains(.vertical) {
            verticalMovementDirection = direction
        }
        if axes.contains(.circular) && movementAxes.contains(.circular) {
            circularDirection = direction
        }
    }
    
    // MARK: - Private
    
    private func performMovementIfNeeded() {
        if movementAxes.contains(.horizontal) {
            entity?.component(ofType: HorizontalMovementComponent.self)?.movementDirection = horizontalMovementDirection
        }
        
        if movementAxes.contains(.vertical) {
            entity?.component(ofType: VerticalMovementComponent.self)?.movementDirection = verticalMovementDirection
        }
        
        if movementAxes.contains(.circular) {
            switch circularDirection {
            case .stationary:
                entity?.component(ofType: CircularMovementComponent.self)?.movementDirection = .stationary
            case .positive:
                entity?.component(ofType: CircularMovementComponent.self)?.movementDirection = .counterClockwise
            case .negative:
                entity?.component(ofType: CircularMovementComponent.self)?.movementDirection = .clockwise
            }
        }
    }
}

extension SelfMoveComponent: StateResettingComponent {
    public func resetStates() {
        previousHorizontalMovementDirection = horizontalMovementDirection
        previousVerticalMovementDirection = verticalMovementDirection
        previousCircularDirection = circularDirection
    }
}
