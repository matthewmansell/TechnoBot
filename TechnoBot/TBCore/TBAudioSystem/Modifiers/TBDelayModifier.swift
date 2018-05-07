//
//  TBDelayModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBDelayModifier : TBAudioModifier {
    
    private var delay = AKDelay()
    
    public func setInput(_ input: AKNode) {
        let dwm = delay.dryWetMix, fb = delay.feedback, t = delay.time
        delay = AKDelay(input)
        delay.dryWetMix = dwm
        delay.feedback = fb
        delay.time = t
        delay.start()
    }
    
    public func getOutput() -> AKNode { return delay }
    
    public func duplicate() -> TBAudioModifier {
        let duplicate = TBDelayModifier()
        duplicate.delay.dryWetMix = delay.dryWetMix
        duplicate.delay.feedback = delay.feedback
        duplicate.delay.time = delay.time
        return duplicate
    }
    
    public static func factory(_ intensity: ModifierIntensity) -> TBAudioModifier {
        let delay = TBDelayModifier()
        switch intensity {
        case .low:
            delay.delay.dryWetMix = Double.random(min: 0.1, max: 0.5)
            delay.delay.feedback = Double.random(min: 0.1, max: 0.25)
            delay.delay.time = TimeInterval(Double.random(min:0.1, max: 0.5))
        case .high:
            delay.delay.dryWetMix = Double.random(min: 0.5, max: 1.0)
            delay.delay.feedback = Double.random(min: 0.25, max: 0.5)
            delay.delay.time = TimeInterval(Double.random(min:0.5, max: 1.0))
        }
        return delay
    }
}
