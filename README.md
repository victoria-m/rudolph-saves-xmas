# Final Project
## Summary
I changed the theme of this project, but it’s still a very similar game to the one I intended to make. In this game, Rudolph the Red-Nosed Reindeer needs to keep his schedule free so he can help Santa deliver presents on Christmas. This means he needs to avoid those pesky professors who are trying to give him more homework.

I learned a about SpriteKit game development while making this, but I also realized I may have been a bit overly-ambitious with my project proposal. So I ended up making a game with the following features:
	1. You can move Rudolph around by clicking on your desired location.
	2. You can make Rudolph shoot candy canes by clicking on the candy cane icon on the right of the screen
	3. A professor (wizard sprite) spawns on the opposite side of the screen (I began using the physics engine but I didn’t have enough time to fully figure it out so you can’t hit the professor with candy canes).
	4. You can go back and forth between the start and game screens by clicking the play and home buttons.
	5. Background music and projectile sound effects :D
	6. Walking animations

## How to Play
1. Press the play button
2. Move Rudolph around by tapping on your desired location
3. Shoot projectiles by tapping the candy cane icon

## Points
**Total points: 42**

I changed the way the points were allocated because after using SpriteKit I realized I wouldn’t be able to use the UIKit the way I had intended and a lot of the points required using UIKit (so I changed around some things).

* Network request/response - 3 pts
* GCD - 2 pts
* Threads - 2 pts
* Full Autolayout - 3 pts
* All available device support - 2 pts (iPhone only)
* Custom SpriteKit drawing - 18 pts (6 things: rudolph, projectiles, professor,
* home button, start game button, foreground, and background)
* UIController/SKScenes - 3 pts (GameViewController, GameScene, StartScene)
* Animations - 9 pts (rudolph walk, professor walk, throwing projectiles)

## Game Assets
All assets used were royalty-free.

* Christmas sprites and music
	* [Renne Cadeaux TUTO by Dev Du Dimanche](https://developpeusedudimanche.itch.io/renne-cadeau-tuto)
* Wizard sprite
	* [The “Fuck Wasting Art” Art Package by Andrew Connelly](https://cog_software.itch.io/fwa-artpackage)
* GUI
	* [Button Asset Pack by adwitr](https://adwitr.itch.io/button-asset-pack)

## References
* Walking animation
	* [Sprite Kit Animations and Texture Atlases in Swift](https://www.raywenderlich.com/89222/sprite-kit-animations-texture-atlases-swift)