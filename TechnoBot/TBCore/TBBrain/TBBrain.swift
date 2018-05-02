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
        return list[TechnoBot.randomInt(list.count-1)]
    }
}

/// Responsible for generating and modifying content. Processing handled by utility functions.
public class TBBrain {
    
    //Index applies to section number (section.rawValue)
    let SECTION_STRING = ["buildup", "dance", "breakdown"] //Section relevance
    let PROGRESSION_CHANCE = [50, 25, 50] //Chance to progress sections
    let ADDITION_CHANCE = [75, 50, 0] //Chance of generating/adding a new sound
    let REMOVAL_CHANCE = [0, 50, 75] //Chance of removing a sound
    let MUTATION_CHANCE = [25, 25, 25] //Chance of mutating a sound
    //Samples
    let kickSamples = ["kick_01", "kick_02", "kick_03", "kick_05", "kick_05", "kick_06", "kick_07", "kick_08"]
    let hatSamples = ["hat_01", "hat_02", "hat_03", "hat_04", "hat_05", "hat_06", "hat_07", "hat_08"]
    let clapSamples = ["clap_01", "clap_02", "clap_03", "clap_04"]
    let snareSamples = ["snare_01", "snare_02", "snare_03", "snare_04", "snare_05", "snare_06", "snare_07", "snare_08"]
    let rimSamples = ["rim_01", "rim_02", "rim_03", "rim_04"]
    let percSamples = ["perc_01", "perc_02", "perc_03", "perc_04", "perc_05", "perc_06", "perc_07", "perc_08"]
    
    var section = Section.buildup //Current section
    var adaptionRate = 1
    
    var audioUnits = [TBAudioUnit]() //Units to be added to system
    var modifiers = [TBAudioModifier]() //Modifiers to be added to system (main bus)
    
    
    var alt = true
    
    init() {
        var au = TBAudioUnit(genInstrument(RecognisedSoundTag.perc))
        genScore(au, notePattern: [[1,1],[1,1],[1,1],[1,1]], beatCoverage: 2) //Kick pattern
        audioUnits.append(au)
    }
    
    public func generateSection() -> TBSection {
        let newSection = TBSection() //To return
        //TechnoBot.shared.log("Generating next section...")
        
        //if(audioUnits.count == 0) { audioUnits.append(genAudioUnit()) }
        //if(shouldAdapt(ADDITION_CHANCE)) { audioUnits.append(genAudioUnit()) }
        //if(shouldAdapt(REMOVAL_CHANCE)) { print("removing") }
        //if(shouldAdapt(MUTATION_CHANCE)) { print("adding") }
        //print("result = "+String(reducingChance(90.0, chanceReduction: 0.9)))
        //let _ = genAudioUnit()
        
        
        //let au = audioUnits[0].duplicate()
        //genScore(au, notePattern: [[1,1],[1,1],[1,1],[1,1]], beatCoverage: 2) //Kick pattern
        //newSection.audioUnits.append(au)
        
        for unit in audioUnits {
            newSection.audioUnits.append(unit.duplicate())
        }
        
        //newSection.audioUnits.append(contentsOf: audioUnits)
        
        //Prepare for next section
        if(shouldAdapt(PROGRESSION_CHANCE)) { //Move section?
            if(section == Section.buildup) { section = Section.dance }
            else if(section == Section.dance) { section = Section.breakdown }
            else if(section == Section.breakdown) { section = Section.buildup }
            print(SECTION_STRING[section.rawValue])
        }
        
        return newSection
    }
    
    public func setAdaptionRate(_ rate: Int) { adaptionRate = rate }
    
    /// Utility, question to adapt
    private func shouldAdapt(_ chanceArray: [Int]) -> Bool {
        if(TechnoBot.randomInt(100) < (chanceArray[section.rawValue] * adaptionRate)) { return true }
        else { return false }
    }
    
    /// Utility to calculate number of iterations for a cycle to occur, when chance reduces by an ammount each time
    private func reducingChance(_ initialChance: Double, chanceReduction: Double = 0.75) -> Int {
        var count = 0, chance = initialChance
        while(TechnoBot.randomInt(100) < Int(chance)) { count += 1; chance *= chanceReduction }
        return count
    }
    
