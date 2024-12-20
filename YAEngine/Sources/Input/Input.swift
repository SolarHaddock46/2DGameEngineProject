//
//  Input.swift
//  YAEngine
//

import CoreGraphics
import Foundation
import GameController
import SpriteKit

/// Represents a controller class for all kinds of input events.
public class Input {
    /// Shared instance of input events controller.
    public static var shared = Input()
    
    /// Represents currently recognized input method.
    public private(set) var inputMethod: InputMethod = .native {
        didSet {
            NotificationCenter.default.post(name: .InputMethodDidChange,
                                            object: self,
                                            userInfo: ["method": inputMethod])
            flushInputs()
        }
    }
    
    /// Current mouse position in screen coordinates.
    public internal(set) var mousePosition: CGPoint = .zero
    
    /// Returns input profile with the given name.
    public func profileValue(_ named: String) -> CGFloat {
        let selectedProfile = inputProfiles.first { $0.name == named }
        guard let profile = selectedProfile else {
            return 0.0
        }
        
        if profile.name == "Mouse X" {
            return mouseDeltaSnapshot.x * profile.sensitivity
        } else if profile.name == "Mouse Y" {
            return mouseDeltaSnapshot.y * profile.sensitivity
        }
        return profile.value
    }
    
    /// Returns `true` if an input profile with given name contains
    /// keys that are pressed in the current frame.
    public func isButtonPressed(_ profileName: String) -> Bool {
        let buttonProfiles = inputProfiles.filter { $0.name == profileName }
        return buttonProfiles.filter { profile in
            profile.isPressed()
            }.isEmpty == false
    }
    
    /// Returns `true` if an input profile with given name contains
    /// keys that were hold down since the previous frame.
    public func isButtonHoldDown(_ profileName: String) -> Bool {
        let buttonProfiles = inputProfiles.filter { $0.name == profileName }
        return buttonProfiles.filter { profile in
            profile.isHoldDown()
            }.isEmpty == false
    }
    
    /// Returns `true` if an input profile with given name contains
    /// keys that were pressed in the previous frame but released
    /// in the current frame.
    public func isButtonReleased(_ profileName: String) -> Bool {
        let buttonProfiles = inputProfiles.filter { $0.name == profileName }
        return buttonProfiles.filter { profile in
            profile.isReleased()
            }.isEmpty == false
    }
    
    /// Cleans up all cached information about previous key presses and mouse positions.
    /// Comes in handy for example when displaying a new game menu after another.
    public func flushInputs() {
        keysSnapshot = []
        previousKeysSnapshot = []
        pressedKeys = []
        inputProfiles.forEach { $0.flushInputs() }
        mouseDeltaSnapshot = .zero
        mouseDelta = .zero
    }
    
    /// Adds given input profile to the list of profiles controlled by this input controller.
    /// Does nothing if a profile with given name already exists.
    public func addInputProfile(_ profile: InputProfile) {
        let existingProfileIndex = inputProfiles.firstIndex { $0.name == profile.name }
        if existingProfileIndex != nil {
            return
        }
        inputProfiles.append(profile)
    }
    
    /// Removes profiles with a given name from the list of profiles controlled by this input
    /// controller.
    public func removeInputProfilesNamed(_ named: String) {
        if let index = inputProfiles.firstIndex(where: { $0.name == named }) {
            inputProfiles.remove(at: index)
        }
    }
    
    /// Returns `true` if the given key code is pressed in the current frame.
    public func isPressed(_ keyCode: KeyCode) -> Bool {
        return keysSnapshot.contains { $0.keyCode == keyCode } &&
            previousKeysSnapshot.contains { $0.keyCode == keyCode } == false
    }
    
    /// Returns `true` if the given key code were hold down since the previous
    /// frame.
    public func isHoldDown(_ keyCode: KeyCode) -> Bool {
        return keysSnapshot.contains { $0.keyCode == keyCode }
    }
    
    /// Returns `true` if the given key code was pressed in the previous frame
    /// but released in the current frame.
    public func isReleased(_ keyCode: KeyCode) -> Bool {
        return keysSnapshot.contains { $0.keyCode == keyCode } == false &&
            previousKeysSnapshot.contains { $0.keyCode == keyCode }
    }
    
