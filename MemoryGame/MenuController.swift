	//
//  ViewController.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 24/03/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import UIKit
import Foundation

class MenuController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    // Properties
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var pickerLevels: UIPickerView!
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the levels' picker
        self.pickerLevels.dataSource = self
        self.pickerLevels.delegate = self
        
        // Setting the name's text field
        self.txtName.delegate = self
        txtName.placeholder = "Enter your name"
        txtName.textAlignment = .center
        txtName.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.eGameLevel.getNumberOfLevels()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.eGameLevel(rawValue: row)?.getDescription()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Closing the keyboard when the user touch outside of it
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Closing the keyboard when the user press return
        txtName.resignFirstResponder()
        return true
    }

    @IBAction func onGoButtonClick(_ sender: UIButton) {
        txtName.text = txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (txtName.text!.isEmpty) {
            let alertView = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            // Checking how to configure the game's board
            switch pickerLevels.selectedRow(inComponent: 0) {
                case Constants.eGameLevel.easy.rawValue:
                    Board.sharedInstance.ConfigBoard(level: .easy, playerName: txtName.text!)
                case Constants.eGameLevel.medium.rawValue:
                    Board.sharedInstance.ConfigBoard(level: .medium, playerName: txtName.text!)
                case Constants.eGameLevel.hard.rawValue:
                    Board.sharedInstance.ConfigBoard(level: .hard, playerName: txtName.text!)
                default:
                    return
            }
            
            // Navigating to the game's view
            let gameController = storyboard?.instantiateViewController(withIdentifier: "GameController") as! GameController
            navigationController?.pushViewController(gameController, animated: true)
        }
    }
}