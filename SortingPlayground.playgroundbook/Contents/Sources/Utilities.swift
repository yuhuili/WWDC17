import UIKit
import PlaygroundSupport

// MARK: - Playground Elements Layout
public let SPBoardSize = CGSize(width: 1080, height: 320)
public let SPArrangementAreaSizeSecondary = CGSize(width: 1000, height: 300)

public enum SortingAlgo {
    case bubbleSort
    case selectionSort
    case quickSort
}

public let SPCardImageSize = CGSize(width: 120, height: 120)
public let SPCardImageOffset = CGPoint(x: 0, y: 20)
public let SPCardLabelOffset = CGPoint(x: 0, y: -80)
public let SPCardSize = CGSize(width: 150, height: 200)
public let SPCardInterItemDistance: CGFloat = 20
public let SPCardVelocity: CGFloat = 425

public let NormalColorOnWood = UIColor(red: 133.0/255, green: 88.0/255, blue: 10.0/255, alpha: 1)
public let DisabledColorOnWood = UIColor(red: 181.0/255, green: 131.0/255, blue: 47.0/255, alpha: 1)

public let SkyGradient = [UIColor(red: 31.0/255.0, green: 182.0/255.0, blue: 246.0/255.0, alpha: 1).cgColor, UIColor(red: 153.0/255.0, green: 224.0/255.0, blue: 254.0/255.0, alpha: 1).cgColor]


// MARK: - SPAction
public enum SPActionType: UInt8 {
    case swap
    case quickSwap
    case dim
    case showDoneIndicator
    case showSwapIndicators
    case hideSwapIndicators
    case showSelectionInterestIndicator
    case showPivotIndicator
    case showCurrentIndicator
    case showCurrentIndicators
    case showLookLeft
    case showLookRight
    case hideIndicator
    case hideIndicators
    case resetAll
    case terminate
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

// MARK: - Initial setup for Contents.swift
public func _internalSetup() {
    srand48(Int(Date().timeIntervalSince1970))
    _loadFonts()
}

// MARK: - Custom Font Loader
private func _loadFonts() {
    let bubbleFontURL = Bundle.main.url(forResource: "akaDylan Collage", withExtension: "otf")
    CTFontManagerRegisterFontsForURL(NSURL.init(string: "", relativeTo: bubbleFontURL)!, CTFontManagerScope.process, nil)
    let bubbleFontURL2 = Bundle.main.url(forResource: "akaDylan Plain", withExtension: "ttf")
    CTFontManagerRegisterFontsForURL(NSURL.init(string: "", relativeTo: bubbleFontURL2)!, CTFontManagerScope.process, nil)
    let bubbleFontURL3 = Bundle.main.url(forResource: "KGSweetNSassy", withExtension: "ttf")
    CTFontManagerRegisterFontsForURL(NSURL.init(string: "", relativeTo: bubbleFontURL3)!, CTFontManagerScope.process, nil)
}

public func degToRad(degree: Double) -> CGFloat {
    return CGFloat(degree / 180.0) * (CGFloat.pi)
}

// MARK: - Various Extensions
// http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension MutableCollection where Indices.Iterator.Element == Index {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension CGPoint {
    func withOffset(_ offset: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + offset.x, y: self.y + offset.y)
    }
}

extension UIButton {
    static func createSPButton() -> UIButton {
        let button = UIButton(type: UIButtonType.system)
        button.setBackgroundImage(UIImage(named: "purty_wood"), for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(NormalColorOnWood , for: .normal)
        return button
    }
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
