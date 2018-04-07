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
    
    enum eCards : Int{
        case aceH,
             twoH,
             threeH,
             fourH,
             fiveH,
             sixH,
             sevenH,
             eightH,
             nineH,
             tenH,
             jackH,
             queenH,
             kingH
        
        func getImage() -> UIImage {
            switch self {
            case .aceH: return #imageLiteral(resourceName: "AH")
            case .twoH: return #imageLiteral(resourceName: "2H")
            case .threeH: return #imageLiteral(resourceName: "3H")
            case .fourH: return #imageLiteral(resourceName: "4H")
            case .fiveH: return #imageLiteral(resourceName: "5H")
            case .sixH: return #imageLiteral(resourceName: "6H")
            case .sevenH: return #imageLiteral(resourceName: "7H")
            case .eightH: return #imageLiteral(resourceName: "8H")
            case .nineH: return #imageLiteral(resourceName: "9H")
            case .tenH: return #imageLiteral(resourceName: "10H")
            case .jackH: return #imageLiteral(resourceName: "JH")
            case .queenH: return #imageLiteral(resourceName: "QH")
            case .kingH: return #imageLiteral(resourceName: "KH")
            }
        }
        
        static func getCardsNumber() -> UInt32{
            return 13
        }
    }
}
