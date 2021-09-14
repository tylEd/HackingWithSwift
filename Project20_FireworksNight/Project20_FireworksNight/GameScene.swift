//
//  GameScene.swift
//  Project20_FireworksNight
//
//  Created by Tyler Edwards on 9/14/21.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    var waveCount = 0
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: 20)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMove: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch (Int.random(in: 0...2)) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMove, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        let moveAmount: CGFloat = 1800
        
        switch (Int.random(in: 0...3)) {
        case 0:
            // fire 5 straight up
            createFirework(xMove: 0, x: 512, y: bottomEdge)
            createFirework(xMove: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMove: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMove: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMove: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            // fire 5, in a fan
            createFirework(xMove: 0, x: 512, y: bottomEdge)
            createFirework(xMove: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMove: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMove: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMove: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            // fire 5, left to right
            createFirework(xMove: moveAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMove: moveAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMove: moveAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMove: moveAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMove: moveAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            // fire 5, right to left
            createFirework(xMove: -moveAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMove: -moveAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMove: -moveAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMove: -moveAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMove: -moveAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
        
        // Check the timer
        if waveCount < 10 {
            waveCount += 1
        } else {
            gameTimer?.invalidate()
            gameTimer = nil
            print("Game Over")
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            let removeSequence = SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.removeFromParent()
            ])
            emitter.run(removeSequence)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
}