    // MARK: - Private
    
    private var currentTime: UInt64 = 0
    private let numer: UInt64
    private let denom: UInt64
    
    private var pressedKeys: [Input.KeyPressContext] = []
    private var previousKeysSnapshot: [Input.KeyPressContext] = []
    private var keysSnapshot: [Input.KeyPressContext] = []
    
    // Mouse
    var mouseDelta: CGPoint = .zero
    var mouseDeltaSnapshot: CGPoint = .zero
    
    // Game controller
    let gameControllerObserver = GameControllerObserver()
    
    var availableControllerPlayerIndices: [Int] = Array(0..<9)
    var connectedControllerPlayerIndices: [Int] = []
    
    // GCController
    var availableGCControllerPlayerIndices = [GCControllerPlayerIndex.index1,
                                              GCControllerPlayerIndex.index2,
                                              GCControllerPlayerIndex.index3,
                                              GCControllerPlayerIndex.index4]
    var connectedGCControllerPlayerIndices: [GCControllerPlayerIndex: Int] = [:]
    
    var connectedGCControllers: [GCController] = [] {
        didSet {
            updateInputMethod()
        }
    }
    
    var connectedKeyboard: GCKeyboard? {
        didSet {
            updateInputMethod()
        }
    }
    
    var connectedMouse: GCMouse? {
        didSet {
            updateInputMethod()
        }
    }
    
    private init() {
        var info = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&info)
        numer = UInt64(info.numer)
        denom = UInt64(info.denom)
    }
    
    func updateInputMethod() {
        var hasCustomControllers: Bool = false
        if connectedGCControllers.isEmpty && hasCustomControllers == false {
            inputMethod = .native
        } else {
            inputMethod = .gameController
        }
    }
    
    func update() {
        currentTime = mach_absolute_time()
        keysSnapshot = pressedKeys
        mouseDeltaSnapshot = mouseDelta
        inputProfiles.forEach { $0.update() }
    }
    
    func reset() {
        previousKeysSnapshot = keysSnapshot
        keysSnapshot = []
        mouseDeltaSnapshot = .zero
        inputProfiles.forEach { $0.reset() }
    }
    
    func addKey(_ keyCode: KeyCode, value: Float? = nil, profileName: String? = nil, removeAtNextUpdate: Bool = false) {
        removeKeyForRepeatedPress(keyCode, profileName: profileName)
        let currentTime = mach_absolute_time()
        let context = Input.KeyPressContext(keyCode: keyCode, value: value, precisePressTime: currentTime)
        pressedKeys.append(context)
        
        if let profileName = profileName {
            inputProfiles.filter { $0.name == profileName }.forEach { $0.addKey(context: context, removeAtNextUpdate: removeAtNextUpdate) }
        } else {
            inputProfiles.forEach { $0.addKey(context: context, removeAtNextUpdate: removeAtNextUpdate) }
        }
    }
    
    func removeKeyForRepeatedPress(_ keyCode: KeyCode, profileName: String? = nil) {
        if let index = pressedKeys.firstIndex(where: { $0.keyCode == keyCode }) {
            pressedKeys.remove(at: index)
        }
        
        if let profileName = profileName {
            inputProfiles.filter { $0.name == profileName }.forEach { $0.removeKeyForRepeatedPress(keyCode: keyCode) }
        } else {
            inputProfiles.forEach { $0.removeKeyForRepeatedPress(keyCode: keyCode) }
        }
    }
    
    func removeKey(_ keyCode: KeyCode, profileName: String? = nil) {
        if let index = pressedKeys.firstIndex(where: { $0.keyCode == keyCode }) {
            pressedKeys.remove(at: index)
        }
        
        if let profileName = profileName {
            inputProfiles.filter { $0.name == profileName }.forEach { $0.removeKey(keyCode: keyCode) }
        } else {
            inputProfiles.forEach { $0.removeKey(keyCode: keyCode) }
        }
    }
}

extension Input {
    struct KeyPressContext {
        let keyCode: KeyCode
        let value: Float?
        let precisePressTime: UInt64
    }
}
