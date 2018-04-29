//
//  TBSequencer.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 14/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import AudioKit

public class TBSequencer  {
    
    let sequencer = AKSequencer()
    //private let click : AKMusicTrack
    
    init() {
        sequencer.setTempo(128)
    }
    public func play() { sequencer.play() }
    public func pause() { sequencer.stop() }
    public func isPlaying() -> Bool { return sequencer.isPlaying }
    public func getBeat() -> Int { return Int(round(sequencer.currentPosition.beats)) }
    public func rewind() {
        sequencer.setTime(MusicTimeStamp(0))
        //sequencer.rewind()
    }
    
    public func connectAudioUnit(_ unit: TBAudioUnit) {
        let t = sequencer.newTrack()
        unit.getTrack().copyAndMergeTo(musicTrack: t!)
        t?.setMIDIOutput(unit.instrument.midiIn)
        //sequencer.tracks.append(track)
    }
}
