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
    
    var lifetime = 0 //Chunks survived
    var pattern = [[Double]]()
    var coverage = 1
    var instrument: TBInstrument //Instrument
    var modifierGroup : TBModifierGroup //Modifiers
    var musicTrack = AKMusicTrack() //Midi
    var limiter : AKPeakLimiter //For safety reasons
    
    public init(_ instrument: TBInstrument, modifierSlots: Int = 5) {
        self.instrument = instrument
        modifierGroup = TBModifierGroup(instrument.getOutput(), slots: modifierSlots)
        musicTrack.setMIDIOutput(instrument.midiIn())
        limiter = AKPeakLimiter()
    }
    
    deinit { print("Deinit"+instrument.instrumentID) }
    
    public func incrementLife() { lifetime += 1 }
    
    /// Adds a modifier to the unit. Can specify a slot, else its random.
    public func addModifier(_ modifier: TBAudioModifier, slot: Int? = nil) {
        if(slot != nil) {
            modifierGroup.setModifier(modifier: modifier, slot: slot!)
        } else {
            let freeSlots = getFreeModifierSlots()
            modifierGroup.setModifier(modifier: modifier, slot: freeSlots[Int.random(freeSlots.count)])
        }
    }
    
    public func removeModifier(_ slot: Int) { modifierGroup.removeModifier(slot: slot) }
    
    public func getFreeModifierSlots() -> [Int] { return modifierGroup.getFreeSlots() }
    
    public func getOutput() -> AKNode {
        //limiter
        return modifierGroup.getOutput() //Last modifier is output
    }
    
    public func getTag() -> RecognisedSoundTag? { return instrument.tag }
    public func setTag(_ tag: RecognisedSoundTag) { instrument.tag = tag }
    
    public func writeScore(pattern: [[Double]], coverage: Int) {
        self.pattern = pattern; self.coverage = coverage //Save
        let noteGap = Double(coverage)/Double(pattern.count);
        var loop = 0.0
        while loop < 64.0 {
            var position = loop//Note position
            for note in pattern {
                if(note[0] != 0) { //0 is no note
                    var noteLength = noteGap * note[1];
                    if(50<Int.random(100)) { noteLength = noteGap/2 }
                    musicTrack.add(noteNumber: MIDINoteNumber(note[0]), velocity: 100, position: AKDuration(beats: position), duration: AKDuration(beats: noteLength))
                }
                position += noteGap
            }
            loop += Double(coverage)
        }
        //Remove sound bug with fm
        if(instrument.tag == RecognisedSoundTag.fm) { musicTrack.clearRange(start: AKDuration(beats: 0), duration: AKDuration(beats: 0.5)) }
    }
    
    public func duplicate() -> TBAudioUnit {
        let au = TBAudioUnit(instrument.duplicate())
        au.writeScore(pattern: self.pattern, coverage: self.coverage)
        modifierGroup.copyTo(au.modifierGroup)
        return au
    }
    
}
