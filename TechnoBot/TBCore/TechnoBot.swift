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
        //vc.setupPlot(audioSystem.getOutput())
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
        brain.reset() //Re-initialise brain
        audioSystem.reset() //Re-initialise audio system
        newSection = brain.generateSection()
        processSection()
        //vc.setupPlot(audioSystem.getOutput())
        log("System reset.")
    }
    
    public func setAdaption(_ value: Double) { brain.setAdaptionRate(value) }
    
    /// Pushes stored changes and then generates ones for next sectionaz.
    public func processSection() {
        log("New Section")
        _ = audioSystem.getOutput()
        audioSystem.pushSection(newSection) //Push stored changes
        for item in newSection.notes { (log("TB: "+item)) }
        newSection = brain.generateSection() //Generate new changes
    }
    
    /// Write to log
    public func log(_ s : String) { vc.writeLog(s) }
    /// Update sequence timer
    public func updateTimer(_ beat: Int) { vc.setBeat(beat+1) }
    
}

/// Int with random funciton extensions
public extension Int {
    public static func random(_ n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(max-min+1)+min
    }
}
/// Double with random function extensions
public extension Double {
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    public static func random(min: Double, max: Double) -> Double {
        return Double.random()*(max-min)+min
    }
}


