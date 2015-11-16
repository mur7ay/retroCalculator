//
//  ViewController.swift
//  retroCalculator
//
//  Created by shawn murray on 11/14/15.
//  Copyright © 2015 shawn murray. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtraction = "-"
        case Add = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }

    // Outlets
    @IBOutlet var numLabel: UILabel!
    
    // Properties
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    } // End of viewDidLoad

    @IBAction func numberPressed(btn: UIButton) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        numLabel.text = runningNumber
        
    } // End of numberPressed
    
    @IBAction func divideButtonPressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func multiplicationButtonPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func subtractionButtonPressed(sender: AnyObject) {
        processOperation(Operation.Subtraction)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func equalButtonPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        processOperation(Operation.Clear)
        
        if currentOperation == Operation.Clear {
            numLabel.text = "0"
        }
    }
    
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            
            // Prevents error if user selects two operators in a row
            if runningNumber != "" {
                
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtraction {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                numLabel.text = result
                
            }
            
            currentOperation = op
            
            
        } else {
            // first time an operator is pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
        
    } // End of processOperation
    
    func playSound() {
        
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }

}

