//
//  TBAudioModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// A 'blank' modifier is provided for extension. Defult simply passes input.
public class TBAudioModifier {
    
    var input = AKNode()
    internal var mixer: AKDryWetMixer? //Modifier mix
    internal var modifier = AKNode() //To be replaced by extensions
    
    func setInput(_ input: AKNode) {
        self.input = input
        //mixer = AKDryWetMixer(input, modifier, balance: 50)
    }
    
    func getOutput() -> AKNode {
        //if mixer != nil { return mixer! }
        //else { return modifier }
        return input
    }
    
    /// Dry/wet balance: dry = 0, wet = 100
    //func setMix(_ mix: Double) { if mixer != nil { mixer!.balance = mix } }
    
    
}
