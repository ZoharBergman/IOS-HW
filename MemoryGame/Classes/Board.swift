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
    private var rowsNumber : Int
    private var colsNumber : Int
    private var level : Constants.eGameLevel
    private var arrCardsImages = [UIImage]()
    private var matchesNumber : Int
    private var selectedCells = [BoardCell]()
    private var playerName : String
    
    
    // Ctor
    private init() {
        rowsNumber = 0
        colsNumber = 0
        matchesNumber = 0
        playerName = ""
        level = .easy
    }
    
    // Getters
    func getRowsNumber() -> Int {
        return rowsNumber
    }
    
    func getColsNumber() -> Int {
        return colsNumber
    }
    
    func getLevel() -> Constants.eGameLevel {
        return level
    }
    
    func getMatchesNumber() -> Int {
        return matchesNumber
    }
    
    func getSelectedCells() -> [BoardCell] {
        return selectedCells
    }
    
    func getPlayerName() -> String {
        return playerName
    }
    
    func setArrCardsImages(arrCardsImages : [UIImage]) {
        self.arrCardsImages = arrCardsImages
        self.arrCardsImages.append(contentsOf: arrCardsImages)
        
        if (arrCardsImages.count < matchesNumber) {
            generateCardsImages()
        }
    }
    
    // Functions
    func configBoard(level: Constants.eGameLevel, playerName: String) {
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
        self.level = level
        matchesNumber = colsNumber * rowsNumber / 2
        selectedCells = []
        arrCardsImages = []
    }
    
    func allocateImage(cell : BoardCell) {
        // Allocate an image (from the generated images) to each cell in the board
        let rand = Int(arc4random_uniform(UInt32(arrCardsImages.count)))
        cell.setImageVal(arrCardsImages[rand])
        arrCardsImages.remove(at: rand)
    }
    
    func generateCardsImages() {
        // In case the level is hard, just put all the images twice
        if (arrCardsImages.count == 0 && level == .hard) {
            for i in 1...matchesNumber {
                arrCardsImages.append(UIImage(named: String(i))!)
                arrCardsImages.append(UIImage(named: String(i))!)
            }
        } else {
            // While we didn't finish to fill an array with all the images that are needed for filling the board
            while (arrCardsImages.count < matchesNumber * 2) {
                // Getting a random card image
                let randCardImage = arc4random_uniform(UInt32(matchesNumber)) + 1
                
                // Checking that the random card image is not already in the array of cards
                if (!arrCardsImages.contains(UIImage(named: String(randCardImage))!)) {
                    arrCardsImages.append(UIImage(named: String(randCardImage))!)
                    arrCardsImages.append(UIImage(named: String(randCardImage))!)
                }
            }
        }
    }
    
    func handleSelectedCell(selectedCell : BoardCell, cvBoard: UICollectionView, finishGameHandler: () -> Void) {
        // Validating that the user havn't found a match to this cell yet or presented it already
        if (!selectedCell.getIsMatchFound() && !selectedCell.getIsPresented()) {
            // Flipping the card
            selectedCell.flip()
            selectedCell.setIsPresented(true)
            
            // Disable the cell
            selectedCell.isUserInteractionEnabled = false
            
            // Adding the cell to the selected cells array
            selectedCells.append(selectedCell)
            
            // Checking if two cells were selected
            if(selectedCells.count == 2) {
                // Disable all the cells
                setEnabled(isEnabled: false, cvBoard: cvBoard)
                
                // Checking if there is a match
                checkMatch(cvBoard: cvBoard, finishGameHandler: finishGameHandler)
            }
        }
    }
    
    func checkMatch(cvBoard: UICollectionView, finishGameHandler : () -> Void) {
        // Checking if the two selected cells have the same image
        if (selectedCells[0].getImageVal() == selectedCells[1].getImageVal()) {
            selectedCells[0].setIsMatchFound(true)
            selectedCells[1].setIsMatchFound(true)
            
            // Decreasing the number of matches to find by 1
            matchesNumber = matchesNumber - 1
            
            // Checking if all matches were founded (and the game finished)
            if (matchesNumber == 0) {
                finishGameHandler()
            } else {
                selectedCells = []
                setEnabled(isEnabled: true, cvBoard: cvBoard)
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (_ timer: Timer) -> Void in
                self!.selectedCells[0].flipOver()
                self!.selectedCells[0].setIsPresented(false)
                self!.selectedCells[1].flipOver()
                self!.selectedCells[1].setIsPresented(false)
                self!.selectedCells = []
                self!.setEnabled(isEnabled: true, cvBoard: cvBoard)
            })
        }
    }
    
    func setEnabled(isEnabled: Bool, cvBoard: UICollectionView) {
        for var cell in cvBoard.visibleCells as! [BoardCell] {
            cell.isUserInteractionEnabled = isEnabled
        }
    }
}
