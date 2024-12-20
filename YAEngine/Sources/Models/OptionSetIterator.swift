//
//  OptionSetIterator.swift
//  YAEngine
//

import Foundation

/// From https://stackoverflow.com/questions/32102936/how-do-you-enumerate-optionsettype-in-swift
public struct OptionSetIterator<Element: OptionSet>: IteratorProtocol where Element.RawValue == Int {
    private let value: Element
    
    public init(element: Element) {
        self.value = element
    }
    
    private lazy var remainingBits = value.rawValue
    private var bitMask = 1
    
    public mutating func next() -> Element? {
        while remainingBits != 0 {
            defer { bitMask = bitMask &* 2 }
            if remainingBits & bitMask != 0 {
                remainingBits = remainingBits & ~bitMask
                return Element(rawValue: bitMask)
            }
        }
        return nil
    }
}

extension OptionSet where Self.RawValue == Int {
    public func makeIterator() -> OptionSetIterator<Self> {
        return OptionSetIterator(element: self)
    }
}
