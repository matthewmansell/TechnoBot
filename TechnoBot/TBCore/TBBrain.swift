//
//  TBBrain.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 09/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public enum Section:Int { case buildup = 0, dance = 1, breakdown = 2 }
public enum RecognisedSoundTag:String {
    case kick = "kick", clap = "clap", snare = "snare", rim = "rim", hat = "hat", perc = "perc", fm = "fm"
    static func random() -> RecognisedSoundTag {
        let list = [self.kick, self.clap, self.snare, self.rim, self.hat, self.perc, self.fm]
        return list[Int.random(list.count)]
    }
}
public enum Modifiers {}


/// Responsible for generating and modifying content. Processing handled by utility functions.
public class TBBrain {
    
    //Index applies to section number (section.rawValue)
    let SECTION_STRING = ["buildup", "dance", "breakdown"] //Section relevance
    let PROGRESSION_CHANCE = [50, 25, 50] //Chance to progress sections
    let ADDITION_CHANCE = [75, 50, 0] //Chance of generating/adding a new sound
    let REMOVAL_CHANCE = [0, 50, 75] //Chance of removing a sound
    let MUTATION_CHANCE = [25, 25, 25] //Chance of mutating a sound
    let MAX_UNITS = 6
    //Samples
    let kickSamples = ["kick_01", "kick_02", "kick_03", "kick_05", "kick_05", "kick_06", "kick_07", "kick_08"]
    let hatSamples = ["hat_01", "hat_02", "hat_03", "hat_04", "hat_05", "hat_06", "hat_07", "hat_08"]
    let clapSamples = ["clap_01", "clap_02", "clap_03", "clap_04"]
    let snareSamples = ["snare_01", "snare_02", "snare_03", "snare_04", "snare_05", "snare_06", "snare_07", "snare_08"]
    let rimSamples = ["rim_01", "rim_02", "rim_03", "rim_04"]
    let percSamples = ["perc_01", "perc_02", "perc_03", "perc_04", "perc_05", "perc_06", "perc_07", "perc_08"]
    
    var section = Section.buildup //Current section
    var adaptionRate = 1.0
    
    var audioUnits = [TBAudioUnit]() //Units to be added to system
    var modifiers = [TBAudioModifier]() //Modifiers to be added to system (main bus)
    var lastAdded = 0, lastRemoved = 0, lastMutated = 0
    
    var newSection = TBSection()
    
    public func reset() {
        section = Section.buildup
        adaptionRate = 1
        audioUnits.removeAll()
        modifiers.removeAll()
        lastAdded = 0; lastRemoved = 0; lastMutated = 0
    }
    
    public func generateSection() -> TBSection {
        let newSection = TBSection() //Reset
        
        if(audioUnits.count == 0) { audioUnits.append(genAudioUnit()) } //At least 1 sound
        let rounds = reducingChance(50)
        var added = false, removed = false, mutated = false
        for _ in 0..<rounds {
            if((shouldAdapt(REMOVAL_CHANCE) && audioUnits.count>1) || lastRemoved >= 3 || audioUnits.count >= MAX_UNITS) {
                removed = true
                var lifetimes = [Int]()
                for unit in audioUnits { lifetimes.append(unit.lifetime) }
                audioUnits.remove(at: rouletteSelect(lifetimes))
            }
            if(shouldAdapt(ADDITION_CHANCE) || lastAdded >= 3) {
                added = true
                audioUnits.append(genAudioUnit())
            }
            if(shouldAdapt(MUTATION_CHANCE) || lastMutated == 2) {
                mutated = true
            }
        }
        if(added == true) { lastAdded = 0 } else { lastAdded+=1 }
        if(removed == true) { lastRemoved = 0 } else { lastRemoved+=1 }
        if(mutated == true) { lastMutated = 0 } else { lastMutated+=1 }
        
        //Prepare for next section
        if(shouldAdapt(PROGRESSION_CHANCE)) { //Move section?
            if(section == Section.buildup) { section = Section.dance }
            else if(section == Section.dance) { section = Section.breakdown }
            else if(section == Section.breakdown) { section = Section.buildup }
            newSection.notes.append("Moving to "+SECTION_STRING[section.rawValue]+" section.")
        }
        
        for unit in audioUnits {
            unit.instrument.start(noteNumber: 10, velocity: 100); unit.instrument.stop() //Removes glitch
            newSection.audioUnits.append(unit.duplicate())
            unit.lifetime += 1 //Increment life
        }
        
        return newSection
    }
    
    public func setAdaptionRate(_ rate: Double) { adaptionRate = rate }
    
    /// Utility, question to adapt
    private func shouldAdapt(_ chanceArray: [Int]) -> Bool {
        if(Double(Int.random(100)) < (chanceArray[section.rawValue] * adaptionRate)) { return true }
        else { return false }
    }
    
    /// Utility to calculate number of iterations for a cycle to occur, when chance reduces by an ammount each time
    private func reducingChance(_ initialChance: Double, chanceReduction: Double = 0.75) -> Int {
        var count = 0, chance = initialChance
        while(Int.random(100) < Int(chance)) { count += 1; chance *= chanceReduction }
        return count
    }
    
    /// Utility to select an individual form an array based on its value.
    private func rouletteSelect(_ individuals: [Int]) -> Int {
        var total = 0, cumulative = 0.0
        var roulette = Array(repeating: 0.0, count: individuals.count)
        for i in 0..<individuals.count { total += individuals[i] } //Total lifetime
        for i in 0..<individuals.count {
            if(individuals[i] != 0) {
                roulette[i] = cumulative + (individuals[i]/total)
            } else { roulette[i] = cumulative }
                cumulative = roulette[i]
        }
        roulette[roulette.count-1] = 1
        let probability = Double.random()
        var selected = 0
        for i in 0..<individuals.count {
            if(probability>=roulette[i]) {
                selected = i
                break
            }
        }
        return selected
    }
    
