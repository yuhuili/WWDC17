import Foundation
import SpriteKit

public class Card: SKSpriteNode {
    
    public var cardValue: Any?
    public var cardImageSpriteNode: SKSpriteNode?
    public var cardLabelSpriteNode: SKLabelNode?
    public var currentIndex: Int = -1
    
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
            self.addChild(cardLabelSpriteNode)
        }
        
        self.size = CardSize
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
