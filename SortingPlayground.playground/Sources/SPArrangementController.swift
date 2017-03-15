import UIKit
import SpriteKit

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
    public var performBubbleSort: ((_ arrangementController: SPArrangementController) -> Void)?
    public var performQuickSort: ((_ arrangementController: SPArrangementController) -> Void)?
    
    public var shuffle: ((_ count: Int) -> Void)?
    
    
    // MARK: - Animation Queue Handlers
    private var actions = [SPAction]()
    public var animationSpeed: Double = 0.7
    
    /**
     Add a new action to animation queue
     
     - parameter action: A `SPAction` to be queued
     */
    public func appendAction(_ action: SPAction) {
        actions.append(action)
    }
    
    /**
     Add a new action to animation queue
     
     - parameter type: A valid `SPActionType`
     - parameter index1: Primary index for the action
     - parameter index2: Secondary Index for the action
     */
    public func appendAction(type: SPActionType, index1: Int?, index2: Int?) {
        
        if (type == .swap) {
            let action = SPAction(type: .showSwapIndicators, index1: index1, index2: index2)
            actions.append(action)
        } else if (type == .showDoneIndicator) {
            let action = SPAction(type: .dim, index1: index1, index2: index2)
            actions.append(action)
        }
        
        let action = SPAction(type: type, index1: index1, index2: index2)
        actions.append(action)
        
        if (type == .swap) {
            let action = SPAction(type: .hideSwapIndicators, index1: index1, index2: index2)
            actions.append(action)
        }
    }
    
    /**
     Execute actions in animation queue with completion handler
     
     - parameter completion: code block to be executed upon completion of all items in animation queue
     */
    public func executeActions(_ completion: @escaping () -> Void) {
        if actions.isEmpty {
            completion()
            return
        }
        
        switch actions[0].type {
        case .swap:
            rearrange(index1: actions[0].index1!, index2: actions[0].index2!)
        case .dim:
            viewController?.labelText = String(format: "%@ is now at the correct position", cards[actions[0].index1!].stringValue())
            cards[actions[0].index1!].alpha = 0.5
        case .showDoneIndicator:
            cards[actions[0].index1!].showIndicatorWithColor(UIColor(red: 0, green: 200.0/255.0, blue: 0, alpha: 1))
        case .showSwapIndicators:
            viewController?.labelText = String(format: "Swapping %@ with %@", cards[actions[0].index1!].stringValue(), cards[actions[0].index2!].stringValue())
            cards[actions[0].index1!].showIndicatorWithColor(UIColor.red)
            cards[actions[0].index2!].showIndicatorWithColor(UIColor.red)
        case .hideSwapIndicators:
            cards[actions[0].index1!].hideIndicator()
            cards[actions[0].index2!].hideIndicator()
        case .showSelectionInterestIndicator:
            viewController?.labelText = String(format: "We are interested in %@", cards[actions[0].index1!].stringValue())
            cards[actions[0].index1!].showIndicatorWithColor(UIColor(red: 0, green: 141.0/255.0, blue: 249.0/255.0, alpha: 1))
        case .showPivotIndicator:
            viewController?.labelText = String(format: "Let %@ be the pivot", cards[actions[0].index1!].stringValue())
            cards[actions[0].index1!].showIndicatorWithColor(UIColor(red: 0, green: 141.0/255.0, blue: 249.0/255.0, alpha: 1))
            actions.removeFirst()
            
            // For longer delay
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2 * animationSpeed) {
                self.executeActions(completion)
            }
            return
        case .showCurrentIndicator:
            cards[actions[0].index1!].showIndicatorWithColor(UIColor.black)
        case .showCurrentIndicators:
            viewController?.labelText = String(format: "Checking %@ and %@", cards[actions[0].index1!].stringValue(), cards[actions[0].index2!].stringValue())
            cards[actions[0].index1!].showIndicatorWithColor(UIColor.black)
            cards[actions[0].index2!].showIndicatorWithColor(UIColor.black)
        case .hideIndicator:
            cards[actions[0].index1!].hideIndicator()
            actions.removeFirst()
            self.executeActions(completion)
            return
        case .hideIndicators:
            cards[actions[0].index1!].hideIndicator()
            cards[actions[0].index2!].hideIndicator()
            actions.removeFirst()
            self.executeActions(completion)
            return
        case .resetAll:
            viewController?.labelText = "Sorting completed!"
            resetCardsOpacity()
            resetCardsIndicator()
            break
        case .quickSwap:
            rearrange(index1: actions[0].index1!, index2: actions[0].index2!)
            actions.removeFirst()
            self.executeActions(completion)
            return
        }
        
        actions.removeFirst()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationSpeed) {
            self.executeActions(completion)
        }
    }
    
    /**
     Execute actions in animation queue
     */
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
        case .dim:
            cards[actions[0].index1!].alpha = 0.5
        case .showDoneIndicator:
            cards[actions[0].index1!].showIndicatorWithColor(UIColor(red: 0, green: 200.0/255.0, blue: 0, alpha: 1))
        case .showSwapIndicators:
            cards[actions[0].index1!].showIndicatorWithColor(UIColor.red)
            cards[actions[0].index2!].showIndicatorWithColor(UIColor.red)
        case .hideSwapIndicators:
            cards[actions[0].index1!].hideIndicator()
            cards[actions[0].index2!].hideIndicator()
        case .showSelectionInterestIndicator:
            viewController?.labelText = String(format: "We are interested in %@", cards[actions[0].index1!].stringValue())
            cards[actions[0].index1!].showIndicatorWithColor(UIColor(red: 0, green: 141.0/255.0, blue: 249.0/255.0, alpha: 1))
        case .showPivotIndicator:
            viewController?.labelText = String(format: "Let %@ be the pivot", cards[actions[0].index1!].stringValue())
            cards[actions[0].index1!].showIndicatorWithColor(UIColor(red: 0, green: 141.0/255.0, blue: 249.0/255.0, alpha: 1))
        case .showCurrentIndicator:
            cards[actions[0].index1!].showIndicatorWithColor(UIColor.black)
        case .showCurrentIndicators:
            cards[actions[0].index1!].showIndicatorWithColor(UIColor.black)
            cards[actions[0].index2!].showIndicatorWithColor(UIColor.black)
        case .hideIndicator:
            cards[actions[0].index1!].hideIndicator()
            actions.removeFirst()
            self.executeActions()
            return
        case .hideIndicators:
            cards[actions[0].index1!].hideIndicator()
            cards[actions[0].index2!].hideIndicator()
            actions.removeFirst()
            self.executeActions()
            return
        case .resetAll:
            viewController?.labelText = "Sorting completed!"
            resetCardsOpacity()
            resetCardsIndicator()
            break
        case .quickSwap:
            rearrange(index1: actions[0].index1!, index2: actions[0].index2!)
            actions.removeFirst()
            self.executeActions()
            return
        }
        
        actions.removeFirst()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationSpeed) {
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
     Hide all indicators
     */
    public func resetCardsIndicator() {
        for n in cards.enumerated() {
            n.element.hideIndicator()
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
}
