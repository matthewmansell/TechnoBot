//
//  TBModifierGroup.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Links a number of modifiers into a chain.
public class TBModifierGroup {
    
    private weak var input : AKNode? //Source node
    private var modifiers = [TBAudioModifier]()
    
    public init(_ input: AKNode, slots: Int = 5) {
        self.input = input
        for _ in 0...slots-1 { modifiers.append(TBBlankModifier()) } //Initialise elements
        chainModifiers()
    }
    
    public func setInput(_ input: AKNode) {
        self.input = input
        chainModifiers()
    }
    
    public func setModifier(modifier: TBAudioModifier, slot: Int) {
        modifiers[slot] = modifier
        chainModifiers()
    }
    
    public func removeModifier(slot: Int) {
        modifiers[slot] = TBBlankModifier()
        chainModifiers()
    }
    
    public func removeAll() {
        let count = modifiers.count
        modifiers.removeAll()
        for _ in 0...count-1 { modifiers.append(TBBlankModifier()) }
        chainModifiers()
    }
    
    public func getModifier(slot: Int) -> TBAudioModifier {
        return modifiers[slot]
    }
    
    /// - Returns: Array of idexes of any free slots
    public func getFreeSlots() -> [Int] {
        var free = [Int]()
        for i in 0..<modifiers.count {
            if(modifiers[i] is TBBlankModifier) { free.append(i) }
        }
        return free
    }
    
    public func getOutput() -> AKNode {
        return modifiers.last!.getOutput()
    }
    
    /// Rechains modifier IO
    private func chainModifiers() {
        if(input != nil) {
            for i in 0...modifiers.count-1 {
                if(i == 0) { modifiers[0].setInput(input!) } //First gets source input
                else { modifiers[i].setInput(modifiers[i-1].getOutput()) }
            }
        }
    }
    
    /// Copies this objects setup into another.
    public func copyTo(_ modifierGroup: TBModifierGroup) {
        for i in 0..<modifiers.count {
            if(!(modifiers[i] is TBBlankModifier)) {
                modifierGroup.setModifier(modifier: modifiers[i].duplicate(), slot: i)
            }
        }
    }
}
