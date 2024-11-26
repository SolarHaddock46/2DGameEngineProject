//
//  GCController+DeviceHash.swift
//  YAEngine
//

import GameController

extension GCController {
    var deviceHash: String? {
        if let rangeOfDeviceHash = debugDescription.range(of: "deviceHash=") {
            let beginIndex = rangeOfDeviceHash.upperBound
            if let rangeOfEndBracket = debugDescription.range(of: ">") {
                let endIndex = rangeOfEndBracket.lowerBound
                
                let range = Range(uncheckedBounds: (lower: beginIndex, upper: endIndex))
                let result = String(debugDescription[range])
                return result
            }
        }
        return nil
    }
}
