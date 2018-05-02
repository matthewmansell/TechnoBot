//
//  TBFMSynthesiser.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 07/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Wrapper for AKFM Oscillator
public class TBFMSynthesiser : TBInstrument {
    
    private var interfaceInstrument : TBCallbackInstrument?
    private var fMO = AKFMOscillator()
    
    public var instrumentID = "FM"
    public var tag: RecognisedSoundTag?
    
    init() {
        interfaceInstrument = TBCallbackInstrument(noteDownCallback: self.start, noteUpCallback: self.stop)
        fMO.presetWobble()
        fMO.amplitude = 0.08
    }
    
    public func midiIn() -> MIDIEndpointRef {
        return interfaceInstrument!.midiIn
    }
    
    public func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        fMO.baseFrequency = noteNumber.midiNoteToFrequency()
        //fMO.carrierMultiplier = noteNumber.midiNoteToFrequency()-5
        fMO.start()
    }
    
    public func stop() { fMO.stop() }
    
    public func getOutput() -> AKNode { return fMO }
    public func pitchBend(_ time: Double) { fMO.rampTime = time }
    
    public func duplicate() -> TBInstrument {
        let fm = TBFMSynthesiser()
        fm.tag = self.tag!
        return fm
        
    }
    public static func factory() -> TBInstrument {
        let fm = TBFMSynthesiser()
        return fm
    }
}
