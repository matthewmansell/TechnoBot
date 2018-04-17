//
//  TBModifierGroup.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/**
 Links a number of modifiers into a chain.
 */
public class TBModifierGroup {
    
    private var input : AKNode
    private var modifiers = [TBAudioModifier()]
    
    public init(_ input: AKNode, _ slots: Int) {
        self.input = input
        for _ in 0...slots { modifiers.append(TBAudioModifier()) } //Initialise elements
        chainModifiers()
    }
    
    public func setInput(_ input: AKNode) {
        self.input = input
    }
    
    public func setModifier(modifier: TBAudioModifier, slot: Int) {
        modifiers[slot] = modifier
        chainModifiers()
    }
    
    public func removeModifier(slot: Int) {
        modifiers[slot] = TBAudioModifier()
        chainModifiers()
    }
    
    public func getModifier(slot: Int) -> TBAudioModifier {
        return modifiers[slot]
    }
    
    public func getOutput() -> AKNode {
        return modifiers.last!.getOutput()
    }
    
    /**
     Rechains modifier IO.
     */
    private func chainModifiers() {
        for i in 0...modifiers.count-1 {
            if(i == 0) { modifiers[0].setInput(input) }
            else { modifiers[i].setInput(modifiers[i-1].getOutput()) }
        }
    }
}
