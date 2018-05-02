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

    private var interfaceInstrument : TBCallbackInstrument?
    private var sampler = AKAppleSampler()
    private var sample = ""
    
    public var instrumentID = "Sampler"
    public var tag: RecognisedSoundTag?
    
    init() {
        interfaceInstrument = TBCallbackInstrument(noteDownCallback: self.start, noteUpCallback: self.stop)
        instrumentID = "Sampler"
        loadSample("kick_01")
    }
    
    public func midiIn() -> MIDIEndpointRef {
        return interfaceInstrument!.midiIn
    }
    
    public func start(noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        do { try sampler.play()
        } catch { TechnoBot.shared.log("Sampler cannot play.") }
    }
    public func stop() {
        do { try sampler.stop()
        } catch { TechnoBot.shared.log("Sampler cannot stop.") }
    }
    public func getOutput() -> AKNode { return sampler }
    
    public func duplicate() -> TBInstrument {
        let sampler = TBSampler()
        sampler.loadSample(sample)
        return sampler
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
    
    public static func factory() -> TBInstrument {
        let sampler = TBSampler()
        return sampler
    }
}
