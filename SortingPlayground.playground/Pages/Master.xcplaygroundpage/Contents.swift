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
//#-code-completion(arrangementController, cards, stringValue(), smallestIndex, smallestIndexWord)
import UIKit
import PlaygroundSupport

_internalSetup()

let viewController = SPViewController(showBubble: true, showSelection: true, showQuick: true, showBogo: true)
PlaygroundPage.current.liveView = viewController

var values = [String]()

// Shuffle Helpers
func rearrange(index1: Int, index2: Int) {
    viewController.arrangementController?.rearrange(index1: index1, index2: index2)
}

func rand(low: Int, high: Int) -> Int {
    return Int(arc4random_uniform(UInt32(high-low))) + low
}

//#-end-hidden-code
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
//#-hidden-code
// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func performBubbleSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Bubble Sort"
    
    values.removeAll()
    for c in arrangementController.cards {
        values.append(c.stringValue())
    }
    
    performBubbleSort(arrangementController, endBefore: values.count)
}
//#-end-hidden-code
//: ## Bubble Sort
//: Can you see how the cards are being bubbled up? Average runtime: O(n^2)
func performBubbleSort(_ arrangementController: SPArrangementController, endBefore: Int) {
    // Imagine the array to have two parts, unosrted and sorted. Each time we examine the adjacent pair, and swap them if they are out of order. Can you see that the last element in each iteration will be at the correct spot?
    //#-hidden-code
    // Some issue with iPad playground layout engine, forcing an update
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    //#-end-hidden-code
    if endBefore > 0 {
        for i in 1..<endBefore {
            //#-hidden-code
            arrangementController.appendAction(type: .showCurrentIndicators, index1: i-1, index2: i)
            //#-end-hidden-code
            if values[i-1] > values[i] {
                swap(&values[i-1], &values[i])
                //#-hidden-code
                arrangementController.appendAction(type: .swap, index1: i-1, index2: i)
                //#-end-hidden-code
            }
            //#-hidden-code
            arrangementController.appendAction(type: .hideIndicators, index1: i-1, index2: i)
            //#-end-hidden-code
        }
        //#-hidden-code
        arrangementController.appendAction(type: .showDoneIndicator, index1: endBefore-1, index2: nil)
        arrangementController.executeActions {
            performBubbleSort(arrangementController, endBefore: endBefore-1)
        }
        //#-end-hidden-code
        return
    }
    //#-hidden-code
    arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()
    //#-end-hidden-code
}
//#-hidden-code
func performSelectionSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Selection Sort"
    
    values.removeAll()
    for c in arrangementController.cards {
        values.append(c.stringValue())
    }
    
    performSelectionSort(arrangementController, startAt: 0)
}
//#-end-hidden-code
//: ## Selection Sort
//: Now we have the sorted part to the left side. Each time we loop through unsorted part, we pick the smallest item. Then place it at the end of the sorted part. Average runtime: O(n^2)
func performSelectionSort(_ arrangementController: SPArrangementController, startAt: Int) {
    let i = startAt
    if i < values.count {
        //#-hidden-code
        arrangementController.appendAction(type: .showCurrentIndicator, index1: i, index2: nil)
        arrangementController.appendAction(type: .showSelectionInterestIndicator, index1: i, index2: nil)
        //#-end-hidden-code
        var (smallestIndex, smallestValue) = (i, values[i])
        for j in i+1..<values.count {
            //#-hidden-code
            arrangementController.appendAction(type: .showCurrentIndicator, index1: j, index2: nil)
            if values[j] < smallestValue {
                arrangementController.appendAction(type: .hideIndicator, index1: smallestIndex, index2: nil)
                arrangementController.appendAction(type: .showSelectionInterestIndicator, index1: j, index2: nil)
            } else {
                arrangementController.appendAction(type: .hideIndicator, index1: j, index2: nil)
            }
            //#-end-hidden-code
            //#-editable-code
            if values[j] < smallestValue {
                (smallestIndex, smallestValue) = (j, values[j])
            }
            //#-end-editable-code
        }
        // Swap the smallest item with the front
        if smallestIndex != i {
            swap(&values[i], &values[smallestIndex])
            //#-hidden-code
            arrangementController.appendAction(type: .swap, index1: i, index2: smallestIndex)
            //#-end-hidden-code
        }
        //#-hidden-code
        arrangementController.appendAction(type: .showDoneIndicator, index1: i, index2: nil)
        arrangementController.executeActions {
            performSelectionSort(arrangementController, startAt: i+1)
        }
        return
        //#-end-hidden-code
    }
    //#-hidden-code
    arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()
    //#-end-hidden-code
}//#-hidden-code
// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func performQuickSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Quick Sort"
    
    values.removeAll()
    for c in arrangementController.cards {
        values.append(c.stringValue())
    }
    
    performQuickSort(arrangementController, startAt: 0, endBefore: values.count, completion: {
        arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
        arrangementController.executeActions()
        viewController.enableBoard()
        viewController.enableButtons()
    })
}
//#-end-hidden-code
//: ## Quick Sort
//: Average runtime: O(nlogn)
func performQuickSort(_ arrangementController: SPArrangementController, startAt: Int, endBefore: Int, completion: (() -> Void)?) {
    // Every time we pick the first card in range as the pivot, then rearrange the board such that everything less than it will be on its left and other ones will be on its right. We know this card must be at the correct place. Then we sort its left and right side.
    
    if startAt < endBefore {
        var dividerLocation: Int = startAt
        arrangementController.appendAction(type: .showPivotIndicator, index1: startAt, index2: nil)
        for i in startAt+1..<endBefore {
            //#-hidden-code
            arrangementController.appendAction(type: .showCurrentIndicator, index1: i, index2: nil)
            //#-end-hidden-code
            if values[i] < values[startAt] {
                dividerLocation += 1
                if dividerLocation != i {
                    swap(&values[i], &values[dividerLocation])
                    //#-hidden-code
                    arrangementController.appendAction(type: .swap, index1: i, index2: dividerLocation)
                    //#-end-hidden-code
                }
            }
            //#-hidden-code
            arrangementController.appendAction(type: .hideIndicator, index1: i, index2: nil)
            //#-end-hidden-code
        }
        if (startAt != dividerLocation) {
            swap(&values[startAt], &values[dividerLocation])
            //#-hidden-code
            arrangementController.appendAction(type: .swap, index1: startAt, index2: dividerLocation)
            //#-end-hidden-code
        }
        //#-hidden-code
        arrangementController.appendAction(type: .showDoneIndicator, index1: dividerLocation, index2: nil)
        arrangementController.executeActions {
            performQuickSort(arrangementController, startAt: startAt, endBefore: dividerLocation, completion: {
                performQuickSort(arrangementController, startAt: dividerLocation+1, endBefore: endBefore, completion: {
                    if let completion = completion {
                        completion()
                    }
                })
            })
        }
        //#-end-hidden-code
        return
    }
    //#-hidden-code
    /*arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()*/
    if let completion = completion {
        completion()
    }
    //#-end-hidden-code
}
//#-hidden-code
viewController.performSelectionSort = performSelectionSort
viewController.performBubbleSort = performBubbleSort
viewController.performQuickSort = performQuickSort
viewController.shuffle = shuffle
//#-end-hidden-code
