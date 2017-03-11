import UIKit
import SpriteKit

public enum SPActionType {
    case swap
    case quickSwap
    case dim
    case resetAll
}

public struct SPAction {
    var type: SPActionType
    var index1: Int?
    var index2: Int?
    
    public init(type: SPActionType, index1: Int?, index2: Int?) {
        self.type = type
        self.index1 = index1
        self.index2 = index2
    }
}

public class SPArrangementController: NSObject {
    private let viewSize: CGSize // Arrangement view size
    private let viewOffset: CGPoint // Arrangement view offset from parent view
    private let itemSize: CGSize
    private let itemCount: Int
    private var halfItemWidth: CGFloat
    private var halfItemHeight: CGFloat
    private let interItemDistance: CGFloat // Distance between two items
    private let velocity: CGFloat // Velocity at which a card will move to a new position
    private let neighbourRearrangeDuration: TimeInterval
    
    public var cards = [Card]()
    
    public weak var viewController: SPViewController?
    
    // MARK: - Animations
    public var performSelectionSort: ((_ arrangementController: SPArrangementController) -> Void)?
    private var actions = [SPAction]()
    
    public func appendAction(_ action: SPAction) {
        actions.append(action)
    }
    
    public func appendAction(type: SPActionType, index1: Int?, index2: Int?) {
        let action = SPAction(type: type, index1: index1, index2: index2)
        actions.append(action)
    }
    
