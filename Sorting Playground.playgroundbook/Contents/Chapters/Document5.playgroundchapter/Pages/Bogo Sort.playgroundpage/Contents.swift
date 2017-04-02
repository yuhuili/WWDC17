//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, visualSwap(index1:index2:), rand(low:high:), rearrange(index1:index2:), verifyBogo())
//#-code-completion(identifier, show, count, i, r)
//#-code-completion(keyword, show, for, if, let, var)
import UIKit
import PlaygroundSupport
import AVFoundation

_internalSetup()

let viewController = SPViewController(showBubble: false, showSelection: false, showQuick: false, showBogo: true)
PlaygroundPage.current.liveView = viewController

func playShuffleSound() {
    viewController.playShuffle()
}

var names = [String]()

// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func rearrange(index1: Int, index2: Int) {
    viewController.arrangementController?.rearrange(index1: index1, index2: index2)
}

func rand(low: Int, high: Int) -> Int {
    return Int(arc4random_uniform(UInt32(high-low))) + low
}

func shuffle(_ count: Int) {
    // Each time we swap current index i with a random index j such that i <= j < number of elements
    //#-editable-code
    for i in 0..<count-1 {
        // rand takes low and high inclusive
        let r = rand(low: i, high: count)
        // Use rearrange to update the graphics
        rearrange(index1: i, index2: r)
    }
    //#-end-editable-code
    playShuffleSound()
}

//#-end-hidden-code
//#-hidden-code
// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func performBogoSort(_ arrangementController: SPArrangementController) {
    viewController.labelText = "Performing Bogo Sort"
    performBogo(viewController.arrangementController!.cards.count)
}

func verifyBogo() {
    if viewController.shouldTerminate {
        return
    }
    
    for i in 1..<viewController.arrangementController!.cards.count {
        if viewController.arrangementController!.cards[i-1].stringValue() > viewController.arrangementController!.cards[i].stringValue() {
            // Out of order
            viewController.labelText = "Not in order, reshuffle..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                performBogo(viewController.arrangementController!.cards.count)
            })
            return
        }
    }
    viewController.labelText = "Bogo succeeded!"
    viewController.enableButtons()
    viewController.enableBoard()
}
//#-end-hidden-code
/*:
 ## Bogo Sort
 
 This one is interesting, we reshuffle again and again until the cards are in order.
 
 Average runtime: [O(n * n!)](glossary://bogo%20runtime)
 
* callout(Think about):
 
     How many times do we need to shuffle in the *best case*? What about *worst case*? Could this *run forever* if we are unlucky? [How to solve this issue?](glossary://deterministic%20bogo)
 */
func performBogo(_ count: Int) {
    //#-editable-code
    for i in 0..<count-1 {
        // rand outputs integer between low and high inclusive
        let r = rand(low: i, high: count)
        // Use rearrange to update the graphics
        rearrange(index1: i, index2: r)
    }
    verifyBogo()
    //#-end-editable-code
}
//: [Next](@next)
//#-hidden-code
viewController.performBogoSort = performBogoSort
viewController.shuffle = shuffle
//#-end-hidden-code
