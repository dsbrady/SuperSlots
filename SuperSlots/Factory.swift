//
//  Factory.swift
//  SuperSlots
//
//  Created by Scott Brady on 10/27/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

import Foundation
import UIKit

class Factory {
	class func createSlots() -> [[Slot]] {
		let kNumberOfColumns = 3
		let kNumberOfRows = 3
		var slots:[[Slot]] = []
		for var columnNumber = 0; columnNumber < kNumberOfColumns; ++columnNumber {
			var slotArray:[Slot] = []
			for var rowNumber = 0; rowNumber < kNumberOfRows; ++rowNumber {
				var slot = createSlot(slotArray)
				slotArray.append(slot)
			}
			slots.append(slotArray)
		}
		return slots
	}

	class func createSlot(currentCards: [Slot]) -> Slot {
		var currentCardValues:[Int] = []
		for slot in currentCards {
			currentCardValues.append(slot.value)
		}

		var randomNumber = Int(arc4random_uniform(UInt32(13)) + 1)
		while contains(currentCardValues, randomNumber) {
			randomNumber = Int(arc4random_uniform(UInt32(13)) + 1)
		}

		var slot:Slot
		switch randomNumber {
		case 1:
			slot = Slot(value: 1, image: UIImage(named: "Ace"), isRed: true, suit: "diamonds")
		case 2:
			slot = Slot(value: 2, image: UIImage(named: "Two"), isRed: true, suit: "hearts")
		case 3:
			slot = Slot(value: 3, image: UIImage(named: "Three"), isRed: true, suit: "diamonds")
		case 4:
			slot = Slot(value: 4, image: UIImage(named: "Four"), isRed: true, suit: "hearts")
		case 5:
			slot = Slot(value: 5, image: UIImage(named: "Five"), isRed: false, suit: "spades")
		case 6:
			slot = Slot(value: 6, image: UIImage(named: "Six"), isRed: false, suit: "spades")
		case 7:
			slot = Slot(value: 7, image: UIImage(named: "Seven"), isRed: true, suit: "hearts")
		case 8:
			slot = Slot(value: 8, image: UIImage(named: "Eight"), isRed: false, suit: "spades")
		case 9:
			slot = Slot(value: 9, image: UIImage(named: "Nine"), isRed: false, suit: "clubs")
		case 10:
			slot = Slot(value: 10, image: UIImage(named: "Ten"), isRed: true, suit: "hearts")
		case 11:
			slot = Slot(value: 11, image: UIImage(named: "Jack"), isRed: false, suit: "clubs")
		case 12:
			slot = Slot(value: 12, image: UIImage(named: "Queen"), isRed: false, suit: "clubs")
		case 13:
			slot = Slot(value: 13, image: UIImage(named: "King"), isRed: true, suit: "diamonds")
		default:
			slot = Slot(value: 0, image: UIImage(named: "Ace"), isRed: true, suit: "diamonds")
		}

		return slot
	}
}
