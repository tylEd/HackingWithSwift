import UIKit
import GameplayKit

let int1 = Int.random(in: 0...10)
let int2 = Int.random(in: 0..<10)
let double1 = Double.random(in: 1000...10000)
let float1 = Float.random(in: -100...100)

//MARK: Old-fashioned randomness

arc4random()
arc4random()
arc4random()
arc4random()

arc4random() % 7 // modulo bias or pigeonhole principle

arc4random_uniform(7)

//MARK: GameplayKit

GKRandomSource.sharedRandom().nextInt()
GKRandomSource.sharedRandom().nextInt(upperBound: 6)
GKRandomSource.sharedRandom().nextBool()
GKRandomSource.sharedRandom().nextUniform()

let arc4 = GKARC4RandomSource()
arc4.nextInt(upperBound: 20)
arc4.nextBool()
arc4.nextUniform()

let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

let linCon = GKLinearCongruentialRandomSource()
linCon.nextInt(upperBound: 20)

/* NOTE:
 Apple recommends force flushing its ARC4 random number generator before using it
 for anything important, otherwise it will generate sequences that can be guessed
 to begin with. Apple suggests dropping at least the first 769 values.
 */
arc4.dropValues(1024)

//MARK: Distributions

let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d20 = GKRandomDistribution.d20()
d20.nextInt()

let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
crazy.nextInt()

//let distribution = GKRandomDistribution(lowestValue: 10, highestValue: 20)
//print(distribution.nextInt(upperBound: 9)) CRASHES!

// Custom random source
let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
distribution.nextInt()

let shuffled = GKShuffledDistribution.d6()
shuffled.nextInt()
shuffled.nextInt()
shuffled.nextInt()
shuffled.nextInt()
shuffled.nextInt()
shuffled.nextInt()

shuffled.nextInt()

let gaussian = GKGaussianDistribution.d20()
gaussian.nextInt()
gaussian.nextInt()
gaussian.nextInt()
gaussian.nextInt()
gaussian.nextInt()
gaussian.nextInt()


//MARK: Shuffling Arrays

//NOTE(Paul): Many Swift game projects use this Fisher-Yates array shuffle algorithm
//  implemented in Swift by Nate Cook.
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j) //NOTE: Shuffles in place
        }
    }
}

let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
shuffledBalls[0]
shuffledBalls[1]
shuffledBalls[2]
shuffledBalls[3]
shuffledBalls[4]
shuffledBalls[5]

let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001) //NOTE: Fixed seed
                            .arrayByShufflingObjects(in: fixedLotteryBalls)
fixedShuffledBalls[0]
fixedShuffledBalls[1]
fixedShuffledBalls[2]
fixedShuffledBalls[3]
fixedShuffledBalls[4]
fixedShuffledBalls[5]
