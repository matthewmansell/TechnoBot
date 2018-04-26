//
//  TBSampler.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 20/04/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Wrapper for AK Sampler
public class TBSampler : TBInstrument {
    
    private var sampler = AKAppleSampler()
    var x = AKSamplePlayer()
    
    override public init(midiInputName: String? = nil) {
        super.init(midiInputName: midiInputName)
        instrumentID = "Sampler"
    }
    
    public func loadSample(_ file: URL?) {
        if(file != nil) {
            let f : AKAudioFile
            do { try f = AKAudioFile(forReading: file!)
                try sampler.loadAudioFile(f)
            } catch { TechnoBot.shared.log("File could not be loaded") }
        }
    }
    
    override public func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        do { try sampler.play()
        } catch { TechnoBot.shared.log("Sampler cannot play.") }
    }
    
    override public func stop(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        //Not required
    }
    
    override public func getOutput() -> AKNode {
        return sampler
    }
}
