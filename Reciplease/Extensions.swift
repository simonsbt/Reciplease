//
//  Extensions.swift
//  Reciplease
//
//  Created by Simon Sabatier on 07/11/2023.
//

import Foundation
import UIKit

extension String {
    var capitalizeFirstLetter: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters

    }
}

extension UIApplication {
    // 3
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}
