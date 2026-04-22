import SpriteKit

final class BrickNode: SKNode {
    private(set) var hp: Int
    var gridRow: Int = 0
    private let background: SKShapeNode
    private let label: SKLabelNode

    init(hp: Int, width: CGFloat, height: CGFloat) {
        self.hp = hp
        background = SKShapeNode(rectOf: CGSize(width: width - 2, height: height - 2), cornerRadius: 6)
        label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        super.init()

        background.fillColor = BrickNode.color(for: hp)
        background.strokeColor = SKColor(white: 1, alpha: 0.15)
        background.lineWidth = 1
        addChild(background)

        label.text = "\(hp)"
        label.fontSize = BrickNode.fontSize(for: hp)
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        addChild(label)
    }

    required init?(coder: NSCoder) { fatalError() }

    /// Decrements HP. Returns true if the brick should be destroyed.
    @discardableResult
    func hit() -> Bool {
        hp -= 1
        guard hp > 0 else { return true }
        label.text = "\(hp)"
        label.fontSize = BrickNode.fontSize(for: hp)
        let newColor = BrickNode.color(for: hp)
        background.fillColor = .white
        background.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.06),
            SKAction.run { [weak self] in self?.background.fillColor = newColor }
        ]))
        return false
    }

    private static func fontSize(for hp: Int) -> CGFloat {
        if hp < 10  { return 18 }
        if hp < 100 { return 15 }
        return 11
    }

    private static func color(for hp: Int) -> SKColor {
        let ratio = min(CGFloat(hp) / 25.0, 1.0)
        switch ratio {
        case ..<0.34: return SKColor(red: 0.18, green: 0.72, blue: 0.32, alpha: 1)
        case ..<0.67: return SKColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1)
        default:      return SKColor(red: 0.90, green: 0.22, blue: 0.22, alpha: 1)
        }
    }
}
