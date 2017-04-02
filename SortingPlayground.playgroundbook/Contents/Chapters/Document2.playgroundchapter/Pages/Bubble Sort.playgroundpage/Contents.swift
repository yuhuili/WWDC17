//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, visualSwap(index1:index2:))
//#-code-completion(identifier, show, startAt, endBefore, names, i)
//#-code-completion(keyword, show, for, if, let, var)
import UIKit
import PlaygroundSupport
import AVFoundation

_internalSetup()

let viewController = SPViewController(showBubble: true, showSelection: false, showQuick: false, showBogo: false)
PlaygroundPage.current.liveView = viewController

func playShuffleSound() {
    viewController.playShuffle()
}

var names = [String]()

// Shuffle Helpers
func rearrange(index1: Int, index2: Int) {
    viewController.arrangementController?.rearrange(index1: index1, index2: index2)
}

func rand(low: Int, high: Int) -> Int {
    return Int(arc4random_uniform(UInt32(high-low))) + low
}
//: ## Shuffle
//: Shuffle the cards so we can sort them back~
func shuffle(_ count: Int) {
    //#-editable-code
    for i in 0..<count-1 {
        // rand gives you an integer between low and high inclusive
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
func performBubbleSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Bubble Sort"
    
    names.removeAll()
    for c in arrangementController.cards {
        names.append(c.stringValue())
    }
    
    performBubbleSort(arrangementController, endBefore: names.count)
}

func bubbleVisualIterator(range: CountableRange<Int>, iterator: (_ i: Int) -> Void) {
    for i in range {
        viewController.arrangementController?.appendAction(type: .showCurrentIndicators, index1: i-1, index2: i)
        iterator(i)
        viewController.arrangementController?.appendAction(type: .hideIndicators, index1: i-1, index2: i)
    }
}

func visualSwap(index1: Int, index2: Int) {
    swap(&names[index1], &names[index2])
    viewController.arrangementController?.appendAction(type: .swap, index1: index1, index2: index2)
}

func visualIf(value: Int, greaterThan v: Int, execute: () -> Void) {
    if value > v {
        execute()
        viewController.arrangementController?.appendAction(type: .showDoneIndicator, index1: value-1, index2: nil)
        viewController.arrangementController?.executeActions {
            performBubbleSort(viewController.arrangementController!, endBefore: value-1)
        }
    } else {
        viewController.arrangementController?.appendAction(type: .resetAll, index1: nil, index2: nil)
        viewController.arrangementController?.executeActions()
    }
}

//#-end-hidden-code
/*:
 ## Bubble Sort
 Average runtime: O(n^2), i.e., if we have 2 times amount of cards, this algorithm will take 4 times longer to run.
 
 Imagine the array having two parts, left is unosrted and right is sorted. Each time we examine the adjacent pair, and swap them if they are out of order. Can you see that the last element in each iteration will be at the correct spot? (Hint: what do we do if we encounter a card along the way that is supposed to be placed at the end?)
 
 ![Bubble example](bubble_example.png)
 */
func performBubbleSort(_ arrangementController: SPArrangementController, endBefore: Int) {
    // Can you see how the cards are being bubbled up?
    //#-editable-code
    visualIf(value: endBefore, greaterThan: 0) {
        // Special iterator so we can see what happens in LiveView
        bubbleVisualIterator(range: 1..<endBefore) { i in
            if names[i-1] > names[i] {
                visualSwap(index1: i-1, index2: i)
            }
        }
    }
    //#-end-editable-code
}
//: Ready to check out [Selection Sort?](@next)
//#-hidden-code
viewController.performBubbleSort = performBubbleSort
viewController.shuffle = shuffle
//#-end-hidden-code
