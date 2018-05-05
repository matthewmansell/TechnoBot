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
import AudioKitUI

class ViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var seq16: NSLevelIndicator!
    @IBOutlet weak var seq4: NSLevelIndicator!
    @IBOutlet weak var seq1: NSLevelIndicator!
    @IBOutlet weak var beat: NSTextField!
    @IBOutlet var log: NSTextView!
    @IBOutlet weak var play: NSButton!
    @IBOutlet weak var record: NSButton!
    @IBOutlet weak var audioPlot: EZAudioPlot!
    
    var plot : AKNodeOutputPlot? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override var representedObject: Any? { didSet {} }
    override func viewDidAppear() { self.view.window?.delegate = self }
    private func windowShouldClose(_ sender: NSWindow) { NSApplication.shared.terminate(self) }
    
    func setBeat(_ beat: Int) {
        let s16 = (ceil(beat/16)-1).truncatingRemainder(dividingBy: 4)
        let s4 = (ceil(beat/4)-1).truncatingRemainder(dividingBy: 4)
        let s1 = (beat-1).truncatingRemainder(dividingBy: 4)
        seq16.doubleValue = s16
        seq4.doubleValue = s4
        seq1.doubleValue = s1
        self.beat.stringValue = String(beat)
    }
    
    func setupPlot(_ node: AKNode) {
        plot?.clear()
        plot = AKNodeOutputPlot(node, frame: audioPlot.bounds)
        plot!.plotType = .buffer
        plot!.shouldFill = true
        //plot!.shouldMirror = true
        plot!.color = NSColor.gray
        plot!.backgroundColor = NSColor.clear
        plot!.gain = 2
        //plot!.autoresizingMask = NSView.AutoresizingMask.width
        audioPlot.addSubview(plot!)
    }
    
    @IBAction func toggleSeq(_ sender: NSButton) {
        if(TechnoBot.shared.togPlaying()) { sender.state = NSControl.StateValue(rawValue: 1) }
        else { sender.state = NSControl.StateValue(rawValue: 0) }
    }
    
    @IBAction func togRecord(_ sender: NSButton) {
        if(TechnoBot.shared.togRecord()) { sender.state = NSControl.StateValue(rawValue: 1) }
        else { sender.state = NSControl.StateValue(rawValue: 0) }
    }
    
    @IBAction func resetSystem(_ sender: NSButton) {
        TechnoBot.shared.reset()
        play.state = NSControl.StateValue(rawValue: 0)
        record.state = NSControl.StateValue(rawValue: 0)
    }
    
    
    
    func writeLog(_ s: String) {
        log.textStorage?.append(NSAttributedString(string: s + "\n"))
        log.scrollToEndOfDocument(self)
    }
}
