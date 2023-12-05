//
//  Day04.swift
//
//
//  Created by Ryan Token on 12/4/23.
//

import Algorithms
import Foundation

struct Day04: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var cardRows: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    // Cach card has two lists of numbers separated by a vertical bar (|):
    // A list of winning numbers and then a list of numbers you have.
    // Figure out which of the numbers you have appear in the list of winning numbers.
    // The first match makes the card worth one point and each match after the first doubles the point value of that card.
    // How many points are they worth in total?
    func part1() -> Any {
        var totalPoints = 0
        for row in cardRows {
            var cardInfo = getCardInfo(from: row)
            let points = getPointTotal(from: cardInfo)
            cardInfo.points = points

            totalPoints += cardInfo.points ?? 0
        }
        return totalPoints
    }

    // You win copies of the scratchcards below the winning card equal to the number of matches.
    // So, if card 10 were to have 5 matching numbers, you would win one copy each of cards 11, 12, 13, 14, and 15.
    func part2() -> Any {
        // dictionary with key of card number and value of number of copies
        var rowCopies = [Int: Int]()
        for (index, _) in cardRows.enumerated() {
            rowCopies[index + 1] = 1
        }

        for row in cardRows {
            let cardInfo = getCardInfo(from: row)
            let numberOfMatches = cardInfo.numberOfMatches

            if numberOfMatches ?? 0 > 0 {
                for matchNumber in 1...numberOfMatches! {
                    rowCopies[cardInfo.cardNumber + matchNumber]! += rowCopies[cardInfo.cardNumber] ?? 0
                }
            }
        }

        print("rowCopies: \(rowCopies)")
        var totalScratchcards = 0
        for copy in rowCopies {
            totalScratchcards += copy.value
        }
        return totalScratchcards
    }

    private func getRow(_ cardNumber: Int, from data: [String]) -> RowIndex? {
        for (index, row) in data.enumerated() {
            let rowNumber = getCardNumber(from: row)
            if rowNumber == cardNumber {
                let rowData = RowIndex(row: row, index: index)
                return rowData
            }
        }
        print("did not find matching row number for card \(cardNumber)")
        return nil
    }

    private func getCardInfo(from cardRow: String) -> CardInfo {
        var tempRow = cardRow
        let cardNumber = getCardNumber(from: cardRow)
        if cardRow.count < 25 {
            tempRow = getRow(cardNumber, from: cardRows)?.row ?? ""
        }
        let winningNumbers = getWinningNumbers(from: tempRow)
        let yourNumbers = getYourNumbers(from: tempRow)

        var cardInfo = CardInfo(cardNumber: cardNumber, winningNumbers: winningNumbers, yourNumbers: yourNumbers)
        let matches = getMatches(from: cardInfo)
        cardInfo.numberOfMatches = matches
        return cardInfo
    }

    private func getCardNumber(from cardRow: String) -> Int {
        let cardX = cardRow.split(separator: ":")[0].split(separator: " ")
        var cardNumber = "1"
        for chunk in cardX {
            if String(chunk).isDigit {
                cardNumber = String(chunk)
                break
            }
        }

        if let intCardNumber = Int(cardNumber) {
            return intCardNumber
        } else {
            return 0
        }
    }

    private func getWinningNumbers(from cardRow: String) -> [String] {
        var winningNumbers = [String]()
        let chunks = cardRow.split(separator: ":")[1].split(separator: "|")[0].split(separator: " ")
        for chunk in chunks {
            if String(chunk).isDigit {
                winningNumbers.append(String(chunk))
            }
        }
        return winningNumbers
    }

    private func getYourNumbers(from cardRow: String) -> [String] {
        var yourNumbers = [String]()
        let chunks = cardRow.split(separator: "|")[1].split(separator: " ")
        for chunk in chunks {
            if String(chunk).isDigit {
                yourNumbers.append(String(chunk))
            }
        }
        return yourNumbers
    }

    private func getMatches(from cardRow: CardInfo) -> Int {
        let winningNumbers = cardRow.winningNumbers
        let yourNumbers = cardRow.yourNumbers

        var matches = 0
        for number in yourNumbers {
            if winningNumbers.contains(number) {
                matches += 1
            }
        }
        return matches
    }

    private func getPointTotal(from cardRow: CardInfo) -> Int {
        let winningNumbers = cardRow.winningNumbers
        let yourNumbers = cardRow.yourNumbers

        var points = 0
        for number in yourNumbers {
            if winningNumbers.contains(number) {
                if points == 0 {
                    points += 1
                } else {
                    points *= 2
                }
            }
        }
        return points
    }
}

struct RowIndex {
    var row: String
    var index: Int
}

struct CardInfo {
    var cardNumber: Int
    var winningNumbers: [String]
    var yourNumbers: [String]
    var numberOfMatches: Int?
    var points: Int?
}
