import Algorithms

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    let validStringDigits = [
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    ]
    let validStringDigitsReversed = [
        "eno", "owt", "eerht", "ruof", "evif", "xis", "neves", "thgie", "enin"
    ]

    // Combine the first and last int from each string to form a single two-digit number
    // If only one int in the string, use that twice
    // Once all gathered, add them all together for the final answer
    func part1() -> Any {
        var combinedNumbers = [Int]()
        var total = 0
        for stringValue in entities {
            var firstNumber: String = "0"
            var lastNumber: String = "0"

            for char in stringValue {
                if char.isDigit {
                    firstNumber = String(char)
                    break
                }
            }

            for char in stringValue.reversed() {
                if char.isDigit {
                    lastNumber = String(char)
                    break
                }
            }

            if let combinedNumber = Int(firstNumber + lastNumber) {
                print("Adding \(combinedNumber) to array")
                combinedNumbers.append(combinedNumber)
            }
        }

        for num in combinedNumbers {
            total += num
        }

        return total
    }
    
    // Your calculation isn't quite right.
    // It looks like some of the digits are actually spelled out with letters
    // one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".
    func part2() -> Any {

        var combinedNumbers = [Int]()
        var total = 0

        var currentCheck = [""]
        for stringValue in entities {
            var firstNumber: String = "0"
            var lastNumber: String = "0"

            for char in stringValue {
                if char.isDigit {
                    firstNumber = String(char)
                    currentCheck.removeAll()
                    break
                } else {
                    currentCheck.append(String(char))
                    let stringDigit = containsValidStringDigit(currentCheck: currentCheck, shouldCheckReversed: false)
                    if stringDigit.isValid {
                        firstNumber = convertStringDigitToString(stringDigit: stringDigit.number ?? "zero")
                        currentCheck.removeAll()
                        break
                    }
                }
            }

            for char in stringValue.reversed() {
                if char.isDigit {
                    lastNumber = String(char)
                    currentCheck.removeAll()
                    break
                } else {
                    currentCheck.append(String(char))
                    let stringDigit = containsValidStringDigit(currentCheck: currentCheck, shouldCheckReversed: true)
                    if stringDigit.isValid {
                        lastNumber = convertStringDigitToString(stringDigit: stringDigit.number ?? "zero")
                        currentCheck.removeAll()
                        break
                    }
                }
            }

            if let combinedNumber = Int(firstNumber + lastNumber) {
                print("Adding \(combinedNumber) to array")
                combinedNumbers.append(combinedNumber)
            }
        }

        for num in combinedNumbers {
            total += num
        }

        return total
    }

    func convertStringDigitToString(stringDigit: String) -> String {
        switch stringDigit {
        case "one", "eno":
            return "1"
        case "two", "owt":
            return "2"
        case "three", "eerht":
            return "3"
        case "four", "ruof":
            return "4"
        case "five", "evif":
            return "5"
        case "six", "xis":
            return "6"
        case "seven", "neves":
            return "7"
        case "eight", "thgie":
            return "8"
        case "nine", "enin":
            return "9"
        default:
            return "0"
        }
    }

    func containsValidStringDigit(currentCheck: [String], shouldCheckReversed: Bool) -> StringDigit {
        let digitsToCheck = shouldCheckReversed ? validStringDigitsReversed : validStringDigits
        for stringDigit in digitsToCheck {
            if currentCheck.joined().contains(stringDigit) {
                print("currentcheck found \(stringDigit)")
                return StringDigit(isValid: true, number: stringDigit)
            }
        }

        return StringDigit(isValid: false)
    }
}

struct StringDigit {
    var isValid: Bool
    var number: String?
}

extension Character {
    var isDigit: Bool {
        return "0"..."9" ~= self
    }
}
