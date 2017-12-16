import SpriteKit
import GameplayKit

// reference: https://www.raywenderlich.com/89222/sprite-kit-animations-texture-atlases-swift
// assets (royalty-free:
    // game sprites: https://developpeusedudimanche.itch.io/renne-cadeau-tuto
    // GUI: https://legacyretroapp.itch.io/2d-gui-asset-legacyretro

class GameScene: SKScene {
    
    // player sprite
    var rudolph: SKSpriteNode!
    var rudolphWalkingFrames: [SKTexture]!
    
    // enemy sprite
    var professor: SKSpriteNode!
    var professorWalkingFrames: [SKTexture]!
    
    // projectile button sprite
    var candyCaneProjectileButton = SKSpriteNode(imageNamed: "candy cane")
    var candyCaneProjectile = SKSpriteNode(imageNamed: "candy cane")
    
    // background and foreground
    var background = SKSpriteNode(imageNamed: "background")
    var foreground = SKSpriteNode(imageNamed: "foreground")
    
    // music and sound effects
    var backgroundMusic = SKAudioNode(fileNamed: "background music.wav")
    var shootSoundEffect = SKAudioNode(fileNamed: "shoot.wav")
    
    // button
    var homeButton = SKSpriteNode(imageNamed: "home button")

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.isDynamic = true
        
        // initial setup
        setupBackgroundAndForeground()
        setupButtons()
        setupSound()
        setupCandyCaneProjectileButton()
        setupRudolph()
        
        // spawn professor and start walking animations
        spawnProfessor()
        walkingRudolph()
    }
    
    func setupButtons() {
        homeButton.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.maxY - 40)
        homeButton.xScale = 0.09
        homeButton.yScale = 0.09
        homeButton.zPosition = 7
        homeButton.name = "home button"
        addChild(homeButton)
    }
    
    func setupSound() {
        // configure sound effect
        shootSoundEffect.autoplayLooped = false
        
        // add the music
        addChild(backgroundMusic)
        addChild(shootSoundEffect)
    }
    
    func setupBackgroundAndForeground() {
        // center the background and add it to the scene
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.zPosition = 0
        addChild(background)
        
        // set the foreground's position to the bottom of the screen and add it to the scene
        foreground.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 65)
        print(foreground.position)
        foreground.size.width = self.size.width
        foreground.zPosition = 7
        addChild(foreground)
    }
    
    func setupRudolph() {
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
        
        rudolph.name = "rudolph"
        
        rudolph.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 60)
        rudolph.xScale = 1.5
        rudolph.yScale = 1.5
        rudolph.zPosition = 10
        addChild(rudolph)
    }
    
    func setupCandyCaneProjectileButton() {
        // set up candyCaneProjectile button design
        candyCaneProjectileButton.position = CGPoint(x: self.frame.maxX - 90, y: self.frame.minY + 150)
        candyCaneProjectileButton.xScale = 2
        candyCaneProjectileButton.yScale = 2
        candyCaneProjectileButton.zPosition = 7
        candyCaneProjectileButton.name = "projectile button"
        addChild(candyCaneProjectileButton)
    }
    
    func spawnProfessor() {
        // set up the professor walking frames
        let professorAnimatedAtlas = SKTextureAtlas(named: "professor")
        var profWalkFrames = [SKTexture]()
        
        let numProfImages = professorAnimatedAtlas.textureNames.count
        
        // add each image from the rudolph atlas folder to the walkframes array
        for index in 1 ... numProfImages {
            let profTextureName = "professor\(index)"
            profWalkFrames.append(professorAnimatedAtlas.textureNamed(profTextureName))
        }
        
        professorWalkingFrames = profWalkFrames
        
        // get the first walking frame and position it in the center of the screen
        let firstProfFrame = professorWalkingFrames[0]
        professor = SKSpriteNode(texture: firstProfFrame)
        
        // set up professor's position
        professor.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 60)
        professor.xScale = 2.3
        professor.yScale = 2.3
        professor.zPosition = 10
        
        professor.name = "professor"
        
        // set up professor's physics
        professor.physicsBody = SKPhysicsBody(rectangleOf: professor.size)
        professor.physicsBody?.isDynamic = true
        professor.physicsBody?.affectedByGravity = false

        addChild(professor)
        
        walkingProfessor()
        
        // 3
        let moveAction = SKAction.moveTo(x: self.frame.minX - 50, duration: 6.0)
        
        // 4
        let doneAction = (SKAction.run({
            self.removeFromParent()
        }))
        
        // 5
        let moveActionWithDone = (SKAction.sequence([moveAction, doneAction]))
        
        professor.run(moveActionWithDone, withKey: "professor moved")
    }
    
    func walkingProfessor() {
        // this is the walk action method for the professor sprite
        professor.run(SKAction.repeatForever(
            SKAction.animate(with: professorWalkingFrames,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                    withKey:"walkingInPlaceProfessor")
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
    
    func rudolphMoveEnded() {
        rudolph.removeAllActions()
        walkingRudolph()
    }
    
    func shootCandyCaneProjectile() {
        let candyCaneProjectile = SKSpriteNode(imageNamed: "candy cane")
        candyCaneProjectile.name = "candy cane projectile"
        
        // starting position
        candyCaneProjectile.position = CGPoint(x: rudolph.position.x + 40, y: rudolph.position.y)
        candyCaneProjectile.zPosition = 9
        
        
        // set up candyCaneProjectile physics
        candyCaneProjectile.physicsBody = SKPhysicsBody(rectangleOf: candyCaneProjectile.size)
        candyCaneProjectile.physicsBody?.isDynamic = true
        candyCaneProjectile.physicsBody?.affectedByGravity = false
        
        // 3
        let moveAction = SKAction.moveTo(x: self.size.width + 50, duration: 1.0)

        // 4
        let doneAction = (SKAction.run({
            candyCaneProjectile.removeFromParent()
        }))
        
        self.addChild(candyCaneProjectile)
        
        // 5
        let moveActionWithDone = (SKAction.sequence([moveAction, doneAction]))
        
        shootSoundEffect.run(SKAction.play())
        candyCaneProjectile.run(moveActionWithDone, withKey: "shot candy cane projectile")
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            
            // check if the projectile button was touched
            if touchNode.name == "projectile button" {
                shootCandyCaneProjectile()
                return
            }
            // present home screen if home button was touched
            else if touchNode.name == "home button" {
                print("tapped home")
                if view != nil {
                    if let scene = SKScene(fileNamed: "StartScene") {
                        // set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // present the scene
                        let transition:SKTransition = SKTransition.doorsCloseVertical(withDuration: 2)
                        self.view?.presentScene(scene, transition: transition)
                    }

                    view?.ignoresSiblingOrder = true
                    view?.showsFPS = false
                    view?.showsNodeCount = false
                }
            }
        }
        
        // Rudolph movement:
        
        // 1
        let touch = touches.first as! UITouch
        // allow rudolph to move left and right, but not up and down
        let location = CGPoint(x: touch.location(in: self).x, y: self.frame.minY + 60)
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
        
        // turn rudolph around depending on the direction he is headed
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("did begin")
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyA.node?.name == "candy cane projectile" {
            collisionBetween(projectile: nodeA, object: nodeB)
        }
    }
    
    func collisionBetween(projectile: SKNode, object: SKNode) {
        print("there was a collision")
        
        if object.name == "professor" {
            print("collision between prof and projectile")
            destroy(object: object)
            destroy(object: projectile)
        }
    }
    
    func destroy(object: SKNode) {
        object.removeAllActions()
        object.removeFromParent()
    }
}
