# BallzGame

A BALLZ-inspired brick-breaker game for iPhone, built with Swift + SpriteKit.

## Gameplay
- Drag to aim, release to fire your balls
- Numbered bricks show how many hits they need before breaking
- Green circles are power-ups — collect them to add an extra ball
- Balls collect at the spot the first one lands, shifting your launch position
- **Game over** when any row of bricks reaches the bottom

## How to run in Xcode

1. Open Xcode → File → New → Project → **iOS App**
2. Set Interface: **SwiftUI**, Language: **Swift**
3. Delete the auto-generated `ContentView.swift`
4. Drag all four `.swift` files from this folder into the project navigator
5. In the project target, add the **SpriteKit** framework under *Frameworks, Libraries, and Embedded Content*
6. Set deployment target to **iOS 16+**
7. Run on a simulator or your iPhone

## Files

| File | Purpose |
|------|---------|
| `BallzApp.swift` | App entry point |
| `ContentView.swift` | SwiftUI wrapper hosting the SpriteKit view |
| `GameScene.swift` | All game logic — physics, input, spawning, scoring |
| `BrickNode.swift` | Custom `SKNode` subclass for bricks with HP and color |
