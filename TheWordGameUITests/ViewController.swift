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
    var newTile: Tile!
    var currentDimension: Double!
    let origDimension = 80.0
    var currentWord = [Tile]()
    var defaultDimension: Double!
    var addLetterIndicator = UIView()
    var moveType: Int!  // 0: add, 1: remove, 2: sub, 3: rearrange
    
    // Outlets
    @IBOutlet weak var letterSetter: UITextField!
    @IBOutlet weak var currentWordHolderView: UIView!
    @IBOutlet weak var position: UITextField!
    
    // Actions
    @IBAction func addLetterButtonPused(_ sender: Any) {
        addTile(letter: letterSetter.text!)
    }
    @IBAction func removeLetterButtonPressed(_ sender: Any) {
        removeTile(index: Int(position.text!)!)
    }
    @IBAction func swapLetterButtonPressed(_ sender: Any) {
        swapTile(letter: letterSetter.text!, index: Int(position.text!)!)
    }
    
    // Functions
    func addTile(letter: String){
        // creates a new tile
        moveType = 0
        newTile = Tile(letter: letter)
        newTile.alpha = 0
        newTile.center.x = currentWordHolderView.bounds.width/2
        currentWordHolderView.addSubview(newTile)
        currentWord.insert(newTile, at: Int(position.text!)!)
        updateWordVisuals()
    }
    func removeTile(index: Int){
        moveType = 1
        let tileToRemove = currentWord[index]
        currentWord.remove(at: index)
        self.updateWordVisuals()
        
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
        
        newTile = Tile(letter: letter)
        newTile.alpha = 0
        newTile.center = oldTile.center
        newTile.center.y += 150
        newTile.transform = oldTile.transform
        currentWordHolderView.addSubview(newTile)
        currentWord.insert(newTile, at: index)
        updateWordVisuals()
    }
    func updateWordVisuals(){
        currentWordHolderView.bringSubview(toFront: addLetterIndicator)
        // gets dimension variables
        let numTiles = currentWord.count
        currentDimension = Double(0.9*screenSize.width)/(1.1*Double(numTiles) - 0.1)
        if currentDimension > defaultDimension || currentDimension < 0 {  // sets max tile size
            currentDimension = defaultDimension
        }
        let scaleDimension = currentDimension/origDimension
        let scaledTileHeight = self.newTile.bounds.height*CGFloat(scaleDimension)
        
        // sets initial xPos to match 5% padding on each side and centers the tiles
        var xPos = Double(screenSize.width * 0.05)
        if currentWord.count <= 4{
            xPos += Double(4 - currentWord.count)*defaultDimension*1.1/2.0
        }
        
        UIView.animate(withDuration: 0.7) {
            self.newTile.alpha = 1
            for index in 0..<self.currentWord.count{
                let tile = self.currentWord[index]
                tile.transform = CGAffineTransform(scaleX: CGFloat(scaleDimension), y: CGFloat(scaleDimension))
                tile.frame.origin = CGPoint(x: xPos, y: 0)
                tile.setTileStyle()
                xPos += self.currentDimension * 1.1
            }
            
            if self.moveType == 0 {
                self.addLetterIndicator.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50*scaleDimension, height: 10*scaleDimension))
                self.addLetterIndicator.alpha = 1
                self.addLetterIndicator.center.x = self.newTile.center.x
                let yCenter = self.newTile.center.y + scaledTileHeight/CGFloat(2) + self.addLetterIndicator.bounds.height
                if yCenter < 120{
                    self.addLetterIndicator.center.y = yCenter
                }
            } else {
                self.addLetterIndicator.alpha = 0
            }
        }
    }
    
    override func viewDidLoad() {
        screenSize = self.view.bounds
        defaultDimension = Double(0.9*screenSize.width)/(1.1*4.0 - 0.1)
        self.currentWordHolderView.center = self.view.center
        
        // Styling for add indicator
        addLetterIndicator = UIView(frame: CGRect(x: 0, y: 85, width: 40, height: 10))
        addLetterIndicator.backgroundColor = UIColor(red:0.94, green:0.56, blue:0.23, alpha:1.0)
        addLetterIndicator.alpha = 0
        currentWordHolderView.addSubview(addLetterIndicator)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

