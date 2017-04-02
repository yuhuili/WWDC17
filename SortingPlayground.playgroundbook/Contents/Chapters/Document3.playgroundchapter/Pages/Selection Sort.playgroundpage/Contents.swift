//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, visualSwap(index1:index2:), visualizeSelectionIndicatorsWith(j:smallestValue:smallestIndex:))
//#-code-completion(identifier, show, smallestIndex, smallestValue, startAt, names, i, j)
//#-code-completion(keyword, show, for, if, let, var)
import UIKit
import PlaygroundSupport
import AVFoundation

_internalSetup()

let viewController = SPViewController(showBubble: false, showSelection: true, showQuick: false, showBogo: false)
PlaygroundPage.current.liveView = viewController

func playShuffleSound() {
    viewController.playShuffle()
}

var names = [String]()

func visualSwap(index1: Int, index2: Int) {
    
    if index1 == index2 {
        return
    }
    
    swap(&names[index1], &names[index2])
    viewController.arrangementController?.appendAction(type: .swap, index1: index1, index2: index2)
}

func selectionVisualIf(value: Int, lessThan v: Int, execute: () -> Void) {
    if value < v {
        viewController.arrangementController?.appendAction(type: .showCurrentIndicator, index1: value, index2: nil)
        viewController.arrangementController?.appendAction(type: .showSelectionInterestIndicator, index1: value, index2: nil)
        execute()
        viewController.arrangementController?.appendAction(type: .showDoneIndicator, index1: value, index2: nil)
        viewController.arrangementController?.executeActions {
            performSelectionSort(startAt: value+1)
        }
    } else {
        viewController.arrangementController?.appendAction(type: .resetAll, index1: nil, index2: nil)
        viewController.arrangementController?.executeActions()
    }
}

func visualizeSelectionIndicatorsWith(j: Int, smallestValue: String, smallestIndex: Int) {
    viewController.arrangementController?.appendAction(type: .showCurrentIndicator, index1: j, index2: nil)
    if names[j] < smallestValue {
        viewController.arrangementController?.appendAction(type: .hideIndicator, index1: smallestIndex, index2: nil)
        viewController.arrangementController?.appendAction(type: .showSelectionInterestIndicator, index1: j, index2: nil)
    } else {
        viewController.arrangementController?.appendAction(type: .hideIndicator, index1: j, index2: nil)
    }
}

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
func performSelectionSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Selection Sort"
    
    names.removeAll()
    for c in arrangementController.cards {
        names.append(c.stringValue())
    }
    
    performSelectionSort(startAt: 0)
}
//#-end-hidden-code
/*:
 ![Selection example](selection_example.png)
 ## Selection Sort
 Now we have the sorted part to the left side. Each time we loop through unsorted part, we pick the smallest item. Then place it at the end of the sorted part.
 
 Average runtime: O(n^2), same as Bubble Sort
 */
func performSelectionSort(startAt: Int) {
    //#-editable-code
    let i = startAt
    selectionVisualIf(value: i, lessThan: names.count) {
        var (smallestIndex, smallestValue) = (i, names[i])
        for j in i+1..<names.count {
            // Call visualize before we actually make any changes
            visualizeSelectionIndicatorsWith(j: j, smallestValue: smallestValue, smallestIndex: smallestIndex)
            if names[j] < smallestValue {
                (smallestIndex, smallestValue) = (j, names[j])
            }
        }
        // Swap the smallest item with the front
        visualSwap(index1: i, index2: smallestIndex)
    }
    //#-end-editable-code
}
//: These two are too slow? The [next one](@next) is going to be fast! Buckle up!
//#-hidden-code
viewController.performSelectionSort = performSelectionSort
viewController.shuffle = shuffle
//#-end-hidden-code
