//
//  Day03.swift
//  
//
//  Created by Ryan Token on 12/3/23.
//

struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    // Splits input data into its component parts and convert from string.
    var entities: [[String]] {
        data.split(separator: "\n").map {
            $0.split(separator: "").compactMap { String($0) }
        }
    }
    
    let validSymbols = ["*", "&", "@", "/", "+", "%", "-", "#", "$", "="]
    
    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let numbersWithAdjacentSymbols = getValidNumbers(from: entities)
        
        var sum = 0
        for number in numbersWithAdjacentSymbols {
            sum += number
        }
        return sum
    }
    
    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        // Sum the maximum entries in each set of data
        return 0
    }
    
    private func getValidNumbers(from matrix: [[String]]) -> [Int] {
        var validNumbers = [Int]()
        for (rowIdx, rowData) in matrix.enumerated() {
            var foundNumber = false
            var currentDigit = ""
            for (colIdx, colData) in rowData.enumerated() {
                if colData.isDigit {
                    foundNumber = true
                    currentDigit.append(colData)
                    
                    if colIdx == 139 {
                        // found number at the end of the row; check for symbols and add it before continuing to next row
                        if numberHasAdjacentSymbols(matrix: matrix, numberOfDigits: currentDigit.count, currentRow: rowIdx, currentColumn: colIdx) {
                            if let intDigit = Int(currentDigit) {
                                print("adding \(intDigit) to validNumbers array")
                                validNumbers.append(intDigit)
                            }
                        }
                        foundNumber = false
                        currentDigit = ""
                    }
                } else if foundNumber {
                    // found end of number, check for adjacent symbols before adding to valid numbers
                    // print("found number: \(currentDigit)")
                    if numberHasAdjacentSymbols(matrix: matrix, numberOfDigits: currentDigit.count, currentRow: rowIdx, currentColumn: colIdx) {
                        if let intDigit = Int(currentDigit) {
                            print("adding \(intDigit) to validNumbers array")
                            validNumbers.append(intDigit)
                        } else {
                            print("not adding \(currentDigit) to validNumbers array; could not cast as Int")
                        }
                    } else {
                        print("not adding \(currentDigit) to validNumbers array; found no adjacent symbols")
                    }
                    foundNumber = false
                    currentDigit = ""
                }
            }
        }
        
        return validNumbers
    }
    
    private func numberHasAdjacentSymbols(matrix: [[String]], numberOfDigits: Int, currentRow: Int, currentColumn: Int) -> Bool {
        var spacesToCheck = 0
        switch numberOfDigits {
        case 1:
            spacesToCheck = 8
        case 2:
            spacesToCheck = 10
        case 3:
            spacesToCheck = 12
        case 4:
            spacesToCheck = 14
        default:
            spacesToCheck = 0
        }
        
        // start from the item to the right of the number and going around in a rectangle
        // checking every item in the process
        var stepNumber = 1
        var newRow = currentRow
        var newColumn = currentColumn
        for _ in 1...spacesToCheck {
            let directionToCheck = getNextDirectionToCheck(matrix: matrix, numberOfDigits: numberOfDigits, stepNumber: stepNumber)
            stepNumber += 1
            
            switch directionToCheck {
            case .current:
                break
            case .above:
                newRow -= 1
            case .below:
                newRow += 1
            case .left:
                newColumn -= 1
            case .right:
                newColumn += 1
            }
            
            if newRow >= 0 && newRow <= 139 && newColumn >= 0 && newColumn <= 139 {
                let itemToCheck = matrix[newRow][newColumn]
                if itemContainsSymbol(directionToCheck, itemToCheck: itemToCheck) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func getNextDirectionToCheck(matrix: [[String]], numberOfDigits: Int, stepNumber: Int) -> Direction {
        switch stepNumber {
        case 1:
            return .current
        case 2:
            return .above
        case 3, 4:
            return .left
        case 5:
            switch numberOfDigits {
            case 1:
                return .below
            default:
                return .left
            }
        case 6:
            switch numberOfDigits {
            case 1, 2:
                return .below
            default:
                return .left
            }
        case 7:
            switch numberOfDigits {
            case 1:
                return .right
            default:
                return .below
            }
        case 8:
            switch numberOfDigits {
            case 1, 2:
                return .right
            default:
                return .below
            }
        case 9:
            switch numberOfDigits {
            case 2, 3:
                return .right
            default:
                return .below
            }
        case 10, 11, 12, 13, 14:
            return .right
        default:
            print("should never get here unless five-digit numbers are introduced")
            return .right
        }
    }
    
    private func itemContainsSymbol(_ direction: Direction, itemToCheck: String) -> Bool {
        // print("checking \(itemToCheck) for valid symbol")
        if validSymbols.contains(itemToCheck) {
            return true
        } else {
            return false
        }
    }
    
    enum Direction {
        case above, below, left, right, current
    }
}
