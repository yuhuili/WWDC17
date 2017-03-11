import UIKit
import PlaygroundSupport

public let SceneSize = CGSize(width: 1080, height: 320)
public let ArrangementAreaSize = CGSize(width: 1000, height: 300)

public enum SortingAlgo {
    case bubbleSort
    case selectionSort
    case quickSort
}

public let CardImageSize = CGSize(width: 120, height: 120)
public let CardImageOffset = CGPoint(x: 0, y: 20)
public let CardLabelOffset = CGPoint(x: 0, y: -80)
public let CardSize = CGSize(width: 150, height: 200)

public let NormalColorOnWood = UIColor(red: 133.0/255, green: 88.0/255, blue: 10.0/255, alpha: 1)
public let DisabledColorOnWood = UIColor(red: 181.0/255, green: 131.0/255, blue: 47.0/255, alpha: 1)

public let SkyGradient = [UIColor(red: 31.0/255.0, green: 182.0/255.0, blue: 246.0/255.0, alpha: 1).cgColor, UIColor(red: 153.0/255.0, green: 224.0/255.0, blue: 254.0/255.0, alpha: 1).cgColor]

extension CGPoint {
    func withOffset(_ offset: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + offset.x, y: self.y + offset.y)
    }
}

public func _internalSetup() {
    _loadFonts()
}

private func _loadFonts() {
    // Load custom fonts
    let bubbleFontURL = Bundle.main.url(forResource: "akaDylan Collage", withExtension: "otf")
    CTFontManagerRegisterFontsForURL(NSURL.init(string: "", relativeTo: bubbleFontURL)!, CTFontManagerScope.process, nil)
    let bubbleFontURL2 = Bundle.main.url(forResource: "akaDylan Plain", withExtension: "ttf")
    CTFontManagerRegisterFontsForURL(NSURL.init(string: "", relativeTo: bubbleFontURL2)!, CTFontManagerScope.process, nil)
    let bubbleFontURL3 = Bundle.main.url(forResource: "KGSweetNSassy", withExtension: "ttf")
    CTFontManagerRegisterFontsForURL(NSURL.init(string: "", relativeTo: bubbleFontURL3)!, CTFontManagerScope.process, nil)
}

// http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
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
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
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
