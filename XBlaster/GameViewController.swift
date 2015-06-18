//
//  GameViewController.swift
//  XBlaster
//
//  Created by Andrew Perrault on 2015-06-17.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size:CGSize(width: 768, height: 1024))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    override func prefersStatusBarHidden() -> Bool  {
        return true
    }
}
