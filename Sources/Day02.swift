//
//  Day02.swift
//
//
//  Created by Ryan Token on 12/2/23.
//

import Algorithms

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    // The Elf would first like to know which games would have been possible
    // if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
    // Determine which games would have been possible
    // if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes.
    // What is the sum of the IDs of those games?
    func part1() -> Any {
        var gameIdsWithValidCubes = [Int]()
        for row in entities {
            if let gameInfo = getGameInfo(from: row) {
                if gameHasValidCubes(gameInfo) {
                    gameIdsWithValidCubes.append(gameInfo.id)
                }
            }
        }
        
        var sum = 0
        for gameId in gameIdsWithValidCubes {
            sum += gameId
        }
        return sum
    }
    
    // What is the fewest number of cubes of each color that could have been in the bag to make the game possible?
    // The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together.
    // The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively.
    // Adding up these five powers produces the sum 2286.
    // For each game, find the minimum set of cubes that must have been present. What is the sum of the power of these sets?
    func part2() -> Any {
        var gamePowers = [Int]()
        for row in entities {
            if let game = getGameInfo(from: row) {
                let minimumCubes = getMinimumCubesOfEachColor(for: game)
                let powers = minimumCubes.redAmount * minimumCubes.greenAmount * minimumCubes.blueAmount
                gamePowers.append(powers)
            }
        }
        
        var sum = 0
        for power in gamePowers {
            sum += power
        }
        
        return sum
    }
    
    private func getGameInfo(from row: String) -> GameInfo? {
        let splitStringColon = row.split(separator: ":")
        let games = splitStringColon[1].split(separator: ";")
        var gameInfo = GameInfo(id: 0, rounds: [])
        
        // get gameId
        let game = String(splitStringColon[0])
        let gameSplit = game.split(separator: " ")
        guard let gameNum = gameSplit.last else { return nil }
        let gameNumber = String(gameNum)
        
        guard let gameId = Int(gameNumber) else { return nil }
        gameInfo.id = gameId
        
        // loop over rounds and get quantities of each color
        for round in games {
            var redAmount = 0
            var greenAmount = 0
            var blueAmount = 0
            
            var quantity = 0
            let colorQuantities = round.split(separator: ",")
            for colorQuantity in colorQuantities {
                let splits = colorQuantity.split(separator: " ")
                for split in splits {
                    let stringSplit = String(split)
                    if stringSplit.isDigit {
                        let intSplit = Int(stringSplit) ?? 0
                        quantity = intSplit
                    } else if stringSplit.isRgb {
                        switch stringSplit {
                        case CubeColors.red.rawValue:
                            redAmount = quantity
                        case CubeColors.green.rawValue:
                            greenAmount = quantity
                        case CubeColors.blue.rawValue:
                            blueAmount = quantity
                        default:
                            print("Should never be here")
                        }
                    }
                }
            }
            
            gameInfo.rounds.append(Round(redAmount: redAmount, greenAmount: greenAmount, blueAmount: blueAmount))
            
            // reset quantity and amounts
            quantity = 0
            redAmount = 0
            greenAmount = 0
            blueAmount = 0
        }
        
        return gameInfo
    }
    
    func gameHasValidCubes(_ gameInfo: GameInfo) -> Bool {
        for round in gameInfo.rounds {
            if round.redAmount <= 12 && round.greenAmount <= 13 && round.blueAmount <= 14 {
            } else {
                print("returning false for game \(gameInfo.id)")
                return false
            }
        }
        print("returning true for game \(gameInfo.id)")
        return true
    }
    
    func getMinimumCubesOfEachColor(for game: GameInfo) -> Round {
        var minimumReds = 0
        var minimumGreens = 0
        var minimumBlues = 0
        
        for round in game.rounds {
            if minimumReds < round.redAmount {
                minimumReds = round.redAmount
            }
            
            if minimumGreens < round.greenAmount {
                minimumGreens = round.greenAmount
            }
            
            if minimumBlues < round.blueAmount {
                minimumBlues = round.blueAmount
            }
        }
        
        let minimumAmounts = Round(redAmount: minimumReds, greenAmount: minimumGreens, blueAmount: minimumBlues)
        return minimumAmounts
    }
}

enum CubeColors: String {
    case red = "red"
    case green = "green"
    case blue = "blue"
}

struct GameInfo {
    var id: Int
    var rounds: [Round]
}

struct Round {
    var redAmount: Int
    var greenAmount: Int
    var blueAmount: Int
}

extension String {
    var isRgb: Bool {
        if self == "red" || self == "green" || self == "blue" {
            return true
        } else {
            return false
        }
    }
}
