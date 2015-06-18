//
//  GameScene.swift
//  XBlaster
//
//  Created by Andrew Perrault on 2015-06-17.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playerLayerNode = SKNode()
    let hudLayerNode = SKNode()
    let bulletLayerNode = SKNode()
    let playableRect: CGRect
    let hudHeight: CGFloat = 90
    let scoreLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    var scoreFlashAction: SKAction!
    let healthBarString: NSString = "===================="
    let playerHealthLabel = SKLabelNode(fontNamed: "Arial")
    var playerShip: PlayerShip!
    var deltaPoint = CGPointZero
    var bulletInterval: NSTimeInterval = 0
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    override init(size: CGSize) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5"
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
            width: size.width - playableMargin/2,
            height: size.height - hudHeight)
        
        super.init(size: size)
        setupSceneLayers()
        setupUI()
        setupEntities()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Edit Undo Line BRK")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 40;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.horizontalAlignmentMode = .Right
        self.addChild(myLabel)
    }
    
    func setupSceneLayers() {
        playerLayerNode.zPosition = 50
        hudLayerNode.zPosition = 100
        bulletLayerNode.zPosition = 25
        addChild(playerLayerNode)
        addChild(hudLayerNode)
        addChild(bulletLayerNode)
    }
    
    func setupUI() {
        let backgroundSize =
        CGSize(width: size.width, height:hudHeight)
        let backgroundColor = SKColor.blackColor()
        let hudBarBackground =
        SKSpriteNode(color: backgroundColor, size: backgroundSize)
        hudBarBackground.position =
            CGPoint(x:0, y: size.height - hudHeight)
        hudBarBackground.anchorPoint = CGPointZero
        hudLayerNode.addChild(hudBarBackground)
        
        // 1
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.name = "scoreLabel"
        // 2
        scoreLabel.verticalAlignmentMode = .Center
        // 3
        scoreLabel.position = CGPoint(
            x: size.width / 2,
            y: size.height - scoreLabel.frame.size.height + 3)
        // 4
        hudLayerNode.addChild(scoreLabel)
        
        scoreFlashAction = SKAction.sequence([
            SKAction.scaleTo(1.5, duration: 0.1),
            SKAction.scaleTo(1.0, duration: 0.1)])
        scoreLabel.runAction(
            SKAction.repeatAction(scoreFlashAction, count: 20))
        
        // 1
        let playerHealthBackgroundLabel =
        SKLabelNode(fontNamed: "Arial")
        playerHealthBackgroundLabel.name = "playerHealthBackground"
        playerHealthBackgroundLabel.fontColor = SKColor.darkGrayColor()
        playerHealthBackgroundLabel.fontSize = 50
        playerHealthBackgroundLabel.text = healthBarString as String
        playerHealthBackgroundLabel.zPosition = 0
        // 2
        playerHealthBackgroundLabel.horizontalAlignmentMode = .Left
        playerHealthBackgroundLabel.verticalAlignmentMode = .Top
        playerHealthBackgroundLabel.position = CGPoint(
            x: CGRectGetMinX(playableRect),
            y: size.height - CGFloat(hudHeight) +
                playerHealthBackgroundLabel.frame.size.height)
        hudLayerNode.addChild(playerHealthBackgroundLabel)
        // 3
        playerHealthLabel.name = "playerHealthLabel"
        playerHealthLabel.fontColor = SKColor.greenColor()
        playerHealthLabel.fontSize = 50
        playerHealthLabel.text =
            healthBarString.substringToIndex(20*75/100)
        playerHealthLabel.zPosition = 1
        playerHealthLabel.horizontalAlignmentMode = .Left
        playerHealthLabel.verticalAlignmentMode = .Top
        playerHealthLabel.position = CGPoint(
            x: CGRectGetMinX(playableRect),
            y: size.height - CGFloat(hudHeight) +
                playerHealthLabel.frame.size.height)
        hudLayerNode.addChild(playerHealthLabel)
    }
    
    func setupEntities() {
        playerShip = PlayerShip(entityPosition: CGPoint(x: size.width / 2, y: 100))
        playerLayerNode.addChild(playerShip)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let currentPoint = touch.locationInNode(self)
        let previousTouchLocation = touch.previousLocationInNode(self)
        deltaPoint = currentPoint - previousTouchLocation
    }
    
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        var newPoint:CGPoint = playerShip.position + deltaPoint
        newPoint.x.clamp(CGRectGetMinX(playableRect), CGRectGetMaxX(playableRect))
        newPoint.y.clamp(CGRectGetMinY(playableRect), CGRectGetMaxY(playableRect))
        playerShip.position = newPoint
        deltaPoint = CGPointZero
        
        bulletInterval += dt
        if bulletInterval > 0.15 {
            bulletInterval = 0
            var bullet = Bullet(entityPosition: playerShip.position)
            
            //var shoot = SKAction.moveTo(CGPoint(x: playerShip.position.x, y: 0), duration: 1.0)
            //var remove = SKAction.removeFromParent()
            var shootSequence = SKAction.sequence([
                    SKAction.group([
                        SKAction.moveTo(CGPoint(x: playerShip.position.x, y: size.height), duration: 1.0),
                        SKAction.rotateByAngle(CGFloat(50), duration: 1.0)
                    ]),
                    SKAction.removeFromParent()
                ])
            bullet.runAction(shootSequence)
            bulletLayerNode.addChild(bullet)
        }
    }
}
