//
//  Letter.swift
//  TheWordGameUITests
//
//  Created by Cowboy Lynk on 6/18/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit


class Tile: UIView{
    var letter = ""
    let label = UILabel()
    
    func setTileStyle(){
        
        // Label styling
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 40)
        label.text = self.letter
        
        // Tile styling
        self.addSubview(label)
        self.layer.shadowOffset = CGSize(width: 0, height: self.frame.height/12)
    }
    
    init(letter: String){
        self.letter = letter
        super.init(frame: CGRect())
        
        self.frame.size = CGSize(width: 80, height: 80)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        
        label.frame.size = CGSize(width: 80, height: 80)
        label.textColor = .gray
        label.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
