//
//  Constants.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 01/04/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    enum eGameLevel : Int {
        case easy, medium, hard
        
        func getDescription() -> String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }
        
        static func getNumberOfLevels() -> Int {
            return 3
        }
    }
}
