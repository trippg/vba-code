import SpriteKit

private enum GameState { case waiting, aiming, shooting, gameOver }

final class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: - Config
    private let cols        = 7
    private let brickH: CGFloat = 42
    private let brickPad: CGFloat = 4
    private let ballR: CGFloat  = 10
    private let ballSpeed: CGFloat = 650
    private let maxRows     = 10

    private let catBall:    UInt32 = 1 << 0
    private let catBrick:   UInt32 = 1 << 1
    private let catWall:    UInt32 = 1 << 2
    private let catPowerUp: UInt32 = 1 << 3

    // MARK: - State
    private var gameState: GameState = .waiting
    private var ballCount  = 1
    private var ballsShot  = 0
    private var ballsHome  = 0
    private var level      = 1
    private var hasFirstReturn = false
    private var firstReturnX: CGFloat = 0
    private var launchPos  = CGPoint.zero
    private var launchVel  = CGVector.zero

    // MARK: - UI nodes
    private var aimGuide:      SKNode?
    private var levelLabel:    SKLabelNode!
    private var countLabel:    SKLabelNode!
    private var ballIndicator: SKShapeNode!

    private var floorY: CGFloat { size.height * 0.10 }
    private var ceilY:  CGFloat { size.height * 0.90 }
    private var brickW: CGFloat {
        (size.width - brickPad * CGFloat(cols + 1)) / CGFloat(cols)
    }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(white: 0.08, alpha: 1)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        setupWalls()
        setupHUD()
        launchPos    = CGPoint(x: size.width / 2, y: floorY + ballR + 4)
        firstReturnX = launchPos.x
        spawnRow()
    }

    // MARK: - Walls

    private func setupWalls() {
        func wall(from a: CGPoint, to b: CGPoint) {
            let n = SKNode()
            let body = SKPhysicsBody(edgeFrom: a, to: b)
            body.restitution = 1; body.friction = 0
            body.categoryBitMask  = catWall
            body.collisionBitMask = catBall
            n.physicsBody = body
            addChild(n)
        }
        wall(from: CGPoint(x: 0,          y: floorY),        to: CGPoint(x: 0,          y: size.height))
        wall(from: CGPoint(x: size.width, y: floorY),        to: CGPoint(x: size.width, y: size.height))
        wall(from: CGPoint(x: 0,          y: size.height),   to: CGPoint(x: size.width, y: size.height))

        let line = SKShapeNode(rect: CGRect(x: 0, y: floorY - 1, width: size.width, height: 2))
        line.fillColor = SKColor(white: 0.35, alpha: 1)
        line.strokeColor = .clear
        addChild(line)
    }

    // MARK: - HUD

    private func setupHUD() {
        levelLabel = hudLabel("LEVEL 1", size: 18)
        levelLabel.position = CGPoint(x: size.width / 2, y: ceilY + 8)
        addChild(levelLabel)

        countLabel = hudLabel("\u{00D7} 1", size: 16)
        countLabel.fontColor = SKColor(red: 1, green: 0.85, blue: 0.2, alpha: 1)
        countLabel.position = CGPoint(x: size.width / 2, y: floorY - 30)
        addChild(countLabel)

        ballIndicator = SKShapeNode(circleOfRadius: ballR)
        ballIndicator.fillColor = SKColor(red: 1, green: 0.85, blue: 0.2, alpha: 1)
        ballIndicator.strokeColor = .clear
        ballIndicator.position = launchPos
        addChild(ballIndicator)
    }

    private func hudLabel(_ text: String, size: CGFloat) -> SKLabelNode {
        let l = SKLabelNode(fontNamed: "AvenirNext-Bold")
        l.text = text; l.fontSize = size
        l.fontColor = .white
        l.verticalAlignmentMode = .bottom
        return l
    }

    private func refreshHUD() {
        levelLabel.text = "LEVEL \(level)"
        countLabel.text  = "\u{00D7} \(ballCount)"
    }

    // MARK: - Grid helpers

    private func colX(_ c: Int) -> CGFloat {
        brickPad + CGFloat(c) * (brickW + brickPad) + brickW / 2
    }

    private func rowY(_ r: Int) -> CGFloat {
        ceilY - brickH / 2 - CGFloat(r) * (brickH + brickPad)
    }

    // MARK: - Spawn row

    private func spawnRow() {
        let shift = SKAction.moveBy(x: 0, y: -(brickH + brickPad), duration: 0.25)
        var gameEnds = false

        enumerateChildNodes(withName: "brick") { node, _ in
            node.run(shift)
            if let b = node as? BrickNode {
                b.gridRow += 1
                if b.gridRow >= self.maxRows { gameEnds = true }
            }
        }
        enumerateChildNodes(withName: "powerup") { node, _ in node.run(shift) }

        if gameEnds { triggerGameOver(); return }

        let minHP = max(1, level), maxHP = level + 3
        let numBricks = Int.random(in: 3...min(cols - 1, 3 + level / 4))
        var used = Set<Int>()

        for _ in 0..<numBricks {
            let c = unusedCol(&used)
            let hp = Int.random(in: minHP...maxHP)
            makeBrick(col: c, row: 0, hp: hp)
        }

        if Int.random(in: 0...2) < 2 {
            let c = unusedCol(&used)
            makePowerUp(col: c, row: 0)
        }

        refreshHUD()
        gameState = .waiting
    }

    private func unusedCol(_ used: inout Set<Int>) -> Int {
        var c: Int
        repeat { c = Int.random(in: 0..<cols) } while used.contains(c)
        used.insert(c); return c
    }

    private func makeBrick(col: Int, row: Int, hp: Int) {
        let brick = BrickNode(hp: hp, width: brickW, height: brickH)
        brick.position = CGPoint(x: colX(col), y: rowY(row))
        brick.gridRow  = row
        brick.name     = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: brickW - 3, height: brickH - 3))
        brick.physicsBody?.isDynamic          = false
        brick.physicsBody?.restitution        = 1
        brick.physicsBody?.friction           = 0
        brick.physicsBody?.categoryBitMask    = catBrick
        brick.physicsBody?.contactTestBitMask = catBall
        brick.physicsBody?.collisionBitMask   = catBall
        addChild(brick)
    }

    private func makePowerUp(col: Int, row: Int) {
        let r = brickH / 2 - 5
        let node = SKShapeNode(circleOfRadius: r)
        node.fillColor   = SKColor(red: 0.18, green: 0.88, blue: 0.42, alpha: 1)
        node.strokeColor = SKColor(white: 1, alpha: 0.4)
        node.lineWidth   = 2
        node.position    = CGPoint(x: colX(col), y: rowY(row))
        node.name        = "powerup"

        let lbl = SKLabelNode(text: "+\u{25CF}")
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 12; lbl.fontColor = .white
        lbl.verticalAlignmentMode = .center
        node.addChild(lbl)

        node.physicsBody = SKPhysicsBody(circleOfRadius: r)
        node.physicsBody?.isDynamic          = false
        node.physicsBody?.categoryBitMask    = catPowerUp
        node.physicsBody?.contactTestBitMask = catBall
        node.physicsBody?.collisionBitMask   = 0
        addChild(node)
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        switch gameState {
        case .gameOver:  restartGame()
        case .waiting:
            if loc.y > floorY + 50 { gameState = .aiming; updateAim(loc) }
        default: break
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .aiming, let t = touches.first else { return }
        updateAim(t.location(in: self))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .aiming, let t = touches.first else { return }
        clearAim()
        let loc = t.location(in: self)
        let dx = loc.x - launchPos.x
        let dy = loc.y - launchPos.y
        guard dy > 20 else { gameState = .waiting; return }
        let len = sqrt(dx * dx + dy * dy)
        launchVel = CGVector(dx: dx / len * ballSpeed, dy: dy / len * ballSpeed)
        beginRound()
    }

    // MARK: - Aim guide

    private func updateAim(_ point: CGPoint) {
        clearAim()
        let dy = point.y - launchPos.y
        guard dy > 20 else { return }
        let dx = point.x - launchPos.x
        let len = sqrt(dx * dx + dy * dy)
        let nx = dx / len, ny = dy / len

        let container = SKNode()
        container.name = "aimGuide"
        let step: CGFloat = 18
        for i in 1...22 {
            let t = CGFloat(i) * step
            let px = launchPos.x + nx * t
            let py = launchPos.y + ny * t
            guard px > 4, px < size.width - 4, py < ceilY else { break }
            let dot = SKShapeNode(circleOfRadius: 3)
            dot.fillColor = SKColor(white: 1, alpha: CGFloat(23 - i) / 24.0)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: px, y: py)
            container.addChild(dot)
        }
        addChild(container)
        aimGuide = container
    }

    private func clearAim() { aimGuide?.removeFromParent(); aimGuide = nil }

    // MARK: - Round

    private func beginRound() {
        gameState = .shooting
        ballsShot = ballCount
        ballsHome = 0
        hasFirstReturn = false
        for i in 0..<ballsShot {
            run(SKAction.wait(forDuration: Double(i) * 0.12)) { [weak self] in
                self?.fireBall()
            }
        }
    }

    private func fireBall() {
        let ball = SKShapeNode(circleOfRadius: ballR)
        ball.fillColor   = SKColor(red: 1, green: 0.85, blue: 0.2, alpha: 1)
        ball.strokeColor = SKColor(white: 1, alpha: 0.3)
        ball.lineWidth   = 1
        ball.position    = launchPos
        ball.name        = "ball"

        let body = SKPhysicsBody(circleOfRadius: ballR)
        body.velocity         = launchVel
        body.restitution      = 1
        body.friction         = 0
        body.linearDamping    = 0
        body.angularDamping   = 0
        body.allowsRotation   = false
        body.categoryBitMask  = catBall
        body.contactTestBitMask = catBrick | catPowerUp
        body.collisionBitMask = catBrick | catWall
        ball.physicsBody      = body
        addChild(ball)
    }

    // MARK: - Update (floor detection)

    override func update(_ currentTime: TimeInterval) {
        guard gameState == .shooting else { return }
        enumerateChildNodes(withName: "ball") { node, _ in
            if node.position.y <= self.floorY + self.ballR {
                self.returnBall(node)
            }
        }
    }

    private func returnBall(_ ball: SKNode) {
        ball.name        = "returning"
        ball.physicsBody = nil

        if !hasFirstReturn { hasFirstReturn = true; firstReturnX = ball.position.x }
        let target = CGPoint(x: firstReturnX, y: floorY + ballR + 4)

        ball.run(SKAction.sequence([
            SKAction.move(to: target, duration: 0.15),
            SKAction.removeFromParent()
        ])) { [weak self] in
            guard let self else { return }
            self.ballsHome += 1
            if self.ballsHome == self.ballsShot { self.endRound() }
        }
    }

    private func endRound() {
        launchPos.x = firstReturnX
        ballIndicator.run(SKAction.move(to: launchPos, duration: 0.2))
        level += 1
        spawnRow()
    }

    // MARK: - Physics contact

    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA, b = contact.bodyB
        if a.categoryBitMask == catBall, let brick = b.node as? BrickNode {
            onBrickHit(brick)
        } else if b.categoryBitMask == catBall, let brick = a.node as? BrickNode {
            onBrickHit(brick)
        } else if a.categoryBitMask == catBall, b.categoryBitMask == catPowerUp, let pu = b.node {
            onPowerUp(pu)
        } else if b.categoryBitMask == catBall, a.categoryBitMask == catPowerUp, let pu = a.node {
            onPowerUp(pu)
        }
    }

    private func onBrickHit(_ brick: BrickNode) {
        guard brick.parent != nil else { return }
        if brick.hit() { brick.removeFromParent() }
    }

    private func onPowerUp(_ node: SKNode) {
        guard node.parent != nil else { return }
        node.removeFromParent()
        ballCount += 1
        refreshHUD()
    }

    // MARK: - Game over / restart

    private func triggerGameOver() {
        gameState = .gameOver
        enumerateChildNodes(withName: "ball") { $0.removeFromParent() }

        let overlay = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        overlay.fillColor = UIColor.black.withAlphaComponent(0.78)
        overlay.strokeColor = .clear
        overlay.zPosition = 50
        addChild(overlay)

        func addLabel(_ text: String, size: CGFloat, yOffset: CGFloat, color: SKColor = .white) {
            let l = SKLabelNode(fontNamed: "AvenirNext-Bold")
            l.text = text; l.fontSize = size; l.fontColor = color
            l.verticalAlignmentMode = .center
            l.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + yOffset)
            l.zPosition = 51
            addChild(l)
        }

        addLabel("GAME OVER",                              size: 44, yOffset:  50)
        addLabel("Level \(level)  \u{00B7}  \(ballCount) balls", size: 22, yOffset:   5,
                 color: SKColor(red: 1, green: 0.85, blue: 0.2, alpha: 1))
        addLabel("Tap to play again",                     size: 18, yOffset: -45,
                 color: SKColor(white: 0.65, alpha: 1))
    }

    private func restartGame() {
        removeAllChildren()
        ballCount = 1; level = 1
        ballsShot = 0; ballsHome = 0; hasFirstReturn = false
        setupWalls()
        setupHUD()
        firstReturnX = size.width / 2
        launchPos    = CGPoint(x: firstReturnX, y: floorY + ballR + 4)
        ballIndicator.position = launchPos
        spawnRow()
    }
}
