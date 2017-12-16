import SpriteKit

class StartScene: SKScene {

    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let playButton = childNode(withName: "play button")
        
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            // start game if play button is pressed
            if node == playButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsOpenVertical(withDuration: 1.5)
                    let scene:SKScene = GameScene(size: self.size)
                    scene.scaleMode = .resizeFill
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
