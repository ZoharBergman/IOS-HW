//
//  CardsPickerController.swift
//  MemoryGame
//
//  Created by Zohar Bergman on 26/05/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class CardsPickerController : UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
    // Constants
    let TileMargin = CGFloat(5.0)
    
    // Properties
    let imagePickerController = UIImagePickerController()
    var images = [UIImage]()
    var selectedImages = Set<UIImage>()
    var numberOfSections = 0
    @IBOutlet weak var CVImagesPicker: UICollectionView!
    @IBOutlet weak var lblPhotosToPickNum: UILabel!
    @IBOutlet weak var imgLoader: UIImageView!
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting ui components
        imgLoader.isHidden = true
        lblPhotosToPickNum.text = "Pick up to " + String(Board.sharedInstance.getMatchesNumber()) + " photos"
        
        // Reading the photos from the app path and setting them on the collection view
        readImagesFromAppPath()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numOfItems = 3
        
        if (section == numberOfSections - 1) {
            if (!(images.count % 3 == 0)) {
                numOfItems = images.count % 3
            }
        }
        
        return numOfItems
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (images.count == 0) {
            numberOfSections = 0
        } else {
            if (images.count % 3 == 0) {
                numberOfSections = images.count / 3
            } else {
                numberOfSections = (images.count / 3) + 1
            }
        }
        
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Getting a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as! ImagePickerCell
        
        // Setting the image of the cell
        cell.uiImage.image = images[indexPath.section * 3 + indexPath.item]
        
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set the dimentions of each cell in the board
        let dimention = (collectionView.frame.width / 3) - 2 * TileMargin
        
        return CGSize(width: dimention, height: dimention)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(TileMargin, TileMargin, TileMargin, TileMargin)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Getting the cell the user pressed on
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImagePickerCell
        
        selectedCell.setIsCellSelected(isSelected: !selectedCell.getIsCellSelected())
        
        if (selectedCell.getIsCellSelected()) {
            selectedImages.insert(selectedCell.uiImage.image!)
        } else {
            selectedImages.remove(selectedCell.uiImage.image!)
        }
    }
    
    @IBAction func onButtonAddPhotoPressed(_ sender: UIButton) {
        // Create alert message
        let alertSourceType = UIAlertController(title: "Photo source", message: "Pick a source", preferredStyle: .alert)
        
        // Create the actions of the alert
        alertSourceType.addAction(UIAlertAction(title: "URL", style: .default, handler:{
            [weak self] (alert: UIAlertAction) -> Void in
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
            self?.addPhotoFromURL()
        }))
        
        alertSourceType.addAction(UIAlertAction(title: "Camera", style: .default, handler:{
            [weak self] (alert: UIAlertAction) -> Void in
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
            self?.addPhotoFromCamera()
        }))
        
        alertSourceType.addAction(UIAlertAction(title: "Gallery", style: .default, handler:{
            [weak self] (alert: UIAlertAction) -> Void in
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
            self?.addPhotoFromGallery()
        }))
        
        // Presenting the alert
        self.present(alertSourceType, animated: true, completion: nil)
    }
    
    @IBAction func onButtonStartGamePressed(_ sender: UIButton) {
        let different = selectedImages.count - Board.sharedInstance.getMatchesNumber()
        if (different > 0) {
            // Create alert message
            let alertToMuchCards = UIAlertController(title: "You picked too much cards", message: "Please unselect at least " + String(different) + " cards", preferredStyle: .alert)
            
            // Create the actions of the alert
            alertToMuchCards.addAction(UIAlertAction(title: "Ok", style: .default, handler:{
                [weak self] (_) in
                // Dismissing the alert
                self?.dismiss(animated: true, completion: nil)
            }))
            
            // Presenting the alert
            self.present(alertToMuchCards, animated: true, completion: nil)
        } else {
            Board.sharedInstance.setArrCardsImages(arrCardsImages: Array(selectedImages))
            
            // Go back to the menu and start the game
            self.navigationController!.popViewController(animated: true)
            let gameController = self.storyboard?.instantiateViewController(withIdentifier: "GameController") as! GameController
            self.navigationController?.pushViewController(gameController, animated: true)
        }
    }
    
    func notAvailableAlert(source : String) {
        // Create alert message
        let alertNotAvailable = UIAlertController(title: "", message: source + " is not available", preferredStyle: .alert)
        
        // Create the actions of the alert
        alertNotAvailable.addAction(UIAlertAction(title: "Ok", style: .default, handler:{
            [weak self] (_) in
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
        }))
        
        // Presenting the alert
        self.present(alertNotAvailable, animated: true, completion: nil)
    }
    
    func addPhotoFromGallery() {
        if (!UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            notAvailableAlert(source: "Gallery")
        } else {
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func addPhotoFromCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            notAvailableAlert(source: "Camera")
        } else {
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage(image: image)
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func addPhotoFromURL() {
        // Create alert message
        let alertURL = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alertURL.addTextField(configurationHandler: {(urlTextfield) in
            urlTextfield.placeholder = "Enter URL"
        })
        
        // Create the actions of the alert
        alertURL.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{
            [weak alertURL, weak self] (_) in
            // Getting the entered URL
            var urlText = alertURL?.textFields![0].text
            urlText = urlText!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let url = URL(string: urlText!) {
                self?.downloadImage(url: url)
            }
            
            // Dismissing the alert
            self?.dismiss(animated: true, completion: nil)
        }))
        
        // Presenting the alert
        self.present(alertURL, animated: true, completion: nil)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        openLoader()
        getDataFromUrl(url: url) {[weak self] data, response, error in
            self!.removeLoader()
            
            guard let data = data, error == nil else {
                self!.notAvailableAlert(source: "URL")
                return
            }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else {
                    self!.notAvailableAlert(source: "Image")
                    return
                }
            
                self!.addImage(image: image)
            }
        }
    }
    
    func addImage (image : UIImage) {
        saveImage(image)
        images.insert(image, at: 0)
        CVImagesPicker.reloadData()
    }
    
    func saveImage(_ image : UIImage) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let photoURL = NSURL(fileURLWithPath: documentsPath)
        let destinationPath = photoURL.appendingPathComponent(String(NSDate().timeIntervalSince1970) + ".JPG")
        
        do {
            try UIImageJPEGRepresentation(image,0.5)?.write(to: destinationPath!)
        } catch {
            print("Error saving photo to file")
        }
    }
    
    func readImagesFromAppPath() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            fileURLs.forEach({imageURL -> Void in
                images.append(UIImage(contentsOfFile: imageURL.path)!)
                }
            )
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    func openLoader() {
        imgLoader.isHidden = false
        CVImagesPicker.isHidden = true
        
        // Spin the loader
        let spinningLoader = CABasicAnimation(keyPath: "transform.rotation.z")
        spinningLoader.fromValue = 0
        spinningLoader.toValue = 2*3.14
        spinningLoader.duration = 1
        spinningLoader.repeatCount = .infinity
        
        imgLoader.layer.add(spinningLoader, forKey: "spin")
    }
    
    func removeLoader() {
        DispatchQueue.main.async() {
            self.imgLoader.isHidden = true
            self.CVImagesPicker.isHidden = false
            
            self.imgLoader.layer.removeAllAnimations()
        }
    }
}

class ImagePickerCell : UICollectionViewCell {
    // Properties
    @IBOutlet weak var uiImage: UIImageView!
    private var isCellSelected = Bool(false)
    
    // Functions
    override func awakeFromNib() {
        uiImage.contentMode = .scaleAspectFill
    }
    
    func getIsCellSelected () -> Bool {
        return isCellSelected
    }
    
    func setIsCellSelected(isSelected : Bool) {
        self.isCellSelected = isSelected
        
        if (isSelected) {
            uiImage.alpha = 0.5
        } else {
            uiImage.alpha = 1.0
        }
    }
}
