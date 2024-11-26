//
//  TouchInputProfilesOrCallback.swift
//  YAEngine
//

import Foundation

/// Input variant used with `TouchReceiverComponent`.
public enum TouchInputProfilesOrCallback {
    case profiles([(name: String, isNegative: Bool)])
    case callback(() -> Void)
}
