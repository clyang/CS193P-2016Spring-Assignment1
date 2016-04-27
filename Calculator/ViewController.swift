//
//  ViewController.swift
//  Calculator
//
//  Created by Cheng-Lin Yang on 2016/4/21.
//  Copyright © 2016年 Cheng-Lin Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var performedProcess: UILabel!
    private var userIsIntheMiddleOfTyping = false
    private var userPressFloatPoint = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsIntheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if textCurrentlyInDisplay == "0" && digit != "0" && digit != "⬅︎"{
                if digit == "." {
                    display.text = "0."
                } else {
                    display.text = digit
                }
            } else if textCurrentlyInDisplay != "0" && digit != "⬅︎" {
                if digit == "." && userPressFloatPoint == false  {
                    display.text = textCurrentlyInDisplay + digit
                    userPressFloatPoint = true
                } else if digit != "." {
                    display.text = textCurrentlyInDisplay + digit
                }
            } else if digit == "⬅︎" {
                if textCurrentlyInDisplay.characters.count > 1 {
                    if textCurrentlyInDisplay.characters.last == "." {
                        userPressFloatPoint = false
                    }
                    display.text = textCurrentlyInDisplay.substringToIndex(textCurrentlyInDisplay.endIndex.predecessor())
                } else {
                    display.text = "0"
                }
            }
        } else {
            if digit == "." {
                userPressFloatPoint = true
                display.text = "0."
                userIsIntheMiddleOfTyping = true
            } else if digit != "⬅︎" {
                display.text = digit
                userIsIntheMiddleOfTyping = true
            }
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if floor(newValue) == newValue {
                display.text = String(Int(newValue))
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    private var isProcessable: Bool {
        get {
            return display.text! != "-"
            
        }
    }
    
    private var brain = CalculatorBrain()
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsIntheMiddleOfTyping && isProcessable {
            brain.setOperand(displayValue)
            if floor(displayValue) == displayValue {
                performedProcess.text = performedProcess.text! + " " + String(Int(displayValue))
            } else {
                performedProcess.text = performedProcess.text! + " " + String(displayValue)
            }
        }
        
        if let symbols = sender.currentTitle {
            if symbols == "C" {
                performedProcess.text = ""
                userPressFloatPoint = false
                userIsIntheMiddleOfTyping = false
                brain.performOperation(symbols)
                displayValue = brain.result
            } else {
                if symbols != "=" {
                    let replacedString = performedProcess.text!.stringByReplacingOccurrencesOfString("=", withString: "")
                    performedProcess.text = replacedString + " " + symbols + " ="
                    if symbols == "+/-" {
                        if userIsIntheMiddleOfTyping {
                            displayValue = displayValue * -1
                        } else {
                            brain.performOperation(symbols)
                            displayValue = brain.result
                            userIsIntheMiddleOfTyping = false
                            userPressFloatPoint = false
                        }
                    } else if isProcessable {
                        brain.performOperation(symbols)
                        displayValue = brain.result
                        userIsIntheMiddleOfTyping = false
                    }
                } else if symbols == "=" && isProcessable {
                    brain.performOperation(symbols)
                    displayValue = brain.result
                    userIsIntheMiddleOfTyping = false
                    userPressFloatPoint = false
                }
            }
        }
        
    }
}

