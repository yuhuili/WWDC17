//#-hidden-code
//
//  SortingPlayground
//
//  Copyright (c) 2017 Yuhui Li
//
//#-end-hidden-code
/*:
 Implement sorting functions! Follow the comments to get started.
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
    performSelectionSort(arrangementController, startIndex: 0)
}
//#-end-hidden-code

// Each time we select the smallest element and place it in front, continue doing this for all cards.
func performSelectionSort(_ arrangementController: SPArrangementController, startIndex: Int) {
    // If we have finished looking at all elements of the array, reset the transparency
    if (startIndex >= arrangementController.cards.count) {
        arrangementController.resetCardsOpacity()
        return
    }
    
    var smallestIndex = startIndex
    var smallestIndexWord = arrangementController.cards[startIndex].stringValue()
    if startIndex < arrangementController.cards.count - 1 {
        // Try to change the code to make it sort by descending order, that is, z comes first, a comes last.
        //#-editable-code
        for i in startIndex+1..<arrangementController.cards.count {
            if arrangementController.cards[i].stringValue() < smallestIndexWord {
                smallestIndexWord = arrangementController.cards[i].stringValue()
                smallestIndex = i
            }
        }
        //#-end-editable-code
        
        arrangementController.rearrange(index1: startIndex, index2: smallestIndex)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            performSelectionSort(arrangementController, startIndex: startIndex + 1)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            arrangementController.cards[startIndex].alpha = 0.5
        })
    } else {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            performSelectionSort(arrangementController, startIndex: startIndex + 1)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            arrangementController.cards[startIndex].alpha = 0.5
        })
    }
}
//#-hidden-code
viewController.performSelectionSort = performSelectionSort
//#-end-hidden-code
