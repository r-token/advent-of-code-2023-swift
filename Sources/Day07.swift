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
        let hands = getHands(from: entities)
        let allHands = segmentOutHandTypes(for: hands)
        let sortedHands = sortAllHands(for: allHands)
        let rankedHands = rankHands(for: sortedHands)
        let totalWinnings = getTotalWinnings(from: rankedHands)

        print("totalWinnings: \(totalWinnings)")
        return totalWinnings
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        // Sum the maximum entries in each set of data
        return 0
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

    private func segmentOutHandTypes(for hands: [Hand]) -> AllHands {
        var allHands = AllHands(highCardHands: [], onePairHands: [], twoPairHands: [], threeOfAKindHands: [], fullHouseHands: [], fourOfAKindHands: [], fiveOfAKindHands: [])

        for hand in hands {
            let handType = getTypeOfHand(from: hand)
            switch handType {
            case .highCard:
                allHands.highCardHands.append(hand)
            case .onePair:
                allHands.onePairHands.append(hand)
            case .twoPair:
                allHands.twoPairHands.append(hand)
            case .threeOfAKind:
                allHands.threeOfAKindHands.append(hand)
            case .fullHouse:
                allHands.fullHouseHands.append(hand)
            case .fourOfAKind:
                allHands.fourOfAKindHands.append(hand)
            case .fiveOfAKind:
                allHands.fiveOfAKindHands.append(hand)
            }
        }

        return allHands
    }

    private func getTypeOfHand(from hand: Hand) -> HandType {
        var cardsDictionary = [String: Int]()
        for card in hand.cards {
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

    private func sortAllHands(for allHands: AllHands) -> [Hand] {
        var sortedHands = [Hand]()
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.highCardHands))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.onePairHands))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.twoPairHands))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.threeOfAKindHands))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.fullHouseHands))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.fourOfAKindHands))
        sortedHands.append(contentsOf: sortSetOfHands(for: allHands.fiveOfAKindHands))
        return sortedHands
    }

    private func sortSetOfHands(for hands: [Hand]) -> [Hand] {
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
    var rank: Int?
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
