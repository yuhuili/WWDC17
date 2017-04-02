//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, rand(low:high:), rearrange(index1:index2:), visualSwap(index1:index2:), visualizePivot(_:))
//#-code-completion(identifier, show, startAt, endBefore)
//#-code-completion(keyword, show, for, if, let, var)
import UIKit
import PlaygroundSupport
import AVFoundation

_internalSetup()

let viewController = SPViewController(showBubble: false, showSelection: false, showQuick: true, showBogo: false)
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
        // rand outputs integer between low and high inclusive
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
func performQuickSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Quick Sort"
    
    names.removeAll()
    for c in arrangementController.cards {
        names.append(c.stringValue())
    }
    
    performQuickSort(startAt: 0, endBefore: names.count, completion: {
        arrangementController.appendAction(type: .resetAll, index1: nil, index2: nil)
        arrangementController.executeActions()
        viewController.enableBoard()
        viewController.enableButtons()
    })
}

func visualizePivot(_ index: Int) {
    viewController.arrangementController?.appendAction(type: .showPivotIndicator, index1: index, index2: nil)
}

func quickVisualIterator(range: CountableRange<Int>, iterator: (_ i: Int) -> Void) {
    for i in range {
        viewController.arrangementController?.appendAction(type: .showCurrentIndicator, index1: i, index2: nil)
        iterator(i)
        viewController.arrangementController?.appendAction(type: .hideIndicator, index1: i, index2: nil)
    }
}

func quickVisualIf(value startAt: Int, lessThan endBefore: Int, thenPerform completion: (() -> Void)?, getFinalPivotLocation: () -> Int) {
    if startAt < endBefore {
        let pivotLocation = getFinalPivotLocation()
        viewController.arrangementController?.appendAction(type: .showDoneIndicator, index1: pivotLocation, index2: nil)
        viewController.arrangementController?.executeActions {
            viewController.arrangementController?.appendAction(type: .showLookLeft, index1: pivotLocation, index2: nil)
            performQuickSort(startAt: startAt, endBefore: pivotLocation, completion: {
                viewController.arrangementController?.appendAction(type: .showLookRight, index1: pivotLocation, index2: nil)
                performQuickSort(startAt: pivotLocation+1, endBefore: endBefore, completion: {
                    if let completion = completion {
                        completion()
                    }
                })
            })
        }
    }
    else {
        
        if let completion = completion {
            completion()
        }
    }
}

//#-end-hidden-code
/*:
 ## Quick Sort
 
 Average runtime: [O(nlogn)](glossary://linearithmic%20runtime)
 
 Quick sort follows three steps:
 
 1. Pick an item as *pivot*, we'll always pick the first one.
 2. *Partition* such that all items that should come before the pivot are placed on the left, otherwise on the right side of pivot.
 3. Recursively apply the same steps for each side of the pivot.
 
 ![Quick example](quick_example.png)
 
* callout(Challenge for you):
 
     The [choice of pivot](glossary://choice%20of%20pivot) has been studied extensively because it affects how fast the algorithm runs. So a good thing to do is to randomize the pivot. Currently we always choose the first card as pivot. Can you write simple **two lines** of code to randomize this?
 */
func performQuickSort(startAt: Int, endBefore: Int, completion: (() -> Void)?) {
    //#-editable-code
    // Let app handle visualization of each step
    quickVisualIf(value: startAt, lessThan: endBefore, thenPerform: completion) {
        
        // TODO: use rand(low: Int, high: Int) to randomly choose an index between startAt and endBefore. Note that rand is inclusive so high needs to be endBefore-1
        
        // TODO: use visualSwap(index1: Int, index2: Int) to swap so the pivot comes to the front
        
        // Choose first card as the pivot
        visualizePivot(startAt)
        
        // Mark the dividing line of cards with values less than pivot and those greater than pivot
        var dividerLocation: Int = startAt
        
        quickVisualIterator(range: startAt+1..<endBefore) { i in
            
            // If we find a card that needs to be moved to the left of dividing line because it is less than the pivot, we shift the dividerLocation to the right. Now the dividerLocation is exactly on a card that has value greater than pivot. So if we swap current card with that, the current card will be at the correct place and that original card will still be to the right of dividing line.
            if names[i] < names[startAt] {
                dividerLocation += 1
                if dividerLocation != i {
                    visualSwap(index1: i, index2: dividerLocation)
                }
            }
        }
        
        // Swap the pivot with the dividerLocation, note that at this instant, the dividerLocation is on a card with value less than the pivot. So swapping does not violate the ordering property.
        visualSwap(index1: startAt, index2: dividerLocation)
        
        // The app will handle the calls for you to sort left and right side, just give it the pivotLocation and it will know where to proceed.
        return dividerLocation
    }
    //#-end-editable-code
}
//: Ready for some laugh? [Continue](@next)
/*:
 - - -
 ### Further readings:
 
 O(nlogn) is much better than O(n^2), in this case we have 6 cards, but if we have 600 cards, O(n^2) will approximately do 30 times more work than O(nlogn), and if we have 6 million cards, Quick Sort can be 100000 times faster! Amazing isn't it?
 
 This is also a form of [divide and conquer](https://en.wikipedia.org/wiki/Divide_and_conquer_algorithm) algorithm, in which we break down big problems into smaller ones. Divide occurs when we arrange elements based on the pivot, then in conquer stage, we recursively sort the cards on the left and right.
 */

//#-hidden-code
viewController.performQuickSort = performQuickSort
viewController.shuffle = shuffle
//#-end-hidden-code
