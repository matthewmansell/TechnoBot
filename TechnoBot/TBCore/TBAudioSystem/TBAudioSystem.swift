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
    
    var playing = false
    var mixer = AKMixer() //Master bus
    var audioUnits = [TBAudioUnit]() //All audio units
    var modifiers : TBModifierGroup //Master bus inserts
    var sequencer = AKSequencer() //Main Sequencer
    
    /// Initialises the audio system
    public init() {
        modifiers = TBModifierGroup(mixer, slots: MOD_SLOTS)
        AudioKit.output = modifiers.getOutput()
        do { try AudioKit.start()
        } catch { AKLog("AudioKit did not start!"); TechnoBot.shared.log("Audio system did not start!") }
        
    }
    
    /// Number of audio units playing
    public func audioUnitCount() -> Int { return audioUnits.count }
    public func play() {
        mixer.start()
        for unit in audioUnits { unit.play() }
        playing = true
    }
    public func pause() {
        mixer.stop()
        for unit in audioUnits { unit.pause() }
        playing = false
    }
    public func startRecording() {}
    public func stopRecording() {}
    public func isRecording() -> Bool { return false }
    
    public func isPlaying() -> Bool { return playing }
    
    public func addAudioUnit(_ unit: TBAudioUnit) {
        audioUnits.append(unit)
        mixer.connect(input: unit.getOutput())
    }
    
    public func removeAudioUnit() {}
    
    public func addAudioModifier() {
        //let newModifier = TBReverbModifier()
        
        //modifiers.append(newModifier)
    }
    
    public func removeAudioModifier() {}
    
    
}

