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
    let viewController = SPViewController()
    PlaygroundPage.current.liveView = viewController
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
