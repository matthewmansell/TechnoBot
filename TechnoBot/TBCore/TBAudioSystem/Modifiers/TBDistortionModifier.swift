//
//  TBDistortionModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBDistortionModifier : TBAudioModifier {
    
    public var distortionUnit = AKDistortion()
    
    public override func setInput(_ input: AKNode) {
        distortionUnit = AKDistortion(input)
        distortionUnit.start()
        super.mixer = AKDryWetMixer(input, distortionUnit)
    }
    
    
}
