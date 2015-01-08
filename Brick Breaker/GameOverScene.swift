//
//  GameOverScene.swift
//  Brick Breaker
//
//  Created by Sean Viswanathan on 12/30/14.
//  Copyright (c) 2014 Sean Viswanathan. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
   
    
    init(size: CGSize, playerWon:Bool) {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.addChild(background)
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverLabel.fontSize = 46
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        
        if playerWon {
            gameOverLabel.text = "YOU WIN!"
        }else{
            gameOverLabel.text = "GAME OVER!"
        }
        
        self.addChild(gameOverLabel)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let breakoutGameScene = GameScene(size: self.size)
        self.view?.presentScene(breakoutGameScene)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
