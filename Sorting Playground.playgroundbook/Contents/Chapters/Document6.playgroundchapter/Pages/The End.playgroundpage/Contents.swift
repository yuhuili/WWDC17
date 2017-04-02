//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, (, ))
//#-code-completion(rand(low: Int, high: Int), visualSwap(index1: Int, index2: Int))
import UIKit
import PlaygroundSupport
import AVFoundation

_internalSetup()

let viewController = SPViewController(showBubble: true, showSelection: true, showQuick: true, showBogo: true)
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

func bubbleVisualIterator(range: CountableRange<Int>, iterator: (_ i: Int) -> Void) {
    for i in range {
        viewController.arrangementController?.appendAction(type: .showCurrentIndicators, index1: i-1, index2: i)
        iterator(i)
        viewController.arrangementController?.appendAction(type: .hideIndicators, index1: i-1, index2: i)
    }
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
// ## Shuffle
// Shuffle the cards so we can sort them back~
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
func performBubbleSort(_ arrangementController: SPArrangementController) {
    
    viewController.labelText = "Performing Bubble Sort"
    
    names.removeAll()
    for c in arrangementController.cards {
        names.append(c.stringValue())
    }
    
    performBubbleSort(arrangementController, endBefore: names.count)
}
/*
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
/*
 ## Selection Sort
 */
func performSelectionSort(_ arrangementController: SPArrangementController, startAt: Int) {
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
    
    performQuickSort(arrangementController, startAt: 0, endBefore: names.count, completion: {
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
            performQuickSort(viewController.arrangementController!, startAt: startAt, endBefore: pivotLocation, completion: {
                viewController.arrangementController?.appendAction(type: .showLookRight, index1: pivotLocation, index2: nil)
                performQuickSort(viewController.arrangementController!, startAt: pivotLocation+1, endBefore: endBefore, completion: {
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

/*
 ## Quick Sort
 */
func performQuickSort(_ arrangementController: SPArrangementController, startAt: Int, endBefore: Int, completion: (() -> Void)?) {
    // Let app handle visualization of each step
    quickVisualIf(value: startAt, lessThan: endBefore, thenPerform: completion) {
        
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
}

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
}
/*
 ## Bogo Sort
 */
func performBogo(_ count: Int) {
    for i in 0..<count-1 {
        // rand outputs integer between low and high inclusive
        let r = rand(low: i, high: count)
        // Use rearrange to update the graphics
        rearrange(index1: i, index2: r)
    }
    verifyBogo()
}
//#-end-hidden-code

/*:
 # The end
 Sorting Playground provides you with an intuitive interface and animations to explore a number of sorting algorithms, ranging from easy but slow ones, to a very sophisticated Quick Sort, then finally a laugh with Bogo.
 
 You may play with all previously shown algorithms on this page, or reread the details by navigating the table of contents. I hope you have enjoyed this journey in sorting.
 
 Yuhui Li
 */

//#-hidden-code
viewController.performSelectionSort = performSelectionSort
viewController.performBubbleSort = performBubbleSort
viewController.performQuickSort = performQuickSort
viewController.performBogoSort = performBogoSort
viewController.shuffle = shuffle
//#-end-hidden-code
