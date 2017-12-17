import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // load the SKScene from 'StartScene.sks'
            if let scene = SKScene(fileNamed: "StartScene") {
                // set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // present the scene
                view.presentScene(scene)
            }
                        
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
//            view.showsPhysics = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var shouldAutorotate: Bool {
        return true
    }
}
