import Foundation

enum Suit {
    case spades, clubs, hearts, diamonds
}

enum PlayingCardValue: Int {
    case one = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

struct Card {
    var suit: Suit
    var value: PlayingCardValue
}

enum PossibleHands: Int {
    case royalFlush = 0,
         straightFlush,
         fourOfAKind,
         fullHouse,
         flush,
         straight,
         threeOfAKind,
         twoPair,
         pair,
         highCard
    
}

/// determineWinner will take in an array of "Poker" hands and determine which hand is better (according to texas holdem rules).
/// Traditionally in Texas Holdem you are only given 2 cards and then 5 other cards are placed flipped up in front of everyone.
/// In our version each player is given 5 cards with no cards placed on the table.
/// Based on just the 5 cards given in a hand. You are to determine what type of winning hands a player has and which is best.
/// For example a player may have a 2 of a kind and a 3 of a kind in a single hand. 3 of a kind is better than 2 of a kind and should be used to determine if their hand is better than any of the other players hands.
///
/// - Returns: Hand - Which is the hand that won. It is expected that the handType property("2 of a kind", "3 of a kind", "4 of a kind", etc) will have a value when returning the winning hand.
///

func determineWinner(hands: [Hand]) -> Hand {
    var bestHand = hands[0]
    
    for hand in hands {
        if hand.handType!.rawValue < bestHand.handType!.rawValue {
            bestHand = hand
        }
    }
    return bestHand
}


struct Hand {
    let cards: [Card]
    var handType: PossibleHands? {
        if isRoyalFlush() {
            return .royalFlush
        } else if isStraightFlush() {
            return .straightFlush
        } else if isFourOfAKind() {
            return .fourOfAKind
        } else if isFullHouse() {
            return .fullHouse
        } else if isFlush() {
            return .flush
        } else if isStraight() {
            return .straight
        } else if isThreeOfAKind() {
            return .threeOfAKind
        } else if isTwoPair() {
            return .twoPair
        } else if isOnePair() {
            return .pair
        } else {
            return .highCard
        }
    }
    
    init?(cards: [Card]) {
        guard cards.count == 5 else { return nil }
        self.cards = cards
    }
    
