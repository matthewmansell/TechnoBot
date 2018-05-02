//
//  TBIntrument.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 07/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Wrapper for AKMIDIInstrument. Not to be used directly!
public class TBInstrument: AKMIDIInstrument {
    internal(set) public var instrumentID: String = "Default" //Type identifier
    public var tag : RecognisedSoundTag? = nil
    func getOutput() -> AKNode { return AKNode() }//Output
    func pitchBend(_ time: Double) {}
    func duplicate() -> TBInstrument {
        return TBInstrument()
    }
}
