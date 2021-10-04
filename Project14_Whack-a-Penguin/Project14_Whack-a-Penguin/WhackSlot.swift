//
//  WhackSlot.swift
//  Project14_Whack-a-Penguin
//
//  Created by Tyler Edwards on 9/8/21.
//

import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    //NOTE: I not appropriate particle effects
    let useParticles = false
    static var mudEmitter = SKEmitterNode(fileNamed: "explode.sks")
    static var hitEmitter = SKEmitterNode(fileNamed: "explosion.sks")

    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        // Particles
        if useParticles,
           let emitter = WhackSlot.mudEmitter?.copy() as? SKEmitterNode
        {
            emitter.position = charNode.position
            emitter.position.y += 80
            addChild(emitter)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
        
        // Particles
        if useParticles,
           let emitter = WhackSlot.mudEmitter?.copy() as? SKEmitterNode
        {
            emitter.position = charNode.position
            addChild(emitter)
        }
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
        
        // Particles
        if useParticles,
           let emitter = WhackSlot.hitEmitter?.copy() as? SKEmitterNode
        {
            emitter.position = charNode.position
            addChild(emitter)
        }
    }

}
