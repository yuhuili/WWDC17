//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(module, show, Swift)
//#-code-completion(if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, (, ))
//#-code-completion(rand(low: Int, high: Int), rearrange)
import UIKit
import PlaygroundSupport

_internalSetup()

let viewController = SPViewController(showBubble: false, showSelection: false, showQuick: false, showBogo: false)
PlaygroundPage.current.liveView = viewController

// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func rearrange(index1: Int, index2: Int) {
    viewController.arrangementController?.rearrange(index1: index1, index2: index2)
}

func rand(low: Int, high: Int) -> Int {
    return Int(arc4random_uniform(UInt32(high-low))) + low
}

//#-end-hidden-code
/*:
 ## Shuffle
 Before we start, we'll learn to shuffle.
 Drag cards around to shuffle manually, or let Swift do the shuffling for you!
 
 This is the Fisher-Yates shuffle algorithm, which produces an unbiased permutation: every permutaton is equally likely. It takes time proportional to the number of items being shuffled and shuffles them in place. Want to [find out more?](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
*/
func shuffle(_ count: Int) {
    // Each time we swap current index i with a random index j such that i <= j < number of elements
    //#-editable-code
    for i in 0..<count-1 {
        // rand gives you an integer between low and high inclusive
        let r = rand(low: i, high: count)
        // Use rearrange to update the graphics
        rearrange(index1: i, index2: r)
    }
    //#-end-editable-code
}
//: Coming up, [Bubble Sort!](@next)
//#-hidden-code
viewController.shuffle = shuffle
//#-end-hidden-code
