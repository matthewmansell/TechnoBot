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
    
    
    public var instrumentID = "Sampler"
    private var sampler = AKAppleSampler()
    
    init(_ file: String? = nil) {
        if(file != nil) { loadSample(file!) }
    }
    
    public func loadSample(_ file: String) {
        let f : AKAudioFile
        do { try f = AKAudioFile(forReading: URL(fileURLWithPath: file))
            try sampler.loadAudioFile(f)
        } catch { TechnoBot.shared.log("File could not be loaded") }
    }
    
    public func play() {
        do { try sampler.play()
        } catch { TechnoBot.shared.log("Cannot play.") }
    }
    
    public func pause() { }
        //try sampler.stop() }
    
    public func getOutput() -> AKNode {
        //fMO.start()
        
        return sampler
    }
    
}
