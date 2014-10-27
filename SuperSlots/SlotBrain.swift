//
//  SlotBrain.swift
//  SuperSlots
//
//  Created by Scott Brady on 10/27/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

import Foundation

class SlotBrain {


	class func computeWinnings (slots: [[Slot]]) -> Int {
		let kFlushMultiplier = 2
		let kRoyalFlushBonus = 10
		let kTrueFlushMultiplier = 30
		let kTrueRoyalFlushBonus = 150
		let kStraightMultiplier = 5
		let kEpicStraightBonus = 25
		let kPairMultiplier = 3
		let kAllPairsBonus = 15
		let kOfAKindMultiplier = 10
		let kEpicOfAKindBonus = 50

		var slotsInRows = unpackSlotsIntoSlotRows(slots)
		var winnings = 0
		var flushWinCount = 0
		var ofAKindWinCount = 0
		var straightWinCount = 0
		var pairWinCount = 0
		var trueFlushWinCount = 0

		var resultsText = ""

		for slotRow in slotsInRows {

			if isTrueFlush(slotRow) {
				trueFlushWinCount++
			}
			else if isFlush(slotRow) {
				flushWinCount++
			}

			if isStraight(slotRow) {
				straightWinCount++
			}

			if isOfAKind(slotRow) {
				ofAKindWinCount++
			}
			else if isPair(slotRow) {
				pairWinCount++
			}
		}

		// True royal flush check (all rows have flushes)
		if trueFlushWinCount == slotsInRows.count {
			winnings += kTrueRoyalFlushBonus
			resultsText += "True Royal Flush!\n"
		}
		else {
			winnings += trueFlushWinCount * kTrueFlushMultiplier
			resultsText += "True Flushes: \(trueFlushWinCount)\n"
		}

		// Royal flush check (all rows have flushes)
		if flushWinCount == slotsInRows.count {
			winnings += kRoyalFlushBonus
			resultsText += "Royal Flush!\n"
		}
		else {
			winnings += flushWinCount * kFlushMultiplier
			resultsText += "Flushes: \(flushWinCount)\n"
		}

		// Epic straight check (all rows have straights)
		if straightWinCount == slotsInRows.count {
			winnings += kEpicStraightBonus
			resultsText += "Epic Straight!\n"
		}
		else {
			winnings += straightWinCount * kStraightMultiplier
			resultsText += "Straights: \(straightWinCount)\n"
		}

		// Epic "of a kind" check (all rows have "of a kind" wins)
		if ofAKindWinCount == slotsInRows.count {
			winnings += kEpicOfAKindBonus
			resultsText += "Epic \(slotsInRows[0].count) of a Kind!\n"
		}
		else {
			winnings += ofAKindWinCount * kOfAKindMultiplier
			resultsText += "\(slotsInRows[0].count)s of a Kind: \(ofAKindWinCount)\n"
		}

		// All pairs check (all rows have pair wins)
		if pairWinCount == slotsInRows.count {
			winnings += kAllPairsBonus
			resultsText += "All Pairs!\n"
		}
		else {
			winnings += pairWinCount * kPairMultiplier
			resultsText += "Pairs: \(pairWinCount)\n"
		}

		println(resultsText)

		return winnings
	}

	class func isFlush(slotRow: [Slot]) -> Bool {
		var isFlush = true
		var isRed = slotRow[0].isRed

		// Loop over the remaining slots in the row to see if it matches
		for var i = 1; i < slotRow.count; ++i {
			if isRed != slotRow[i].isRed {
				isFlush = false
				break
			}
		}

		return isFlush
	}

	class func isOfAKind(slotRow: [Slot]) -> Bool {
		var isOfAKind = true
		var valueToMatch = slotRow[0].value

		// Loop over the remaining slots in the row to see if it matches
		for var i = 1; i < slotRow.count; ++i {
			if valueToMatch != slotRow[i].value {
				isOfAKind = false
				break
			}
		}

		return isOfAKind
	}

	class func isPair(slotRow: [Slot]) -> Bool {
		var isPair = false
		var valueToMatch:Int

		// Loop over each value and see if there's a match
		for var i = 0; i < slotRow.count; ++i {
			valueToMatch = slotRow[i].value
			// Loop over the remaining values and see if there's a match
			for var j = i + 1; j < slotRow.count; ++j {
				if valueToMatch == slotRow[j].value {
					isPair = true;
					break
				}
			}
		}

		return isPair
	}

	class func isStraight(slotRow: [Slot]) -> Bool {
		var isStraight = true
		var slotValues:[Int] = []
		var currentValue:Int

		for slot in slotRow {
			slotValues.append(slot.value)
		}

		// Now sort the array
		slotValues.sort{$0 < $1}

		// Loop over the sorted array to see if the values are consecutive
		currentValue = slotValues[0]
		for var i = 1; i < slotValues.count; ++i {
			if slotValues[i] != currentValue + 1 {
				isStraight = false;
				break;
			}
			else {
				currentValue = slotValues[i]
			}
		}
		return isStraight
	}

	class func isTrueFlush(slotRow: [Slot]) -> Bool {
		var isFlush = true
		var currentSuit = slotRow[0].suit

		// Loop over the remaining slots in the row to see if it matches
		for var i = 1; i < slotRow.count; ++i {
			if currentSuit != slotRow[i].suit {
				isFlush = false
				break
			}
		}

		return isFlush
	}

	class func unpackSlotsIntoSlotRows (slots: [[Slot]]) -> [[Slot]] {

		var slotsInRows: [[Slot]] = []

		for slotColumn in slots {
			for var i=0; i<slotColumn.count; ++i {
				let currentRowIndex = i + 1
				let currentSlot = slotColumn[i]
				if slotsInRows.count >= currentRowIndex {
					// This row has room, so append
					slotsInRows[i].append(currentSlot)
				}
				else {
					// Create a new array for the current row
					let currentRow = [currentSlot]
					slotsInRows.append(currentRow)
				}
			}
		}

		return slotsInRows
	}
}