import Foundation
import SpriteKit

public class Card: SKSpriteNode {
    
    public var cardValue: Any?
    public var cardImageSpriteNode: SKSpriteNode?
    public var cardLabelSpriteNode: SKLabelNode?
    public var currentIndex: Int = -1
    private var indicatorNode: SKShapeNode?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    public init(cardImage imageName: String, cardValue: Any?) {
        self.cardValue = cardValue
        let woodTexture = SKTexture(imageNamed: "card")
        let imageTexture = SKTexture(imageNamed: imageName)
        super.init(texture: woodTexture, color: UIColor.white, size: woodTexture.size())
        cardImageSpriteNode = SKSpriteNode(texture: imageTexture, size: imageTexture.size())
        if let cardImageSpriteNode = cardImageSpriteNode {
            cardImageSpriteNode.size = CardImageSize
            cardImageSpriteNode.position = CardImageOffset
            self.addChild(cardImageSpriteNode)
        }
        
        cardLabelSpriteNode = SKLabelNode(text: self.stringValue())
        if let cardLabelSpriteNode = cardLabelSpriteNode {
            cardLabelSpriteNode.position = CardLabelOffset
            cardLabelSpriteNode.fontColor = UIColor.black
            cardLabelSpriteNode.fontName = "HelveticaNeue-Thin"
            self.addChild(cardLabelSpriteNode)
        }
        
        self.size = CardSize
        
        let path = CGPath.init(roundedRect: CGRect(x: 0, y: 0, width: self.size.width * 0.95, height: self.size.height * 0.95), cornerWidth: 20, cornerHeight: 20, transform: nil)
        indicatorNode = SKShapeNode(path: path, centered: true)
        if let indicatorNode = indicatorNode {
            indicatorNode.isHidden = true
            indicatorNode.fillColor = UIColor.clear
            indicatorNode.strokeColor = UIColor.red
            indicatorNode.lineWidth = 3
            self.addChild(indicatorNode)
        }
    }
    
    public func showIndicatorWithColor(_ color: UIColor) {
        indicatorNode?.isHidden = false
        indicatorNode?.strokeColor = color
    }
    
    public func hideIndicator() {
        indicatorNode?.isHidden = true
    }
    
    public func stringValue() -> String{
        if let cardValue = cardValue as? String {
            return cardValue
        } else if let cardValue = cardValue as? Int {
            return String(format: "%i", cardValue)
        } else  {
            return ""
        }
    }
    
}