    private func isRoyalFlush() -> Bool {
        let sortedCards = cards.sorted { $0.value.rawValue < $1.value.rawValue }
        
        if !self.isFlush() { //has to be a flush
            return false
        }
        
        let royalFlushCards: [PlayingCardValue] = [.ten, .jack, .queen, .king, .ace]
        for (index, value) in royalFlushCards.enumerated() {
            if sortedCards[index].value != value {
                return false
            }
        }
        return true
    }
    private func isStraightFlush() -> Bool {
        return isStraight() && isFlush()
    }
    private func isFourOfAKind() -> Bool {
        let groupedByValue = Dictionary(grouping: cards, by: { $0.value })
        let fourOfAKind = groupedByValue.filter { $0.value.count == 4 }
        
        return !fourOfAKind.isEmpty //return true if there's a four of a kind
    }
    private func isFullHouse() -> Bool {
        let groupedByValue = Dictionary(grouping: cards, by: { $0.value })
        let pairs = groupedByValue.filter { $0.value.count == 2 }
        let trio = groupedByValue.filter { $0.value.count == 3 }
        
        return !pairs.isEmpty && !trio.isEmpty
    }
    private func isFlush() -> Bool {
        guard let firstCardSuit = cards.first?.suit else { return false }
        for card in cards {
            if card.suit != firstCardSuit {
                return false
            }
        }
        return true
    }
    private func isStraight() -> Bool {
        let sortedCards = cards.sorted { $0.value.rawValue < $1.value.rawValue }

            // Check for a 5-card sequence in the sorted values
        var consecutiveCount = 1
        for i in 1..<sortedCards.count {
            if sortedCards[i].value.rawValue == sortedCards[i - 1].value.rawValue + 1 {
                consecutiveCount += 1
            } else if sortedCards[i].value.rawValue != sortedCards[i - 1].value.rawValue {
                consecutiveCount = 1
            }
            
            if consecutiveCount == 5 {
                return true
            }
        }
        if consecutiveCount == 4 && sortedCards.last?.value == .ace && sortedCards.first?.value == .two {
            return true
        }

        return false
    }
    private func isThreeOfAKind() -> Bool {
        let groupedByValue = Dictionary(grouping: cards, by: { $0.value })
        let trio = groupedByValue.filter { $0.value.count == 3 }
        
        return !trio.isEmpty //return true if there's a four of a kind
    }
    private func isTwoPair() -> Bool {
        let groupedByValue = Dictionary(grouping: cards, by: { $0.value })
        let pairs = groupedByValue.filter { $0.value.count == 2 }
        
        return pairs.count == 2 //return true if there's a four of a kind
    }
    private func isOnePair() -> Bool {
        let groupedByValue = Dictionary(grouping: cards, by: { $0.value })
        let double = groupedByValue.filter { $0.value.count == 2 }
        
        return !double.isEmpty //return true if there's a four of a kind
    }
}


let royalFlushHand = Hand(cards: [
    Card(suit: .hearts, value: .ten),
    Card(suit: .hearts, value: .jack),
    Card(suit: .hearts, value: .queen),
    Card(suit: .hearts, value: .king),
    Card(suit: .hearts, value: .ace)
])
let straightFlushHand = Hand(cards: [
    Card(suit: .spades, value: .eight),
    Card(suit: .spades, value: .nine),
    Card(suit: .spades, value: .ten),
    Card(suit: .spades, value: .jack),
    Card(suit: .spades, value: .queen)
])
let fourOfAKindHand = Hand(cards: [
    Card(suit: .spades, value: .nine),
    Card(suit: .clubs, value: .nine),
    Card(suit: .hearts, value: .nine),
    Card(suit: .diamonds, value: .nine),
    Card(suit: .hearts, value: .king)
])
let fullHouseHand = Hand(cards: [
    Card(suit: .spades, value: .nine),
    Card(suit: .clubs, value: .nine),
    Card(suit: .hearts, value: .king),
    Card(suit: .diamonds, value: .king),
    Card(suit: .hearts, value: .king)
])
let flushHand = Hand(cards: [
    Card(suit: .hearts, value: .two),
    Card(suit: .hearts, value: .five),
    Card(suit: .hearts, value: .seven),
    Card(suit: .hearts, value: .ten),
    Card(suit: .hearts, value: .king)
])
let straightHand = Hand(cards: [
    Card(suit: .spades, value: .eight),
    Card(suit: .clubs, value: .nine),
    Card(suit: .hearts, value: .ten),
    Card(suit: .diamonds, value: .jack),
    Card(suit: .hearts, value: .queen)
])
let threeOfAKindHand = Hand(cards: [
    Card(suit: .spades, value: .four),
    Card(suit: .clubs, value: .nine),
    Card(suit: .hearts, value: .nine),
    Card(suit: .diamonds, value: .nine),
    Card(suit: .hearts, value: .king)
])
let twoPairHand = Hand(cards: [
    Card(suit: .spades, value: .four),
    Card(suit: .clubs, value: .four),
    Card(suit: .hearts, value: .nine),
    Card(suit: .diamonds, value: .nine),
    Card(suit: .hearts, value: .king)
])
let onePairHand = Hand(cards: [
    Card(suit: .spades, value: .four),
    Card(suit: .clubs, value: .four),
    Card(suit: .hearts, value: .nine),
    Card(suit: .diamonds, value: .jack),
    Card(suit: .hearts, value: .king)
])
let highCardHand = Hand(cards: [
    Card(suit: .spades, value: .two),
    Card(suit: .clubs, value: .five),
    Card(suit: .hearts, value: .seven),
    Card(suit: .diamonds, value: .ten),
    Card(suit: .hearts, value: .king)
])

print(determineWinner(hands: [highCardHand!, twoPairHand!, royalFlushHand!, straightHand!]).handType ?? "")
print(determineWinner(hands: [highCardHand!, straightFlushHand!, straightHand!, flushHand!]).handType ?? "")

//print(royalFlushHand?.handType ?? "")
//print(straightFlushHand?.handType ?? "")
//print(fourOfAKindHand?.handType ?? "")
//print(fullHouseHand?.handType ?? "")
//print(flushHand?.handType ?? "")
//print(straightHand?.handType ?? "")
//print(threeOfAKindHand?.handType ?? "")
//print(twoPairHand?.handType ?? "")
//print(onePairHand?.handType ?? "")
//print(highCardHand?.handType ?? "")

