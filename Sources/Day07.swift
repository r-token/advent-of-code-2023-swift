//
//  Day07.swift
//
//
//  Created by Ryan Token on 12/7/23.
//

import Algorithms

struct Day07: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    // Each hand is followed by its bid amount.
    // Each hand wins an amount equal to its bid multiplied by its rank, where the weakest hand gets rank 1.
    // Put the hands in order of strength.
    // Determine the total winnings of this set of hands by adding up the result of multiplying each hand's bid with its rank
    // Find the rank of every hand in your set. What are the total winnings?
    func part1() -> Any {
        let hands: [Hand] = getHands(from: entities)
        let allHands: AllHands = segmentOutHandTypes(for: hands, challengeNumber: 1)
        let sortedHands: [Hand] = sortAllHands(for: allHands, challengeNumber: 1)
        let rankedHands: [Hand] = rankHands(for: sortedHands)
        let totalWinnings: Int = getTotalWinnings(from: rankedHands)

        return totalWinnings
    }

    // Guesses: 251121167 (too high)
    func part2() -> Any {
        let hands: [Hand] = getHands(from: entities)
        let jokerHands: [Hand] = getJokerHands(from: hands)
        let allHands: AllHands = segmentOutHandTypes(for: jokerHands, challengeNumber: 2)
        let sortedHands: [Hand] = sortAllHands(for: allHands, challengeNumber: 2)
        let rankedHands: [Hand] = rankHands(for: sortedHands)
        let totalWinnings: Int = getTotalWinnings(from: rankedHands)


        print("sortedHands: \(sortedHands)")

        return totalWinnings
    }

    private func getHands(from entities: [String]) -> [Hand] {
        var hands = [Hand]()
        for row in entities {
            let hand = getHandInfo(from: row)
            hands.append(hand)
        }
        return hands
    }

    private func getHandInfo(from row: String) -> Hand {
        let cardsString = row.components(separatedBy: " ")[0]
        let bidString = row.components(separatedBy: " ")[1]

        var cards = [String]()
        var bid = 0
        for card in cardsString {
            cards.append(String(card))
        }

        if let bidInt = Int(bidString) {
            bid = bidInt
        }

        let hand = Hand(cards: cards, bid: bid)
        return hand
    }

    private func segmentOutHandTypes(for hands: [Hand], challengeNumber: Int) -> AllHands {
        var allHands = AllHands(highCardHands: [], onePairHands: [], twoPairHands: [], threeOfAKindHands: [], fullHouseHands: [], fourOfAKindHands: [], fiveOfAKindHands: [])

        for hand in hands {
            var tempHand = hand
            let handType = getTypeOfHand(from: hand, challengeNumber: challengeNumber)
            tempHand.handType = handType
            switch handType {
            case .highCard:
                allHands.highCardHands.append(tempHand)
            case .onePair:
                allHands.onePairHands.append(tempHand)
            case .twoPair:
                allHands.twoPairHands.append(tempHand)
            case .threeOfAKind:
                allHands.threeOfAKindHands.append(tempHand)
            case .fullHouse:
                allHands.fullHouseHands.append(tempHand)
            case .fourOfAKind:
                allHands.fourOfAKindHands.append(tempHand)
            case .fiveOfAKind:
                allHands.fiveOfAKindHands.append(tempHand)
            }
        }

        return allHands
    }

    private func getJokerHands(from hands: [Hand]) -> [Hand] {
        var jokerHands = [Hand]()
        for hand in hands {
            let jokerHand = convertJokersToBestCard(from: hand)
            jokerHands.append(jokerHand)
        }
        return jokerHands
    }

    private func convertJokersToBestCard(from hand: Hand) -> Hand {
        guard hand.cards.contains("J") else { return hand }
        print("found hand with J: \(hand)")
        var tempHand = hand

        let handType = getTypeOfHand(from: hand, challengeNumber: 2)

        switch handType {
        case .highCard:
            tempHand.jMap = JMap(newValue: "A")
        case .onePair:
            let pairCard = hand.cards.filter({ (i: String) in hand.cards.filter({ $0 == i }).count > 1})
            if let cardToUse = pairCard.first {
                if cardToUse == "J" {
                    var newCardToUse = getBestCard(from: hand.cards)
                    tempHand.jMap = JMap(newValue: newCardToUse)
                } else {
                    tempHand.jMap = JMap(newValue: cardToUse)
                }
            }
        case .twoPair:
            let pairCards = hand.cards.filter({ (i: String) in hand.cards.filter({ $0 == i }).count > 1})
            let bestCard = getBestCard(from: pairCards)
            tempHand.jMap = JMap(newValue: bestCard)
        case .threeOfAKind:
            let threeCard = hand.cards.filter({ (i: String) in hand.cards.filter({ $0 == i }).count == 3})
            if let cardToUse = threeCard.first {
                if cardToUse == "J" {
                    var newCardToUse = getBestCard(from: hand.cards)
                    tempHand.jMap = JMap(newValue: newCardToUse)
                } else {
                    tempHand.jMap = JMap(newValue: cardToUse)
                }
            }
        case .fullHouse:
            tempHand.jMap = JMap(newValue: "A")
        case .fourOfAKind:
            let fourCard = hand.cards.filter({ (i: String) in hand.cards.filter({ $0 == i }).count == 4})
            if let cardToUse = fourCard.first {
                if cardToUse == "J" {
                    var newCardToUse = getBestCard(from: hand.cards)
                    tempHand.jMap = JMap(newValue: newCardToUse)
                } else {
                    tempHand.jMap = JMap(newValue: cardToUse)
                }
            }
        case .fiveOfAKind:
            tempHand.jMap = JMap(newValue: "A")
        }

        return tempHand
    }

    private func swapJokersForNewValue(for hand: Hand) -> Hand {
        var tempHand = hand
        var cardsWithSwappedJokers = [String]()
        for card in hand.cards {
            var tempCard = card
            if card == "J" {
                tempCard = hand.jMap?.newValue ?? card
            }
            cardsWithSwappedJokers.append(tempCard)
        }
        tempHand.cards = cardsWithSwappedJokers
        return tempHand
    }

    private func getTypeOfHand(from hand: Hand, challengeNumber: Int) -> HandType {
        var cardsDictionary = [String: Int]()
        var cards = challengeNumber == 1 ? hand.cards : swapJokersForNewValue(for: hand).cards

        for card in cards {
            if let _ = cardsDictionary[card] {
                cardsDictionary[card]! += 1
            } else {
                cardsDictionary[card] = 1
            }
        }

        var handType: HandType = .highCard
        for card in cardsDictionary {
            switch card.value {
            case 1:
                break
            case 2:
                switch handType {
                case .highCard:
                    handType = .onePair
                case .onePair:
                    handType = .twoPair
                case .threeOfAKind:
                    handType = .fullHouse
                default:
                    print("two of one card but unsure what to do: \(card.key); \(handType)")
                }
            case 3:
                switch handType {
                case .highCard:
                    handType = .threeOfAKind
                case .onePair:
                    handType = .fullHouse
                default:
                    print("3 of one card but unsure what to do: \(card.key); \(handType)")
                }
            case 4:
                switch handType {
                case .highCard:
                    handType = .fourOfAKind
                default:
                    print("4 of one card but unsure what to do: \(card.key); \(handType)")
                }
            case 5:
                switch handType {
                case .highCard:
                    handType = .fiveOfAKind
                default:
                    print("5 of one card but unsure what to do: \(card.key); \(handType)")
                }
            default:
                print("should never get here unless more cards are added to the hand")
            }
        }

        return handType
    }

    private func cardPriority(_ card: String) -> Int? {
        let priorityOrder = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
        return priorityOrder.firstIndex(of: card)
    }

    private func cardPriorityPartTwo(_ card: String) -> Int? {
        let priorityOrder = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
        return priorityOrder.firstIndex(of: card)
    }

    private func sortAllHands(for allHands: AllHands, challengeNumber: Int) -> [Hand] {
        var sortedHands = [Hand]()
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.highCardHands, challengeNumber: challengeNumber))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.onePairHands, challengeNumber: challengeNumber))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.twoPairHands, challengeNumber: challengeNumber))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.threeOfAKindHands, challengeNumber: challengeNumber))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.fullHouseHands, challengeNumber: challengeNumber))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.fourOfAKindHands, challengeNumber: challengeNumber))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.fiveOfAKindHands, challengeNumber: challengeNumber))
        return sortedHands
    }

    private func sortSetOfHands(for hands: [Hand], challengeNumber: Int) -> [Hand] {
        if challengeNumber == 1 {
            return hands.sorted { (hand1, hand2) -> Bool in
                // Compare the cards based on their relative priority
                for (card1, card2) in zip(hand1.cards, hand2.cards) {
                    if let priority1 = cardPriority(card1), let priority2 = cardPriority(card2) {
                        if priority1 != priority2 {
                            return priority1 > priority2
                        }
                    }
                }

                // If the cards are the same, compare based on other criteria (e.g., bid or rank)
                return hand1.bid > hand2.bid
            }
        } else {
            return hands.sorted { (hand1, hand2) -> Bool in
                // Compare the cards based on their relative priority
                for (card1, card2) in zip(hand1.cards, hand2.cards) {
                    if let priority1 = cardPriorityPartTwo(card1), let priority2 = cardPriorityPartTwo(card2) {
                        if priority1 != priority2 {
                            return priority1 > priority2
                        }
                    }
                }

                // If the cards are the same, compare based on other criteria (e.g., bid or rank)
                return hand1.bid > hand2.bid
            }
        }
    }

    private func getBestCard(from cards: [String]) -> String {
        let priorityOrder = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
        var highestPriority = 0
        var highestPriorityCard = "J"
        for card in cards {
            if let priority = priorityOrder.firstIndex(of: card) {
                if priority > highestPriority {
                    highestPriorityCard = card
                }
            }
        }
        return highestPriorityCard
    }

    private func rankHands(for sortedHands: [Hand]) -> [Hand] {
        var rankedHands = [Hand]()
        for (index, hand) in sortedHands.enumerated() {
            var tempHand = hand
            tempHand.rank = index + 1
            rankedHands.append(tempHand)
        }
        return rankedHands
    }

    private func getTotalWinnings(from rankedHands: [Hand]) -> Int {
        var totalWinnings = 0
        for hand in rankedHands {
            if let rank = hand.rank {
                let totalWinning = hand.bid * rank
                totalWinnings += totalWinning
            }
        }
        return totalWinnings
    }
}

enum HandType {
    case highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
}

struct Hand {
    var cards: [String]
    var bid: Int
    var handType: HandType?
    var rank: Int?
    var jMap: JMap?
}

struct AllHands {
    var highCardHands: [Hand]
    var onePairHands: [Hand]
    var twoPairHands: [Hand]
    var threeOfAKindHands: [Hand]
    var fullHouseHands: [Hand]
    var fourOfAKindHands: [Hand]
    var fiveOfAKindHands: [Hand]
}

struct JMap {
    var newValue: String
}
