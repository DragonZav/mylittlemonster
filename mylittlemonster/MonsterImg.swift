//
//  MonsterImg.swift
//  mylittlemonster
//
//  Created by Chris Augg on 12/8/15.
//  Copyright © 2015 Auggie Doggie iOSware. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    
    private var _monsterIdle = "idle"
    private var _monsterDead = "dead"
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        //playIdleAnimation()
    }
    
    func assignHero() {
        _monsterIdle = "idleHero"
        _monsterDead = "deadHero"
    }
    
    
    func playIdleAnimation() {
       
        // TODO: Add a way for different images because this is tied to onw type of monster
        
        self.image = UIImage(named: "\(_monsterIdle)1.png")
       
        var imgArray = [UIImage]()
        
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "\(_monsterIdle)\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "\(_monsterDead)5.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "\(_monsterDead)\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}