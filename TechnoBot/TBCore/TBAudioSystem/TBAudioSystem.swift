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
    var modifiers : TBModifierGroup //Master bus inserts
    var sequencer = TBSequencer() //Main Sequencer
    //var limiter : AKPeakLimiter? //Used as output, level safety is important!
    var recorder : AKNodeRecorder? = nil
    var recordingSettings: [String : Any] = [:] as [String : Any] //Specify recording settings?
    var section : TBSection?
    
    /// Initialises the audio system
    public init() {
        modifiers = TBModifierGroup(mixer, slots: MOD_SLOTS)
    }
    
    public func play() {
        //do { try AudioKit.start()
        //} catch { AKLog("AudioKit did not start!"); TechnoBot.shared.log("Audio system did not start!") }
        sequencer.play()
    }
    public func pause() {
        //do { try AudioKit.stop()
        //} catch { AKLog("AudioKit could not stop!"); TechnoBot.shared.log("Audio system could not stop!") }
        sequencer.pause()
    }
    public func isPlaying() -> Bool { return sequencer.isPlaying() }
    
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
    public func stopRecording() { recorder?.stop(); recorder = nil; TechnoBot.shared.log("Recording stopped.") }
    public func isRecording() -> Bool { if(recorder != nil) { return recorder!.isRecording } else { return false } }
    
    /// Adds an audio unit
    //public func addAudioUnit(_ unit: TBAudioUnit) { audioUnits.append(unit) }
    
    /// Clears a given audio unit
    /*
    public func removeAudioUnit(_ unit: TBAudioUnit) {
        var index = 0;
        for i in 0..<audioUnits.count { if(unit === audioUnits[i]) { index = i; break } } //Same object
        audioUnits.remove(at: index)
    }
 */
    //public func removeAllAudioUnits() { audioUnits.removeAll() }
    /*
    public func addModifier(_ modifier: TBAudioModifier, slot: Int? = nil) {
        if(slot != nil) {
            modifiers.setModifier(modifier: modifier, slot: slot!)
        } else { }
    }
    public func removeModifier(_ slot: Int) {
        modifiers.removeModifier(slot: slot)
    }
 */
    
    /// Called once per beat, updates timer.
    public func tickOn() { TechnoBot.shared.updateTimer(sequencer.getBeat()) }
    
    /// Called at end of beat
    public func tickOff() {
        if(sequencer.getBeat() == 16) {
            sequencer.pause()
            //sequencer.rewind()
            TechnoBot.shared.processSection()
            sequencer.rewind()
            sequencer.play()
        }
    }
    
    /// Re-chains audio streams including new content.
    public func pushSection(_ newSection: TBSection) {
        section = newSection
        let wasPlaying = sequencer.isPlaying()
        sequencer = TBSequencer() //Reset sequencer
        mixer = AKMixer() //Reset mixer
        modifiers = TBModifierGroup(mixer, slots: MOD_SLOTS)
        sequencer.connectAudioUnit(generateClick())
        //TechnoBot.shared.log(String(audioUnitCount()))
        for unit in newSection.audioUnits {
            mixer.connect(input: unit.getOutput())
            sequencer.connectAudioUnit(unit)
        } //Add all instruments
        modifiers.setInput(mixer) //Reset modifier input
        //limiter = AKPeakLimiter(modifiers.getOutput()) //Reset limiter
        AudioKit.output = mixer //Reset output
        if(wasPlaying) { play() }
        do { try AudioKit.start()
        } catch { AKLog("AudioKit did not start!"); TechnoBot.shared.log("Audio system did not start!") }
    }
    
    //Internal click instrument
    public func generateClick() -> TBAudioUnit {
        //Generate sequencer event instrument
        let eventInstrument = TBCallbackInstrument(noteDownCallback: tickOn, noteUpCallback: tickOff)
        let au = TBAudioUnit(eventInstrument)
        for i in 0...64 {
            au.musicTrack.add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 1))
        }
        //sequencer.connectAudioUnit(au)
        return au
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
        super.instrumentID = "Callback"
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

