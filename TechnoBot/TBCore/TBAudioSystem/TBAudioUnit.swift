//
//  TBAudioUnit.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBAudioUnit {
    
    
    
    var source = TBAudioSource()
    var modifiers : TBModifierGroup
    
    
    public init() {
        modifiers = TBModifierGroup(source.getOutput(), TBAudioSystem.MOD_SLOTS)
    }
    
    public func setSource(source: TBAudioSource) {
        self.source = source
    }
    
    public func addReverb() {
        
    }
    
    
    public func addModifier(modifier: TBAudioModifier) {
    }
    
    public func getOutput() -> AKNode {
        return modifiers.getOutput() //Last modifier is output
    }
    
    
    
}
