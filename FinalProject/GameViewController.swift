import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'StartScene.sks'
            if let scene = SKScene(fileNamed: "StartScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
                        
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        
//        let scene = GameScene(size: view.bounds.size)
//        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = false
//        scene.scaleMode = .resizeFill
//        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
}
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}

