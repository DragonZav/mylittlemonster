//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Chris Augg on 12/8/15.
//  Copyright © 2015 Auggie Doggie iOSware. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
   
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var groundImg: UIImageView!
    
    @IBOutlet weak var choosePetStackView: UIStackView!
    @IBOutlet weak var dragItemsStackView: UIStackView!
    
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!    
    @IBOutlet weak var penalty3Img: UIImageView!
    
    @IBOutlet weak var ChoosePetMsgLbl: UILabel!
    
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    @IBAction func petChosen(sender: AnyObject) {
        
        switch sender.tag {
        case 0:
            monsterImg.assignHero()
            monsterImg.playIdleAnimation()
            
            
            startGame()
            
        case 1:
            monsterImg.playIdleAnimation()
            startGame()
        default: print("Error!")
        }
        
    }
    
    
    
    func startGame() {
        
        // TODO: Add a way for a player to choose the monster they want to play with.
        // Whatever character is picked is the one that is used until the app is closed
        // and re-opened. Also, set the background to match the chosen character.
        monsterImg.hidden = false
        backgroundImg.hidden = false
        
        groundImg.hidden = false
        choosePetStackView.hidden = true
        dragItemsStackView.hidden = false
        ChoosePetMsgLbl.hidden = true
        
        // TODO: Pick a third item that the monster needs randomly - obedience - (find own graphic)
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        startTimer()
    }
    
    
    

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        
        if !monsterHappy {
           
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            }else if penalties == 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        let rand = arc4random_uniform(2) // 0 or 1
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
           
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
        }
        
        currentItem = rand
        monsterHappy = false
    }

    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        
        //TODO: Add a way to restart the Game with a replay button
        // full health, come back to life on image, (use own graphic)
    }

}

