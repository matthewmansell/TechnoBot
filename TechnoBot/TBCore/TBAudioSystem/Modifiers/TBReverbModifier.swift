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
    
    public var reverb = AKReverb()
    
    public override func setInput(_ input: AKNode) {
        reverb = AKReverb(input, dryWetMix: 1)
        reverb.start()
        //super.mixer = AKDryWetMixer(input, reverbUnit)
    }
    
    public override func getOutput() -> AKNode {
        return reverb
    }
    
}
