//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Cheng-Lin Yang on 2016/4/23.
//  Copyright © 2016年 Cheng-Lin Yang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var accumlator = 0.0
    
    func setOperand(operand: Double) {
        accumlator = operand
    }
    
    var operations = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "C": Operation.ClearValue,
        "+/-": Operation.UnaryOperation({ $0 * -1 }),
        "sqrt": Operation.UnaryOperation(sqrt),
        "sin": Operation.UnaryOperation({sin( $0 * M_PI / 180)}),
        "cos": Operation.UnaryOperation({cos( $0 * M_PI / 180)}),
        "log": Operation.UnaryOperation(log10),
        "×": Operation.BinaryOperation({ $0 * $1}),
        "+": Operation.BinaryOperation({ $0 + $1}),
        "-": Operation.BinaryOperation({ $0 - $1}),
        "÷": Operation.BinaryOperation({ $0 / $1}),
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case ClearValue
    }
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: ((Double, Double) ->  Double)
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?

    func performOperation(symbol: String) {
        if let opeation = operations[symbol] {
            switch opeation{
            case .Constant(let value):
                accumlator = value
            case .UnaryOperation(let function):
                accumlator = function(accumlator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumlator)
            case .Equals:
                executePendingBinaryOperation()
            case .ClearValue:
                accumlator = 0
                pending = nil
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumlator = pending!.binaryFunction(pending!.firstOperand, accumlator)
            pending = nil
        }    }
    
    var result: Double {
        get {
            return accumlator
        }
    }
}