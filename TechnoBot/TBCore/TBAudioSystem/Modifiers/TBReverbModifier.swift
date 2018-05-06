//
//  TBReverbModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBReverbModifier : TBAudioModifier {
    
    private var reverb = AKReverb()
    private var dryWetMix = 0.1
    
    public func setInput(_ input: AKNode) {
        let dwm = reverb.dryWetMix
        reverb = AKReverb(input, dryWetMix: dwm)
        reverb.start()
    }
    
    public func getOutput() -> AKNode { return reverb }
    
    public func duplicate() -> TBAudioModifier {
        let duplicate = TBReverbModifier()
        duplicate.reverb.dryWetMix = reverb.dryWetMix
        return duplicate
    }
    
    public static func factory(_ intensity: ModifierIntensity) -> TBAudioModifier {
        let verb = TBReverbModifier()
        switch intensity {
        case .low: verb.reverb.dryWetMix = Double.random(min: 0.0, max: 0.5)
        case .high: verb.reverb.dryWetMix = Double.random(min: 0.5, max: 1.0)
        }
        return verb
    }
    
}
