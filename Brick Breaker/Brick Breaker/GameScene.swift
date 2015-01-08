//
//  GameScene.swift
//  Brick Breaker
//
//  Created by Sean Viswanathan on 12/29/14.
//  Copyright (c) 2014 Sean Viswanathan. All rights reserved.
//

import SpriteKit
import AVFoundation
class GameScene: SKScene, SKPhysicsContactDelegate {
var brickRows = 8
var bricksInRow = 8
let ballRef = "ball"
let brickRef = "brick"
let paddleRef = "paddle"

let backgroundMusicPlayer = AVAudioPlayer()
    
var isTouched = false
    
    let ballVal: UInt32 = 0x1 << 0                  // 000000000001
    let bottomSide: UInt32 = 0x1 << 1               // 000000000010
    let brickVal:UInt32 = 0x1 << 2                  // 000000000100
    let paddleVal: UInt32 = 0x1 << 3                // 000000001000
    override init(size: CGSize) {
        super.init(size: size)
        self.physicsWorld.contactDelegate = self
        
        let URL = NSBundle.mainBundle().URLForResource("EpicBgMusic", withExtension: "mp3")
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: URL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(background)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        let worldBoarder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBoarder
        self.physicsBody?.friction = 0
        
        
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballRef
        ball.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        
        ball.physicsBody?.applyImpulse(CGVectorMake(2, -2))
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleRef
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 8)
        self.addChild(paddle)
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.dynamic = false
        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, 1.0)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomSide
        ball.physicsBody?.categoryBitMask = ballVal
        paddle.physicsBody?.categoryBitMask = paddleVal
        ball.physicsBody?.contactTestBitMask = bottomSide | brickVal

        
        drawBricks()
        
}
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        let body:SKPhysicsBody? = self.physicsWorld.bodyAtPoint(location)
        if body?.node?.name == paddleRef{
            println("paddle touched")
            isTouched = true
        }
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if isTouched{
            let touch = touches.anyObject() as UITouch
            let location = touch.locationInNode(self)
            let lastTouch = touch.previousLocationInNode(self)
            
            let paddle = self.childNodeWithName(paddleRef) as SKSpriteNode
            
            var newX = paddle.position.x + (location.x - lastTouch.x)
            paddle.position.x = newX
        }
    }
   override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
       isTouched = false
}
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.categoryBitMask == ballVal && secondBody.categoryBitMask == bottomSide{
            let gameOverScene = GameOverScene(size: self.frame.size, playerWon:false)
            self.view?.presentScene(gameOverScene)
            
        }
        
        if firstBody.categoryBitMask == ballVal && secondBody.categoryBitMask == brickVal {
            secondBody.node?.removeFromParent()
            
            if isGameWon() {
                println("hell")
            }
            
            if isGameWon() {
                let youWinScene = GameOverScene(size: self.frame.size, playerWon: true)
                self.view?.presentScene(youWinScene)
            }
        }
    }
        func isGameWon() -> Bool{
            var numOfBricks = 0
            for nodeObject in self.children{
                let node = nodeObject as SKNode
                if node.name == brickRef {
                    numOfBricks += 1
                    
                }
            }
            
            return numOfBricks <= 0
        }
    
    
    func drawBricks(){
        var bricks : [SKShapeNode] = []
        var brickSpace: CGFloat = 4.0
        var setx: CGFloat = 3.5
        var sety: CGFloat = 30.0
        var topHeight: CGFloat = 15.0
        var heightBricks: CGFloat = 15.0
        var widthBricks: CGFloat = 42.8
        for y in Range(1...bricksInRow){
            for x in Range(1...brickRows){
                var brick = SKShapeNode(rectOfSize: CGSize(width: widthBricks, height: heightBricks))
                if y < 3 {
                    brick.fillColor = UIColor.redColor()
                    brick.strokeColor = UIColor.redColor()
                }
                else if y < 5{
                    brick.fillColor = UIColor.blueColor()
                    brick.strokeColor = UIColor.blueColor()
                }
                else if y < 7 {
                    brick.fillColor = UIColor.yellowColor()
                    brick.strokeColor = UIColor.yellowColor()
                }
                else if y < 9 {
                    brick.fillColor = UIColor.orangeColor()
                    brick.strokeColor = UIColor.orangeColor()
                }
                brick.position = CGPointMake(setx+20, self.frame.size.height - sety-15.0)
                brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.friction = 0
                brick.physicsBody?.restitution = 0
                brick.physicsBody?.dynamic = false
                brick.name = brickRef
                brick.physicsBody?.categoryBitMask = brickVal
                bricks.append(brick)
                self.addChild(brick)
                
                setx = setx + widthBricks + brickSpace
            }
            setx = 3.5
            sety = sety + heightBricks + brickSpace
        }

    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
}
}