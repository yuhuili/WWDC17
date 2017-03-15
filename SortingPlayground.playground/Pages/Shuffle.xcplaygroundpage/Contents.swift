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
//#-code-completion(rand(low: Int, high: Int), rearrange)
import UIKit
import PlaygroundSupport
import AVFoundation

_internalSetup()

let viewController = SPViewController(showBubble: false, showSelection: false, showQuick: false, showBogo: false)
PlaygroundPage.current.liveView = viewController

// == Shuffle Sound ==
var shuffleSoundPlayer = AVAudioPlayer()
let shuffleURL = Bundle.main.url(forResource: "shuffle", withExtension: "mp3")
if let shuffleURL = shuffleURL {
    do {
        shuffleSoundPlayer = try AVAudioPlayer(contentsOf: shuffleURL)
        shuffleSoundPlayer.volume = 0.1
        shuffleSoundPlayer.prepareToPlay()
    } catch {
        
    }
}
func playShuffleSound() {
    shuffleSoundPlayer.stop()
    shuffleSoundPlayer.currentTime = 0
    shuffleSoundPlayer.play()
}
// == Shuffle Sound ==


// Note: These functions are not following Swift conventions but are instead trying to mimic the feel of a class for a beginner audience.
func rearrange(index1: Int, index2: Int) {
    viewController.arrangementController?.rearrange(index1: index1, index2: index2)
}

func rand(low: Int, high: Int) -> Int {
    return Int(arc4random_uniform(UInt32(high-low))) + low
}

//#-end-hidden-code
/*:
 # Prologue
 Hello there, welcome to Sorting Playground! In this book, you will be guided through a number of sorting algorithms accompanied by beautiful animations. There will be small challenges for you to complete, and some questions for you to think about.
 
 ### Table of Contents
 * [Shuffle](Shuffle)
 * [Bubble Sort](Bubble%20Sort)
 * [Selection Sort](Selection%20Sort)
 * [Quick Sort](Quick%20Sort)
 * [Bogo Sort](Bogo%20Sort)
 * [The End](The%20End)
 */
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
    playShuffleSound()
}
//: Coming up, [Bubble Sort!](@next)
//#-hidden-code
viewController.shuffle = shuffle
//#-end-hidden-code
