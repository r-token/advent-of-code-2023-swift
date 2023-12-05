//
//  File.swift
//  
//
//  Created by Ryan Token on 12/5/23.
//

import Algorithms
import Foundation

struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var seeds: String {
        data.slice(from: "seeds: ", to: "\n") ?? ""
    }
    var seedToSoil: String {
        data.slice(from: "seed-to-soil map:\n", to: "\n\n") ?? ""
    }
    var soilToFertilizer: String {
        data.slice(from: "soil-to-fertilizer map:\n", to: "\n\n") ?? ""
    }
    var fertilizerToWater: String {
        data.slice(from: "fertilizer-to-water map:\n", to: "\n\n") ?? ""
    }
    var waterToLight: String {
        data.slice(from: "water-to-light map:\n", to: "\n\n") ?? ""
    }
    var lightToTemperature: String {
        data.slice(from: "light-to-temperature map:\n", to: "\n\n") ?? ""
    }
    var temperatureToHumidity: String {
        data.slice(from: "temperature-to-humidity map:\n", to: "\n\n") ?? ""
    }
    var humidityToLocation: String {
        data.slice(from: "humidity-to-location map:\n", to: "\n\n") ?? ""
    }

    // The maps describe entire ranges of numbers that can be converted.
    // Each line within a map contains three numbers: the destination range start, the source range start, and the range length
    // What is the lowest location number that corresponds to any of the initial seed numbers?
    func part1() -> Any {
        var locationNumbers = [Int]()
        let seedNumbers = getSeedNumbers(from: seeds)
        print("seeds: \(seedNumbers)")

        for seedNumber in seedNumbers {
            let locationNumber = traverseTheAlmanac(for: seedNumber)
            locationNumbers.append(locationNumber)
        }

        if let smallestLocation = locationNumbers.min() {
            return smallestLocation
        } else {
            return 0
        }
    }

    // The seeds: line actually describes ranges of seed numbers.
    // The values on the initial seeds: line come in pairs
    // Within each pair, the first value is the start of the range and the second value is the length of the range.
    func part2() -> Any {
        var locationNumbers = [Int]()
        let seedNumbers = getSeedNumbersPartTwo(from: seeds)

        for seedNumber in seedNumbers {
            let locationNumber = traverseTheAlmanac(for: seedNumber)
            locationNumbers.append(locationNumber)
        }

        if let smallestLocation = locationNumbers.min() {
            return smallestLocation
        } else {
            return 0
        }
    }

    private func getSeedNumbers(from seedsString: String) -> [Int] {
        var seedInts = [Int]()
        let seedsString = seedsString.components(separatedBy: " ")
        for seed in seedsString {
            if let seedInt = Int(seed) {
                seedInts.append(seedInt)
            }
        }
        return seedInts
    }

    private func getSeedNumbersPartTwo(from seedsString: String) -> [Int] {
        var newSeedNumbers = [Int]()
        let seedInts = getSeedNumbers(from: seedsString)

        var tempNumbers = [Int]()
        for seedInt in seedInts {
            tempNumbers.append(seedInt)
            if tempNumbers.count % 2 == 0 {
                let startRange = tempNumbers[0]
                let rangeLength = tempNumbers[1]
                for number in startRange..<startRange+rangeLength {
                    newSeedNumbers.append(number)
                }
                tempNumbers.removeAll()
            }
        }

        print("newSeedNumbers: \(newSeedNumbers)")
        return newSeedNumbers
    }

    private func traverseTheAlmanac(for seedNumber: Int) -> Int {
        let seedToSoilRows = getAlamanacRows(from: seedToSoil)
        let soilToFertilizerRows = getAlamanacRows(from: soilToFertilizer)
        let fertilizerToWaterRows = getAlamanacRows(from: fertilizerToWater)
        let waterToLightRows = getAlamanacRows(from: waterToLight)
        let lightToTemperatureRows = getAlamanacRows(from: lightToTemperature)
        let temperatureToHumidityRows = getAlamanacRows(from: temperatureToHumidity)
        let humidityToLocationRows = getAlamanacRows(from: humidityToLocation)

        let soilNumber = findDestinationNumber(from: seedToSoilRows, for: seedNumber)
        let fertilizerNumber = findDestinationNumber(from: soilToFertilizerRows, for: soilNumber)
        let waterNumber = findDestinationNumber(from: fertilizerToWaterRows, for: fertilizerNumber)
        let lightNumber = findDestinationNumber(from: waterToLightRows, for: waterNumber)
        let temperatureNumber = findDestinationNumber(from: lightToTemperatureRows, for: lightNumber)
        let humidityNumber = findDestinationNumber(from: temperatureToHumidityRows, for: temperatureNumber)
        let locationNumber = findDestinationNumber(from: humidityToLocationRows, for: humidityNumber)

        return locationNumber
    }

    private func getAlamanacRows(from bigString: String) -> [AlmanacRow] {
        var almanacRows: [AlmanacRow] = []
        let allNumbers = bigString.components(separatedBy: CharacterSet(charactersIn: " \n"))

        // allNumbers.count/3 - 1 === number of rows for the data set
        for index in 0...allNumbers.count/3 - 1 {
            var sourceIndex = 0
            var destinationIndex = 0
            var rangeIndex = 0

            if index == 0 {
                sourceIndex = 1
                destinationIndex = 0
                rangeIndex = 2
            } else {
                sourceIndex = (index * 4) - (index - 1)
                destinationIndex = index * 3
                rangeIndex = (index * 3) + 2
            }

            if let source = Int(allNumbers[sourceIndex]), let destination = Int(allNumbers[destinationIndex]), let range = Int(allNumbers[rangeIndex]) {
                let almanacRow = AlmanacRow(source: source, destination: destination, range: range)
                almanacRows.append(almanacRow)
            }
        }

        return almanacRows
    }

    private func findDestinationNumber(from rows: [AlmanacRow], for sourceNumber: Int) -> Int {
        for row in rows {
            let maximum = row.source + row.range
            if sourceNumber >= row.source && sourceNumber <= maximum {
                let difference = sourceNumber - row.source
                let destinationNumber = row.destination + difference
                print("sourceNumber \(sourceNumber) has destinationNumber \(destinationNumber) for range \(row.source) to \(maximum)")
                return destinationNumber
            }
        }

        return sourceNumber
    }
}

struct AlmanacRow {
    var source: Int
    var destination: Int
    var range: Int
}
