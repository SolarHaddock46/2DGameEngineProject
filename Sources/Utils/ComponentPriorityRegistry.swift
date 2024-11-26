//
//  ComponentPriorityRegistry.swift
//  YAEngine
//

import GameplayKit

/// That class is a singleton used to keep a record of the priorities for each
/// `GKComponent` that adopts `GlideComponent`.
public class ComponentPriorityRegistry {
    
    public static var shared = ComponentPriorityRegistry()
    
    /// Returns the registered priority for a given component type.
    ///
    /// - Parameters:
    ///     - componentType: Type of the component to fetch the priority for.
    /// Note that the component of this type should also adopt to `GlideComponent`
    public func priority(for componentType: GKComponent.Type) -> Int {
        for obj in componentTypeToPriority {
            if obj.value.firstIndex(where: { $0 === componentType }) != nil {
                return obj.key
            }
        }
        return 0
    }
    
    /// Prints the registered priorities of component types in the app bundle.
    /// Note that, this works only if `DEBUG` flag is enabled during compile time.
    public func prettyPrintPriorityList() {
        #if DEBUG
        let sorted = componentTypeToPriority.sorted { (left, right) -> Bool in
            return left.key < right.key
        }
        
        for obj in sorted {
            for value in obj.value {
                if let className = NSString(string: "\(value)").utf8String {
                    let result = String(format: "%-50s %d", className, obj.key)
                    print(result)
                }
                
            }
        }
        #endif
    }
    
    // MARK: - Internal
    
    func initializeIfNeeded() {
        initialize()
    }
    
    // MARK: - Private
    
    private var componentTypeToPriority: [Int: [GKComponent.Type]] = [:]
    
    /// Flag to prevent component priority registration more than once.
    private var didInitialize: Bool = false
    
    private init() {
        initialize()
    }
    
    private func initialize() {
        guard didInitialize == false else {
            return
        }
        
        didInitialize = true
        
        func allClassesOfType<R>(_ body: (UnsafeBufferPointer<AnyClass>) throws -> R) rethrows -> R {
            
            var count: UInt32 = 0
            let classListPtr = objc_copyClassList(&count)
            defer {
                free(UnsafeMutableRawPointer(classListPtr))
            }
            let classListBuffer = UnsafeBufferPointer(
                start: classListPtr, count: Int(count)
            )
            
            return try body(classListBuffer)
        }
        
        let componentClasses = allClassesOfType { $0.compactMap { $0 as? GlideComponent.Type } }
        for componentClass in componentClasses {
            if let gkComponentClass = componentClass as? GKComponent.Type {
                setPriority(componentClass.componentPriority, for: gkComponentClass)
            }
        }
    }
    
    private func setPriority(_ priority: Int, for componentType: GKComponent.Type) {
        for obj in componentTypeToPriority {
            if let index = obj.value.firstIndex(where: { $0 === componentType }) {
                var types = obj.value
                types.remove(at: index)
                componentTypeToPriority[obj.key] = types
                break
            }
        }
        
        var types: [GKComponent.Type] = []
        if let existingTypes = componentTypeToPriority[priority] {
            types = existingTypes
        }
        
        types.append(componentType)
        componentTypeToPriority[priority] = types
    }
    
}
