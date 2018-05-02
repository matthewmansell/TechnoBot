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
    
    public static let shared = TechnoBot() //Shared/Singleton instance
    
    let vc = NSApplication.shared.mainWindow?.contentViewController as! ViewController //VC Pointer
    
    var brain = TBBrain() //Brain/idea generation
    var audioSystem = TBAudioSystem() //Audio system
    
    var newSection = TBSection()
    
    init() {
        newSection = brain.generateSection()
        processSection()
    }
    
    /// Play/pause audio system, initialises system on first play.
    public func togPlaying() -> Bool {
        if(!audioSystem.isPlaying()) {
            log("Playing...")
            audioSystem.play() //Start
        } else { //Pause
            audioSystem.pause()
            log("System paused.")
        }
        return audioSystem.isPlaying() //Return current status to caller
    }
    
    public func togRecord() -> Bool {
        if(audioSystem.isRecording()) { audioSystem.stopRecording() }
        else { audioSystem.startRecording() }
        return audioSystem.isRecording() //Current status
    }
    
    public func reset() {
        audioSystem.pause() //Pause for safety
        brain = TBBrain() //Re-initialise brain
        audioSystem = TBAudioSystem() //Re-initialise audio system
        newSection = brain.generateSection()
        processSection()
        log("System reset.")
    }
    
    /// Pushes stored changes and then generates ones for next sectionaz.
    public func processSection() {
        //var section = TBSection()
        //audioSystem.pushSection(section)
        audioSystem.pushSection(newSection) //Push stored changes
        newSection = brain.generateSection() //Generate new changes
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
        for i in stride(from: 0, to: 4, by: 0.5) {
            if(TechnoBot.randomInt(100) < 25) {
                note = TechnoBot.randomInt(50)
                unit3.getTrack().add(noteNumber: MIDINoteNumber(note), velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 0.5))
            }
        }
        unit3.getTrack().setLength(AKDuration(beats: 4))
        let verb = TBReverbModifier()
        unit3.addModifier(verb, slot: 1)
        audioSystem.addAudioUnit(unit3)
 
        audioSystem.pushChanges()
         */
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
