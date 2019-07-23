//
//  main.swift
//  Calculator
//
//  Created by Alex Paul on 10/25/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

var operations: ([String: (Double, Double) -> Double]) = ["+": { $0 + $1 },
                                                          "-": { $0 - $1 },
                                                          "*": { $0 * $1 },
                                                          "/": { $0 / $1 }]

func Basic() {
    print("Enter a basic operation such as 6 * 9. Use '?' as an operator to play a mini-game!")
    let input = readLine()
    let numbers  = "0123456789"
    var calculating = true
    
    if let basicOperation = input {
        var inputArray = basicOperation.components(separatedBy: " ")
        
        if basicOperation.first?.isNumber == false || basicOperation.last?.isNumber == false || inputArray.count != 3 {
            print("Error: Incorrect format. Please enter a basic operation using the following format: 6 * 9")
            return Basic()
        }
        if inputArray[1] == "?" {
            inputArray[1] = operations.keys.randomElement()!
        }
        if operations.keys.contains(inputArray[1]) == false {
            print("Unknown operator: \(inputArray[1])")
            return Basic()
        }
        for i in 0...2 {
            if i == 1 {
                continue
            }
            for char in inputArray[i] {
                if numbers.contains(char) == false {
                    print("Error: Incorrect format. Please enter a basic operation using the following format: 6 * 9")
                    return Basic()
                }
            }
        }
        
        while calculating == true {
            if let equation = operations[inputArray[1]] {
                if basicOperation.contains("?") == true {
                    print("\(basicOperation) = \(equation(Double(inputArray[0])!, Double(inputArray[2])!))")
                    print("Which operation was performed? Enter your guess.")
                    
                    let guess = readLine()
                    if guess == inputArray[1] {
                        calculating = false
                        print("Correct!")
                        continue
                    } else {
                        calculating = false
                        print("Sorry, the correct operation was \(inputArray[1]).")
                        continue
                    }
                } else {
                    calculating = false
                    print("\(basicOperation) = \(equation(Double(inputArray[0])!, Double(inputArray[2])!))")
                }
            }
        }
    }
}


func mapFunc(_ inputArray: [Int],_ map: (Int) -> Int) {
    var changedArray = [Int]()
    for num in inputArray {
        changedArray.append(map(num))
    }
    print(changedArray)
}


func filterFunc(_ inputArray: [Int],_ filter: (Int) -> Bool) {
    var sortedArray = [Int]()
    for num in inputArray.sorted() {
        if filter(num) == true {
            sortedArray.append(num)
        }
        print(sortedArray)
    }
}

func reduceFunc(_ inputArray: [Int],_ reduce: (Int) -> Int) {
    var reduction = 0
    for num in inputArray {
        reduction += reduce(num)
    }
    print(reduction)
}


func Advanced() -> (String, [Int], String, Int) {
    print("Enter your advanced operation. (Ex. filter 1,5,2,7,3,4 by < 4)")
    let userInput = readLine()
    let advancedOperations = ["filter", "map", "reduce"]
    let mathOperators = ["<", ">", "*", "/", "+", "-"]
    let numbers  = "0123456789"
    
    if let userInput = userInput {
        let inputArray = userInput.components(separatedBy: " ")
        if inputArray.count != 5 || advancedOperations.contains(inputArray[0]) == false || mathOperators.contains(inputArray[3]) == false || inputArray.last?.last?.isNumber == false || inputArray[1].contains(",") == false {
            return Advanced()
        }
        
        let inputArray2 = inputArray[1].components(separatedBy: ",")
        for element in inputArray2 {
            if element == "" || numbers.contains(element) == false {
                return Advanced()
            }
        }
        
        var numInput = [Int]()
        for char in inputArray2 {
            numInput.append(Int(char)!)
        }
        return (inputArray[0], numInput, inputArray[3], Int(inputArray[4])!)
    }
    
    return Advanced()
}

func calculatorLoop() {
    print("Which type of calculation would you like to perform? Enter 1 for basic, or 2 for advanced.")
    let firstInput = readLine()
    if let input = firstInput {
        if input == "1" {
            Basic()
        } else if input == "2" {
            let userInput = Advanced()
            switch userInput.2 {
            case "<":
                filterFunc(userInput.1) {
                    return $0 < userInput.3
                }
            case ">":
                filterFunc(userInput.1) {
                    return $0 > userInput.3
                }
            case "*":
                if userInput.0 == "map" {
                    mapFunc(userInput.1) {
                        return $0 * userInput.3
                    }
                } else if userInput.0 == "reduce" {
                    
                    reduceFunc(userInput.1) {
                        return $0 * userInput.3
                    }
                }
            case "/":
                mapFunc(userInput.1) {
                    return $0 / userInput.3
                }
            case "+":
                reduceFunc(userInput.1) {
                    return $0 + (userInput.3 / userInput.1.count)
                }
            default:
                print("Error.")
            }
        } else {
            return calculatorLoop()
        }
    }
    
    print("Would you like to perform another calculation? Enter 'y' if so, or anything else if not.")
    let again = readLine()
    if again!.lowercased() == "y" || again!.lowercased() == "ye" || again!.lowercased() == "yes" {
        return calculatorLoop()
    }
}

calculatorLoop()
