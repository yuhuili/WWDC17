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

// http://stackoverflow.com/questions/8812192/how-to-set-font-size-to-fill-uilabel-height
class LabelWithAdaptiveTextHeight: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {
        
        var minFontSize: CGFloat = 18
        var maxFontSize: CGFloat = 60
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard (text?.characters.count)! > 0 else {
                break
            }
            
            if let labelText: String = text {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.size(
                    attributes: [NSFontAttributeName: font.withSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }
}
