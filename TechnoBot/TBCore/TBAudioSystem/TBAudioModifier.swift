//
//  TBAudioModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBAudioModifier {
    
    internal var mixer = AKDryWetMixer()
    
    public init() {
        
    }
    
    func setInput(_ input: AKNode) {
        mixer = AKDryWetMixer(input, input, balance: 0) //No mix by default
    }
    
    func getOutput() -> AKNode {
        return mixer
    }
    
    func setMix(mix: Double) {
        mixer.balance = mix
    }
    
    
}
