//
//  Day04.swift
//
//
//  Created by Ryan Token on 12/4/23.
//

import Algorithms

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

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return 0
    }

    private func getCardInfo(from cardRow: String) -> CardInfo {
        let cardNumber = getCardNumber(from: cardRow)
        let winningNumbers = getWinningNumbers(from: cardRow)
        let yourNumbers = getYourNumbers(from: cardRow)

        let cardInfo = CardInfo(cardNumber: cardNumber, winningNumbers: winningNumbers, yourNumbers: yourNumbers)
        return cardInfo
    }

    private func getCardNumber(from cardRow: String) -> Int {
        let cardX = cardRow.split(separator: ":")[0]
        var cardNumber = "1"
        for chunk in cardX {
            if chunk.isDigit {
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

struct CardInfo {
    var cardNumber: Int
    var winningNumbers: [String]
    var yourNumbers: [String]
    var points: Int?
}
