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

var values = [String]()

// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func performSelectionSort(_ arrangementController: SPArrangementController) {
    values.removeAll()
    for c in arrangementController.cards {
        values.append(c.stringValue())
    }
    
    performSelectionSort(arrangementController, i: 0)
}


//#-end-hidden-code
//: ## Selection Sort
//: Average runtime: O(n^2)
/*
func performSelectionSort(_ arrangementController: SPArrangementController, values: inout [String]) {
    // Imagine the array to have two parts, sorted and unsorted.
    // Each time we loop through unsorted part, we pick the smallest item. Then place it at the end of the sorted part.
    //#-hidden-code
    // Some issue with iPad playground layout engine, forcing an update
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    //#-end-hidden-code
    for i in 0..<values.count {
        //#-hidden-code
        //arrangementController.appendAction(type: .showCurrentIndicator, index1: i, index2: nil)
        //arrangementController.appendAction(type: .showInterestIndicator, index1: i, index2: nil)
        //#-end-hidden-code
        var (smallestIndex, smallestValue) = (i, values[i])
        for j in i+1..<values.count {
            
            //#-hidden-code
            //arrangementController.appendAction(type: .showCurrentIndicator, index1: j, index2: nil)
            if values[j] < smallestValue {
                //arrangementController.appendAction(type: .hideIndicator, index1: smallestIndex, index2: nil)
                //arrangementController.appendAction(type: .showInterestIndicator, index1: j, index2: nil)
            } else {
                //arrangementController.appendAction(type: .hideIndicator, index1: j, index2: nil)
            }
            //#-end-hidden-code
 
            //#-editable-code
            if values[j] < smallestValue {
                (smallestIndex, smallestValue) = (j, values[j])
            }
            //#-end-editable-code
        }
        // Swap the smallest item with front of the unsorted part
        if smallestIndex != i {
            swap(&values[i], &values[smallestIndex])
            //#-hidden-code
            arrangementController.appendAction(type: .showSwapIndicators, index1: i, index2: smallestIndex)
            arrangementController.appendAction(type: .swap, index1: i, index2: smallestIndex)
            arrangementController.appendAction(type: .hideSwapIndicators, index1: i, index2: smallestIndex)
            //#-end-hidden-code
        }
        //#-hidden-code
        arrangementController.appendAction(type: .dim, index1: i, index2: nil)
        //arrangementController.appendAction(type: .showDoneIndicator, index1: i, index2: nil)
        //#-end-hidden-code
    }
    //#-hidden-code
    arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()
    //#-end-hidden-code
}
 */
func performSelectionSort(_ arrangementController: SPArrangementController, i: Int) {
    
    print("perform")
    
    if i < values.count {
        //#-hidden-code
        arrangementController.appendAction(type: .showCurrentIndicator, index1: i, index2: nil)
        arrangementController.appendAction(type: .showInterestIndicator, index1: i, index2: nil)
        //#-end-hidden-code
        var (smallestIndex, smallestValue) = (i, values[i])
        for j in i+1..<values.count {
            
            //#-hidden-code
            arrangementController.appendAction(type: .showCurrentIndicator, index1: j, index2: nil)
            if values[j] < smallestValue {
                arrangementController.appendAction(type: .hideIndicator, index1: smallestIndex, index2: nil)
                arrangementController.appendAction(type: .showInterestIndicator, index1: j, index2: nil)
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
        // Swap the smallest item with front of the unsorted part
        if smallestIndex != i {
            swap(&values[i], &values[smallestIndex])
            //#-hidden-code
            arrangementController.appendAction(type: .showSwapIndicators, index1: i, index2: smallestIndex)
            arrangementController.appendAction(type: .swap, index1: i, index2: smallestIndex)
            arrangementController.appendAction(type: .hideSwapIndicators, index1: i, index2: smallestIndex)
            //#-end-hidden-code
        }
        //#-hidden-code
        arrangementController.appendAction(type: .dim, index1: i, index2: nil)
        arrangementController.appendAction(type: .showDoneIndicator, index1: i, index2: nil)
        //#-end-hidden-code
        
        arrangementController.executeActions {
            performSelectionSort(arrangementController, i: i+1)
        }
    } else {
        arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
        arrangementController.executeActions {}
    }
    /*
    //#-hidden-code
    arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()
    //#-end-hidden-code
    */
}
// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func performBubbleSort(_ arrangementController: SPArrangementController) {
    var valueArray = [String]()
    for c in arrangementController.cards {
        valueArray.append(c.stringValue())
    }
    
    performBubbleSort(arrangementController, values: &valueArray)
}
//#-end-hidden-code
//: ## Selection Sort
//: Average runtime: O(n^2)
func performBubbleSort(_ arrangementController: SPArrangementController, values: inout [String]) {
    // We swap adjacent pair that is not in the correct order. After each iteration, can you see that the last element is at the correct spot?
    //#-hidden-code
    // Some issue with iPad playground layout engine, forcing an update
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    arrangementController.appendAction(type: .quickSwap, index1: 0, index2: 1)
    //#-end-hidden-code
    for i in stride(from: values.count, to: 0, by: -1) {
        for j in 1..<i {
            if values[j-1] > values[j] {
                swap(&values[j-1], &values[j])
                //#-hidden-code
                arrangementController.appendAction(type: .swap, index1: j-1, index2: j)
                //#-end-hidden-code
            }
        }
        //#-hidden-code
        arrangementController.appendAction(type: .dim, index1: i-1, index2: nil)
        //#-end-hidden-code
    }
    //#-hidden-code
    arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
    arrangementController.executeActions()
    //#-end-hidden-code
}
//#-hidden-code
viewController.performSelectionSort = performSelectionSort
viewController.performBubbleSort = performBubbleSort
//#-end-hidden-code
