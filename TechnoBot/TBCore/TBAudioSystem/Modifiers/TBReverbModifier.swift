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
    
    public func setInput(_ input: AKNode) {
        reverb = AKReverb(input, dryWetMix: 0.1)
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
        case .low: verb.reverb.dryWetMix = 0.1
        case .high: verb.reverb.dryWetMix = 0.5
        }
        return verb
    }
    
}
