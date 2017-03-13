import UIKit
import SpriteKit

class SPBoard: SKScene {
    private let dummyNode: SKSpriteNode // selectedNode when there is no real selection
    public var selectedNode: SKSpriteNode // Currently selected node
    private var labelNode: SKLabelNode
    public var labelText: String? {
        didSet {
            labelNode.text = labelText
        }
    }
    
    private let kCardName = "movable" // Identifier for cards
    private let restrictCardYMax: CGFloat = 180 // Restrict max y at which a card can be dragged
    private let restrictCardYMin: CGFloat = 100 // Restrict min y at which a card can be dragged
    
    public var isUserTouchEnabled: Bool {
        didSet {
            if isUserTouchEnabled == false {
                if let selectedNode = selectedNode as? Card {
                    arrangementController.placeToCurrentIndexPos(card: selectedNode)
                    self.selectedNode = dummyNode
                }
            }
        }
    }
    
    private let arrangementController: SPArrangementController
    
    public init(arrangementController: SPArrangementController, viewSize: CGSize) {
        self.dummyNode = SKSpriteNode()
        self.selectedNode = dummyNode
        self.arrangementController = arrangementController
        self.isUserTouchEnabled = true
        self.labelNode = SKLabelNode()
        super.init(size: viewSize)
        self.backgroundColor = UIColor.clear
        
        setupLabelNode()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.dummyNode = SKSpriteNode()
        self.selectedNode = dummyNode
        self.arrangementController = SPArrangementController(viewSize: CGSize.zero, offsetFromSuperview: CGPoint.zero, itemSize: CGSize.zero, itemCount: 0, interItemDistance: 0, velocity: 1)
        self.isUserTouchEnabled = true
        self.labelNode = SKLabelNode()
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        setupLabelNode()
    }
    
    private func setupLabelNode() {
        self.labelNode.fontColor = UIColor.white
        self.labelNode.position = CGPoint(x: self.size.width / 2, y: self.size.height - 30)
        self.labelNode.fontName = "HelveticaNeue-Medium"
        self.addChild(self.labelNode)
    }
    
    private func addAnimalCard () {
        arrangementController.removeAllCards()
        let animals = ["squirrel","pig","penguin","panda","dog","cat"].shuffled()
        
        for item in animals {
            let card = Card.init(cardImage: item, cardValue: item)
            card.position = arrangementController.addCard(card: card)
            
            self.addChild(card)
        }
    }
    
    override public func didMove(to view: SKView) {
        // Backboard
        let backboardTexture = SKTexture(imageNamed: "backboard")
        let backboard = SKSpriteNode.init(texture: backboardTexture)
        backboard.size = CGSize(width: self.size.width - 40, height: CardSize.height + 40)
        backboard.position = CGPoint(x: self.size.width / 2, y: CardSize.height / 2 + 40)
        self.addChild(backboard)
        
        // Cards
        addAnimalCard()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        
        selectNodeForTouch(positionInScene)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        performTranslation(translation)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode.removeAllActions()
        if let selectedNode = selectedNode as? Card {
            arrangementController.placeToCurrentIndexPos(card: selectedNode)
        }
        selectedNode = dummyNode
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode.removeAllActions()
        if let selectedNode = selectedNode as? Card {
            arrangementController.placeToCurrentIndexPos(card: selectedNode)
        }
        selectedNode = dummyNode
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0) * (CGFloat.pi)
    }
    
    func selectNodeForTouch(_ touchLocation: CGPoint) {
        if !isUserTouchEnabled {
            return
        }
        
        let touchedNodes = self.nodes(at: touchLocation)
        
        var touchedNode: SKSpriteNode? = nil
        
        for n in touchedNodes.enumerated() {
            if let elem = n.element as? Card {
                touchedNode = elem
                break
            }
        }
        
        if let touchedNode = touchedNode {
            if !selectedNode.isEqual(to: touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
                
                selectedNode = touchedNode
                
                if let selectedNode = selectedNode as? Card {
                    arrangementController.moveCardToFront(card: selectedNode)
                }
                
                let dur = 0.1
                
                let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -4), duration: dur), SKAction.rotate(byAngle: degToRad(degree: 0), duration: dur), SKAction.rotate(byAngle: degToRad(degree: 4), duration: dur)])
                selectedNode.run(SKAction.repeatForever(sequence))
            }
        } else {
            selectedNode = dummyNode
        }
        
    }
    
    func performTranslation(_ translation: CGPoint) {
        
        if let selectedNode = selectedNode as? Card {
            let position = selectedNode.position
            selectedNode.position = CGPoint(x: position.x + translation.x, y: max(restrictCardYMin, min(restrictCardYMax, position.y + translation.y)))
            arrangementController.handleRearrange(card: selectedNode)
        }
        
        
    }
    
}

