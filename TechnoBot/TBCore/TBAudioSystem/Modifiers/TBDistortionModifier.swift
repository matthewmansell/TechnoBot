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
    
    private var distortion = AKDistortion()
    
    public func setInput(_ input: AKNode) {
        distortion = AKDistortion(input)
        distortion.start()
    }
    public func getOutput() -> AKNode { return distortion }
    
    public func duplicate() -> TBAudioModifier {
        let duplicate = TBDistortionModifier()
        //duplicate.distortion.
        return duplicate
    }
    
    public static func factory(_ intensity: ModifierIntensity) -> TBAudioModifier {
        print("DISTORTION!!!!!")
        let distortion = TBDistortionModifier()
        ///switch intensity {
        ///case .low: distortion.distortion.
        ///case .high: (verb.modifier as! AKReverb).dryWetMix = 0.5
        ///}
        return distortion
    }
    
    
}
