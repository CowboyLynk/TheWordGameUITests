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
    let origDimension = 80.0
    var currentWord = [Tile]()
    
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
        newTile = Tile(letter: letter)
        newTile.alpha = 0
        currentWordHolderView.addSubview(newTile)
        currentWord.insert(newTile, at: Int(position.text!)!)
        updateWordVisuals()
    }
    func removeTile(index: Int){
        let tileToRemove = currentWord[index]
        currentWord.remove(at: index)
        
        UIView.animate(withDuration: 0.2, animations: {
            tileToRemove.alpha = 0
        }) { (sucsess:Bool) in
            tileToRemove.removeFromSuperview()
            self.updateWordVisuals()
        }
    }
    func swapTile(letter: String, index: Int){
        let oldTile = currentWord[index]
        newTile = Tile(letter: letter)
        newTile.alpha = 0
        newTile.center = oldTile.center
        newTile.center.y += 100
        newTile.transform = oldTile.transform
        oldTile.removeFromSuperview()
        currentWordHolderView.addSubview(newTile)
        currentWord.remove(at: index)
        currentWord.insert(newTile, at: index)
        updateWordVisuals()
    }
    func updateWordVisuals(){
        // gets dimension variable
        let numTiles = currentWord.count
        var dimension = Double(0.9*screenSize.width)/(1.1*Double(numTiles) - 0.1)
        if dimension > 80 || dimension < 0 {  // sets max tile size (tile won't be bigger than 80x80)
            dimension = 80.0
        }
        
        // center the tiles
        var xPos = Double(screenSize.width * 0.05)
        
        UIView.animate(withDuration: 1) {
            self.newTile.alpha = 1
            for index in 0..<self.currentWord.count{
                let tile = self.currentWord[index]
                tile.transform = CGAffineTransform(scaleX: CGFloat(dimension/self.origDimension), y: CGFloat(dimension/self.origDimension))
                tile.frame.origin = CGPoint(x: xPos, y: 0)
                tile.setTileStyle()
                xPos += dimension * 1.1
            }
            
            // set wordHolder dimensions
            let wordHolderWidth = CGFloat(Double(self.screenSize.width) * 0.1 + (1.1*Double(numTiles) - 0.1) * dimension)
            self.currentWordHolderView.frame = CGRect(origin: self.currentWordHolderView.frame.origin, size: CGSize(width: wordHolderWidth, height: CGFloat(dimension)))
            self.currentWordHolderView.center = self.view.center
        }
    }
    
    override func viewDidLoad() {
        screenSize = self.view.bounds
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

