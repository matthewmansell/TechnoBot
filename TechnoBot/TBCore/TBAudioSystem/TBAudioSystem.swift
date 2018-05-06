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
    
    var unitMixer = AKMixer() //Unit bus
    var outputMixer = AKMixer() //Output stream
    var plotMixer = AKMixer() //Output to recorder
    var modifiers : TBModifierGroup //Master bus inserts
    var sequencer = TBSequencer() //Main Sequencer
    //var limiter : AKPeakLimiter? //Used as output, level safety is important!
    var recorder : AKNodeRecorder? = nil
    var recordingSettings: [String : Any] = [:] as [String : Any] //Specify recording settings?
    var started = false;
    
    /// Initialises the audio system
    public init() {
        modifiers = TBModifierGroup(unitMixer, slots: MOD_SLOTS)
        AudioKit.output = outputMixer //Reset output
    }
    
    public func reset() {
        sequencer.pause()
        do { try AudioKit.stop()
            started = false;
        } catch { AKLog("AudioKit did not stop!"); }
        outputMixer.disconnectInput(bus: 0)
        unitMixer = AKMixer()
        modifiers.removeAll()
        sequencer.sequencer.tracks.removeAll()
        sequencer.rewind()
        recorder = nil
    }
    
    public func getOutput() -> AKNode { return plotMixer }
    
    public func play() { sequencer.play() }
    public func pause() { sequencer.pause() }
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
            try recorder = AKNodeRecorder(node: outputMixer, file: audioFile)
            try recorder!.record()
            TechnoBot.shared.log("Recording to \"" + fileURL!.absoluteString + "\"") //Notify location
        } catch { TechnoBot.shared.log("Could not start recording.") }
    }
    public func stopRecording() {
        recorder?.stop()
        recorder = nil
        TechnoBot.shared.log("Recording stopped.")
    }
    public func isRecording() -> Bool { if(recorder != nil) { return recorder!.isRecording } else { return false } }
    
    /// Called once per beat, updates timer.
    public func tickOn() { TechnoBot.shared.updateTimer(sequencer.getBeat()) }
    
    /// Called at end of beat
    public func tickOff() {
        if(sequencer.getBeat() >= 32) {
            sequencer.pause()
            TechnoBot.shared.processSection()
            sequencer.rewind()
            sequencer.play()
        }
    }
    
    /// Re-chains audio streams including new content.
    public func pushSection(_ newSection: TBSection) {
        let wasPlaying = sequencer.isPlaying()
        //do { try AudioKit.stop()
        //    started = false;
        //} catch { AKLog("AudioKit did not stop!"); }
        sequencer = TBSequencer() //Reset sequencer
        unitMixer = AKMixer() //Reset mixer
        modifiers = TBModifierGroup(unitMixer, slots: MOD_SLOTS)
        generateClick(sequencer)
        outputMixer.disconnectInput(bus: 0)
        
        for unit in newSection.audioUnits {
            unitMixer.connect(input: unit.getOutput())
            sequencer.connectAudioUnit(unit)
        } //Add all instruments
        modifiers.setInput(unitMixer) //Reset modifier input
        //let inputs = [outputMixer.input(0), plotMixer.input(0)]
        //modifiers.getOutput().outputNode.connect(toInputs: inputs)
        outputMixer.connect(input: modifiers.getOutput(), bus: 0)
        
        if(wasPlaying) { play() }
        if(!started) {
            do { try AudioKit.start()
            } catch { AKLog("AudioKit did not start!"); }
            started = true
        }
    }
    
    //Internal click instrument
    public func generateClick(_ sequencer: TBSequencer) {
        //Generate sequencer event instrument
        let tick = TBTickInstrument(noteDownCallback: tickOn, noteUpCallback: tickOff)
        let track = sequencer.sequencer.newTrack()
        track?.setMIDIOutput(tick.midiIn)
        for i in 0...64 {
            track!.add(noteNumber: 60, velocity: 100, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 1))
        }
    }
    
    deinit {
        pause()
        if(isRecording()) { stopRecording() }
    }
}

///Instrument allowing funcitons to be attatched to note up/down events.
public class TBTickInstrument: AKMIDIInstrument {
    var noteDownCallback : () -> Void
    var noteUpCallback : () -> Void
    
    /**
     - Parameter noteDownCallBack: Function pointer for note down
     - Parameter noteUpCallBack: Function pointer for note up
     */
    public init(noteDownCallback: @escaping () -> Void, noteUpCallback: @escaping () -> Void) {
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
