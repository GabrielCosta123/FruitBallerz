//
//  PhysicsCategory.swift
//  FruitBallers
//
//  Created by Aluno a25957 Teste on 15/05/2025.
//

import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let fruit: UInt32 = 0x1 << 0
    static let blade: UInt32 = 0x1 << 1
    static let bomb: UInt32 = 0x1 << 2
}
