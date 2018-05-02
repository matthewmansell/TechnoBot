//
//  TBSection.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 01/05/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation

/// Represents a section of music. Insludes all audiounits and modifiers for the audiosystem
public class TBSection {
    var audioUnits = [TBAudioUnit]() //All audio units
    var masterModifiers = [TBAudioModifier]() //Modifiers to apply to master bus
}
