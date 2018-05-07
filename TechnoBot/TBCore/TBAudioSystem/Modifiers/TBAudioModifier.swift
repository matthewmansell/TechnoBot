//
//  TBAudioModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Used for controlling modifier factory generation
public enum ModifierIntensity { case low, high
    static func random() -> ModifierIntensity {
        let list = [self.low, self.high]
        return list[Int.random(list.count)]
    }
}

/// Protocol (interface) for which instruments to adhere
public protocol TBAudioModifier {
    /// Must be able to set the input
    func setInput(_ input: AKNode)
    /// Must be able to get the output
    func getOutput() -> AKNode
    /// Must be able to duplicate itself
    func duplicate() -> TBAudioModifier
    /// Must have inbuilt factory
    static func factory(_ intensity: ModifierIntensity) -> TBAudioModifier
}

/// A blank 'passthrough' modifier. Used for empty chain links.
public class TBBlankModifier : TBAudioModifier {
    
    public weak var input = AKNode()
    
    public func setInput(_ input: AKNode) { self.input = input }
    public func getOutput() -> AKNode { return input! }
    public func duplicate() -> TBAudioModifier { return TBBlankModifier() }
    public static func factory(_ intensity: ModifierIntensity) -> TBAudioModifier {
        return TBBlankModifier()
    }
    
    
}
