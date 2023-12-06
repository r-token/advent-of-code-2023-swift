//
//  Day06.swift
//
//
//  Created by Ryan Token on 12/6/23.
//

import Algorithms

struct Day06: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    // Holding down the button charges the boat, and releasing the button allows the boat to move.
    // You can only hold the button at the start of the race, and boats don't move until the button is released.
    // The first number in the column is the time of the race.
    // The second number in the column is the record distance.
    // Determine the number of ways you could beat the record in each race. What do you get if you multiply these numbers together?
    func part1() -> Any {
        let races = parseRaces(from: entities)
        var allWinningDurations = [Int]()
        for race in races {
            let numberOfHoldDurationsForRace = getNumberOfWinningHoldDurations(from: race)
            allWinningDurations.append(numberOfHoldDurationsForRace)
        }

        let multipliedDurations = allWinningDurations.reduce(1) { $0 * $1 }
        return multipliedDurations
    }

    // There's really only one race - ignore the spaces between the numbers on each line.
    // How many ways can you beat the record in this one much longer race?
    func part2() -> Any {
        if let race = parseRacesPartTwo(from: entities) {
            let numberOfWinningHoldDurations = getNumberOfWinningHoldDurations(from: race)
            return numberOfWinningHoldDurations
        }

        return 0
    }

    private func parseRaces(from data: [String]) -> [Race] {
        var times = [Int]()
        var distances = [Int]()

        for (index, row) in data.enumerated() {
            if index == 0 {
                times = getTimesOrDistances(from: row)
            } else {
                distances = getTimesOrDistances(from: row)
            }
        }

        var races = [Race]()
        for time in times {
            let race = Race(time: time, distance: 0)
            races.append(race)
        }
        for (index, distance) in distances.enumerated() {
            races[index].distance = distance
        }

        return races
    }

    private func parseRacesPartTwo(from data: [String]) -> Race? {
        var stringTime = ""
        var stringDistance = ""

        for (index, row) in data.enumerated() {
            if index == 0 {
                stringTime = getTimesOrDistancesPartTwo(from: row)
            } else {
                stringDistance = getTimesOrDistancesPartTwo(from: row)
            }
        }

        if let time = Int(stringTime), let distance = Int(stringDistance) {
            let race = Race(time: time, distance: distance)
            return race
        }

        return nil
    }

    private func getTimesOrDistances(from row: String) -> [Int] {
        var data = [Int]()
        let stringRows = row.split(separator: " ")
        for chunk in stringRows {
            if String(chunk).isDigit {
                if let intData = Int(chunk) {
                    data.append(intData)
                }
            }
        }

        return data
    }

    private func getTimesOrDistancesPartTwo(from row: String) -> String {
        var data = ""
        let stringRows = row.split(separator: " ")
        for chunk in stringRows {
            if String(chunk).isDigit {
                data += chunk
            }
        }

        return data
    }

    private func getNumberOfWinningHoldDurations(from race: Race) -> Int {
        var winningDurations = 0
        let distanceToBeat = race.distance
        for holdDuration in 1..<race.time {
            let timeMoving = race.time - holdDuration
            let distanceTraveled = holdDuration * timeMoving
            if distanceTraveled > distanceToBeat {
                winningDurations += 1
            }
        }

        return winningDurations
    }
}

struct Race {
    var time: Int
    var distance: Int
}
