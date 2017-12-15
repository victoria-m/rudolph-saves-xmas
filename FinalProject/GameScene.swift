import SpriteKit
import GameplayKit

// reference: https://www.raywenderlich.com/89222/sprite-kit-animations-texture-atlases-swift

class GameScene: SKScene {
    
    var rudolph: SKSpriteNode!
    var rudolphWalkingFrames: [SKTexture]!
    var background = SKSpriteNode(imageNamed: "background")
    var foreground = SKSpriteNode(imageNamed: "foreground")
    
    override func didMove(to view: SKView) {
        // center the background and add it to the scene
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        addChild(background)
        
        // set the foreground's position to the bottom of the screen and add it to the scene
        foreground.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        foreground.size.width = self.size.width
        addChild(foreground)

        // set up the rudolph walking frames
        let rudolphAnimatedAtlas = SKTextureAtlas(named: "rudolph")
        var walkFrames = [SKTexture]()
        
        let numImages = rudolphAnimatedAtlas.textureNames.count
        
        // add each image from the rudolph atlas folder to the walkframes array
        for index in 1 ... numImages {
            let rudolphTextureName = "rudolph\(index)"
            walkFrames.append(rudolphAnimatedAtlas.textureNamed(rudolphTextureName))
        }
        
        rudolphWalkingFrames = walkFrames
        
        // get the first walking frame and position it in the center of the screen
        let firstFrame = rudolphWalkingFrames[0]
        rudolph = SKSpriteNode(texture: firstFrame)
        
        rudolph.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        rudolph.xScale = 2
        rudolph.yScale = 2
        addChild(rudolph)
        
        walkingRudolph()
    }
    
    func walkingRudolph() {
        // this is the walk action method for the rudolph sprite
        rudolph.run(SKAction.repeatForever(
            SKAction.animate(with: rudolphWalkingFrames,
                                         timePerFrame: 0.2,
                                         resize: false,
                                         restore: true)),
                       withKey:"walkingInPlaceRudolph")
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func rudolphMoveEnded() {
        rudolph.removeAllActions()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        let touch = touches.first as! UITouch
        let location = touch.location(in: self)
        var multiplierForDirection: CGFloat
        
        // 2
        let rudolphVelocity = self.frame.size.width / 3.0
        
        // 3
        let moveDifference = CGPoint(x: location.x - rudolph.position.x, y: location.y - rudolph.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        // 4
        let moveDuration = distanceToMove / rudolphVelocity
        
        // 5
        if moveDifference.x < 0 { multiplierForDirection = 1.0 }
        else { multiplierForDirection = -1.0 }
        
        rudolph.xScale = -1 * fabs(rudolph.xScale) * multiplierForDirection
        
        // 1
        if (rudolph.action(forKey: "rudolphMoving") != nil) {
            //stop just the moving to a new location, but leave the walking legs movement running
            rudolph.removeAction(forKey: "rudolphMoving")
        }
        
        // 2
        if (rudolph.action(forKey: "walkingInPlaceRudolph") == nil) {
            //if legs are not moving go ahead and start them
            walkingRudolph()
        }
        
        // 3
        let moveAction = (SKAction.move(to: location, duration:(Double(moveDuration))))
        
        // 4
        let doneAction = (SKAction.run({
            print("Animation Completed")
            self.rudolphMoveEnded()
        }))
        
        // 5
        let moveActionWithDone = (SKAction.sequence([moveAction, doneAction]))
        rudolph.run(moveActionWithDone, withKey:"rudolphMoving")
    }

//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
