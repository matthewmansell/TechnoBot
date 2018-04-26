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
    var audioUnits = [TBAudioUnit]() //All audio units
    //var xyz = Set<TBAudioUnit>()
    var modifiers : TBModifierGroup //Master bus inserts
    var sequencer = TBSequencer() //Main Sequencer
    
    /// Initialises the audio system
    public init() {
        modifiers = TBModifierGroup(mixer, slots: MOD_SLOTS)
        AudioKit.output = modifiers.getOutput()
        do { try AudioKit.start()
        } catch { AKLog("AudioKit did not start!"); TechnoBot.shared.log("Audio system did not start!") }
        //Generate sequencer event instrument
        let eventInstrument = TBCallbackInstrument(noteDownCallback: tickOn, noteUpCallback: tickOff)
        let au = TBAudioUnit(eventInstrument)
        for i in 0...64 {
            au.getTrack().add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 1))
        }
        sequencer.connectAudioUnit(au)
    }
    
    /// Number of audio units playing
    public func audioUnitCount() -> Int { return audioUnits.count }
    public func play() {
        mixer.start()
        sequencer.play()
    }
    public func pause() {
        mixer.stop()
        sequencer.pause()
    }
    public func startRecording() {}
    public func stopRecording() {}
    public func isRecording() -> Bool { return false }
    
    public func isPlaying() -> Bool { return sequencer.isPlaying() }
    
    public func addAudioUnit(_ unit: TBAudioUnit) {
        audioUnits.append(unit) //Add unit
        sequencer.pause()
        sequencer.connectAudioUnit(unit) //Connect to sequencer
        sequencer.sequencer.setLength(AKDuration(beats: 4))
        sequencer.sequencer.enableLooping()
        sequencer.play()
        mixer.connect(input: unit.getOutput()) //Connect to mixer
    }
    
    public func removeAudioUnit(_ unit: TBAudioUnit) {
        
    }
    
    public func addModifier(_ modifier: TBAudioModifier, slot: Int? = nil) {
        if(slot != nil) {
            modifiers.setModifier(modifier: modifier, slot: slot!)
        } else { }
    }
    public func removeModifier(_ slot: Int) {
        modifiers.removeModifier(slot: slot)
    }
    
    public func removeAudioModifier() {}
    
    /// Called once per beat
    public func tickOn() {
        TechnoBot.shared.updateTimer(sequencer.getBeat())
    }
    //Called at end of beat
    public func tickOff() {
        if(sequencer.getBeat() == 64) {
            sequencer.pause()
            audioUnits.removeAll()
            mixer = AKMixer()
            sequencer.rewind()
            sequencer.play()
        }
        /*
        if(sequencer.getBeat() == 32) {
            print("here")
            let sound2 = TBSampler()
            sound2.loadSample(Bundle.main.url(forResource: "hat_01", withExtension: "wav"))
            let unit2 = TBAudioUnit(sound2)
            for i in 0 ..< 64 {
                unit2.getTrack().add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)+0.5), duration: AKDuration(beats: 1))
            }
            addAudioUnit(unit2)
        }
         */
    }
}

private class TBCallbackInstrument: TBInstrument {
    var noteDownCallback : () -> Void
    var noteUpCallback : () -> Void
    
    init(noteDownCallback: @escaping () -> Void, noteUpCallback: @escaping () -> Void) {
        self.noteDownCallback = noteDownCallback
        self.noteUpCallback = noteUpCallback
        super.init(midiInputName: "TBCallbackInstrument")
    }
    
    //Called on note down
    override public func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        DispatchQueue.main.async { self.noteDownCallback() }
    }
    //Called on note up
    override public func stop(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        DispatchQueue.main.async { self.noteUpCallback() }
    }
}

