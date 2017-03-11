import UIKit
import SpriteKit

public class SPCloudScene: SKScene {
    private var cloudNode: SKSpriteNode
    private var timer: Timer?
    public var minimumY: CGFloat?
    override public init() {
        print("init")
        cloudNode = SKSpriteNode(imageNamed: "cloud")
        super.init()
    }
    
    override public init(size viewSize: CGSize) {
        print("size")
        cloudNode = SKSpriteNode(imageNamed: "cloud")
        super.init(size: viewSize)
        self.backgroundColor = UIColor.clear
        setupCloud()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        print("coder")
        cloudNode = SKSpriteNode(imageNamed: "cloud")
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        setupCloud()
    }
    
    private func setupCloud() {
        self.addChild(cloudNode)
        
        let height: CGFloat = min(100.0, self.size.height/3)
        let width: CGFloat = height/250 * 460
        
        cloudNode.size = CGSize(width: width, height: height)
        cloudNode.position = CGPoint(x: -1000, y: -1000)
        restartTimer()
    }
    
    override public func didMove(to view: SKView) {
        self.size = view.frame.size
        print(self.size.width)
        print(self.size.height)
        restartTimer()
    }
    
    public func restartTimer() {
        let height: CGFloat = min(100.0, self.size.height/3) * CGFloat((drand48() / 3.0 + 0.66))
        
        let width: CGFloat = height/250 * 460
        
        cloudNode.size = CGSize(width: width, height: height)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
            
            var y = self.size.height / 4 + CGFloat(arc4random_uniform(UInt32(self.size.height/2)))
                
            if let minimumY = self.minimumY {
                y = max(minimumY, y)
            }
            
            self.cloudNode.position = CGPoint(x: self.size.width + width, y: y)
            self.cloudNode.run(SKAction.moveBy(x: -(self.size.width + 600), y: CGFloat(arc4random_uniform(80))-40, duration: 9.5))
        })
    }
}
