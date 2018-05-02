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
    var sample = ""
    
    init() {
        super.init()
        instrumentID = "Sampler"
        loadSample("kick_01")
    }
    
    public func loadSample(_ file: String) {
        sample = file
        let url = Bundle.main.url(forResource: file, withExtension: "wav") //Convert to url
        if(url != nil) {
            let audioFile : AKAudioFile
            do { try audioFile = AKAudioFile(forReading: url!)
                try sampler.loadAudioFile(audioFile)
            } catch { TechnoBot.shared.log("File could not be loaded") }
        }
    }
    
    override public func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        do { try sampler.play()
        } catch { TechnoBot.shared.log("Sampler cannot play.") }
    }
    /// Not used in sampler
    override public func stop(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        do { try sampler.stop()
        } catch { TechnoBot.shared.log("Sampler cannot stop.") }
    }
    override public func getOutput() -> AKNode { return sampler }
    override public func duplicate() -> TBInstrument {
        let sampler = TBSampler()
        sampler.loadSample(sample)
        return sampler
    }
}
