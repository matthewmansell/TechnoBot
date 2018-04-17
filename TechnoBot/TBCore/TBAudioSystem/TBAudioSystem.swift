//
//  TBAudioSystem.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 09/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBAudioSystem {
    
    let MOD_SLOTS = 5 //Max audio modifiers allowed per group
    let AU_SLOTS = 5 //Max audio unit allowed
    
    var mixer = AKMixer() //Master bus
    var audioUnits = [TBAudioUnit()] //All audio units
    var modifiers : TBModifierGroup //Master bus inserts
    var sequencer = AKSequencer() //Main Sequencer
    
    public init() {
        modifiers = TBModifierGroup(mixer, MOD_SLOTS)
        
        AudioKit.output = modifiers.getOutput() //Output is from last modifier
        do {
            try AudioKit.start()
        } catch {}
            
    }
    
    public func play() {
        
    }
    
    public func isPlaying() -> Bool {
        return 
    }
    
    public func addAudioUnit() {
        let newUnit = TBAudioUnit()
        
        audioUnits.append(newUnit)
        
        mixer.connect(input: newUnit.getOutput())
        
    }
    public func addAudioModifier() {
        //let newModifier = TBReverbModifier()
        
        //modifiers.append(newModifier)
    }
    
    
}