    public func executeActions() {
        if actions.isEmpty {
            if let viewController = viewController {
                viewController.enableBoard()
                viewController.enableButtons()
            }
            return
        }
        
        switch actions[0].type {
        case .swap:
            rearrange(index1: actions[0].index1!, index2: actions[0].index2!)
            
            break
        case .dim:
            cards[actions[0].index1!].alpha = 0.5
            break
        case .resetAll:
            resetCardsOpacity()
            break
        case .quickSwap:
            rearrange(index1: actions[0].index1!, index2: actions[0].index2!)
            actions.removeFirst()
            self.executeActions()
            return
        }
        
        actions.removeFirst()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.executeActions()
        }
    }
    
    // MARK: - Initializer
    
    /**
     Initialize an ArrangementController with properties
     
     - parameter viewSize: view in which arrangement will be displayed
     - parameter offsetFromSuperview: `view` offset from its superview
     - parameter itemSize: size of each item
     - parameter itemCount: number of expected items
     - parameter interItemDistance: margin between each item
     - parameter velocity: speed at which an item will be moved at during rearranging stage
     */
    
    public init(viewSize: CGSize, offsetFromSuperview viewOffset: CGPoint, itemSize: CGSize, itemCount: Int, interItemDistance: CGFloat, velocity: CGFloat) {
        self.viewSize = viewSize
        self.viewOffset = viewOffset
        self.itemSize = itemSize
        self.itemCount = itemCount
        self.halfItemWidth = itemSize.width / 2
        self.halfItemHeight = itemSize.height / 2
        self.interItemDistance = interItemDistance
        self.velocity = velocity
        self.neighbourRearrangeDuration = TimeInterval((itemSize.width + interItemDistance) / velocity)
        super.init()
    }
    
    // MARK: - Cards
    
    /**
     Add a new card to the existing group
     
     - parameter card: A Card object to be added
     
     - returns: The position at which the card should be placed in view
     */
    public func addCard(card: Card) -> CGPoint {
        var res = CGPoint(x: 0, y: 0)
        if cards.count == 0 {
            res = CGPoint.zero.withOffset(viewOffset)
        } else {
            res = CGPoint(x: CGFloat(cards.count) * CGFloat(itemSize.width + interItemDistance), y: 0).withOffset(viewOffset)
        }
        card.currentIndex = cards.count
        cards.append(card)
        return res
    }
    
    /**
     Remove all cards
     */
    public func removeAllCards() {
        cards.removeAll()
    }
    
    /**
     Reset the opacity of all cards to 1
     */
    public func resetCardsOpacity() {
        for n in cards.enumerated() {
            n.element.alpha = 1
        }
    }
    
    /**
     Update `card` zPosition to 1.0 and that of other cards to 0.0
     
     - parameter card: A card to be brought to front
     */
    public func moveCardToFront(card: Card) {
        card.zPosition = 1.0
        for n in cards.enumerated() {
            if (n.element !== card) {
                n.element.zPosition = 0.0
            }
        }
    }
    
    /**
     Rearrange `card` position if needed with animation
     
     - parameter card: A card to be checked and potentially rearranged
     */
    public func handleRearrange(card: Card) {
        // Allow +/-0.75 * width of movement freedom
        let currentIndexPosX = CGFloat(card.currentIndex) * (itemSize.width + interItemDistance) + viewOffset.x
        let xLowerBound: CGFloat = card.currentIndex == 0 ? -9999 : currentIndexPosX - 1.5 * halfItemWidth
        let xUpperBound: CGFloat = card.currentIndex == 5 ? 9999 : currentIndexPosX + 1.5 * halfItemWidth
        
        let index = card.currentIndex
        
        if (card.position.x < xLowerBound) {
            cards[index - 1].currentIndex += 1
            card.currentIndex -= 1
            swap(&cards[index], &cards[index-1])
            
            let moveRight = SKAction.moveBy(x: itemSize.width + interItemDistance, y: 0, duration: neighbourRearrangeDuration)
            cards[index].run(moveRight)
        } else if (card.position.x > xUpperBound) {
            cards[index + 1].currentIndex -= 1
            card.currentIndex += 1
            swap(&cards[index], &cards[index+1])
            
            let moveLeft = SKAction.moveBy(x: -(itemSize.width + interItemDistance), y: 0, duration: neighbourRearrangeDuration)
            cards[index].run(moveLeft)
        }
    }
    
    /**
     Rearrange cards at `index1` and `index2`
     
     - parameter card: A card to be checked and potentially rearranged
     */
    public func rearrange(index1: Int, index2: Int) {
        if index1 == index2 {
            return
        }
        
        let xPos1 = CGFloat(index1) * (itemSize.width + interItemDistance) + viewOffset.x
        let xPos2 = CGFloat(index2) * (itemSize.width + interItemDistance) + viewOffset.x
        
        cards[index1].run(SKAction.move(to: CGPoint(x: xPos2, y: viewOffset.y), duration: neighbourRearrangeDuration))
        cards[index2].run(SKAction.move(to: CGPoint(x: xPos1, y: viewOffset.y), duration: neighbourRearrangeDuration))
        
        cards[index1].currentIndex = index2
        cards[index2].currentIndex = index1
        swap(&cards[index1], &cards[index2])
    }
    
    public func quickRearrange(index1: Int, index2: Int) {
        if index1 == index2 {
            return
        }
        
        let xPos1 = CGFloat(index1) * (itemSize.width + interItemDistance) + viewOffset.x
        let xPos2 = CGFloat(index2) * (itemSize.width + interItemDistance) + viewOffset.x
        
        cards[index1].run(SKAction.move(to: CGPoint(x: xPos2, y: viewOffset.y), duration: 0))
        cards[index2].run(SKAction.move(to: CGPoint(x: xPos1, y: viewOffset.y), duration: 0))
        
        cards[index1].currentIndex = index2
        cards[index2].currentIndex = index1
        swap(&cards[index1], &cards[index2])
    }
    
    /**
     Move `card` to default position according to its index
     
     - parameter card: A card to be moved
     */
    public func placeToCurrentIndexPos(card: Card) {
        let currentIndexPosX  = card.currentIndex == 0 ? viewOffset.x : CGFloat(card.currentIndex) * (itemSize.width + interItemDistance) + viewOffset.x
        
        // Move item to position with calculated duration based on velocity, time = distance / speed
        card.run(SKAction.move(to: CGPoint(x: currentIndexPosX, y: viewOffset.y), duration: Double(abs(currentIndexPosX - card.position.x)) / Double(velocity)))
        card.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
    }
    
    
    /*
     public func performSort(_ type: SortingAlgo) {
     if type == .selectionSort {
     performSelectionSort()
     }
     }
     
     private func performSelectionSort() {
     performSelectionSort(startIndex: 0)
     }
     
     private func performSelectionSort(startIndex: Int) {
     if (startIndex >= cards.count) {
     for n in cards.enumerated() {
     n.element.alpha = 1
     }
     return
     }
     
     var smallestIndex = startIndex
     var smallestIndexWord = cards[startIndex].stringValue()
     if startIndex < cards.count - 1 {
     for i in startIndex+1..<cards.count {
     if cards[i].stringValue() < smallestIndexWord {
     smallestIndexWord = cards[i].stringValue()
     smallestIndex = i
     }
     }
     
     rearrange(index1: startIndex, index2: smallestIndex)
     
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
     self.performSelectionSort(startIndex: startIndex + 1)
     })
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
     self.cards[startIndex].alpha = 0.5
     })
     } else {
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
     self.performSelectionSort(startIndex: startIndex + 1)
     })
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
     self.cards[startIndex].alpha = 0.5
     })
     }
     }
     
     private func performBubbleSort() {
     performBubbleSort(index: 0, swapped: false)
     }
     
     private func performBubbleSort(index: Int, swapped: Bool) {
     if (index >= cards.count) {
     if swapped {
     
     } else {
     return
     }
     }
     }*/
}
