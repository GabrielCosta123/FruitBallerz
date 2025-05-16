//
//  GameScene.swift
//  FruitBallers
//
//  Created by Aluno a25957 Teste on 15/05/2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var lastSpawnTime: TimeInterval = 0
    private let spawnInterval: TimeInterval = 1.0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
            
    }
        
    func spawnRandomFruit() {
        let randomType = FruitType.allCases.randomElement()!
        let fruit = Fruit(type: randomType)

        let edge = Int.random(in: 0...2)
        var position: CGPoint
        var velocity: CGVector

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        switch edge {
        case 0: // Spawn de baixo
            let startX = CGFloat.random(in: 100...screenWidth - 100)
            position = CGPoint(x: startX, y: -100)
            velocity = CGVector(
                dx: CGFloat.random(in: -100...100),
                dy: CGFloat.random(in: 900...1300)
            )

        case 1: // Spawn da esquerda
            let startY = CGFloat.random(in: screenHeight / 2 ... screenHeight - 200)
            position = CGPoint(x: -100, y: startY)
            velocity = CGVector(
                dx: CGFloat.random(in: 500...800),
                dy: CGFloat.random(in: 100...300)
            )

        case 2: // Spawn da direita
            let startY = CGFloat.random(in: screenHeight / 2 ... screenHeight - 200)
            position = CGPoint(x: screenWidth + 100, y: startY)
            velocity = CGVector(
                dx: CGFloat.random(in: -800 ... -500),
                dy: CGFloat.random(in: 100...300)
            )

        default:
            return
        }

        fruit.launch(from: position, with: velocity)
        addChild(fruit)
    }


    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        
        let swipeLine = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: previous)
        path.addLine(to: location)
        swipeLine.path = path
        swipeLine.strokeColor = .white
        swipeLine.lineWidth = 5
        addChild(swipeLine)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        swipeLine.run(sequence)

        // Check for fruit hit
        nodes(at: location).forEach { node in
            if node.name == "fruit" {
                node.removeFromParent()
                // play sound or animation
            }
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        print("update called")
        print("Ballerz")
        if currentTime - lastSpawnTime > spawnInterval {
                spawnRandomFruit()
                lastSpawnTime = currentTime
        }
    }
}

