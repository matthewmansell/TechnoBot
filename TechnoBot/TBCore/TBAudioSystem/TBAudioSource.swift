//
//  TBAudioSource.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 10/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBAudioSource {
    
    var osc = AKOscillator()
    
    public init() {
        osc.start()
    }
    
    public func getOutput() -> AKNode {
        return osc
    }
    
    
}
