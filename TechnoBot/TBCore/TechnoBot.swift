//
//  TechnoBot.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 04/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import Cocoa
import AudioKit

public class TechnoBot {
    
    public static let shared = TechnoBot()
    
    //Index applies to section number
    let SECTIONS = ["buildup", "dance", "breakdown"]
    let PROGRESSION_CHANCE = [50, 25, 50] //Chance to progress sections
    let ADDITION_CHANCE = [75, 50, 0] //Chance of generating/adding a new sound
    let MUTATION_CHANCE = [25, 25, 25] //Chance of mutating a sound
    
    let kickSamples = ["kick_01", "kick_02", "kick_03", "kick_05", "kick_05", "kick_06", "kick_07", "kick_08"]
    let hatSamples = ["hat_01", "hat_02", "hat_03", "hat_04", "hat_05", "hat_06", "hat_07", "hat_08"]
    let clapSamples = ["clap_01", "clap_02", "clap_03", "clap_04"]
    let snareSamples = ["snare_01", "snare_02", "snare_03", "snare_04", "snare_05", "snare_06", "snare_07", "snare_08"]
    let rimSamples = ["rim_01", "rim_02", "rim_03", "rim_04"]
    let percSamples = ["perc_01", "perc_02", "perc_03", "perc_04", "perc_05", "perc_06", "perc_07", "perc_08"]
    
    let vc = NSApplication.shared.mainWindow?.contentViewController as! ViewController
    
    var section = 0 //Section
    var adaptionRate = 50
    var brain = TBBrain() //Brain/idea generation
    var audioSystem = TBAudioSystem() //Audio system
    
    public func progressionChance() -> Int { return PROGRESSION_CHANCE[section] * adaptionRate }
    
    /// Play/pause audio system, initialises system on first play.
    public func togPlaying() -> Bool {
        if(!audioSystem.isPlaying()) {
            log("Playing...")
            if(audioSystem.audioUnitCount() == 0) { //Not yet started?
                generateSound() //Generate initial audio
                audioSystem.play() //Start
            } else { audioSystem.play() } //Resume
        } else { //Pause
            log("System paused.")
            audioSystem.pause()
        }
        return audioSystem.isPlaying()
    }
    
    public func togRecord() -> Bool {
        if(audioSystem.isRecording()) { audioSystem.stopRecording() }
        else { audioSystem.startRecording() }
        return audioSystem.isRecording() //Current status
    }
    
    public func reset() {
        log("System reset.")
        audioSystem.pause() //Pause for safety
        brain = TBBrain() //Re-initialise brain
        audioSystem = TBAudioSystem() //Re-initialise audio system
    }
    
    /// Pushes stored changes and then generates ones for next round.
    public func processChunk() {
        if(TechnoBot.randomInt(100) < PROGRESSION_CHANCE[section]) {
            section += 1; //Progress section
            if(section > SECTIONS.count) { section = 0 } //Loop back
        }
        
    }
    
    /// Generates a new sound and adds it to the audio system
    public func generateSound() {
        /*
        //let sound = TBFMSynthesiser()
        var sample = kickSamples[TechnoBot.randomInt(kickSamples.count)]
        let sound = TBSampler()
        sound.loadSample(Bundle.main.url(forResource: sample, withExtension: "wav"))
        let unit = TBAudioUnit(sound)
        for i in 0 ..< 64  {
            unit.getTrack().add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 1))
        }
        unit.getTrack().setLength(AKDuration(beats: 64))
        //unit.addModifier(verb, slot: 1)
        audioSystem.addAudioUnit(unit)
                
        let clap = TBSampler()
        sample = percSamples[TechnoBot.randomInt(percSamples.count)]
        clap.loadSample(Bundle.main.url(forResource: sample, withExtension: "wav"))
        let unit4 = TBAudioUnit(clap)
        for i in stride(from: 0, to: 4, by: 0.5) {
            if(TechnoBot.randomInt(100) < 25) {
                unit4.getTrack().add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 0.5))
            }
        }
        unit4.getTrack().setLength(AKDuration(beats: 64))
        audioSystem.addAudioUnit(unit4)
        
        
        let rim = TBSampler()
        sample = rimSamples[TechnoBot.randomInt(rimSamples.count)]
        rim.loadSample(Bundle.main.url(forResource: sample, withExtension: "wav"))
        let unit5 = TBAudioUnit(rim)
        for i in stride(from: 0, to: 4, by: 0.25) {
            if(TechnoBot.randomInt(100) < 25) {
                unit5.getTrack().add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 0.25))
            }
        }
        unit5.getTrack().setLength(AKDuration(beats: 64))
        audioSystem.addAudioUnit(unit5)
        
        
        let fm = TBFMSynthesiser()
        let unit3 = TBAudioUnit(fm)
        var note = 0
        for i in stride(from: 0, to: 4, by: 0.25) {
            if(TechnoBot.randomInt(100) < 25) {
                note = TechnoBot.randomInt(10)
                unit3.getTrack().add(noteNumber: MIDINoteNumber(note), velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 0.5))
            }
        }
        unit3.getTrack().setLength(AKDuration(beats: 4))
        let verb = TBReverbModifier()
        unit3.addModifier(verb, slot: 1)
        audioSystem.addAudioUnit(unit3)
        */
    }
    
    private func mutateSound() {
        
    }
    
    /// Write to log
    public func log(_ s : String) {
        vc.writeLog(s)
    }
    public func updateTimer(_ beat: Int) {
        vc.setBeat(beat+1)
    }
    
    /// Random number utility
    static func randomInt(_ n: Int) -> Int { return Int(arc4random_uniform(UInt32(n))) }
    
}
