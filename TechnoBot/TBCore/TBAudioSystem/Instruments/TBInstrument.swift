//
//  TBIntrument.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 07/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Protocol for which instruments to adhere
public protocol TBInstrument {
    /// An instrument should have a type identifier.
    var instrumentID : String {get set}
    /// An instrument should be able to store a tag.
    var tag : RecognisedSoundTag? {get set}
    /// An instrument should have a MIDI endpoint.
    func midiIn() -> MIDIEndpointRef
    /// An instrument should have an output.
    func getOutput() -> AKNode
    /// An instrument should be able to start.
    func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity)
    /// An instrument should be able to stop.
    func stop()
    /// An instruent should be able to duplicate itself.
    func duplicate() -> TBInstrument
    /// An instrument should contain its own factory.
    static func factory() -> TBInstrument
}

/// MIDIInstrument with function callback ability. Can be used to wrap non MIDI instruments.
public class TBCallbackInstrument: AKMIDIInstrument {
    var noteDownCallback : (MIDINoteNumber, MIDIVelocity) -> Void
    var noteUpCallback : () -> Void
    
    init(noteDownCallback: @escaping (MIDINoteNumber, MIDIVelocity) -> Void, noteUpCallback: @escaping () -> Void) {
        self.noteDownCallback = noteDownCallback
        self.noteUpCallback = noteUpCallback
        super.init(midiInputName: "TBCallbackInstrument")
    }
    
    //Called on note down
    override public func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        DispatchQueue.main.async { self.noteDownCallback(noteNumber, velocity) }
    }
    //Called on note up
    override public func stop(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        DispatchQueue.main.async { self.noteUpCallback() }
    }
}
