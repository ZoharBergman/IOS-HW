//
//  Board.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 25/03/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit

class Board {
    // Static instance of the class
    static let sharedInstance = Board()
    
    // Properties
    public var rowsNumber : Int
    public var colsNumber : Int
    public var arrCardsImages = [Constants.eCards]()
    public var matchesNumber : Int
    public var selectedCells = [BoardCell]()
    public var playerName : String
    
    
    // Ctor
    private init() {
        rowsNumber = 0
        colsNumber = 0
        matchesNumber = 0
        playerName = ""
    }
    
    // Functions
    func ConfigBoard(level: Constants.eGameLevel, playerName: String) {
        switch level {
        case .easy:
            rowsNumber = 4
            colsNumber = 3
        case .medium:
            rowsNumber = 4
            colsNumber = 4
        case .hard:
            rowsNumber = 5
            colsNumber = 4
        }
        
        // Init the properties for the new game
        self.playerName = playerName
        matchesNumber = colsNumber * rowsNumber / 2
        selectedCells = []
        arrCardsImages = []
        
        // Generating the card images for the new game
        GenerateCardsImages()
    }
    
    func AllocateImage(cell : BoardCell) {
        // Allocate an image (from the generated images) to each cell in the board
        let rand = Int(arc4random_uniform(UInt32(arrCardsImages.count)))
        cell.eImageVal = arrCardsImages[rand]
        arrCardsImages.remove(at: rand)
    }
    
    func GenerateCardsImages() {
        arrCardsImages = []
        
        // While we didn't fill an array with all the images that are needed for filling the board
        while (arrCardsImages.count < rowsNumber * colsNumber) {
            // Getting a random card image
            let randCardImage = Constants.eCards(rawValue: Int(arc4random_uniform(Constants.eCards.getCardsNumber())))!
            
            // Checking that the random card image is not already in the array of cards
            if (!arrCardsImages.contains(randCardImage)) {
                arrCardsImages.append(randCardImage)
                arrCardsImages.append(randCardImage)
            }
        }
    }
    
    func HandleSelectedCell(selectedCell : BoardCell, cvBoard: UICollectionView, finishGameHandler: () -> Void) {
        // Validating that the user havn't found a match to this cell yet or presented it already
        if (!selectedCell.isMatchFound && !selectedCell.isPresented) {
            // Flipping the card
            selectedCell.Flip()
            selectedCell.isPresented = true
            
            // Disable the cell
            selectedCell.isUserInteractionEnabled = false
            
            // Adding the cell to the selected cells array
            selectedCells.append(selectedCell)
            
            // Checking if two cells were selected
            if(selectedCells.count == 2) {
                // Disable all the cells
                SetEnabled(isEnabled: false, cvBoard: cvBoard)
                
                // Checking if there is a match
                CheckMatch(cvBoard: cvBoard, finishGameHandler: finishGameHandler)
            }
        }
    }
    
    func CheckMatch(cvBoard: UICollectionView, finishGameHandler : () -> Void) {
        // Checking if the two selected cells have the same image
        if (selectedCells[0].eImageVal == selectedCells[1].eImageVal) {
            selectedCells[0].isMatchFound = true
            selectedCells[1].isMatchFound = true
            
            // Decreasing the number of matches to find by 1
            matchesNumber = matchesNumber - 1
            
            // Checking if all matches were founded (and the game finished)
            if (matchesNumber == 0) {
                finishGameHandler()
            } else {
                selectedCells = []
                SetEnabled(isEnabled: true, cvBoard: cvBoard)
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (_ timer: Timer) -> Void in
                self!.selectedCells[0].FlipOver()
                self!.selectedCells[0].isPresented = false
                self!.selectedCells[1].FlipOver()
                self!.selectedCells[1].isPresented = false
                self!.selectedCells = []
                self!.SetEnabled(isEnabled: true, cvBoard: cvBoard)
            })
        }
    }
    
    func SetEnabled(isEnabled: Bool, cvBoard: UICollectionView) {
        for var cell in cvBoard.visibleCells as! [BoardCell] {
            cell.isUserInteractionEnabled = isEnabled
        }
    }
}
