//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
/*:
 # Sorting Playground
 Sorting: the process of arranging items.
 - - -
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(module, show, Swift)
//#-code-completion(if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, (, ))
//#-code-completion(rand(low: Int, high: Int), visualSwap(index1: Int, index2: Int))
import UIKit
import PlaygroundSupport

_internalSetup()

let viewController = SPViewController(showBubble: true, showSelection: true, showQuick: false, showBogo: false)
PlaygroundPage.current.liveView = viewController

var names = [String]()

func bubbleVisualIterator(range: CountableRange<Int>, iterator: (_ i: Int) -> Void) {
    for i in range {
        viewController.arrangementController?.appendAction(type: .showCurrentIndicators, index1: i-1, index2: i)
        iterator(i)
        viewController.arrangementController?.appendAction(type: .hideIndicators, index1: i-1, index2: i)
    }
}

func visualSwap(index1: Int, index2: Int) {
    
    if index1 == index2 {
        return
    }
        
    swap(&names[index1], &names[index2])
    viewController.arrangementController?.appendAction(type: .swap, index1: index1, index2: index2)
}

func bubbleVisualIf(value: Int, greaterThan v: Int, execute: () -> Void) {
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

func selectionVisualIf(value: Int, lessThan v: Int, execute: () -> Void) {
    if value < v {
        viewController.arrangementController?.appendAction(type: .showCurrentIndicator, index1: value, index2: nil)
        viewController.arrangementController?.appendAction(type: .showSelectionInterestIndicator, index1: value, index2: nil)
        execute()
        viewController.arrangementController?.appendAction(type: .showDoneIndicator, index1: value, index2: nil)
        viewController.arrangementController?.executeActions {
            performSelectionSort(viewController.arrangementController!, startAt: value+1)
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
/*:
 ## Bubble Sort
*/
func performBubbleSort(_ arrangementController: SPArrangementController, endBefore: Int) {
    // Can you see how the cards are being bubbled up?
    bubbleVisualIf(value: endBefore, greaterThan: 0) {
        // Special iterator so we can see what happens in LiveView
        bubbleVisualIterator(range: 1..<endBefore) { i in
            if names[i-1] > names[i] {
                visualSwap(index1: i-1, index2: i)
            }
        }
    }
}
//#-end-hidden-code
//#-hidden-code
func performSelectionSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Selection Sort"
    
    names.removeAll()
    for c in arrangementController.cards {
        names.append(c.stringValue())
    }
    
    performSelectionSort(arrangementController, startAt: 0)
}
//#-end-hidden-code
/*:
 ## Selection Sort
 Now we have the sorted part to the left side. Each time we loop through unsorted part, we pick the smallest item. Then place it at the end of the sorted part.
 
 Average runtime: O(n^2), same as Bubble Sort
 */
func performSelectionSort(_ arrangementController: SPArrangementController, startAt: Int) {
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
viewController.performBubbleSort = performBubbleSort
viewController.shuffle = shuffle
//#-end-hidden-code
