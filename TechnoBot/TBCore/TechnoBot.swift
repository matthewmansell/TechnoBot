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
        vc.setupPlot(audioSystem.getOutput())
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
        vc.setupPlot(audioSystem.getOutput())
        newSection = brain.generateSection()
        processSection()
        log("System reset.")
    }
    
    /// Pushes stored changes and then generates ones for next sectionaz.
    public func processSection() {
        log("Pushing generated section.")
        _ = audioSystem.getOutput()
        //vc.setupPlot(AKNode())
        audioSystem.pushSection(newSection) //Push stored changes
        //vc.setupPlot(audioSystem.getOutput())
        for item in newSection.notes { (log("----"+item)) }
        log("Processing next section...")
        newSection = brain.generateSection() //Generate new changes
    }
    
    /// Write to log
    public func log(_ s : String) { vc.writeLog(s) }
    /// Update sequence timer
    public func updateTimer(_ beat: Int) { vc.setBeat(beat+1) }
    
    /// Random number utility
    static func randomInt(_ n: Int) -> Int { return Int(arc4random_uniform(UInt32(n))) }
    static func randomBetween(_ lower: Double, _ higher: Double) -> Double {
        return 0.5
    }
}

//Just some utility extensions

public extension Int {
    
}
