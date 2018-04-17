//
//  TechnoBot.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 04/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation

public class TechnoBot {
    
    static let shared = TechnoBot() //Single shared instance
    
    var brain = TBBrain() //Brain/idea generation
    var audioSystem = TBAudioSystem() //Audio system
    
    /// Play/pause audio system
    public func togPlaying() {
        
    }
    
    public func reset() {
        audioSystem = TBAudioSystem() //Re-initialise system
    }
    
    public func togRecord() -> Bool {
        return false;
    }
    
}

