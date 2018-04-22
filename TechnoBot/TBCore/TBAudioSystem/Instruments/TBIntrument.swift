//
//  TBIntrument.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 07/03/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

/// Protocol for instrument type conforment
public protocol TBInstrument {
    var instrumentID: String { get } //Type identifier
    func getOutput() -> AKNode //Output
    func play()
    func pause()
    //func setInput()
}
