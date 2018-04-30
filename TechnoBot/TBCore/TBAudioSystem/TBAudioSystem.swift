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
    let RECORDINGS_FOLDER = "TechnoBot_Recordings"
    let RECORD_FILE = "TBRecording"
    
    var mixer = AKMixer() //Master bus
    var audioUnits = [TBAudioUnit]() //All audio units
    //var xyz = Set<TBAudioUnit>()
    var modifiers : TBModifierGroup //Master bus inserts
    var sequencer = TBSequencer() //Main Sequencer
    //var limiter : AKPeakLimiter? //Used as output, level safety is important!
    var recorder : AKNodeRecorder? = nil
    var recordingSettings: [String : Any] = [:] as [String : Any] //Specify recording settings?
    
    /// Initialises the audio system
    public init() {
        modifiers = TBModifierGroup(mixer, slots: MOD_SLOTS)
        pushChanges() //Setup signal chain
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
        //mixer!.start()
        sequencer.play()
    }
    public func pause() {
        //mixer!.stop()
        sequencer.pause()
    }
    
    /// Sets up recorder and starts recording stream to a new file
    public func startRecording() {
        let directoryPath = NSHomeDirectory() + "/Music/" + RECORDINGS_FOLDER //Folder path
        var isDir : ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDir) { //Need to creade folder first?
            do { try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch { print(error) }
        }
        let date = Date(); let calendar = Calendar.current
        let dateString = String(calendar.component(.year, from: date)) + String(calendar.component(.month, from: date)) + String(calendar.component(.day, from: date))
        let timeString = String(calendar.component(.hour, from: date)) + String(calendar.component(.minute, from: date))
        var fileName = RECORD_FILE + "_" + dateString + "_" + timeString
        var noCount = 0
        while FileManager.default.fileExists(atPath: directoryPath + "/" + fileName) { noCount += 1 } //Exists
        if(noCount != 0) { fileName += "-" + String(noCount) } //Add suffix
        let fileURL = URL(string: directoryPath + "/" + fileName + ".alac")
        //FileManager.default.createFile(atPath: fileURL!.path, contents: nil, attributes: nil)
        do { let audioFile = try AKAudioFile(forWriting: fileURL!, settings: AKSettings.audioFormat.settings)
            //let m = AKMixer(); m.connect(input: limiter!)
            try recorder = AKNodeRecorder(node: modifiers.getOutput(), file: audioFile)
            try recorder?.record()
            TechnoBot.shared.log("Recording to \"" + fileURL!.absoluteString + "\"") //Notify location
        } catch { TechnoBot.shared.log("Could not start recording.") }
    }
    public func stopRecording() { recorder?.stop(); recorder = nil; TechnoBot.shared.log("") }
    public func isRecording() -> Bool {
        if(recorder != nil) { return recorder!.isRecording }
        else { return false }
    }
    
    public func isPlaying() -> Bool { return sequencer.isPlaying() }
    
    public func addAudioUnit(_ unit: TBAudioUnit) {
        audioUnits.append(unit) //Add unit
        sequencer.pause()
        sequencer.connectAudioUnit(unit) //Connect to sequencer
        sequencer.sequencer.setLength(AKDuration(beats: 4))
        sequencer.sequencer.enableLooping()
        sequencer.play()
        //mixer.connect(input: unit.getOutput()) //Connect to mixer
        //refresh()
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
    
    /// Called once per beat, updates timer.
    public func tickOn() { TechnoBot.shared.updateTimer(sequencer.getBeat()) }
    
    /// Called at end of beat
    public func tickOff() {
        if(sequencer.getBeat() == 64) {
            sequencer.pause()
            audioUnits.removeAll()
            //mixer = AKMixer()
            sequencer.rewind()
            sequencer.play()
        }
    }
    
    /// Re-chains audio streams including new content.
    public func pushChanges() {
        mixer = AKMixer() //Reset mixer
        for unit in audioUnits { mixer.connect(input: unit.getOutput()) } //Add all instruments
        modifiers.setInput(mixer) //Reset modifier input
        //limiter = AKPeakLimiter(modifiers.getOutput()) //Reset limiter
        AudioKit.output = modifiers.getOutput() //Reset output
    }
}

/// Custom instrument type for
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

