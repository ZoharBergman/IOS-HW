//
//  EasyController.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 25/03/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit

class GameController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // Constants
    let TileMargin = CGFloat(5.0)
 
    // Properties
    @IBOutlet weak var cvBoard: UICollectionView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    var timer = MyTimer()
    var boardController = Board.sharedInstance
    
    // Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardController.colsNumber
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return boardController.rowsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Getting a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCell", for: indexPath) as! BoardCell
        
        // Setting the cell style
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3.5
        cell.layer.borderColor = UIColor.black.cgColor
        
        // Allocating an image to the cell
        boardController.allocateImage(cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Getting the cell the user pressed on
        let selectedCell = collectionView.cellForItem(at: indexPath) as! BoardCell
        
        // Handle with selecting a cell
        boardController.handleSelectedCell(selectedCell: selectedCell, cvBoard: cvBoard, finishGameHandler: finishGame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the label of the player's name
        lblPlayerName.text = boardController.playerName
        
        // Creating custom back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GameController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // Starting the timer
        timer.StartTimer(lblTimer)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Pause the timer
        timer.PauseTimer()
        
        // Create alert message
        let alertValidating = UIAlertController(title: "", message: "Are you sure?", preferredStyle: .alert)
        
        // Create the actions of the alert
        alertValidating.addAction(UIAlertAction(title: "Yes", style: .default, handler:{
            [weak self] (alert: UIAlertAction) -> Void in
                // Dismissing the alert
                self?.dismiss(animated: true, completion: nil)
                
                // Go back to the menu
                self?.navigationController!.popViewController(animated: true)
        }))
        
        alertValidating.addAction(UIAlertAction(title: "No", style: .default, handler:{
            [weak self] (alert: UIAlertAction) -> Void in
                // Dismissing the alert
                self?.dismiss(animated: true, completion: nil)
                
                // Resume the timer
                self?.timer.ResumeTimer((self?.lblTimer)!)
        }))
        
        // Presenting the alert
        self.present(alertValidating, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set the dimentions of each cell in the board
        let colsCount = CGFloat(boardController.colsNumber)
        let rowsCount = CGFloat(boardController.rowsNumber)
        let dimentionWidth = (collectionView.frame.width / colsCount) - TileMargin * 2
        let dimentionHeight = (collectionView.frame.height / rowsCount) - TileMargin * 2

        return CGSize(width: dimentionWidth, height: dimentionHeight)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {        
        return UIEdgeInsetsMake(TileMargin, TileMargin, TileMargin, TileMargin)
    }
    
    func finishGame() {
        // Stoping the timer
        timer.StopTimer()
        
        // Show FINISH message
        let alertFinish = UIAlertController(title: "Congratulations!", message: "You finished the game in " + lblTimer.text! + " minutes", preferredStyle: .alert)
        alertFinish.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            [weak self] (alert: UIAlertAction) -> Void in
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
            
            // Go back to the menu
            self?.navigationController!.popViewController(animated: true)
        }))
        
        self.present(alertFinish, animated: true, completion: nil)
    }
}

class BoardCell : UICollectionViewCell {
    // Constants
    let COVER_IMAGE = #imageLiteral(resourceName: "card_cover")
    
    // Properties
    @IBOutlet weak var uiImage: UIImageView!
    var isPresented = Bool(false)
    var isMatchFound = Bool(false)
    var imageVal = #imageLiteral(resourceName: "card_cover")
    
    // Functions
    override func awakeFromNib() {
        uiImage.contentMode = .scaleAspectFill
        uiImage.image = COVER_IMAGE
    }
    
    func flip() {
        uiImage.image = imageVal
    }
    
    func flipOver() {
        uiImage.image = COVER_IMAGE
    }
}
