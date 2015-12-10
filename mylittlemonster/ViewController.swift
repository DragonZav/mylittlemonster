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
    // Diamond clip art from clker.com
    @IBOutlet weak var diamondImg: DragImg!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!    
    @IBOutlet weak var penalty3Img: UIImageView!
    
    @IBOutlet weak var ChoosePetMsgLbl: UILabel!
    
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxDiamond: AVAudioPlayer!
    
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
            backgroundImg.image = UIImage(named: "bg.png")
            groundImg.image = UIImage(named: "ground.png")
            monsterImg.assignHero()
            monsterImg.playIdleAnimation()
            
            
            startGame()
            
        case 1:
            monsterImg.playIdleAnimation()
            startGame()
        default: print("Error!")
        }
        
    }
    
    func prepareVisuals() {
        
        monsterImg.hidden = false
        backgroundImg.hidden = false
        
        groundImg.hidden = false
        choosePetStackView.hidden = true
        dragItemsStackView.hidden = false
        ChoosePetMsgLbl.hidden = true
        
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        diamondImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
    }
    
    func prepareSoundFx() {
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            // Jump sound from SoundBible.com
            try sfxDiamond = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("diamond", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDiamond.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    
    func startGame() {
        
        prepareVisuals()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        prepareSoundFx()        
        chooseRandomItems()
        startTimer()
    }
    
    
    

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        diamondImg.alpha = DIM_ALPHA
        diamondImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxDiamond.play()
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
        
        chooseRandomItems()
        monsterHappy = false
    }
    
    func chooseRandomItems() {
       
        let rand = arc4random_uniform(3) // 0, 1, or 2
        if rand == 0 {
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            diamondImg.alpha = DIM_ALPHA
            diamondImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else if rand == 1 {
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            diamondImg.alpha = OPAQUE
            diamondImg.userInteractionEnabled = true
          
        } else {
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            diamondImg.alpha = DIM_ALPHA
            diamondImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
        }
        
        currentItem = rand

    }

    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        
        //TODO: Add a way to restart the Game with a replay button
        // full health, come back to life on image, (use own graphic)
    }

}

