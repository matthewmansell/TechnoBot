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
    let SECTION = ["buildup", "dance", "breakdown"]
    let PROGRESSION_CHANCE = [50, 25, 50] //Chance to progress sections
    let ADDITION_CHANCE = [75, 50, 0] //Chance of generating/adding a new sound
    let MUTATION_CHANCE = [25, 25, 25] //Chance of mutating a sound
    
    var section = 0 //Section
    var adaptionRate = 50
    var brain = TBBrain() //Brain/idea generation
    var audioSystem = TBAudioSystem() //Audio system
    
    public func progressionChance() -> Int { return PROGRESSION_CHANCE[section] * adaptionRate }
    
    /// Play/pause audio system, initialises system on first play.
    public func togPlaying() {
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
    
    /// Pushed stored changes and then generates ones for next round.
    public func processChunk() {
        //Push
    }
    
    /// Generates a new sound and adds it to the audio system
    public func generateSound() {
        //let sound = TBFMSynthesiser()
        let sound = TBSampler("Shockout_KrudeBootleg.mp3")
        let verb = TBReverbModifier()
        let unit = TBAudioUnit(sound)
        unit.addModifier(verb, slot: 1)
        audioSystem.addAudioUnit(unit)
    }
    
    private func mutateSound() {
        
    }
    
    /// Write to log
    public func log(_ s : String) {
        let vc = NSApplication.shared.mainWindow?.contentViewController as! ViewController
        vc.writeLog(s)
    }
    
}

