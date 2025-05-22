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
    private var spawnInterval : TimeInterval = 1.0
    
    private var lastBombSpawnTime: TimeInterval = 0
    private var bombSpawnInterval = Double.random(in: 2.0...3.5)
    
    private var score = 0
    private var scoreLabel: SKLabelNode!
    
    private var lives = 3
    private var livesLabel: SKLabelNode!

    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        scoreLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.width - 380, y: frame.height - 50)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)
        
        livesLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        livesLabel.fontSize = 24
        livesLabel.fontColor = .red
        livesLabel.position = CGPoint(x: frame.width - 35, y: frame.height - 50)
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.text = "Lives: \(lives)"
        addChild(livesLabel)


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
    
    func spawnBomb() {
        let bomb = SKSpriteNode(imageNamed: "bomb") // Use uma imagem de bomba
        bomb.name = "bomb"
        bomb.setScale(0.5)

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let edge = Int.random(in: 0...2)
        var position: CGPoint
        var velocity: CGVector

        switch edge {
            case 0: // De baixo para cima
                let startX = CGFloat.random(in: 100...screenWidth - 100)
                position = CGPoint(x: startX, y: -100)
                velocity = CGVector(
                    dx: CGFloat.random(in: -100...100),
                    dy: CGFloat.random(in: 900...1300)
                )

            case 1: // Da esquerda para direita
                let startY = CGFloat.random(in: screenHeight / 2 ... screenHeight - 200)
                position = CGPoint(x: -100, y: startY)
                velocity = CGVector(
                    dx: CGFloat.random(in: 500...800),
                    dy: CGFloat.random(in: 100...300)
                )

            case 2: // Da direita para esquerda
                let startY = CGFloat.random(in: screenHeight / 2 ... screenHeight - 200)
                position = CGPoint(x: screenWidth + 100, y: startY)
                velocity = CGVector(
                    dx: CGFloat.random(in: -800 ... -500),
                    dy: CGFloat.random(in: 100...300)
                )

            default:
                position = CGPoint(x: screenWidth / 2, y: -100)
                velocity = CGVector(dx: 0, dy: 1000)
            }

            bomb.position = position

            let physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2)
            physicsBody.categoryBitMask = PhysicsCategory.bomb
            physicsBody.collisionBitMask = PhysicsCategory.none
            physicsBody.contactTestBitMask = PhysicsCategory.blade
            physicsBody.velocity = velocity
            physicsBody.linearDamping = 0
            physicsBody.affectedByGravity = true

        bomb.physicsBody = physicsBody
        
        
        addChild(bomb)
    }

    func addScore(_ points: Int = 1) {
        score += points
        scoreLabel.text = "Score: \(score)"
    }
    
    func loseLife() {
        lives -= 1
        livesLabel.text = "Lives: \(lives)"

        if lives <= 0 {
            gameOver()
        }
    }
    
    func gameOver() {
        let gameOverLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .white
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverLabel)

        isPaused = true
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
                addScore(1)
            }else if node.name == "bomb"{
                node.removeFromParent()
                loseLife()
                addScore(-3)
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
        if score >= 40 {
            spawnInterval = 0.5
        } else if score >= 30 {
            spawnInterval = 0.6
        } else if score >= 20 {
            spawnInterval = 0.8
        } else {
            spawnInterval = 1.0
        }
        if currentTime - lastSpawnTime > spawnInterval {
            spawnRandomFruit()
            lastSpawnTime = currentTime
        }
        if currentTime - lastBombSpawnTime > bombSpawnInterval {
                spawnBomb()
                lastBombSpawnTime = currentTime
            }
        for node in children {
            if node.name == "fruit" && node.position.y < -150 {
                node.removeFromParent()
                loseLife()
            }else if node.name == "bomb" && node.position.y < -150 {
                node.removeFromParent()
            }
        }

    }
}

