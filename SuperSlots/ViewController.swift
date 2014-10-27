//
//  ViewController.swift
//  SuperSlots
//
//  Created by Scott Brady on 10/26/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var firstContainer: UIView!
	var secondContainer: UIView!
	var thirdContainer: UIView!
	var fourthContainer: UIView!

	var titleLabel:UILabel!

	// Slots
	var slots:[[Slot]] = []

	// Stats
	var credits = 0
	var currentBet = 0
	var winnings = 0

	// Information labels
	var creditsLabel: UILabel!
	var betLabel: UILabel!
	var winnerPaidLabel: UILabel!
	var creditsTitleLabel: UILabel!
	var betTitleLabel: UILabel!
	var winnerPaidTitleLabel: UILabel!

	// Buttons in fourth container
	var resetButton: UIButton!
	var betOneButton: UIButton!
	var betMaxButton: UIButton!
	var spinButton: UIButton!

	// Constants
	let kSixth:CGFloat = 1.0/6.0
	let kThird:CGFloat = 1.0/3.0
	let kHalf:CGFloat = 1.0/2.0
	let kEighth:CGFloat = 1.0/8.0

	let kMarginForView:CGFloat = 10.0
	let kMarginForSlot:CGFloat = 2.0

	let kNumberOfColumns = 3
	let kNumberOfRows = 3

	let kMaxBet = 5
	let kStartingCredits = 3


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		setupContainerView()
		setupFirstContainer(self.firstContainer)
//		setupSecondContainer(self.secondContainer)
		setupThirdContainer(self.thirdContainer)
		setupFourthContainer(self.fourthContainer)

		hardReset()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

// MARK: Button Actions
	func resetButtonPressed(button: UIButton) {
		hardReset()
	}

	func betOneButtonPressed(button: UIButton) {
		if self.credits - self.currentBet <= 0 {
			showAlertWithText(header: "No More Credits", message: "Reset Game")
		}
		else {
			if self.currentBet < self.kMaxBet {
				self.currentBet += 1
//				self.credits -= 1
				updateMainView()
			}
			else {
				showAlertWithText(message: "You can only bet \(self.kMaxBet) credits at a time!")
			}
		}
	}

	func betMaxButtonPressed(button: UIButton) {
		if self.credits < self.kMaxBet {
			showAlertWithText(header: "Not Enough Credits", message: "Bet less")
		}
		else {
			if self.currentBet < self.kMaxBet {
				var creditsToBetMax = self.kMaxBet - self.currentBet
//				self.credits -= creditsToBetMax
				self.currentBet += creditsToBetMax
				spin()
			}
			else {
				showAlertWithText(message: "You can only bet \(self.kMaxBet) credits at a time")
			}
		}
	}

	func spinButtonPressed(button: UIButton) {
		if self.currentBet == 0 {
			showAlertWithText(header: "No Bet", message: "You need to place a bet before spinning.")
		}
		else {
			spin()
		}
	}

