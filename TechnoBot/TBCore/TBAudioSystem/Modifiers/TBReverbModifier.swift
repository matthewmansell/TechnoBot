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
    
    public var reverbUnit = AKReverb()
    
    public override func setInput(_ input: AKNode) {
        reverbUnit = AKReverb(input, dryWetMix: 1)
        reverbUnit.start()
        super.mixer = AKDryWetMixer(input, reverbUnit)
    }
    
}
