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
    var origScore = [[Double]]()
    var coverage = 1
    var musicTrack = AKMusicTrack() //Midi
    var instrument: TBInstrument //Instrument
    var modifierGroup : TBModifierGroup //Modifiers
    //var tag : RecognisedSoundTag? = nil //Tag?
    
    public init(_ instrument: TBInstrument, modifierSlots: Int = 5) {
        self.instrument = instrument
        modifierGroup = TBModifierGroup(instrument.getOutput(), slots: modifierSlots)
        musicTrack.setMIDIOutput(instrument.midiIn)
    }
    deinit {
        print("Deinit"+instrument.instrumentID)
    }
    
    public func incrementLife() { lifetime += 1 }
    
    public func addModifier(_ modifier: TBAudioModifier, slot: Int? = nil) {
        if(slot != nil) {
            modifierGroup.setModifier(modifier: modifier, slot: slot!)
        } else { }
    }
    
    public func removeModifier(_ slot: Int) {
        modifierGroup.removeModifier(slot: slot)
    }
    
    public func getOutput() -> AKNode {
        return modifierGroup.getOutput() //Last modifier is output
    }
    
    public func getTag() -> RecognisedSoundTag? { return instrument.tag }
    public func setTag(_ tag: RecognisedSoundTag) { instrument.tag = tag }
    
    public func duplicate() -> TBAudioUnit {
        let au = TBAudioUnit(instrument.duplicate())
        return au
    }
    
}
