//
//  BallViewController.swift
//  BallA5
//
//  Created by iMac21.5 on 5/24/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class BallViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    
    let breakout = BreakoutBehavior()
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.gameView) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakout)
        gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushBall:"))
        gameView.backgroundColor = UIColor.blueColor()
    }

    func pushBall(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            if breakout.balls.count == 0 {
                let ball = createBall()
                placeBall(ball)
                breakout.addBall(ball)
            }
            breakout.pushBall(breakout.balls.last!)
        }
    }
    struct Constants {
        static let BallSize: CGFloat = 40.0
        static let BallColor = UIColor.yellowColor()
        static let BoxPathName = "Box"
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var rect = gameView.bounds
        rect.size.height *= 2
        breakout.addBarrier(UIBezierPath(rect: rect), named: Constants.BoxPathName)
        //Its not nice if the player looses a ball because the device has been rotated accidentally. In such cases put the ball back on screen:
        for ball in breakout.balls {
            if !CGRectContainsRect(gameView.bounds, ball.frame) {
                placeBall(ball)
                animator.updateItemUsingCurrentState(ball)
            }
        }
    }
    
    func createBall() -> UIView {
        let ball = UIView(frame: CGRect(origin: CGPoint.zeroPoint, size: CGSize(width: Constants.BallSize, height: Constants.BallSize)))
        ball.backgroundColor = Constants.BallColor
        ball.layer.cornerRadius = Constants.BallSize / 2.0
        ball.layer.borderColor = UIColor.blackColor().CGColor
        ball.layer.borderWidth = 2.0
        ball.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        ball.layer.shadowOpacity = 0.5
        return ball
    }
    func placeBall(ball: UIView) {
        ball.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
    }

}
