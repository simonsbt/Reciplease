//
//  Extensions.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import Foundation

extension String {
    var capitalizeFirstLetter: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters

    }
}
