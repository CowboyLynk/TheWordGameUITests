//
//  ViewController.swift
//  TheWordGameUITests
//
//  Created by Cowboy Lynk on 6/16/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Variables
    var screenSize: CGRect!
    var currentDimension: Double! // is the scalled dimesion when more than 4 tiles are on screen
    var defaultDimension: Double! // this dimension perfectly fits 4 tiles on a screen without scalling
    var newTile: Tile!  // is the tile that was added most recently
    var currentWord = [Tile]()  // Array of all tiles (letters) on the screen
    var moveType = 4  // 0: add, 1: remove, 2: sub, 3: rearrange, 4: default
    var previousMoveType = 4 // ^
    var changedLetterIndicator = UIView() // used to indicate which letter was changed
    var previousWord = "CAT"
    
    // Outlets
    @IBOutlet weak var letterSetter: UITextField!
    @IBOutlet weak var currentWordHolderView: UIView!
    @IBOutlet weak var position: UITextField!
    
    // Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        getLetterToChange()
    }
    @IBAction func addLetterButtonPused(_ sender: Any) {
        if Int(position.text!)! <= currentWord.count{
            addTile(letter: letterSetter.text!, index: Int(position.text!)!)
        }
    }
    @IBAction func removeLetterButtonPressed(_ sender: Any) {
        if Int(position.text!)! < currentWord.count{
             removeTile(index: Int(position.text!)!)
        }
    }
    @IBAction func swapLetterButtonPressed(_ sender: Any) {
        if Int(position.text!)! < currentWord.count{
            swapTile(letter: letterSetter.text!, index: Int(position.text!)!)
        }
    }
    
    // Functions
    func getLetterToChange(){
        
    }
    func addTile(letter: String, index: Int){
        // creates a new tile
        moveType = 0
        newTile = Tile(letter: letter, defaultDimension: defaultDimension)
        currentWordHolderView.addSubview(newTile)
        currentWord.insert(newTile, at: index)
        updateWordVisuals(index: index)  // centers all the other letters and adjusts their size
    }
    func removeTile(index: Int){
        moveType = 1
        let tileToRemove = currentWord[index]
        currentWord.remove(at: index)
        self.updateWordVisuals(index: index)  // centers all the other letters and adjusts their size
        
        // Fades out the tile to remove
        UIView.animate(withDuration: 0.5, animations: {
            tileToRemove.alpha = 0
            tileToRemove.center.y += 100
        }) { (sucsess:Bool) in
            tileToRemove.removeFromSuperview()
        }
    }
    func swapTile(letter: String, index: Int){
        moveType = 2
        let oldTile = currentWord[index]
        currentWord.remove(at: index)
        
        UIView.animate(withDuration: 0.5, animations: {
            oldTile.alpha = 0
            oldTile.center.y -= 75
        }) { (sucsess:Bool) in
            oldTile.removeFromSuperview()
        }
        
        newTile = Tile(letter: letter, defaultDimension: defaultDimension)
        newTile.center = oldTile.center
        newTile.center.y += 150
        newTile.transform = oldTile.transform
        currentWordHolderView.addSubview(newTile)
        currentWord.insert(newTile, at: index)
        updateWordVisuals(index: index)
    }
    func updateWordVisuals(index: Int){
        currentWordHolderView.bringSubview(toFront: changedLetterIndicator)
        // gets dimension variables
        let numTiles = currentWord.count
        currentDimension = Double(0.9*screenSize.width)/(1.1*Double(numTiles) - 0.1)
        if currentDimension > defaultDimension || currentDimension < 0 {  // sets max tile size
            currentDimension = defaultDimension
        }
        let scaleDimension = currentDimension/defaultDimension  // is a decimal value e.g. 0.8
        let scaledTileHeight = self.newTile.bounds.height*CGFloat(scaleDimension) // represents the new height after the original is scaled
        
        // sets initial xPos to match 5% padding on each side and centers the tiles
        var xPos = Double(screenSize.width * 0.05)
        if currentWord.count < 4{
            xPos += Double(4 - currentWord.count)*currentDimension*1.1/2.0
        }
        
        // centers a letter thats added by calculating where its center will be
        if moveType == 0 || moveType == 2{ // is ADD or SWAP
            let xCenter = CGFloat(xPos) + CGFloat(index)*scaledTileHeight*1.1 + CGFloat(currentDimension/2)
            if previousMoveType != 0 && previousMoveType != 2{  // centers the letter indicator
                changedLetterIndicator.center.x = xCenter
            }
            if moveType == 0{
                newTile.center.x = xCenter
                newTile.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }
        
        UIView.animate(withDuration: 0.7) {
            self.newTile.alpha = 1
            for index in 0..<self.currentWord.count{
                let tile = self.currentWord[index]
                tile.removeIndicator()
                tile.transform = CGAffineTransform(scaleX: CGFloat(scaleDimension), y: CGFloat(scaleDimension))
                tile.frame.origin = CGPoint(x: xPos, y: 0)
                tile.center.y = self.currentWordHolderView.bounds.height/2
                tile.setTileStyle()
                xPos += Double(scaledTileHeight) * 1.1
            }
            
            if self.moveType == 0 || self.moveType == 2 {
                // Normal changedLetterIndicator
                self.newTile.addIndicator()
                
                // Adds the slide changedLetterIndicator
                self.changedLetterIndicator.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50*scaleDimension, height: 10*scaleDimension))
                self.changedLetterIndicator.alpha = 0 // SET TO 1 TO ENABLE THE SLIDE ADD EFFECT AND COMMENT OUT "Normal ChangedLetterIndicator"
                self.changedLetterIndicator.center.x = self.newTile.center.x
                let yCenter = self.newTile.center.y + scaledTileHeight/CGFloat(2) + self.changedLetterIndicator.bounds.height
                self.changedLetterIndicator.center.y = yCenter
            } else {
                if self.changedLetterIndicator.center.y < 120 {
                    self.changedLetterIndicator.center.y += 100
                    self.changedLetterIndicator.alpha = 0
                }
            }
        } // END of UIView animation
        
        previousMoveType = moveType
        
        
    }
    
    override func viewDidLoad() {
        screenSize = self.view.bounds
        defaultDimension = Double(0.9*screenSize.width)/(1.1*4.0 - 0.1)
        //self.currentWordHolderView.center = self.view.center
        
        // Styling for add indicator
        changedLetterIndicator = UIView(frame: CGRect(x: 0, y: 85, width: 40, height: 10))
        changedLetterIndicator.backgroundColor = UIColor(red:0.94, green:0.56, blue:0.23, alpha:1.0)
        changedLetterIndicator.alpha = 0
        currentWordHolderView.addSubview(changedLetterIndicator)
        
        // Because its annoying to type in values each time when testing
        letterSetter.text = "R"
        position.text = "0"
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Adds the starting word
        for index in 0..<previousWord.characters.count{
            let charIndex = previousWord.index(previousWord.startIndex, offsetBy: index)
            newTile = Tile(letter: String(previousWord[charIndex]), defaultDimension: defaultDimension)
            currentWordHolderView.addSubview(newTile)
            currentWord.insert(newTile, at: index)
            updateWordVisuals(index: index)
            newTile.removeIndicator()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

