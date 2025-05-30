//
//  GameOverScene.swift
//  FruitBallers
//
//  Created by Aluno a25957 Teste on 30/05/2025.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "gameOverBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
        
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.name = "restart"
        restartButton.fontName = "AvenirNext-Bold"
        restartButton.fontColor = .green
        restartButton.fontSize = 36
        restartButton.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        addChild(restartButton)
        
        let menuButton = SKLabelNode(text: "Main Menu")
        menuButton.name = "menu"
        menuButton.fontName = "AvenirNext-Bold"
        menuButton.fontColor = .red
        menuButton.fontSize = 36
        menuButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        addChild(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node.name == "restart" {
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: .doorsOpenVertical(withDuration: 0.5))
            } else if node.name == "menu" {
                let menuScene = StartScene(size: self.size)
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene, transition: .flipHorizontal(withDuration: 0.5))
            }
        }
    }
}
