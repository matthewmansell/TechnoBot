//
//  TBBrain.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 09/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation

/// Responsible for generating and modifying content
public class TBBrain {
    
    var audioUnits = [TBAudioUnit]() //Units to be added to system
    var modifiers = [TBAudioModifier]() //Modifiers to be added to system
    
    public init() {
        
    }
    
    private func getAudioUnit() -> TBAudioUnit {
        let newUnit = TBAudioUnit(genInstrument())
        return newUnit
    }
    
    private func genInstrument() -> TBInstrument {
        let newInstrument = TBInstrument()
        return newInstrument
    }
    
    private func genModifier() -> TBAudioModifier {
        let newModifier = TBAudioModifier()
        return newModifier
    }
    
    
    
    
}
