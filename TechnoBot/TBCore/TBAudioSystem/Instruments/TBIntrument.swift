//
//  TBIntrument.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 07/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Wrapper for AKMIDIInstrument
public class TBInstrument: AKMIDIInstrument {
    var osc = AKOscillator()
    var instrumentID: String = "Default" //Type identifier
    //var midiIn: MIDIEndpointRef {get}
    func getOutput() -> AKNode { return osc }//Output
    //func start(noteNumber: MIDINoteNumber?, velocity: MIDIVelocity?)
    //func stop()
}
