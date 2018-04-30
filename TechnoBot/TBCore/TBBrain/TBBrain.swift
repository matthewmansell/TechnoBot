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
    
    //Index applies to section number
    let SECTIONS = ["buildup", "dance", "breakdown"] //Section relevance
    let PROGRESSION_CHANCE = [50, 25, 50] //Chance to progress sections
    let ADDITION_CHANCE = [75, 50, 0] //Chance of generating/adding a new sound
    let MUTATION_CHANCE = [25, 25, 25] //Chance of mutating a sound
    //Samples
    let kickSamples = ["kick_01", "kick_02", "kick_03", "kick_05", "kick_05", "kick_06", "kick_07", "kick_08"]
    let hatSamples = ["hat_01", "hat_02", "hat_03", "hat_04", "hat_05", "hat_06", "hat_07", "hat_08"]
    let clapSamples = ["clap_01", "clap_02", "clap_03", "clap_04"]
    let snareSamples = ["snare_01", "snare_02", "snare_03", "snare_04", "snare_05", "snare_06", "snare_07", "snare_08"]
    let rimSamples = ["rim_01", "rim_02", "rim_03", "rim_04"]
    let percSamples = ["perc_01", "perc_02", "perc_03", "perc_04", "perc_05", "perc_06", "perc_07", "perc_08"]
    
    var section = 0 //Current section
    var adaptionRate = 50
    
    var audioUnits = [TBAudioUnit]() //Units to be added to system
    var modifiers = [TBAudioModifier]() //Modifiers to be added to system (main bus)
    
    
    
    public func generateSection(_ audioSystem: TBAudioSystem) {
        if(shouldAdapt(PROGRESSION_CHANCE)) { //Move section?
            section += 1; //Progress section
            if(section > SECTIONS.count) { section = 0 } //Loop back
        }
        
    }
    
    public func setAdaptionRate(_ rate: Int) { adaptionRate = rate }
    
    /// Utility, question to adapt
    private func shouldAdapt(_ chanceArray: [Int]) -> Bool {
        if(TechnoBot.randomInt(100) < (chanceArray[section] * adaptionRate)) { return true }
        else { return false }
    }
    
    private func genAudioUnit() -> TBAudioUnit {
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
    
    private func genScore() {
        
    }
    
    private func mutateAudioUnit(_ unit: TBAudioUnit) {
    }
    
    private func mutateInstrument(_ instrument: TBInstrument) {
    }
    
    private func mutateModifier(_ modifier: TBAudioModifier) {
    }
}
