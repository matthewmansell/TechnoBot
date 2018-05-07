//
//  TBPhaserModifier.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBPhaserModifier : TBAudioModifier {
    
    private var phaser = AKPhaser()
    
    public func setInput(_ input: AKNode) {
        let nw = phaser.notchWidth, nf = phaser.notchFrequency //Store
        let dep = phaser.depth, fb = phaser.feedback
        phaser = AKPhaser(input)
        phaser.notchFrequency = nw
        phaser.notchFrequency = nf
        phaser.depth = dep
        phaser.feedback = fb
        phaser.start()
    }
    public func getOutput() -> AKNode { return phaser }
    
    public func duplicate() -> TBAudioModifier {
        let duplicate = TBPhaserModifier()
        duplicate.phaser.notchWidth = phaser.notchWidth
        duplicate.phaser.notchFrequency = phaser.notchFrequency
        duplicate.phaser.depth = phaser.depth
        duplicate.phaser.feedback = phaser.feedback
        return duplicate
    }
    
    public static func factory(_ intensity: ModifierIntensity) -> TBAudioModifier {
        let phaser = TBPhaserModifier()
        switch intensity {
        case .low:
            phaser.phaser.notchWidth = Double.random(min: 10, max: 2495)
            phaser.phaser.notchFrequency = Double.random(min: 1.1, max: 3.45)
            phaser.phaser.depth = Double.random(min: 0.1, max: 0.5)
            phaser.phaser.feedback = Double.random(min: 0.1, max: 0.5)
        case .high:
            phaser.phaser.notchWidth = Double.random(min: 2495, max: 5000)
            phaser.phaser.notchFrequency = Double.random(min: 3.45, max: 4)
            phaser.phaser.depth = Double.random(min: 0.5, max: 1.0)
            phaser.phaser.feedback = Double.random(min: 0.5, max: 1.0)
        }
        return phaser
    }
}
