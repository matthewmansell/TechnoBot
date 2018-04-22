//
//  TBAudioUnit.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// A single audio unit (score, instrument and modifiers)
public class TBAudioUnit {
    
    var lifetime = 0
    var instrument: TBInstrument
    var modifierGroup : TBModifierGroup
    
    public init(_ instrument: TBInstrument, modifierSlots: Int = 5) {
        self.instrument = instrument
        modifierGroup = TBModifierGroup(instrument.getOutput(), slots: modifierSlots)
    }
    
    public func incrementLife() { lifetime += 1 }
    
    
    public func play() { instrument.play() }
    public func pause() { instrument.pause() }
    
    public func addModifier(_ modifier: TBAudioModifier, slot: Int? = nil) {
        if(slot != nil) {
            modifierGroup.setModifier(modifier: modifier, slot: slot!)
        } else {
            
        }
    }
    
    public func getOutput() -> AKNode {
        //return instrument.getOutput()
        return modifierGroup.getOutput() //Last modifier is output
    }
    
}
