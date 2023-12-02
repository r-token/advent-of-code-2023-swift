//
//  isDigit.swift
//
//
//  Created by Ryan Token on 12/2/23.
//

import Foundation

extension Character {
    var isDigit: Bool {
        return "0"..."9" ~= self
    }
}

extension String  {
    var isDigit: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
