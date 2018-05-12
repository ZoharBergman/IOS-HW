//
//  ScoresController.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 07/05/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit

class ScoresController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Consts
    let LIMIT = 10
    let NAME = "Name"
    let SCORE = "Score"
    
    // Properties
    @IBOutlet weak var cvScores: UICollectionView!
    private var scores : [Score]?
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scores = Score.fetchData(limit: LIMIT)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (scores?.count)! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Getting a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreCell", for: indexPath) as! ScoreCell
        
        // Setting the cell's content
        if (indexPath.row == 0) {
            if (indexPath.item == 0) {
                cell.lblText.text = NAME
            } else if (indexPath.item == 1){
                cell.lblText.text = SCORE
            }
        } else {
            if (indexPath.item == 0) {
                cell.lblText.text = scores![indexPath.item - 1].name
            } else if (indexPath.item == 1){
                cell.lblText.text = MyTimer.formatTimer(minutes: scores![indexPath.item - 1].minutes.intValue, seconds: scores![indexPath.item - 1].seconds.intValue)
            }
        }
        
        return cell
    }
}

class ScoreCell : UICollectionViewCell {
    @IBOutlet weak internal var lblText: UILabel!
}
