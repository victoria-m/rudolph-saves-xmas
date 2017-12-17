import SpriteKit
import GameplayKit

// references:
    // animation: https://www.raywenderlich.com/89222/sprite-kit-animations-texture-atlases-swift
// assets (royalty-free:
    // christmas sprites: https://developpeusedudimanche.itch.io/renne-cadeau-tuto
    // wizard sprite: https://cog_software.itch.io/fwa-artpackage
    // GUI: https://adwitr.itch.io/button-asset-pack

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
    var homeButton: SKSpriteNode!
    
    // win condition is to defeat 5 professors
    var professorSpawnCount = 0
    
    // label
    var hintLabel = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.isDynamic = true
        
        // initial setup
        setupBackgroundAndForeground()
        setupButtons()
        setupSound()
        setupLabels()
        setupCandyCaneProjectileButton()
        setupRudolph()
        
        // spawn professor and start rudolph walking animation
        spawnProfessor()
        walkingRudolph()
    }
    
    func setupButtons() {
        // get home button image using a url session
        let imageUrl = "https://i.imgur.com/vQTT7Ip.png"
        
        let url = URL(string: imageUrl)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                // initialize homebutton using the image
                let image = UIImage(data: data!)
                let texture = SKTexture(image: image!)
                self.homeButton = SKSpriteNode(texture: texture)
                
                // set up home button design
                self.homeButton.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.maxY - 40)
                self.homeButton.xScale = 0.09
                self.homeButton.yScale = 0.09
                self.homeButton.zPosition = 7
                self.homeButton.name = "home button"
                
                self.addChild(self.homeButton)
            }
        }).resume()
    }
    
    func setupLabels() {
        hintLabel.fontSize = 40
        hintLabel.fontColor = UIColor.white
        hintLabel.text = "hint: press the candy cane to shoot"
        hintLabel.position = CGPoint(x: frame.size.width / 2, y: frame.maxY - 100)
        hintLabel.zPosition = 20
        addChild(hintLabel)
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
        
        // set up Rudolph's position
        rudolph.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 60)
        rudolph.xScale = 1.5
        rudolph.yScale = 1.5
        rudolph.zPosition = 10
        
        // rudolph's physics
        rudolph.physicsBody = SKPhysicsBody(rectangleOf: rudolph.size)
        rudolph.physicsBody?.isDynamic = true
        rudolph.physicsBody?.affectedByGravity = false
        rudolph.physicsBody?.categoryBitMask = PhysicsCategory.rudolphCategory
        rudolph.physicsBody?.contactTestBitMask = PhysicsCategory.professorCategory
        rudolph.physicsBody?.collisionBitMask = PhysicsCategory.professorCategory
        
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
        
        // generate random x coordinate for spawning position
        let randomX = CGFloat(arc4random_uniform(500))
        
        // set up professor's position
        professor.position = CGPoint(x: self.frame.maxX - randomX, y: self.frame.minY + 60)
        professor.xScale = 2.3
        professor.yScale = 2.3
        professor.zPosition = 10
        
        professor.name = "professor"
        
        // set up professor's physics
        professor.physicsBody = SKPhysicsBody(rectangleOf: professor.size)
        professor.physicsBody?.isDynamic = true
        professor.physicsBody?.affectedByGravity = false
        professor.physicsBody?.categoryBitMask = PhysicsCategory.professorCategory
        professor.physicsBody?.contactTestBitMask = PhysicsCategory.rudolphCategory | PhysicsCategory.candyCaneProjectileCategory
        professor.physicsBody?.collisionBitMask = PhysicsCategory.rudolphCategory | PhysicsCategory.candyCaneProjectileCategory

        addChild(professor)
        
        walkingProfessor()
        
        // generate random speed duration
        let randomDuration = Double(arc4random_uniform(7) + 3)
        
        let moveAction = SKAction.moveTo(x: self.frame.minX - 50, duration: randomDuration)
        let doneAction = SKAction.run({ self.removeFromParent()})
        
        // combine move and done actions
        let moveActionWithDone = (SKAction.sequence([moveAction, doneAction]))
        
        professor.run(moveActionWithDone, withKey: "professor moved")
        professorSpawnCount += 1
    }
    
    // starts the professor's walk animation
    func walkingProfessor() {
        professor.run(SKAction.repeatForever(
            SKAction.animate(with: professorWalkingFrames,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                    withKey:"walkingInPlaceProfessor")
    }
    
    // starts Rudolph's walk animation
    func walkingRudolph() {
        rudolph.run(SKAction.repeatForever(
            SKAction.animate(with: rudolphWalkingFrames,
                                         timePerFrame: 0.2,
                                         resize: false,
                                         restore: true)),
                       withKey:"walkingInPlaceRudolph")
    }
    
    // once rudolph's done moving, remove his actions and start walking in place
    func rudolphMoveEnded() {
        rudolph.removeAllActions()
        walkingRudolph()
    }
    
    func shootCandyCaneProjectile() {
        let candyCaneProjectile = SKSpriteNode(imageNamed: "candy cane")
        candyCaneProjectile.name = "candy cane projectile"
        
        // starting position
        candyCaneProjectile.position = CGPoint(x: rudolph.position.x + 40, y: rudolph.position.y)
        candyCaneProjectile.zPosition = 10
        candyCaneProjectile.xScale = 1.5
        candyCaneProjectile.yScale = 1.5
        
        
        // set up candyCaneProjectile physics
        candyCaneProjectile.physicsBody = SKPhysicsBody(rectangleOf: candyCaneProjectile.size)
        candyCaneProjectile.physicsBody?.isDynamic = true
        candyCaneProjectile.physicsBody?.affectedByGravity = false
        candyCaneProjectile.physicsBody?.categoryBitMask = PhysicsCategory.candyCaneProjectileCategory
        candyCaneProjectile.physicsBody?.contactTestBitMask = PhysicsCategory.professorCategory | PhysicsCategory.candyCaneProjectileCategory
        candyCaneProjectile.physicsBody?.collisionBitMask = PhysicsCategory.professorCategory | PhysicsCategory.candyCaneProjectileCategory
        
        let moveAction = SKAction.moveTo(x: self.size.width + 50, duration: 1.0)
        let doneAction = SKAction.run({candyCaneProjectile.removeFromParent()})
        
        self.addChild(candyCaneProjectile)
        
        // combine move and done actions
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
        
        // Rudolph's movement:
        guard let touch = touches.first else { return }
        // allow rudolph to move left and right, but not up and down
        let location = CGPoint(x: touch.location(in: self).x, y: self.frame.minY + 60)
        
        var multiplierForDirection: CGFloat
        let rudolphVelocity = self.frame.size.width / 3.0
        
        let moveDifference = CGPoint(x: location.x - rudolph.position.x, y: location.y - rudolph.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        let moveDuration = distanceToMove / rudolphVelocity
        
        if moveDifference.x < 0 { multiplierForDirection = 1.0 }
        else { multiplierForDirection = -1.0 }
        
        // turn rudolph around depending on the direction he is headed
        rudolph.xScale = -1 * fabs(rudolph.xScale) * multiplierForDirection
        
        // stop moving to a new location if about to move again, but continue the walking animation
        if (rudolph.action(forKey: "rudolphMoving") != nil) { rudolph.removeAction(forKey: "rudolphMoving") }
        
        // if not walking, then start walking
        if (rudolph.action(forKey: "walkingInPlaceRudolph") == nil) { walkingRudolph() }
        
        let moveAction = SKAction.move(to: location, duration:(Double(moveDuration)))
        let doneAction = SKAction.run({ self.rudolphMoveEnded() })
        
        // combine move and done actions
        let moveActionWithDone = (SKAction.sequence([moveAction, doneAction]))
        rudolph.run(moveActionWithDone, withKey:"rudolphMoving")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // called before each frame is rendered
    }
    
    func gameOver() {
        if view != nil {
            if let scene = SKScene(fileNamed: "GameOverScene") {
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
    
    func win() {
        if view != nil {
            if let scene = SKScene(fileNamed: "WinScene") {
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

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // candy cane with professor collision
        if contact.bodyA.categoryBitMask == 0b1 && contact.bodyB.categoryBitMask == 0b10 || contact.bodyA.categoryBitMask == 0b10 && contact.bodyB.categoryBitMask == 0b1 {
            collisionBetween(projectile: (contact.bodyA.node)!, object: (contact.bodyB.node)!)
        }
        // professor and rudolph collision
        else if contact.bodyA.categoryBitMask == 0b10 && contact.bodyB.categoryBitMask == 0b11 || contact.bodyA.categoryBitMask == 0b11 && contact.bodyB.categoryBitMask == 0b10 {
            collisionBetween(projectile: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        
    }
    
    func collisionBetween(projectile: SKNode, object: SKNode) {
        if object.name == "rudolph" {
            destroy(object: object)
            gameOver()
        }
        else if projectile.name == "rudolph" {
            destroy(object: projectile)
            gameOver()
        }
        else if object.name == "professor" {
            destroy(object: object)
            destroy(object: projectile)
            if professorSpawnCount < 6 { spawnProfessor() }
            else { win() }
        } else if object.name == "candy cane projectile" {
            destroy(object: object)
            destroy(object: projectile)
            if professorSpawnCount < 6 { spawnProfessor() }
            else { win() }
        }
    }
    
    func destroy(object: SKNode) {
        object.removeAllActions()
        object.removeFromParent()
    }
}