    private func genAudioUnit() -> TBAudioUnit {
        //Decide unit type, search current unit tags
        var tags = [RecognisedSoundTag]()
        for unit in audioUnits { if(unit.getTag() != nil) {tags.append(unit.getTag()!)} }
        //Overwrite specials
        if(!tags.contains(RecognisedSoundTag.kick) && section == Section.dance) { //Must have kick
            let kick = TBAudioUnit(genInstrument(RecognisedSoundTag.kick))
            genScore(kick, notePattern: [[1,1],[1,1],[1,1],[1,1]], beatCoverage: 4) //Kick pattern
            //return kick
        }
        let newUnit = TBAudioUnit(genInstrument())
        genScore(newUnit)
        return newUnit
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
            sampler.loadSample(kickSamples[TechnoBot.randomInt(kickSamples.count-1)])
            sampler.tag = RecognisedSoundTag.kick
            return sampler
        case .clap:
            let sampler = TBSampler()
            sampler.loadSample(clapSamples[TechnoBot.randomInt(clapSamples.count-1)])
            sampler.tag = RecognisedSoundTag.clap
            return sampler
        case .snare:
            let sampler = TBSampler()
            sampler.loadSample(snareSamples[TechnoBot.randomInt(snareSamples.count-1)])
            sampler.tag = RecognisedSoundTag.snare
            return sampler
        case .rim:
            let sampler = TBSampler()
            sampler.loadSample(rimSamples[TechnoBot.randomInt(rimSamples.count-1)])
            sampler.tag = RecognisedSoundTag.rim
            return sampler
        case .hat:
            let sampler = TBSampler()
            sampler.loadSample(hatSamples[TechnoBot.randomInt(hatSamples.count-1)])
            sampler.tag = RecognisedSoundTag.hat
            return sampler
        case .perc:
            let sampler = TBSampler()
            sampler.loadSample(percSamples[TechnoBot.randomInt(percSamples.count-1)])
            sampler.tag = RecognisedSoundTag.perc
            return sampler
        case .fm:
            let fm = TBFMSynthesiser()
            fm.tag = RecognisedSoundTag.fm
            return fm
        }
    }
    
    private func genModifier() -> TBAudioModifier {
        let newModifier = TBAudioModifier()
        return newModifier
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
            while(length < 64 && iterations > 0) { length *= 2; iterations -= 1 } //Doubling length gives 1,2,4,8 etc..
            pattern = Array(repeating: Array(repeating: 0, count: 2), count: length) //Empty pattern of length n
            let noteChance = TechnoBot.randomInt(100) //Chance of note addition
            for i in 0..<pattern!.count {
                if(noteChance < TechnoBot.randomInt(100)) {
                    pattern![i][0] = Double(TechnoBot.randomInt(80)) //MIDI number
                    pattern![i][1] = 0.5
                }
            }
        }
        if(coverage == nil) { //Gen beat coverage
            var iterations = reducingChance(75.0); coverage = 1
            while(coverage! < 64 && iterations > 0) { coverage! *= 2; iterations -= 1 } //Doubling lenght gives 1,2,4,8 etc..
        }
        //print(pattern!)
        //Fill pattern over 64 beats
        let noteGap = Double(coverage!)/Double(pattern!.count); //print(noteGap)
        for i in 0..<(64/coverage!) {
            var position : Double = 0 + i//Note potition
            for note in pattern! {
                if(note[0] != 0) { //0 is no note
                    var noteLength = noteGap * note[1];
                    if(50<TechnoBot.randomInt(100)) { noteLength = noteGap/2 }
                    unit.musicTrack.add(noteNumber: MIDINoteNumber(note[0]), velocity: 100, position: AKDuration(beats: position), duration: AKDuration(beats: noteLength))
                }
                position += noteGap
            }
        }
        unit.origScore = pattern! //Copy original pattern
    }
    
    private func mutateAudioUnit(_ unit: TBAudioUnit) {
    }
    
    private func mutateInstrument(_ instrument: TBInstrument) {
    }
    
    private func mutateModifier(_ modifier: TBAudioModifier) {
    }
}
