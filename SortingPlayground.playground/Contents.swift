//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
/*: #
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

let viewController = SPViewController()
PlaygroundPage.current.liveView = viewController
// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func performSelectionSort(_ arrangementController: SPArrangementController) {
    var valueArray = [String]()
    for c in arrangementController.cards {
        valueArray.append(c.stringValue())
    }
    
    performSelectionSort(arrangementController, values: &valueArray)
}
//#-end-hidden-code
//: ## Selection Sort
//: Average runtime: O(n^2)
func performSelectionSort(_ arrangementController: SPArrangementController, values: inout [String]) {
    // Imagine the array to have two parts, sorted and unsorted.
    // Each time we loop through unsorted part, we pick the smallest item. Then place it at the end of the sorted part.
    //#-hidden-code
    // Some issue with iPad playground layout engine, forcing an update
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    //#-end-hidden-code
    for i in 0..<values.count {
        //#-editable-code
        // Challenge for you: modify the code to sort in descending order
        var (smallestIndex, smallestValue) = (i, values[i])
        for j in i..<values.count {
            if values[j] < smallestValue {
                (smallestIndex, smallestValue) = (j, values[j])
            }
        }
        //#-end-editable-code
        // Swap the smallest item with front of the unsorted part
        if smallestIndex != i {
            swap(&values[i], &values[smallestIndex])
            //#-hidden-code
            arrangementController.appendAction(type: .swap, index1: i, index2: smallestIndex)
            //#-end-hidden-code
        }
        //#-hidden-code
        arrangementController.appendAction(type: .dim, index1: i, index2: nil)
        //#-end-hidden-code
    }
    //#-hidden-code
    arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()
    //#-end-hidden-code
}
//#-hidden-code
viewController.performSelectionSort = performSelectionSort
//#-end-hidden-code