    private func genAudioUnit() -> TBAudioUnit {
        //Decide unit type, search current unit tags
        var tags = [RecognisedSoundTag]()
        for unit in audioUnits { if(unit.getTag() != nil) {tags.append(unit.getTag()!)} }
        
        var newUnit: TBAudioUnit? = nil
        //Kick is special
        if(!tags.contains(RecognisedSoundTag.kick) && section == Section.dance) { //Must have kick in a dance section
            newUnit = TBAudioUnit(genInstrument(RecognisedSoundTag.kick))
            genScore(newUnit!, notePattern: [[1,1],[1,1],[1,1],[1,1]], beatCoverage: 4) //Kick pattern
        } else {
            newUnit = TBAudioUnit(genInstrument())
            genScore(newUnit!)
        }
        
        var modifiersToAdd = reducingChance(50)
        if(modifiersToAdd>5) { modifiersToAdd = 5 } //Cap
        for _ in 0..<modifiersToAdd {
            newUnit!.addModifier(genModifier())
        }
        
        return newUnit!
    }
    /**
     Generates an insturment
     - Parameter specific: Specify creation of a recognised type.
     */
    private func genInstrument(_ specific: RecognisedSoundTag? = nil) -> TBInstrument {
        var tag = RecognisedSoundTag.random()
        if(specific != nil) { tag = specific! }
        switch tag {
        case .kick:
            let sampler = TBSampler()
            sampler.loadSample(kickSamples[Int.random(kickSamples.count-1)])
            sampler.tag = RecognisedSoundTag.kick
            return sampler
        case .clap:
            let sampler = TBSampler()
            sampler.loadSample(clapSamples[Int.random(clapSamples.count-1)])
            sampler.tag = RecognisedSoundTag.clap
            return sampler
        case .snare:
            let sampler = TBSampler()
            sampler.loadSample(snareSamples[Int.random(snareSamples.count-1)])
            sampler.tag = RecognisedSoundTag.snare
            return sampler
        case .rim:
            let sampler = TBSampler()
            sampler.loadSample(rimSamples[Int.random(rimSamples.count-1)])
            sampler.tag = RecognisedSoundTag.rim
            return sampler
        case .hat:
            let sampler = TBSampler()
            sampler.loadSample(hatSamples[Int.random(hatSamples.count-1)])
            sampler.tag = RecognisedSoundTag.hat
            return sampler
        case .perc:
            let sampler = TBSampler()
            sampler.loadSample(percSamples[Int.random(percSamples.count-1)])
            sampler.tag = RecognisedSoundTag.perc
            return sampler
        case .fm:
            let fm = TBFMSynthesiser()
            fm.tag = RecognisedSoundTag.fm
            return fm
        }
    }
    
    /// Generates a random audio modifier
    private func genModifier() -> TBAudioModifier {
        let selection = Int.random(4), intensity = ModifierIntensity.random()
        let newModifier : TBAudioModifier?
        switch selection {
        case 0: newModifier = TBReverbModifier.factory(intensity)
        case 1: newModifier = TBDistortionModifier.factory(intensity)
        case 2: newModifier = TBPhaserModifier.factory(intensity)
        case 3: newModifier = TBDelayModifier.factory(intensity)
        default: newModifier = TBBlankModifier()
        }
        return newModifier!
    }
    
    /**
     Generate a score for an audio unit.
     (If notePattern length = 4, and beatCoverage is 4, there is one note per beat.)
     - Parameter unit: The unit to generate a score for.
     - Parameter notePattern: Pre-specified pattern. If nil, one is generated.
     - Parameter beatCoverage: Number of beats the pattern covers. If nil, one is generated
     */
    private func genScore(_ unit: TBAudioUnit, notePattern: [[Double]]? = nil, beatCoverage: Int? = nil) {
        var pattern = notePattern, coverage = beatCoverage //Editable
        if(pattern == nil) { //Gen note pattern
            var iterations = reducingChance(95.0, chanceReduction: 0.8), length = 2
            while(length < 32 && iterations > 0) { length *= 2; iterations -= 1 } //Doubling length gives 1,2,4,8 etc..
            pattern = Array(repeating: Array(repeating: 0, count: 2), count: length) //Empty pattern of length n
            let noteChance = Int.random(100) //Chance of note addition
            for i in 0..<pattern!.count {
                if(noteChance < Int.random(100)) {
                    pattern![i][0] = Double(Int.random(80)) //MIDI number
                    pattern![i][1] = 0.5
                }
            }
        }
        if(coverage == nil) { //Gen beat coverage
            var iterations = reducingChance(75.0); coverage = 1
            while(coverage! < 64 && iterations > 0) { coverage! *= 2; iterations -= 1 } //Doubling length gives 1,2,4,8 etc..
            while((Double(coverage!)/Double(pattern!.count)) < 0.25) { coverage! *= 2 }
        }
        
        unit.writeScore(pattern: pattern!, coverage: coverage!)
    }
    
    private func mutateAudioUnit(_ unit: TBAudioUnit) {
    }
    
    private func mutateInstrument(_ instrument: TBInstrument) {
    }
    
    private func mutateModifier(_ modifier: TBAudioModifier) {
    }
}
