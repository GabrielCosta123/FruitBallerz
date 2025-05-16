//
//  Fruit.swift
//  FruitBallers
//
//  Created by Aluno a25957 Teste on 15/05/2025.
//

import Foundation
import SpriteKit

enum FruitType: String, CaseIterable {
    case dragonfruit
    case banana
    case peach
    
    var imageName: String {
            switch self {
            case .banana: return "banana"
            case .dragonfruit: return "dragonfruit"
            case .peach: return "peach"
            }
        }
}

class Fruit: SKSpriteNode {
    
    let fruitType: FruitType

        init(type: FruitType) {
            self.fruitType = type
            let texture = SKTexture(imageNamed: type.imageName)
            super.init(texture: texture, color: .clear, size: texture.size())

            self.name = "fruit"
            self.setupPhysics()
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.fruit
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.physicsBody?.contactTestBitMask = PhysicsCategory.blade
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
    }
    
    func launch(from position: CGPoint, with velocity: CGVector) {
        self.position = position
        self.physicsBody?.velocity = velocity
        self.physicsBody?.angularVelocity = CGFloat.random(in: -5...5)
    }
}