// MARK: view container functions
	func removeSlotImageViews() {
		if self.secondContainer != nil {
			let container: UIView? = self.secondContainer
			let subViews:Array? = container!.subviews
			for view in subViews! {
				view.removeFromSuperview()
			}
		}
	}

	func setupContainerView() {
		self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (self.kMarginForView * 2), height: self.view.bounds.height * self.kSixth))
		self.firstContainer.backgroundColor = UIColor.redColor()
		self.view.addSubview(self.firstContainer)

		self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: self.firstContainer.frame.height, width: self.view.bounds.width - (self.kMarginForView * 2), height: self.view.bounds.height * (3 * self.kSixth)))
		self.secondContainer.backgroundColor = UIColor.blackColor()
		self.view.addSubview(self.secondContainer)

		self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height, width: self.view.bounds.width - (self.kMarginForView * 2), height: self.view.bounds.height * self.kSixth))
		self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
		self.view.addSubview(self.thirdContainer)

		self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height + self.thirdContainer.frame.height, width: self.view.bounds.width - (self.kMarginForView * 2), height: self.view.bounds.height * kSixth))
		self.fourthContainer.backgroundColor = UIColor.blackColor()
		self.view.addSubview(self.fourthContainer)
	}

	func setupFirstContainer(containerView: UIView){
		self.titleLabel = UILabel()
		self.titleLabel.text = "Super Slots"
		self.titleLabel.textColor = UIColor.yellowColor()
		self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
		self.titleLabel.sizeToFit()
		self.titleLabel.center = containerView.center
		containerView.addSubview(self.titleLabel)
	}

	func setupSecondContainer(containerView: UIView){
		for var columnNumber = 0; columnNumber < kNumberOfColumns; ++columnNumber {
			for var rowNumber = 0; rowNumber < kNumberOfRows; ++rowNumber {
				var slot:Slot
				var slotImageView = UIImageView()

				if self.slots.count != 0 {
					let slotContainer = self.slots[columnNumber]
					slot = slotContainer[rowNumber]
					slotImageView.image = slot.image
				}
				else {
					slotImageView.image = UIImage(named: "Ace")
				}

				slotImageView.backgroundColor = UIColor.yellowColor()
				slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(columnNumber) * kThird), y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(rowNumber) * kThird), width: containerView.bounds.width * kThird - kMarginForSlot, height: containerView.bounds.height * kThird - kMarginForSlot)
				containerView.addSubview(slotImageView)
			}
		}
	}

	func setupThirdContainer(containerView: UIView) {
		self.creditsLabel = UILabel()
		self.creditsLabel.text = "000000"
		self.creditsLabel.textColor = UIColor.redColor()
		self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
		self.creditsLabel.sizeToFit()
		self.creditsLabel.center = CGPoint(x: containerView.frame.width * self.kSixth, y: containerView.frame.height * self.kThird)
		self.creditsLabel.textAlignment = NSTextAlignment.Center
		self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
		containerView.addSubview(self.creditsLabel)

		self.betLabel = UILabel()
		self.betLabel.text = "0000"
		self.betLabel.textColor = UIColor.redColor()
		self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
		self.betLabel.sizeToFit()
		self.betLabel.center = CGPoint(x: containerView.frame.width * self.kSixth * 3, y: containerView.frame.height * self.kThird)
		self.betLabel.textAlignment = NSTextAlignment.Center
		self.betLabel.backgroundColor = UIColor.darkGrayColor()
		containerView.addSubview(self.betLabel)

		self.winnerPaidLabel = UILabel()
		self.winnerPaidLabel.text = "000000"
		self.winnerPaidLabel.textColor = UIColor.redColor()
		self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
		self.winnerPaidLabel.sizeToFit()
		self.winnerPaidLabel.center = CGPoint(x: containerView.frame.width * self.kSixth * 5, y: containerView.frame.height * self.kThird)
		self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
		self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
		containerView.addSubview(self.winnerPaidLabel)

		self.creditsTitleLabel = UILabel()
		self.creditsTitleLabel.text = "Credits"
		self.creditsTitleLabel.textColor = UIColor.blackColor()
		self.creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
		self.creditsTitleLabel.sizeToFit()
		self.creditsTitleLabel.center = CGPoint(x: containerView.frame.width * self.kSixth, y: containerView.frame.height * self.kThird * 2)
		containerView.addSubview(self.creditsTitleLabel)

		self.betTitleLabel = UILabel()
		self.betTitleLabel.text = "Bet"
		self.betTitleLabel.textColor = UIColor.blackColor()
		self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
		self.betTitleLabel.sizeToFit()
		self.betTitleLabel.center = CGPoint(x: containerView.frame.width * self.kSixth * 3, y: containerView.frame.height * self.kThird * 2)
		containerView.addSubview(self.betTitleLabel)

		self.winnerPaidTitleLabel = UILabel()
		self.winnerPaidTitleLabel.text = "Winner Paid"
		self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
		self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
		self.winnerPaidTitleLabel.sizeToFit()
		self.winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * self.kSixth * 5, y: containerView.frame.height * self.kThird * 2)
		containerView.addSubview(self.winnerPaidTitleLabel)
	}

	func setupFourthContainer(containerView: UIView) {
		self.resetButton = UIButton()
		self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
		self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
		self.resetButton.backgroundColor = UIColor.lightGrayColor()
		self.resetButton.sizeToFit()
		self.resetButton.center = CGPoint(x: containerView.frame.width * self.kEighth, y: containerView.frame.height * self.kHalf)
		self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		containerView.addSubview(self.resetButton)

		self.betOneButton = UIButton()
		self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
		self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
		self.betOneButton.backgroundColor = UIColor.greenColor()
		self.betOneButton.sizeToFit()
		self.betOneButton.center = CGPoint(x: containerView.frame.width * self.kEighth * 3, y: containerView.frame.height * self.kHalf)
		self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		containerView.addSubview(self.betOneButton)

		self.betMaxButton = UIButton()
		self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
		self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
		self.betMaxButton.backgroundColor = UIColor.redColor()
		self.betMaxButton.sizeToFit()
		self.betMaxButton.center = CGPoint(x: containerView.frame.width * self.kEighth * 5, y: containerView.frame.height * self.kHalf)
		self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		containerView.addSubview(self.betMaxButton)

		self.spinButton = UIButton()
		self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
		self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
		self.spinButton.backgroundColor = UIColor.greenColor()
		self.spinButton.sizeToFit()
		self.spinButton.center = CGPoint(x: containerView.frame.width * self.kEighth * 7, y: containerView.frame.height * self.kHalf)
		self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		containerView.addSubview(self.spinButton)
	}

	// MARK: Helper functions
	func hardReset() {
		removeSlotImageViews()
		slots.removeAll(keepCapacity: true)
		self.setupSecondContainer(self.secondContainer)
		self.credits = self.kStartingCredits
		self.winnings = 0
		self.currentBet = 0
		updateMainView()
	}

	func showAlertWithText(header: String = "Warning", message: String) {
		var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}

	func spin() {
		self.credits -= self.currentBet
		removeSlotImageViews()
		self.slots = Factory.createSlots()
		setupSecondContainer(self.secondContainer)
		self.winnings = SlotBrain.computeWinnings(self.slots) * self.currentBet
		self.credits += self.winnings
//		self.currentBet = 0
		updateMainView()
	}

	func updateMainView() {
		self.creditsLabel.text = "\(self.credits)"
		self.betLabel.text = "\(self.currentBet)"
		self.winnerPaidLabel.text = "\(self.winnings)"
	}
}

