//
//  Array+Difference.swift
//  YAEngine
//

import Foundation

extension Array where Element: Hashable {
    
    func difference(from otherArray: [Element]) -> [Element] {
        return Array(Set(self).symmetricDifference(Set(otherArray)))
    }
}
