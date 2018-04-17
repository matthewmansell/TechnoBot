//
//  ViewController.swift
//  TechnoBot
//
//  Created by Matthew Mansell on 09/02/2018.
//  Copyright © 2018 MatthewMansell. All rights reserved.
//

import Foundation
import Cocoa
import AudioKit



class ViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var seq16: NSLevelIndicator!
    @IBOutlet weak var seq4: NSLevelIndicator!
    @IBOutlet weak var seq1: NSLevelIndicator!
    @IBOutlet weak var beat: NSTextField!
    @IBOutlet weak var tempo: NSTextField!
    
    var kick = AKSynthKick()
    var snare = AKSynthSnare()
    var hat = AKShaker()
    var pad = AKOscillatorBank()
    var mixer = AKMixer()
    var phaser = AKPhaser()
    var reverb = AKReverb()
    var limiter = AKPeakLimiter()
    var midi = AKMIDI()
    var sequencer = AKSequencer()
    var osc = AKFMOscillator()
    
    let sequenceLength = AKDuration(beats: 4.0)
    
    let tb = TechnoBot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tb.start()

        /*
        setBeat()
        let click = TBMidiCallback(callback: self.setBeat)
        var midiNode = AKMIDINode(node: pad)
        mixer = AKMixer(kick, snare, pad, osc)
        phaser = AKPhaser(mixer)
        reverb = AKReverb(phaser)
        limiter = AKPeakLimiter(reverb, attackTime: 0.01, decayTime: 0.01, preGain: 0)
        osc.start()
        osc.presetSpiral()
        //AudioKit.output = osc
       // do {
        //    try AudioKit.start()
        //} catch {
        //    //Nothing
        //}
        
        _ = sequencer.newTrack()
        sequencer.tracks[Sequence.click.rawValue].setMIDIOutput(click.midiIn)
        generateClickSequence()
        
        _ = sequencer.newTrack()
        sequencer.tracks[Sequence.kick.rawValue].setMIDIOutput(kick.midiIn)
        generateKickSequence()
        
        _ = sequencer.newTrack()
        sequencer.tracks[Sequence.snare.rawValue].setMIDIOutput(snare.midiIn)
        generateSnareSequence()
        
        _ = sequencer.newTrack()
        sequencer.tracks[Sequence.melody.rawValue].setMIDIOutput(midiNode.midiIn)
        generateMelodySequence()
        
        
        sequencer.setTempo(125)
        sequencer.setLength(sequenceLength)
        sequencer.enableLooping()
        //sequencer.setLoopInfo(AKDuration(beats:64), numberOfLoops: 2)
        //sequencer.enableLooping()
        
        */
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
    }
    
    private func windowShouldClose(_ sender: NSWindow) {
        NSApplication.shared.terminate(self)
    }
    
    
    func generateClickSequence(_ stepSize: Float = 1, clear: Bool = true) {
        if clear { sequencer.tracks[Sequence.click.rawValue].clear() }
        let numberOfSteps = Int(Float(sequenceLength.beats) / stepSize)
        for i in 0 ..< numberOfSteps {
            let step = Double(i) * stepSize

            sequencer.tracks[Sequence.click.rawValue].add(noteNumber: 60,
                                                         velocity: 100,
                                                         position: AKDuration(beats: step),
                                                         duration: AKDuration(beats: 1))
        }
    }
    
    func generateKickSequence(_ stepSize: Float = 1, clear: Bool = true) {
        if clear { sequencer.tracks[Sequence.kick.rawValue].clear() }
        let numberOfSteps = Int(Float(sequenceLength.beats) / stepSize)
        for i in 0 ..< numberOfSteps {
            let step = Double(i) * stepSize
            
            sequencer.tracks[Sequence.kick.rawValue].add(noteNumber: 60,
                                                             velocity: 100,
                                                             position: AKDuration(beats: step),
                                                             duration: AKDuration(beats: 1))
        }
    }
    
    func generateSnareSequence(_ stepSize: Float = 1, clear: Bool = true) {
        if clear { sequencer.tracks[Sequence.snare.rawValue].clear() }
        let numberOfSteps = Int(Float(sequenceLength.beats) / stepSize)
        for i in stride(from: 0, to: numberOfSteps, by: 2) {
            let step = Double(i) * stepSize
            
            sequencer.tracks[Sequence.snare.rawValue].add(noteNumber: 60,
                                                         velocity: 100,
                                                         position: AKDuration(beats: step),
                                                         duration: AKDuration(beats: 1))
        }
    }
    
    func generateMelodySequence(_ stepSize: Float = 1, clear: Bool = true) {
        if clear { sequencer.tracks[Sequence.melody.rawValue].clear() }
        let numberOfSteps = Int(Float(sequenceLength.beats) / stepSize)
        for i in stride(from: 0, to: numberOfSteps, by: 1) {
            let step = Double(i) * stepSize
            sequencer.tracks[Sequence.melody.rawValue].add(noteNumber: 50,
                                                           velocity: 100,
                                                           position: AKDuration(beats: step+0.5),
                                                           duration: AKDuration(beats: 0.5))
        }
    }
    
    func setBeat() {
        let beat = round(sequencer.currentPosition.beats)
        let s16 = (ceil(beat/16)-1).truncatingRemainder(dividingBy: 4)
        let s4 = (ceil(beat/4)-1).truncatingRemainder(dividingBy: 4)
        let s1 = (beat-1).truncatingRemainder(dividingBy: 4)
        seq16.doubleValue = s16
        seq4.doubleValue = s4
        seq1.doubleValue = s1
        self.beat.stringValue = String(beat)
    }
    
    @IBAction func verb(_ sender: NSSlider) {
        reverb.dryWetMix = sender.doubleValue
    }
    
    @IBAction func toggleSeq(_ sender: NSButton) {
        TechnoBot.shared.start()
        /*
        if(sequencer.isPlaying) {
            sequencer.stop()
            sender.title = "Play"
        } else {
            sequencer.play()
            sender.title = "Stop"
        }
        */
    }
    
    @IBAction func changeTempo(_ sender: NSSlider) {
        sequencer.setTempo(round(sender.doubleValue))
        tempo.stringValue = String(sequencer.tempo)
    }
    @IBAction func sld1(_ sender: NSSlider) {
        phaser.notchWidth = sender.doubleValue
        
    }
    @IBAction func sld2(_ sender: NSSlider) {
        phaser.notchFrequency = sender.doubleValue
        
    }
    
    @IBAction func sld3(_ sender: NSSlider) {
        phaser.feedback = sender.doubleValue
    }
    @IBAction func baseFrequency(_ sender: NSSlider) {
        osc.baseFrequency = sender.doubleValue
    }
    @IBAction func carrierMultiplier(_ sender: NSSlider) {
        osc.carrierMultiplier = sender.doubleValue
    }
    @IBAction func modulatingMultiplier(_ sender: NSSlider) {
        osc.modulatingMultiplier = sender.doubleValue
    }
    @IBAction func modulationIndex(_ sender: NSSlider) {
        osc.modulationIndex = sender.doubleValue
    }
    
}

enum Sequence: Int {
    case click, kick, snare, melody
}

public class TBMidiCallback : AKMIDIInstrument {
    var callback : () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    override public func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        DispatchQueue.main.async {
            self.callback() //+ Callback function
        }
    }
}



