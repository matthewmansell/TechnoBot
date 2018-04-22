//
//  TBFMSynthesiser.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 07/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Wrapper for AKFM Oscillator
public class TBFMSynthesiser : TBInstrument {
    
    
    public var instrumentID = "FM"
    private var fMO = AKFMOscillator()
    
    init() {
        fMO.presetWobble()
    }
    
    public func play() { fMO.start() }
    
    public func pause() { fMO.stop() }
    
    public func getOutput() -> AKNode {
        //fMO.start()
        return fMO
    }
    
}
